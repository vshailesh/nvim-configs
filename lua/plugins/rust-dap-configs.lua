-- ~/.config/nvim/lua/plugins/rust-dap-attach.lua
return {
  {
    "mfussenegger/nvim-dap",
    opts = function()
      local dap = require("dap")

      dap.configurations.rust = dap.configurations.rust or {}

      table.insert(dap.configurations.rust, {
        name = "Attach to process (lldb)",
        type = "codelldb",
        request = "attach",
        pid = require("dap.utils").pick_process,
        cwd = "${workspaceFolder}",
      })

      table.insert(dap.configurations.rust, {
        type = "codelldb",
        request = "launch",
        name = "Debug example 'guest-debugging'",
        cargo = {
          args = { -- [] is not valid Lua, use {}
            "build",
            "--example=guest-debugging",
            "--package=hyperlight-host",
            "--features=gdb",
          },
          filter = {
            name = "guest-debugging",
            kind = "example",
          },
        },
        env = {
          RUST_BACKTRACE = "1",
          RUST_LOG = "none",
        },
      })

      table.insert(dap.configurations.rust, {
        name = "Remote LLDB attach",
        type = "codelldb",
        request = "launch",
        targetCreateCommands = { -- [] is not valid Lua, use {}
          function()
            local program = vim.fn.input("Paths to executable: ", vim.fn.getcwd() .. "/", "file")
            return "target create " .. program
          end,
        },
        processCreateCommands = { -- [] is not valid Lua, use {}
          "gdb-remote localhost:8080",
        },
      })

      table.insert(dap.configurations.rust, {
        name = "Remote LLDB attach 2",
        type = "codelldb",
        request = "launch",
        targetCreateCommands = {
          "target create /home/arrow/Disk/hyperlight/target/debug/simpleguest", -- hardcode path or prompt separately
        },
        processCreateCommands = {
          "gdb-remote localhost:8080",
        },
      })
    end,
  },
}

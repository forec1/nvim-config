local map = vim.keymap.set

local cond_bp_input = function()
    local condition = vim.fn.input("Breakpoint condition (optional): ")
    local hit_condition = vim.fn.input("Hit count (optional): ")

    -- Convert empty strings to nil
    condition = condition ~= "" and condition or nil
    hit_condition = hit_condition ~= "" and hit_condition or nil

    require("dap").toggle_breakpoint(condition, hit_condition)
end

map("n", "<leader>db", "<cmd> DapToggleBreakpoint <CR>", { desc = "Toggle DAP Breakpoint" })
map("n", "<leader>dB", cond_bp_input, { desc = "Toggle Conditional DAP Breakpoint" })
map("n", "<leader>dr", "<cmd> DapContinue <CR>", { desc = "Start or continue DAP" })
map("n", "<leader>d<Down>", "<cmd> DapStepOver <CR>", { desc = "Step over DAP" })
map("n", "<leader>d<Left>", "<cmd> DapStepOut <CR>", { desc = "Step out DAP" })
map("n", "<leader>d<Right>", "<cmd> DapStepInto <CR>", { desc = "Step into DAP" })
map("n", "<leader>d<Up>", "<cmd> DapRestartFrame <CR>", { desc = "Restart frame DAP" })

local dap = require("dap")

dap.adapters.codelldb = {
    type = "server",
    port = "${port}",
    executable = {
        command = vim.fn.stdpath("data") .. "/mason/bin/codelldb", -- Path from Mason install
        args = { "--port", "${port}" },
    },
}

-- gdb-based adapter (Mason "cpptools"), for Linux machines where lldb is a poor fit
dap.adapters.cppdbg = {
    id = "cppdbg",
    type = "executable",
    command = vim.fn.stdpath("data") .. "/mason/bin/OpenDebugAD7",
}

-- C/C++ configurations
dap.configurations.cpp = {
    {
        name = "Launch file",
        type = "codelldb",
        request = "launch",
        program = function()
            return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
        end,
        cwd = "${workspaceFolder}",
        stopOnEntry = false,
        args = { "../source/config.json" },
        runInTerminal = false,
    },
}

-- If you want the same config for C as well
dap.configurations.c = dap.configurations.cpp

-- print("DAP configurations loaded for C++")
-- for _, config in ipairs(dap.configurations.cpp) do
--     print(vim.inspect(config))
-- end

vim.api.nvim_set_hl(0, "DapBreakpoint", { ctermbg = 0, fg = "#993939", bg = "#31353f" })
vim.api.nvim_set_hl(0, "DapLogPoint", { ctermbg = 0, fg = "#61afef", bg = "#31353f" })
vim.api.nvim_set_hl(0, "DapStopped", { ctermbg = 0, fg = "#98c379", bg = "#31353f" })

vim.fn.sign_define("DapBreakpoint", {
    text = "●",
    texthl = "DapBreakpoint",
    linehl = "DapBreakpoint",
    numhl = "DapBreakpoint",
})
vim.fn.sign_define(
    "DapBreakpointCondition",
    { text = "ﳁ", texthl = "DapBreakpoint", linehl = "DapBreakpoint", numhl = "DapBreakpoint" }
)
vim.fn.sign_define(
    "DapBreakpointRejected",
    { text = "", texthl = "DapBreakpoint", linehl = "DapBreakpoint", numhl = "DapBreakpoint" }
)
vim.fn.sign_define(
    "DapLogPoint",
    { text = "", texthl = "DapLogPoint", linehl = "DapLogPoint", numhl = "DapLogPoint" }
)
vim.fn.sign_define("DapStopped", { text = "", texthl = "DapStopped", linehl = "DapStopped", numhl = "DapStopped" })

-- Use the debugpy that Mason installs, so no per-machine Python path is needed.
-- The program being debugged still runs with the active venv ($VIRTUAL_ENV) if there is one.
require("dap-python").setup(vim.fn.stdpath("data") .. "/mason/packages/debugpy/venv/bin/python")

-- Per-machine settings. The defaults below are shared by every machine; to change one
-- on a single machine, copy lua/local.example.lua to lua/local.lua (not committed).
local function executable(path)
    return path and vim.fn.executable(path) == 1 and path or nil
end

local M = {
    -- Python that pyright analyses against. nil lets pyright pick up the active venv.
    python = executable(vim.fn.expand("~/.venv/base/bin/python3")),
}

local ok, overrides = pcall(require, "local")
if ok and type(overrides) == "table" then
    M = vim.tbl_extend("force", M, overrides)
end

return M

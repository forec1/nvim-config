local M = {
    git = {
        enable = true,
    },
    filters = {
        git_ignored = false,
    },
    update_focused_file = {
        enable = false, -- disable auto-opening to current file
        update_root = false,
        ignore_list = {},
    },
}

return M

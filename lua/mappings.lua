require("nvchad.mappings")
local map = vim.keymap.set

-- General mappings
map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jk", "<ESC>")

-- Tab navigation
map("n", "<leader>tn", ":tabnext<CR>", { desc = "Next Tab" })
map("n", "<leader>tp", ":tabprevious<CR>", { desc = "Previous Tab" })

-- Go to tab by number (1-9)
for i = 1, 9 do
  map("n", "<leader>" .. i, i .. "gt", { desc = "Go to Tab " .. i })
end


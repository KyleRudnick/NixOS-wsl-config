local map = vim.keymap.set

map('n', '<Esc>', '<cmd>nohlsearch<CR>')
map('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })
-- Keymaps lsp
map("n", "<leader>gd", ":lua vim.lsp.buf.definition()<CR>")
map("n", "<leader>gi", ":lua vim.lsp.buf.implementation()<CR>")
map("n", "K", ":lua vim.lsp.buf.hover()<CR>")
map("n", "<leader>rn", ":lua vim.lsp.buf.rename()<CR>")
map("n", "<leader>gr", ":lua vim.lsp.buf.references()<CR>")
map(
  "n",
  "<leader>i",
  ":lua vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())"
)
-- go to previous buffer
map("n", "<C-p>", ":bp<CR>")
-- go to next buffer
map("n", "<C-n>", ":bn<CR>")
map('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
map('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
map('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
map('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })
-- Bindings for Detour
map("n", "<leader>gD", function()
  -- Open detour with the same buffer
  if not require("detour").Detour() then
    return
  end
  vim.lsp.buf.definition() -- jump to definition
end)

-- Binding for CodeCompanion

map("n", "<leader>at", ":CodeCompanion /unit<CR>")
map("n", "<leader>ac", ":CodeCompanionChat<CR>")
map("n", "<leader>aa", ":CodeCompanionActions<CR>")
map("n", "<leader>ae", ":CodeCompanion /explain<CR>")

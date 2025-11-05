vim.g.cornelis_use_global_binary = 1

local opts = { buffer = true, noremap = true }

vim.keymap.set("n", "<leader>l", ":CornelisLoad<CR>", opts)
vim.keymap.set("n", "<leader>r", ":CornelisRefine<CR>", opts)
vim.keymap.set("n", "<leader>d", ":CornelisMakeCase<CR>", opts)
vim.keymap.set("n", "<leader>,", ":CornelisTypeContext<CR>", opts)
vim.keymap.set("n", "<leader>.", ":CornelisTypeContextInfer<CR>", opts)
vim.keymap.set("n", "<leader>n", ":CornelisSolve<CR>", opts)
vim.keymap.set("n", "<leader>a", ":CornelisAuto<CR>", opts)
vim.keymap.set("n", "gd", ":CornelisGoToDefinition<CR>", opts)
vim.keymap.set("n", "[/", ":CornelisPrevGoal<CR>", opts)
vim.keymap.set("n", "]/", ":CornelisNextGoal<CR>", opts)
vim.keymap.set("n", "<C-A>", ":CornelisInc<CR>", opts)
vim.keymap.set("n", "<C-X>", ":CornelisDec<CR>", opts)

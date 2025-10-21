if vim.g.did_load_lean_plugin then
  return
end
vim.g.did_load_lean_plugin = true

vim.lsp.config.lean = {
    filetypes = { 'lean' },
	cmd = { "lean", "--server" },
	root_markers = { "lean-toolchain", "lakefile.lean" },
}

vim.lsp.enable("lean")

require('lean').setup { mapping = true }

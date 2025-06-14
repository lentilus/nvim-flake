-- load optional plugins
if not vim.g.did_load_typstar_plugin then
  vim.g.did_load_typstar_plugin = true

  -- configure typst-vim
  vim.g.typst_pdf_viewer = 'previewpdf'

  -- load and configure typstar
  vim.cmd.packadd('typstar')
  require('typstar').setup {
    snippets = {
      exclude = {},
    },
  }
end

vim.keymap.set({ 'i', 'n' }, '<M-;>', vim.cmd.TypstarToggleSnippets, { buffer = true })
vim.keymap.set('n', '<leader>ll', vim.cmd.TypstWatch, { buffer = true })

--- LSP SETUP ---
local capabilities = require('user.lsp').make_client_capabilities()

-- tinymist --
if vim.fn.executable('tinymist') == 1 then
  vim.lsp.start {
    name = 'tinymist',
    cmd = { 'tinymist' },
    fileypes = { 'typst' },
    capabilities = capabilities,
    single_file_support = true,
    settings = {
      tinymist = {
        outputPath = '$root/$dir/$name', -- Example: store artifacts in a target directory
      },
    },
    on_attach = function(client, _)
      client.server_capabilities.workspaceSymbolProvider = false
    end,
  }
end

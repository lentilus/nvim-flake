--- LSP SETUP ---
local capabilities = require('user.lsp').make_client_capabilities()

if vim.fn.executable('pyright') == 1 then
  print('pyright is executable')
  vim.lsp.start {
    name = 'pyright',
    cmd = { 'pyright-langserver', '--stdio' },
    filetypes = { 'python' },
    capabilities = capabilities,
    single_file_support = true,
  }
end

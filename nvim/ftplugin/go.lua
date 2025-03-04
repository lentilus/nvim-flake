--- LSP SETUP ---
local capabilities = require('user.lsp').make_client_capabilities()
if vim.fn.executable('gopls') == 1 then
  print('gopls is executable')
  local root_files = {
    '.git',
    'go.mod',
  }

  vim.lsp.start {
    name = 'gopls',
    cmd = { 'gopls' },
    fileypes = { 'go' },
    root_dir = vim.fs.dirname(vim.fs.find(root_files, { upward = true })[1]),
    capabilities = capabilities,
    single_file_support = true,
  }
end

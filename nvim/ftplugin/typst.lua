local capabilities = require('user.lsp').make_client_capabilities()

-- tinymist --
if vim.fn.executable('tinymist') then
  local root_files = {
    '.git',
    '.zeta',
    '*.typ',
  }

  vim.lsp.start {
    name = 'tinymist',
    cmd = { 'tinymist' },
    fileypes = { 'typst' },
    root_dir = vim.fs.dirname(vim.fs.find(root_files, { upward = true })[1]),
    capabilities = capabilities,
    single_file_support = true,
    settings = {
      tinymist = {
        outputPath = '$root/$dir/$name', -- Example: store artifacts in a target directory
        -- rootPath = '-', -- Use parent directory of the file as root
      },
    },
  }
end

-- zeta --
local zeta_bin = '/home/lentilus/git/zeta.git/dev/bin/zeta'

if vim.fn.executable(zeta_bin) then
  local indicator = vim.fs.find({ '.zeta' }, { upward = true })[1] or nil
  if indicator == nil then
    return
  end
  local root = vim.fs.dirname(indicator)
  vim.lsp.start {
    name = 'zeta',
    cmd = { zeta_bin },
    fileypes = { 'typst' },
    root_dir = root,
    capabilities = capabilities,
    init_options = {
      reference_query = '(ref) @reference',
      target_regex = '^@(.*)$',
      path_separator = ':',
      canonical_extension = '.typ',
    },
  }
end

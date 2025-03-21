-- load optional plugins
if not vim.g.did_load_typstar_plugin then
  vim.g.typst_pdf_viewer = 'previewpdf --root .'

  vim.cmd.packadd('typst-vim')
  vim.cmd.packadd('typstar')

  vim.g.did_load_typstar_plugin = true
  require('typstar').setup {}
end

vim.api.nvim_set_hl(0, 'FirstTwoLines', { fg = 'Gray' })
vim.api.nvim_buf_add_highlight(0, -1, 'FirstTwoLines', 0, 0, -1)
vim.api.nvim_buf_add_highlight(0, -1, 'FirstTwoLines', 1, 0, -1)

vim.keymap.set('n', '<leader>ll', vim.cmd.TypstWatch, { buffer = true })

-- journal
local function journal()
  local date = os.date('%d-%m-%y')
  local filename = date .. '.typ'
  local journal_path = vim.fn.expand('~/git/zettelkasten/journal/' .. filename)
  local template_path = vim.fn.expand('~/git/zettelkasten/file-template.typ')

  if vim.fn.filereadable(journal_path) == 1 then
    vim.cmd('edit ' .. journal_path)
  else
    -- Check if the template file is readable
    local template_content = {}
    if vim.fn.filereadable(template_path) == 1 then
      template_content = vim.fn.readfile(template_path)
    end

    vim.cmd('enew') -- Create a new buffer
    vim.api.nvim_buf_set_lines(0, 0, -1, false, template_content) -- Set buffer lines
    vim.api.nvim_buf_set_name(0, journal_path)
  end

  vim.bo.filetype = 'typst'
end

vim.keymap.set('n', '<leader>jj', journal)

-- auto-preview
-- vim.api.nvim_create_autocmd('BufWinEnter', {
--   pattern = '*.typ',
--   callback = function(args)
--     local bufnr = args.buf
--
--     -- if already being watched just switch pdf
--     if vim.b[bufnr].typstwatch then
--       local path = vim.api.nvim_buf_get_name(bufnr)
--       local pdf = vim.fn.fnamemodify(path, ':r') .. '.pdf'
--       vim.fn.jobstart('previewpdf ' .. pdf, { detach = true })
--       return
--     end
--
--     vim.cmd([[TypstWatch]])
--     vim.b[bufnr].typstwatch = true
--   end,
-- })

--- LSP SETUP ---
local capabilities = require('user.lsp').make_client_capabilities()

-- tinymist --
if vim.fn.executable('tinymist') == 1 then
  print('tinymist is executable')
  local root_files = {
    '.git',
    '.zeta',
    -- '*.typ',
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
if vim.fn.executable('zeta') then
  print('zeta is executable')
  local indicator = vim.fs.find({ '.zeta' }, { upward = true })[1] or nil
  if indicator == nil then
    return
  end
  local root = vim.fs.dirname(indicator)
  print('Starting zeta at root: ' .. root)
  vim.lsp.start {
    name = 'zeta',
    cmd = { 'zeta' },
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

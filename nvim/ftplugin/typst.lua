-- load optional plugins
if not vim.g.did_load_typstar_plugin then
  vim.g.did_load_typstar_plugin = true

  if vim.fn.executable('typst') ~= 1 then
    return
  end

  -- configure typst-vim
  vim.g.typst_pdf_viewer = 'previewpdf'

  -- load and configure typstar
  vim.cmd.packadd('typstar')
  require('typstar').setup {}

  vim.keymap.set({ 'i', 'n' }, '<M-;>', vim.cmd.TypstarToggleSnippets, { buffer = true })
end

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

--- LSP SETUP ---
local capabilities = require('user.lsp').make_client_capabilities()

-- tinymist --
if vim.fn.executable('tinymist') == 1 then
  local root_files = {
    '.git',
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
      },
    },
  }
end

-- zeta --
local on_attach = function(client, bufnr)
  print('LSP attached to buffer', bufnr)

  local function buf_set_keymap(...)
    vim.api.nvim_buf_set_keymap(bufnr, ...)
  end
  local opts = { noremap = true, silent = true }

  buf_set_keymap('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
  buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)

  vim.api.nvim_buf_create_user_command(bufnr, 'ZetaGraph', function()
    client.request('workspace/executeCommand', { command = 'graph', arguments = {} }, function(err, result)
      if err then
        vim.notify('Error executing graph command: ' .. err.message, vim.log.levels.ERROR)
      else
        vim.notify('Graph command executed.')
      end
    end, bufnr)
  end, { desc = "Execute Zeta LSP 'graph' command" })
end

if vim.fn.executable('zeta') == 1 then
  local indicator = vim.fs.find({ '.git' }, { upward = true })[1] or nil
  local root = vim.fs.dirname(indicator)
  vim.lsp.start {
    name = 'zeta',
    cmd = { 'zeta', '--logfile=/tmp/zeta.log' },
    fileypes = { 'typst' },
    root_dir = root,
    capabilities = capabilities,
    init_options = {
      query = '(code (call item: (ident) @link (#eq? @link "link") (group (string) @target )))',
      select_regex = '^"(.*)"$',
    },
    on_attach = on_attach,
  }
end

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
end

vim.keymap.set({ 'i', 'n' }, '<M-;>', vim.cmd.TypstarToggleSnippets, { buffer = true })
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

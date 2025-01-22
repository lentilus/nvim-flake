if vim.g.did_load_typst_plugin then
  return
end
vim.g.did_load_typst_plugin = true

require('typstar').setup {}

-- set buffer local keymaps
vim.api.nvim_create_autocmd('FileType', {
  pattern = 'typst',
  callback = function()
    -- hightlight the first two lines in gray
    vim.api.nvim_set_hl(0, 'FirstTwoLines', { fg = 'Gray' })
    vim.api.nvim_buf_add_highlight(0, -1, 'FirstTwoLines', 0, 0, -1)
    vim.api.nvim_buf_add_highlight(0, -1, 'FirstTwoLines', 1, 0, -1)

    vim.keymap.set('n', '<leader>ll', vim.cmd.TypstWatch, { buffer = true })
  end,
})

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
vim.api.nvim_create_autocmd('BufWinEnter', {
  pattern = '*.typ',
  callback = function(args)
    local bufnr = args.buf

    -- if already being watched just switch pdf
    if vim.b[bufnr].typstwatch then
      local path = vim.api.nvim_buf_get_name(bufnr)
      local pdf = vim.fn.fnamemodify(path, ':r') .. '.pdf'
      vim.fn.jobstart('previewpdf ' .. pdf, { detach = true })
      return
    end

    vim.cmd.TypstWatch()
    vim.b[bufnr].typstwatch = true
  end,
})

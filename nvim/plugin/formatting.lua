if vim.g.did_load_formatting_plugin then
  return
end
vim.g.did_load_formatting_plugin = true

local conform = require('conform')

local defaults = {
  async = false,
  lsp_fallback = false,
}

-- https://github.com/stevearc/conform.nvim/issues/92
local function format_range(hunks)
  if next(hunks) == nil then
    vim.notify('done formatting git hunks', 0, { title = 'formatting' })
    return
  end
  local hunk = nil
  while next(hunks) ~= nil and (hunk == nil or hunk.type == 'delete') do
    hunk = table.remove(hunks)
  end

  if hunk ~= nil and hunk.type ~= 'delete' then
    local start = hunk.added.start
    local last = start + hunk.added.count
    -- nvim_buf_get_lines uses zero-based indexing -> subtract from last
    local last_hunk_line = vim.api.nvim_buf_get_lines(0, last - 2, last - 1, true)[1]
    local range = { start = { start, 0 }, ['end'] = { last - 1, last_hunk_line:len() } }
    conform.format(vim.tbl_extend('keep', { range = range }, defaults), function()
      vim.defer_fn(function()
        format_range(hunks)
      end, 1)
    end)
  end
end

-- https://github.com/stevearc/conform.nvim/issues/92
local function format_diff(_)
  local ignore_filetypes = { 'lua', 'go' }
  if vim.tbl_contains(ignore_filetypes, vim.bo.filetype) then
    conform.format(defaults)
    vim.notify('formatted whole buffer.')
    return
  end

  local hunks = require('gitsigns').get_hunks()
  if hunks == nil then
    conform.format(defaults)
    vim.notify('formatted whole buffer.')
    return
  end

  format_range(hunks)
end

local opts = {
  notify_on_error = true,

  formatters_by_ft = {
    lua = { 'stylua' },
    python = { 'black' },
    -- goimports does not play well with format_diff
    -- go = { 'gofumpt', 'goimports', 'golines' },
    go = { 'gofumpt', 'golines' },
    typst = { 'typstfmt' },
  },

  format_on_save = function()
    format_diff()
  end,
}

conform.setup(opts)

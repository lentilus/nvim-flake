if vim.g.did_load_fugitive_plugin then
  return
end
vim.g.did_load_fugitive_plugin = true

vim.keymap.set('n', '<leader>gs', vim.cmd.Git)
vim.keymap.set({ 'n', 'v' }, '<leader>gh', ':Gclog<CR>')
vim.keymap.set('n', '<leader>gpu', ':Git pull --no-rebase --autostash')
vim.keymap.set('n', '<leader>gpr', ':Git pull --rebase --autostash')

local Fugitive = vim.api.nvim_create_augroup('Fugitive', {})
vim.api.nvim_create_autocmd('BufWinEnter', {
  group = Fugitive,
  pattern = '*',
  callback = function()
    if vim.bo.ft ~= 'fugitive' then
      return
    end

    local bufnr = vim.api.nvim_get_current_buf()
    local opts = { buffer = bufnr, remap = false }

    vim.keymap.set('n', '<leader>gpp', function()
      vim.cmd.Git('push')
    end, opts)

    vim.keymap.set('n', '<leader>gc', function()
      vim.cmd.Git('commit')
    end, opts)

    vim.keymap.set('n', '<leader>gpo', ':Git push --set-upstream origin ', opts)
  end,
})

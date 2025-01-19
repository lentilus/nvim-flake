if vim.g.did_load_autocommands_plugin then
  return
end
vim.g.did_load_autocommands_plugin = true

vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('lsp-attach', { clear = true }),
  callback = function(event)
    local map = function(keys, func)
      vim.keymap.set('n', keys, func, { buffer = event.buf })
    end

    map('gd', require('telescope.builtin').lsp_definitions)
    map('gr', require('telescope.builtin').lsp_references)
    map('gI', require('telescope.builtin').lsp_implementations)
    map('<leader>D', require('telescope.builtin').lsp_type_definitions)
    map('<leader>ds', require('telescope.builtin').lsp_document_symbols)
    map('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols)
    map('<leader>rn', vim.lsp.buf.rename)
    map('<leader>ca', vim.lsp.buf.code_action)
    map('K', vim.lsp.buf.hover)
    map('<leader>e', vim.diagnostic.open_float)
    map('gD', vim.lsp.buf.declaration)
  end,
})

if vim.g.did_load_completion_plugin then
  return
end
vim.g.did_load_completion_plugin = true

local cmp = require('cmp')
local luasnip = require('luasnip')
local cmp_select = { behavior = cmp.SelectBehavior.Select }

local opts = {
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  mapping = cmp.mapping.preset.insert {
    ['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
    ['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
    ['<C-y>'] = cmp.mapping.confirm { select = true },
  },
  sources = cmp.config.sources {
    { name = 'nvim_lsp' },
    { name = 'luasnip' },
    { name = 'path' },
    { name = 'buffer' },
  },
}

-- base setup
cmp.setup(opts)

-- `/` cmdline setup.
cmp.setup.cmdline('/', {
  mapping = cmp.mapping.preset.cmdline(),
  sources = {
    { name = 'buffer' },
  },
})

-- `:` cmdline setup.
cmp.setup.cmdline(':', {
  mapping = cmp.mapping.preset.cmdline(),
  sources = cmp.config.sources({
    { name = 'path' },
  }, {
    {
      name = 'cmdline',
      option = {
        ignore_cmds = { 'Man', '!' },
      },
    },
  }),
})

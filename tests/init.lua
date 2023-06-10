vim.o.runtimepath = vim.o.runtimepath .. ',/home/sidharta/.local/share/nvim/lazy/plenary.nvim'
vim.o.runtimepath = vim.o.runtimepath .. ',/home/sidharta/.local/share/nvim/lazy/telescope.nvim'
vim.o.runtimepath = vim.o.runtimepath .. ',/home/sidharta/.local/share/nvim/lazy/sqlite.lua'
vim.o.runtimepath = vim.o.runtimepath .. ',.'

_G.assert_equal_tables = function(tbl1, tbl2)
    assert(vim.deep_equal(tbl1, tbl2), string.format("%s ~= %s", vim.inspect(tbl1), vim.inspect(tbl2)))
end

require('neoclip').setup()

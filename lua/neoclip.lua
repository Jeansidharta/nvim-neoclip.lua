local M = {}

local settings = require('neoclip.settings')

M.stopped = false

local function setup_auto_command()
    local commands = {
        'augroup neoclip',
        'autocmd!',
        'autocmd TextYankPost * :lua require("neoclip.handlers").handle_yank_post()',
        'autocmd VimLeavePre * :lua require("neoclip.handlers").on_exit()',
    }
    if vim.fn.exists('##RecordingLeave') ~= 0 and settings.get().enable_macro_history then
        table.insert(
            commands,
            'autocmd RecordingLeave * :lua require("neoclip.handlers").handle_macro_post()'
        )
    end
    table.insert(
        commands,
        'augroup end'
    )
    vim.cmd(table.concat(commands, '\n'))
end



local function setup_keymap()
		local is_cycling = false;
		local ring_node = nil;
		local cycle_group = vim.api.nvim_create_augroup("NeoclipAugroup", { clear = true })
		vim.keymap.set({"n"}, "<Plug>(NeoclipYankForward)", function ()
				vim.schedule(function ()
						local handlers = require('neoclip.handlers')
						handlers.set_registers({'"'}, ring_node.value)
						handlers.paste(ring_node.value, "p")
				end)
				if not is_cycling then
						ring_node = require('neoclip.storage').get_tail()
						is_cycling = true
						vim.schedule(function ()
								vim.api.nvim_create_autocmd({"CursorMoved"}, { buffer = 0, desc = "", group = cycle_group , callback = function ()
									is_cycling = false
										vim.print"Moved"
								end, once = true })
						end)
				else
						ring_node = ring_node.prev
						vim.cmd(":normal! u")
				end
		end)
end

M.stop = function()
    M.stopped = true
end

M.start = function()
    M.stopped = false
end

M.toggle = function()
    M.stopped = not M.stopped
end

M.db_pull = function()
    require('neoclip.storage').pull()
end

M.db_push = function()
    require('neoclip.storage').push()
end

M.clear_history = function()
    require('neoclip.storage').clear()
end

M.setup = function(opts)
    settings.setup(opts)
    setup_auto_command()
		setup_keymap()
end

return M

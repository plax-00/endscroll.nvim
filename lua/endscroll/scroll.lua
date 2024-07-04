local api = vim.api
local fn = vim.fn
local opts = require('endscroll.config').opts
local scroll_key = vim.keycode('<C-e>')

local function scroll()
    -- check for disabled filetype
    if vim.tbl_contains(opts.disabled_filetypes, vim.o.filetype) then
        vim.cmd.normal { 'j', bang = true }
        return
    end

    local scrolloff = vim.o.scrolloff
    local last_line = fn.line('$')
    local current_line = fn.line('.')
    local top_line = fn.line('w0')
    local count = vim.v.count1



    for _ = 1, count, 1 do
        local above = api.nvim_win_text_height(0, { start_row = top_line - 1, end_row = current_line - 1}).all - 1
        local below = current_line == last_line and 0 or api.nvim_win_text_height(0, { start_row = current_line - 1, end_row = last_line - 1}).all - 2

        if current_line == last_line then
            if above > scrolloff and opts.scroll_at_end then
                vim.cmd.normal { scroll_key, bang = true }
                goto continue
            else
                return
            end
        end

        if below < scrolloff and above >= scrolloff then
            vim.cmd.normal { 'j' .. scroll_key, bang = true }
            goto continue
        end

        vim.cmd.normal { 'j', bang = true }

        ::continue::
        if current_line < last_line - 1 then
            current_line = current_line + 1
        end
    end

end


return scroll

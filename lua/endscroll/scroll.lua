local api = vim.api
local fn = vim.fn
local scroll_key = api.nvim_replace_termcodes('<C-e>', true, true, true)

local function contains(table, val)
    for _, filetype in pairs(table) do
        if filetype == val then return true end
    end
    return false
end

local function scroll()
    local opts = vim.g.endscroll_opts

    -- check for disabled filetype
    if contains(opts.disabled_filetypes, vim.o.filetype) then
        api.nvim_feedkeys('j', 'n', false)
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
                api.nvim_feedkeys(scroll_key, 'n', false)
                goto continue
            else
                return
            end
        end

        if below < scrolloff and above >= scrolloff then
            api.nvim_feedkeys('j' .. scroll_key, 'n', false)
            goto continue
        end

        api.nvim_feedkeys('j', 'n', true)

        ::continue::
        if current_line < last_line - 1 then
            current_line = current_line + 1
        end
    end

end


return scroll

local api = vim.api
local fn = vim.fn

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
        api.nvim_input('<Down>')
        return
    end

    local scrolloff = vim.o.scrolloff
    local last_line = fn.line('$')
    local height = api.nvim_win_get_height(0)
    local current_line = fn.line('.')
    local relative_first = current_line - fn.line('w0')
    local count = vim.v.count1

    for _ = 1, count, 1 do
        if current_line == last_line then
            if relative_first > scrolloff and opts.scroll_at_end then
                api.nvim_input('<C-e>')
                goto continue
            else
                return
            end
        end
        if current_line >= last_line - scrolloff and relative_first >= height - scrolloff - 1 then
            api.nvim_input('<Down><C-e>')
            goto continue
        end

        api.nvim_input('<Down>')

        ::continue::
        if current_line < last_line - 1 then
            current_line = current_line + 1
            relative_first = relative_first + 1
        end
    end
end


return scroll

local line = vim.fn.line
local opts = require('endscroll.config').opts

local function get_text_height(start_line, end_line)
    return vim.api.nvim_win_text_height(0, { start_row = start_line - 1, end_row = end_line - 1 }).all - 1
end

local function scroll(key)

    -- check for disabled filetype
    if vim.tbl_contains(opts.disabled_filetypes, vim.o.filetype) then
        return
    end

    local count = vim.v.count1
    local scrolloff = vim.o.scrolloff
    local last_line = line('$')
    local init_line = line('.')
    local lines_to_end = get_text_height(init_line, last_line)

    local ctrl_d = vim.keycode(key) == vim.keycode('<C-d>')
    local init_lines_above
    if ctrl_d then
        if count == 1 then
            count = vim.o.scroll
        end
        init_lines_above = get_text_height(line('w0'), init_line)
        if init_lines_above < scrolloff then
            init_lines_above = scrolloff
        end
    end

    if count <= lines_to_end - scrolloff and not ctrl_d then
        return
    end

    vim.api.nvim_create_autocmd('SafeState', {
        callback = function()
            local lines_above = get_text_height(line('w0'), line('.'))
            local max_lines_above = vim.fn.winheight(0) - scrolloff - 1

            if init_line ~= line('$') and lines_above <= max_lines_above and not ctrl_d then
                return
            end

            local max_scroll = scrolloff - get_text_height(line('.'), line('$'))

            if count >= lines_to_end then
                max_scroll = math.min(lines_above - scrolloff, count - lines_to_end + scrolloff)
            end
            if not opts.scroll_at_end then
                max_scroll = lines_above - max_lines_above
            end
            if ctrl_d then
                max_scroll = lines_above - init_lines_above
            end

            if count > max_scroll then count = max_scroll end
            if count < 1 then return end

            vim.cmd.normal { count .. vim.keycode('<C-e>'), bang = true }
        end,
        once = true,
    })
end

return scroll

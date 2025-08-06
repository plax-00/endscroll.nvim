---@module 'mini.test'

local INPUT_LINES = 100
local CHILD_PROC_LINES = 40
local CHILD_PROC_COLS = 80

local eq = MiniTest.expect.equality

local child = MiniTest.new_child_neovim()
local T = MiniTest.new_set()
T.default = MiniTest.new_set {
    hooks = {
        pre_case = function()
            -- Restart child process with custom 'init.lua' script
            child.restart({
                '--cmd', 'set lines=' .. CHILD_PROC_LINES .. ' columns=' .. CHILD_PROC_COLS,
                '-u', 'tests/scripts/minimal_init.lua',
                'tests/input.txt'
            })
            child.lua [[
                require('endscroll').setup()
            ]]
        end,
        -- Stop once all test cases are finished
        post_once = child.stop,
    },
    parametrize = { { 'j' }, { '<Down>' }, { '<CR>' }, { '<C-n>' }, { '<C-j>' } },
}

T.non_default = MiniTest.new_set {
    hooks = {
        pre_case = function()
            -- Restart child process with custom 'init.lua' script
            child.restart({
                '--cmd', 'set lines=' .. CHILD_PROC_LINES .. ' columns=' .. CHILD_PROC_COLS,
                '-u', 'tests/scripts/minimal_init.lua',
                'tests/input.txt'
            })
        end,
        -- Stop once all test cases are finished
        post_once = child.stop,
    },
    parametrize = { { 'j' }, { '<Down>' }, { '<CR>' }, { '<C-n>' } },
}

local function get_filler_lines()
    return child.fn.winheight(0) - child.api.nvim_win_text_height(0, { start_row = child.fn.line('w0') }).all - 1
end

T.default.cursor_down = function(key)
    eq(child.fn.line('$'), INPUT_LINES)
    eq(child.fn.line('w$'), CHILD_PROC_LINES - 2)
    eq(child.fn.line('.'), 1)
    child.type_keys(key)
    eq(child.fn.line('.'), 2)
    child.type_keys(string.rep(key, 2))
    eq(child.fn.line('.'), 4)
end

T.default.single_scroll_to_end = function(key)
    repeat
        child.type_keys(key)
    until child.fn.line('.') == INPUT_LINES
    eq(get_filler_lines(), child.o.scrolloff)
end

T.default.single_scroll_before_end = function(key)
    repeat
        child.type_keys(key)
    until child.fn.line('.') == INPUT_LINES - 5
    eq(get_filler_lines(), child.o.scrolloff - 5)
end

T.default.single_scroll_past_end = function(key)
    repeat
        child.type_keys(key)
    until child.fn.line('.') == INPUT_LINES
    for _ = 1, 3 do
        child.type_keys(key)
    end
    eq(get_filler_lines(), child.o.scrolloff + 3)
end

T.default.count_scroll_to_end = function(key)
    child.type_keys(INPUT_LINES - 1 .. key)
    eq(get_filler_lines(), child.o.scrolloff)
    child.type_keys(key)
    eq(get_filler_lines(), child.o.scrolloff + 1)
end

T.default.count_scroll_before_end = function(key)
    child.type_keys(INPUT_LINES - 6 .. key)
    eq(get_filler_lines(), child.o.scrolloff - 5)
end

T.default.count_scroll_past_end = function(key)
    child.type_keys(INPUT_LINES + 1 .. key)
    eq(get_filler_lines(), child.o.scrolloff + 2)
end

T.default.very_large_count = function(key)
    child.type_keys('500' .. key)
    eq(child.fn.winline(), child.o.scrolloff + 1)
end

T.default.ctrl_d = function(key)
    child.type_keys('<C-d>')
    eq(child.fn.line('.'), child.o.scrolloff + child.o.scroll + 1)
    eq(child.fn.winline(), child.o.scrolloff + 1)
    child.type_keys('4' .. key)
    eq(child.fn.winline(), child.o.scrolloff + 5)
    child.type_keys('<C-d>')
    eq(child.fn.winline(), child.o.scrolloff + 5)
    repeat
        child.type_keys('<C-d>')
    until child.fn.line('.') == INPUT_LINES
    eq(child.fn.winline(), child.o.scrolloff + 5)
    child.type_keys('<C-u>')
    child.type_keys('<C-u>')
    eq(child.fn.winline(), child.o.scrolloff + 5)
    child.type_keys('<C-d>')
    eq(child.fn.winline(), child.o.scrolloff + 5)
end

T.default.winview = function(key)
    child.type_keys(INPUT_LINES - 1 .. key)
    eq(get_filler_lines(), child.o.scrolloff)
    child.cmd('edit tests/test_endscroll.lua')
    child.cmd('edit tests/input.txt')
    eq(get_filler_lines(), child.o.scrolloff)
end

T.default.insert_mode = function()
    child.type_keys(INPUT_LINES - 1 .. 'j')
    eq(get_filler_lines(), child.o.scrolloff)
    child.type_keys('A')
    child.type_keys('<CR><CR><CR>')
    eq(get_filler_lines(), child.o.scrolloff)
end

T.default.o_at_and = function()
    child.type_keys(INPUT_LINES - 1 .. 'j')
    eq(get_filler_lines(), child.o.scrolloff)
    child.type_keys('o')
    eq(get_filler_lines(), child.o.scrolloff)
    child.type_keys('<Esc>o<Esc>o')
    eq(get_filler_lines(), child.o.scrolloff)
end

T.non_default.no_scroll_at_end = function(key)
    child.lua [[
        require('endscroll').setup {
            scroll_at_end = false
        }
    ]]
    child.type_keys(INPUT_LINES - 1 .. key)
    eq(get_filler_lines(), child.o.scrolloff)
    child.type_keys(string.rep(key, 3))
    eq(get_filler_lines(), child.o.scrolloff)
    child.type_keys('gg')
    child.type_keys('1000' .. key)
    eq(get_filler_lines(), child.o.scrolloff)
end

T.non_default.disabled_filetype = function(key)
    child.lua [[
        require('endscroll').setup {
            disabled_filetypes = { 'text' }
        }
    ]]
    child.type_keys(INPUT_LINES - 1 .. key)
    eq(get_filler_lines(), 0)
    child.type_keys(string.rep(key, 5))
    eq(get_filler_lines(), 0)
end


return T

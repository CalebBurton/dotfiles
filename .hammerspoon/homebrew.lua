-- Homebrew menubar
Homebrew = {
    menubar  = hs.menubar.new(),
    items    = {},
    disabled = false,
    notified = false,
}

function Homebrew:loadOutdated()
    self.items = {}
    -- local pipe = io.popen('/usr/local/bin/brew outdated -1 --quiet', 'r')
    -- print(pipe)
    -- for item in pipe:lines() do
    --     table.insert(self.items, item)
    -- end
    -- pipe:close()

    -- local outdated_kegs = hs.execute('/usr/local/bin/brew outdated --quiet')
    local check_kegs = hs.task.new(
        '/usr/local/bin/brew',
        function(exitCode, outdated_kegs_str, stdErr)
            if ((exitCode ~= 0) or (stdErr ~= '')) then
                hs.notify.show('Homebrew', '', 'Error updating homebrew. See console for details.')
                print('Error updating homebrew. Exit code ' .. exitCode)
                print('StdErr: ' .. stdErr)
            else
                print(outdated_kegs_str)
            end
        end,
        {'outdated', '--quiet'}
    ):start()

    for keg in string.gmatch(outdated_kegs_str or '', "%S+") do
        table.insert(self.items, keg)
    end

    if next(self.items) == nil then
        self.disabled = true
        self.notified = false
        -- self.menubar:removeFromMenuBar()
    else
        self.disabled = false
        self.menubar:returnToMenuBar()
        if not self.notified then
            hs.notify.show('Homebrew', '', 'Updated formulas available')
            self.notified = true
        end
    end
end

function Homebrew:getMenu()
    local menu = {
        {
            title='Upgrade all',
            -- Probably better to use a background task here
            fn=function() self.disabled = true; hs.execute('/usr/local/bin/brew upgrade') end,
            disabled=self.disabled
        },
        {title='-'},
    }
    for _, item in ipairs(self.items) do
        table.insert(
            menu,
            {
                title=item,
                fn=function()
                    self.disabled = true;
                    hs.task.new(
                        '/usr/local/bin/brew',
                        function() Homebrew:loadOutdated() end,
                        {'upgrade', item}
                    ):start()
                end,
                disabled=self.disabled
            }
        )
    end

    return menu
end

function Homebrew:update()
    print('Updating Homebrew')
    hs.task.new('/usr/local/bin/brew', function() Homebrew:loadOutdated() end, {'update'}):start()
end

hb_update = function()
    Homebrew:update()
end

local icon = [[
. . . . . . . . . . . . .
. 1 # 2 . . . . . 5 # 6 .
. D # # . . . . . # # # .
. # # # . . . . . # # # .
. # # # . . . . . # # # .
. # # 3 # # # # # 4 # # .
. # # # # # # # # # # # .
. # # A # # # # # 9 # # .
. # # # . . . . . # # # .
. # # # . . . . . # # # .
. # # # . . . . . # # # .
. C # B . . . . . 8 # 7 .
. . . . . . . . . . . . .
]]

if Homebrew then
    Homebrew.menubar:setTooltip('Homebrew')
    Homebrew.menubar:setIcon('ASCII:' .. icon)
    Homebrew.menubar:setMenu(function() return Homebrew:getMenu() end)
    -- Homebrew.menubar:removeFromMenuBar()
    Homebrew:update(); hs.timer.doEvery(3600, function() Homebrew:update() end)
end

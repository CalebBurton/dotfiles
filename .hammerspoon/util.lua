local inspect = require('packages/inspect')
utilMenu = hs.menubar.new()

local caffeinatedIcon = [[
1 . . . . . . . . . . . 3
. # # . . . . . . . # # .
. # # # # . . . # # # # .
. . # # # # 2 # # # # . .
. . # # # # # # # # # . .
. . . # # # # # # # . . .
. . . 8 # # # # # 4 . . .
. . . # # # # # # # . . .
. . # # # # # # # # # . .
. . # # # # 6 # # # # . .
. # # # # . . . # # # # .
. # # . . . . . . . # # .
7 . . . . . . . . . . . 5
]]

local sleepyIcon = [[
H 1 . . . . . . . . . 3 4
G . # . . . . . . . # . 5
. # . # # . . . # # . # .
. . # . . 1 2 3 . . # . .
. . # . . . . . . . # . .
. . . G . . . . . 5 . . .
. . . F . . . . . 6 . . .
. . . E . . . . . 7 . . .
. . # . . . . . . . # . .
. . # . . B A 9 . . # . .
. # . # # . . . # # . # .
E . # . . . . . . . # . 7
D C . . . . . . . . . 9 8
]]

utilMenu:setIcon('ASCII:' .. sleepyIcon)

local menu = nil


local reloadMenu = function()
  menu[#menu] = Homebrew:getMenu()
  -- print('!!! FULL MENU')
  -- print(inspect(menu))
  utilMenu:setMenu(menu)
end

menu = {
  {
    title = "Caffeinate",
    checked = false,
    fn = function(modifiers, menuItem)
      local enabled = hs.caffeinate.toggle('displayIdle')
      if enabled then
        print('Caffeinate on')
        utilMenu:setIcon('ASCII:' .. caffeinatedIcon)
      else
        print('Caffeinate off')
        utilMenu:setIcon('ASCII:' .. sleepyIcon)
      end

      menuItem.checked = enabled
      reloadMenu()
    end
  },
  {
    title = "Rescue windows",
    fn = rescue
  },
  {
    title = "-" -- separator
  },
  {
    title = 'Show HS Console',
    fn = function() hs.openConsole() end
  },
  {
    title = 'Show HS Preferences',
    fn = function() hs.openPreferences() end
  },
  {
    title = "-" -- separator
  },
  {} -- will become Homebrew menu
  -- {
  --   title = "Layout: Home",
  --   fn = function()
  --     local ide, layout = layoutHome()
  --     local name = ide or 'Terminal'
  --     local description = 'Home (' .. name .. ')'
  --     applyLayout(description, layout)
  --   end
  -- },
  -- {
  --   title = "Layout: Dorm",
  --   fn = function()
  --     applyLayout("Dorm", layoutDorm)
  --   end
  -- },
  -- {
  --   title = "Layout: Lab",
  --   fn = function()
  --     local ide, layout = layoutLab()
  --     local name = ide or 'Terminal'
  --     local description = 'Lab (' .. name .. ')'
  --     applyLayout(description, layout)
  --   end
  -- },
  -- {
  --   title = "Layout: Laptop",
  --   fn = function()
  --     applyLayout("Laptop", layoutLaptop)
  --   end
  -- },
}

reloadMenu()

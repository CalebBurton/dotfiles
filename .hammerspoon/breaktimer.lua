mouseCircle = nil
mouseCircleTimer = nil

function mouseHighlight()
    -- -- Delete an existing highlight if it exists
    -- if mouseCircle then
    --     mouseCircle:delete()
    --     if mouseCircleTimer then
    --         mouseCircleTimer:stop()
    --     end
    -- end
    -- -- Get the current co-ordinates of the mouse pointer
    -- mousepoint = hs.mouse.getAbsolutePosition()
    -- -- Prepare a big red circle around the mouse pointer
    -- mouseCircle = hs.drawing.circle(hs.geometry.rect(mousepoint.x-40, mousepoint.y-40, 80, 80))
    -- mouseCircle:setStrokeColor({["red"]=0.81,["blue"]=0.81,["green"]=0.81,["alpha"]=0})
    -- mouseCircle:setFill(false) 
    -- mouseCircle:setStrokeWidth(5)
    -- mouseCircle:show()

    -- -- Set a timer to delete the circle after 3 seconds
    -- mouseCircleTimer = hs.timer.doAfter(3, function() mouseCircle:delete() end)


    c = require("hs.canvas")
    allScreens = hs.screen.allScreens()
    a = c.new{x=-1000,y=-1000,h=248,w=248}:appendElements(
        {
            -- first we start with a rectangle that covers the full canvas
            action = "build", padding = 0, type = "rectangle"
        },
        {
            -- and cover the whole thing with a semi-transparent rectangle
                action = "fill",
                fillColor = { alpha = 0.90, red = 0.19, blue = 0.19, green = 0.19 },
                frame = { h = 248.0, w = 500.0, x = -100.0, y = -1000.0 },
                type = "rectangle",
        }
    ):show()

    hs.timer.doAfter(3, function() a:delete() end)
end
hs.hotkey.bind({"cmd","alt","ctrl"}, "C", mouseHighlight)

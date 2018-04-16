--- functions
function chrome_switch_to(ppl)
    return function()
        hs.application.launchOrFocus("Google Chrome")
        local chrome = hs.appfinder.appFromName("Google Chrome")
        local str_menu_item
        if ppl == "Incognito" then
            str_menu_item = {"File", "New Incognito Window"}
        else
            str_menu_item = {"People", ppl}
        end
        local menu_item = chrome:findMenuItem(str_menu_item)
        if (menu_item) then
            chrome:selectMenuItem(str_menu_item)
        end
    end
end

-- function chrome_active_tab_with_name(name)
--     return function()
--         hs.osascript.javascript([[
--             var chrome = Application('Google Chrome');
--             chrome.activate();
--             var wins = chrome.windows;
--             function main() {
--                 for (var i = 0; i < wins.length; i++) {
--                     var win = wins.at(i);
--                     var tabs = win.tabs;
--                     for (var j = 0; j < tabs.length; j++) {
--                     var tab = tabs.at(j);
--                     tab.title(); j;
--                     if (tab.title().indexOf(']] .. name .. [[') > -1) {
--                             win.activeTabIndex = j + 1;
--                             return;
--                         }
--                     }
--                 }
--             }
--             main();
--         ]])
--     end
-- end

function open(name)
    return function()
        hs.application.launchOrFocus(name)
        print(hs.application.runningApplications())
        if name == 'Finder' then
            hs.appfinder.appFromName(name):activate()
        end
    end
end

function sleep()
    hs.caffeinate.systemSleep()
end

function move(dir)
    return function()
        local win = hs.window.focusedWindow()
        local frame = win:frame()
        local screenFrame = win:screen():frame()
        local x = frame.x - screenFrame.x
        local y = frame.y - screenFrame.y
        local w = frame.w
        local h = frame.h
        if dir == 'right' then
            if x < 0 then -- negative left
                frame.x = 0
            elseif x == 0 then -- attach to left
                if w < screenFrame.w * 1 / 4 then -- win width less than 25%
                    frame.w = screenFrame.w * 1 / 4
                elseif w < math.floor(screenFrame.w * 1 / 3) then -- win with less than 33%
                    frame.w = math.floor(screenFrame.w * 1 / 3)
                elseif w < screenFrame.w * 1 / 2 then -- win width less than 50%
                    frame.w = screenFrame.w * 1 / 2
                elseif w < screenFrame.w * 3 / 4 then -- win with less than 75%
                    frame.w = screenFrame.w * 3 / 4
                else
                    frame.x = screenFrame.w * 1 / 4
                    frame.w = screenFrame.w * 3 / 4
                end
            elseif x < screenFrame.w / 2 then -- win on the left side
                frame.x = screenFrame.w / 2
                frame.w = screenFrame.w / 2
            elseif x >= screenFrame.w / 2 and x < math.floor(screenFrame.w * 2 / 3) then -- win left edge in 50% - 66%
                frame.x = math.floor(screenFrame.w * 2 / 3)
                frame.w = math.floor(screenFrame.w * 1 / 3)
            elseif x >= math.floor(screenFrame.w * 2 / 3) and x < screenFrame.w * 3 / 4 then -- win left edge in 66% - 75%
                frame.x = screenFrame.w * 3 / 4
                frame.w = screenFrame.w * 1 / 4
            end
        elseif dir == 'left' then
            if x + w > screenFrame.w  then -- negative right
                frame.x = screenFrame.w - w
            elseif x + w == screenFrame.w then -- attach to right
                if w < screenFrame.w * 1 / 4 then -- win width less than 25%
                    frame.w = screenFrame.w * 1 / 4
                    frame.x = screenFrame.w - frame.w
                elseif w < math.floor(screenFrame.w * 1 / 3) then -- win with less than 33%
                    frame.w = math.floor(screenFrame.w * 1 / 3)
                    frame.x = screenFrame.w - frame.w
                elseif w < screenFrame.w * 1 / 2 then -- win width less than 50%
                    frame.w = screenFrame.w * 1 / 2
                    frame.x = screenFrame.w - frame.w
                elseif w < screenFrame.w * 3 / 4 then -- win with less than 75%
                    frame.w = screenFrame.w * 3 / 4
                    frame.x = screenFrame.w - frame.w
                else
                    frame.x = 0
                    frame.w = screenFrame.w * 3 / 4
                end
            elseif x > screenFrame.w / 2 then -- win on the right side
                frame.x = 0
                frame.w = screenFrame.w / 2
            elseif x > 0 then -- win on left side
                frame.x = 0
            elseif w > screenFrame.w / 2 then -- win larger than 50%
                frame.w = screenFrame.w * 1 / 2
            elseif w > math.floor(screenFrame.w * 1 / 3) then -- win larger than 33%
                frame.w = math.floor(screenFrame.w * 1 / 3)
            elseif w > screenFrame.w * 1 / 4 then -- win larger than 25%
                frame.w = screenFrame.w * 1 / 4
            end
        elseif dir == 'up' then
            if y == 0 then -- attach to top
                if h >= screenFrame.h / 2 then
                    frame.h = screenFrame.h / 2
                end
            elseif y + h == screenFrame.h then -- attach to bottom
                frame.y = 0
                frame.h = screenFrame.h
            else
                frame.y = 0
            end
        elseif dir == 'down' then
            if y + h == screenFrame.h then -- attach to bottom
                if h >= screenFrame.h / 2 then
                    frame.h = screenFrame.h / 2
                    frame.y = screenFrame.h - frame.h + 22
                end
            elseif y == 0 then -- attach to top
                frame.y = 0
                frame.h = screenFrame.h
            elseif y + h > screenFrame.h then -- overflow bottom do nothing
            else
                frame.y = screenFrame.h - h + 22
            end
        end
        win:setFrame(frame)
    end
end

function send_window_prev_monitor()
  local win = hs.window.focusedWindow()
  local nextScreen = win:screen():previous()
  win:moveToScreen(nextScreen)
end

function send_window_next_monitor()
  local win = hs.window.focusedWindow()
  local nextScreen = win:screen():next()
  win:moveToScreen(nextScreen)
end

--- open different Chrome users
hs.hotkey.bind({"alt"}, "1", chrome_switch_to("Google"))
hs.hotkey.bind({"alt"}, "2", chrome_switch_to("Hao"))
hs.hotkey.bind({"alt"}, "`", chrome_switch_to("Incognito"))

--- quick open applications
hs.hotkey.bind({"alt"}, "E", open("Finder"))
hs.hotkey.bind({"alt"}, "W", open("WeChat"))
hs.hotkey.bind({"alt"}, "C", open("Google Chrome"))
hs.hotkey.bind({"alt"}, "T", open("iTerm"))
hs.hotkey.bind({"alt"}, "X", open("Xcode"))
hs.hotkey.bind({"alt"}, "S", open("Sublime Text"))
hs.hotkey.bind({"alt"}, "V", open("Visual Studio Code"))
hs.hotkey.bind({"alt"}, "I", open("IntelliJ IDEA CE"))
hs.hotkey.bind({"alt"}, "N", open("NeteaseMusic")) -- netease
hs.hotkey.bind({"alt"}, "M", open("Spark")) -- mail
hs.hotkey.bind({"alt"}, "H", open("Things3"))

--- sleep
hs.hotkey.bind({"control", "alt", "command"}, "DELETE", sleep)

--- window
hs.window.animationDuration = 0
hs.hotkey.bind({"ctrl", "cmd"}, "Right", move('right'))
hs.hotkey.bind({"ctrl", "cmd"}, "Left", move('left'))
hs.hotkey.bind({"ctrl", "cmd"}, "Up", move('up'))
hs.hotkey.bind({"ctrl", "cmd"}, "Down", move('down'))
hs.hotkey.bind({"ctrl", "alt", "cmd"}, "Left", send_window_prev_monitor)
hs.hotkey.bind({"ctrl", "alt", "cmd"}, "Right", send_window_next_monitor)

--- when connected to work Wifi, mute the computer
local workWifi = 'Google-A'
local outputDeviceName = 'Built-in Output'
hs.wifi.watcher.new(function()
    local currentWifi = hs.wifi.currentNetwork()
    local currentOutput = hs.audiodevice.current(false)
    if not currentWifi then return end
    if (currentWifi == workWifi and currentOutput.name == outputDeviceName) then
        hs.audiodevice.findDeviceByName(outputDeviceName):setOutputMuted(true)
    end
end):start()

--- key macros
function keyStrokes(str)
    return function()
        hs.eventtap.keyStrokes(str)
    end
end
hs.hotkey.bind({"ctrl", "alt", "cmd"}, "L", keyStrokes("console.log("))


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

function chrome_active_tab_with_name(name)
    return function()
        hs.osascript.javascript([[
            var chrome = Application('Google Chrome');
            chrome.activate();
            var wins = chrome.windows;
            function main() {
                for (var i = 0; i < wins.length; i++) {
                    var win = wins.at(i);
                    var tabs = win.tabs;
                    for (var j = 0; j < tabs.length; j++) {
                    var tab = tabs.at(j);
                    tab.title(); j;
                    if (tab.title().indexOf(']] .. name .. [[') > -1) {
                            win.activeTabIndex = j + 1;
                            return;
                        }
                    }
                }
            }
            main();
        ]])
    end
end

function open(name)
    return function()
        hs.application.launchOrFocus(name)
        if name == 'Finder' then
            hs.appfinder.appFromName(name):activate()
        end
    end
end

function sleep()
    hs.caffeinate.systemSleep()
end

function addReminder()
    hs.osascript.javascript([[
        var current = Application.currentApplication();
        current.includeStandardAdditions = true;
        var app = Application('Reminders');
        app.includeStandardAdditions = true;

        var td = new Date(); 

        var dateMap = {
            'Tonight': (function() { var d = new Date(); d.setHours(19, 0, 0, 0); return d; })(),
            'Tomorrow morning': (function() { var d = new Date(); d.setHours(10, 0, 0, 0); d.setHours(d.getHours() + 24); return d; })(),
            'Tomorrow night': (function() { var d = new Date(); d.setHours(19, 0, 0, 0); d.setHours(d.getHours() + 24); return d; })(),
            'This saturday': new Date(td.getFullYear(), td.getMonth(), td.getDate() + (6 - td.getDay()), 10, 0, 0, 0),
            'This sunday': new Date(td.getFullYear(), td.getMonth(), td.getDate() + (7 - td.getDay()), 10, 0, 0, 0) 
        };

        try {
            var content = current.displayDialog('Create a new Reminder', {
                defaultAnswer: '',
                buttons: ['Next', 'Cancel'],
                defaultButton: 'Next',
                cancelButton: 'Cancel',
                withTitle: 'New Reminder',
                withIcon: Path('/Applications/Reminders.app/Contents/Resources/icon.icns')
            });
            
            var list = current.chooseFromList(['TO DO', 'TO BUY', 'TO WATCH'], {
                withTitle: 'List Selection',
                withPrompt: 'Which list?',
                defaultItems: ['TO DO'],
                okButtonName: 'Next',
                cancelButtonName: 'Cancel',
                multipleSelectionsAllowed: false,
                emptySelectionAllowed: false
            })[0];
            
            var remindDate = current.chooseFromList(Object.keys(dateMap), {
                withTitle: 'Due Date Selection',
                withPrompt: 'When?',
                okButtonName: 'OK',
                cancelButtonName: 'Cancel',
                multipleSelectionsAllowed: false,
                emptySelectionAllowed: true
            });
            var remindMeDate = remindDate.length === 1 ? dateMap[ remindDate[0] ] : null;
            
            var entry = app.Reminder({
                name: content.textReturned,
                remindMeDate: remindMeDate
            });
            
            app.lists[list].reminders.push(entry);
            
        } catch (err) {}
    ]])
end

function move(dir)
    local counter = {
        right = 0,
        left = 0
    }
    return function()
        counter[dir] = _move(dir, counter[dir])
    end
end

function _move(dir, ct)
    local screenWidth = hs.window.focusedWindow():screen():frame().w
    local focusedWindowFrame = hs.window.focusedWindow():frame()
    local x = focusedWindowFrame.x >= screenWidth and focusedWindowFrame.x - screenWidth or focusedWindowFrame.x
    local w = focusedWindowFrame.w
    local value = dir == 'right' and x + w or x
    local valueTarget = dir == 'right' and screenWidth or 0
    if value ~= valueTarget then
        hs.window.focusedWindow():moveToUnit(hs.layout[dir .. 50])
        return 50
    elseif ct == 50 then
        hs.window.focusedWindow():moveToUnit(hs.layout[dir .. 70])
        return 70
    elseif ct == 70 then
        hs.window.focusedWindow():moveToUnit(hs.layout[dir .. 30])
        return 30
    else
        hs.window.focusedWindow():moveToUnit(hs.layout[dir .. 50])
        return 50
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
hs.hotkey.bind({"alt"}, "1", chrome_switch_to("Hao"))
hs.hotkey.bind({"alt"}, "2", chrome_switch_to("Yahoo!"))
hs.hotkey.bind({"alt"}, "`", chrome_switch_to("Incognito"))

--- quick open applications
hs.hotkey.bind({"alt"}, "E", open("Finder"))
hs.hotkey.bind({"alt"}, "W", open("WeChat"))
hs.hotkey.bind({"alt"}, "C", open("Google Chrome"))
hs.hotkey.bind({"alt"}, "T", open("iTerm"))
hs.hotkey.bind({"alt"}, "X", open("Xcode"))
hs.hotkey.bind({"alt"}, "S", open("Sublime Text"))
hs.hotkey.bind({"alt"}, "V", open("Visual Studio Code"))
hs.hotkey.bind({"alt"}, "I", open("IntelliJ IDEA"))
hs.hotkey.bind({"alt"}, "M", open("NeteaseMusic"))
hs.hotkey.bind({"alt"}, "H", chrome_active_tab_with_name("HipChat"))

--- sleep
hs.hotkey.bind({"control", "alt", "command"}, "DELETE", sleep)

--- window
hs.window.animationDuration = 0
hs.hotkey.bind({"ctrl", "cmd"}, "Right", move('right'))
hs.hotkey.bind({"ctrl", "cmd"}, "Left", move('left'))
hs.hotkey.bind({"ctrl", "alt", "cmd"}, "Left", send_window_prev_monitor)
hs.hotkey.bind({"ctrl", "alt", "cmd"}, "Right", send_window_next_monitor)

--- when connected to work Wifi, mute the computer
local workWifi = 'YFi'
local outputDeviceName = 'Built-in Output'
hs.wifi.watcher.new(function()
    local currentWifi = hs.wifi.currentNetwork()
    local currentOutput = hs.audiodevice.current(false)
    if not currentWifi then return end
    if (currentWifi == workWifi and currentOutput.name == outputDeviceName) then
        hs.audiodevice.findDeviceByName(outputDeviceName):setOutputMuted(true)
    end
end):start()

--- quick add to reminder
hs.hotkey.bind({"ctrl", "alt", "cmd"}, "R", addReminder)

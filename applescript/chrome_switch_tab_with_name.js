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
        if (tab.title().indexOf('<name>') > -1) {
                win.activeTabIndex = j + 1;
                return;
            }
        }
    }
}
main();
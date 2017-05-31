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
extends Node

static var Notes : Dictionary = {
	"Security": {
		"Title": "If you are reading this I am dead!",
		"Body": "The gate's Password is 2050",
	},
	"Subject-01": {
		"Title": "A complete Failure!",
		"Body": "He Killed Everyone =D"
	}
}


func get_note(note_name):
	return Notes[note_name]
	

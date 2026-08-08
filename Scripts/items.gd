class_name ITEMS
extends Node

const note1 := "note1"
const note2 := "note2"

const contents := {
	note1 = {
		"name" = "Note 1",
		"type" = "note",
		"desc" = "March 17, 2059. Experiment # was progressing faster than intended...",
		"max" = 3
	},
	note2 = {
	"name" = "Note 2",
	"type" = "note",
	"desc" = "March 29, 2059. The serum was now...",
	"max" = 1
	}
}

static func get_item(key: String) -> Dictionary:
	return contents[key]

static func get_item_name(key: String) -> String:
	return contents[key]["name"]

static func get_item_type(key: String) -> String:
	return contents[key]["type"]

static func get_item_desc(key: String) -> String:
	return contents[key]["desc"]

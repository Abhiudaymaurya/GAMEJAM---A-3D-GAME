class_name DEBUG4
extends RefCounted

static var _debug_data :Dictionary = {}

static func debug_setup() -> void:
	_debug_data["inv"] = []

static func run_command(cmd: Array, ui: UI_API) -> bool:
	# RETURN TRUE FOR SUCCESSFUL EXECUTION, OTHERWISE FALSE
	
	match cmd[0]:
		"empty4":
			ui.print_result("Debug script #4 responded.")
			return true
		"_":
			return false
	
	return false

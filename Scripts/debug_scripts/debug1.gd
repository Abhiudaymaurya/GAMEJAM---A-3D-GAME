class_name DEBUG1
extends RefCounted

static var _debug_data :Dictionary = {}

static func debug_setup() -> void:
	_debug_data["inv"] = []

static func run_command(cmd: Array, ui: UI_API) -> bool:
	# RETURN TRUE FOR SUCCESSFUL EXECUTION, OTHERWISE FALSE
	
	match cmd[0]:
		"item_count":
			ui.print_result("Items loaded: " + str(ITEMS.contents.size()))
			return true
		
		"inv_create":
			var dummy :Node = Node.new()
			INVENTORY.create_inventory(dummy)
			_debug_data["inv"].append(dummy)
			ui.print_result.call("Debug inventory created at index %d." % _debug_data["inv"].find(dummy))
			return true
		
		"inv_refresh":
			if cmd.size() != 2:
				ui.print_result("inv_refresh requires 1 argument but received %d." % (cmd.size()-1), Color.RED)
			elif StringValidator.check_type(cmd[1], StringValidator.Validation.ONLY_NUMBERS):
				if int(cmd[1]) < _debug_data["inv"].size(): 
					ui.refresh_inventory(_debug_data["inv"][int(cmd[1])])
					ui.print_result("Inventory %d refreshed." % int(cmd[1]))
				else:
					ui.print_result("Inventory %d does not exists." % int(cmd[1]), Color.RED)
			else:
				ui.print_result("\"%s\" must be a number." % int(cmd[1]), Color.RED)
			return true
		
		"inv_add_item":
			if cmd.size() != 2:
				ui.print_result("inv_add_item requires 1 argument but received %d." % (cmd.size()-1), Color.RED)
			elif StringValidator.check_type(cmd[1], StringValidator.Validation.ONLY_NUMBERS):
				if int(cmd[1]) < _debug_data["inv"].size(): 
					INVENTORY.add_item(_debug_data["inv"][int(cmd[1])], ITEMS.note1)
					ui.refresh_inventory(_debug_data["inv"][int(cmd[1])])
					ui.print_result("Item added to inventory %d." % int(cmd[1]))
				else:
					ui.print_result("Inventory %d does not exists." % int(cmd[1]), Color.RED)
			else:
				ui.print_result("\"%s\" must be a number." % int(cmd[1]), Color.RED)
			return true
		
		
		"inv_eat_item":
			if cmd.size() != 2:
				ui.print_result("inv_eat_item requires 1 argument but received %d." % (cmd.size()-1), Color.RED)
			elif StringValidator.check_type(cmd[1], StringValidator.Validation.ONLY_NUMBERS):
				if int(cmd[1]) < _debug_data["inv"].size(): 
					INVENTORY.consume_item(_debug_data["inv"][int(cmd[1])], ITEMS.note1)
					ui.refresh_inventory(_debug_data["inv"][int(cmd[1])])
					ui.print_result("Item consumed from inventory %d." % int(cmd[1]))
				else:
					ui.print_result("Inventory %d does not exists." % int(cmd[1]), Color.RED)
			else:
				ui.print_result("\"%s\" must be a number." % int(cmd[1]), Color.RED)
			return true
		
		"_":
			return false
	
	return false

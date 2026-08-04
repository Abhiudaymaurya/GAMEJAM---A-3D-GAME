extends Control

var _item_img_path := "res://resources/"

func _ready() -> void:
	_debug_setup()

func _input(event: InputEvent) -> void:
	# DEBUG CONSOLE
	if event is InputEventKey and event.is_pressed():
		if event.keycode == 124:
			_debug_console.visible = !_debug_console.visible
			if _debug_console.visible:
				await get_tree().process_frame
				_debug_input.grab_focus()
		
		if _debug_console and event.keycode == KEY_ENTER and !_debug_input.text.is_empty():
			_run_command()

# -----------------------------------------------------------------

@onready var _inventory_list := $InventoryDisplay/HBoxContainer/Panel1/ScrollContainer/ContentList

func _refresh_inventory(index: String) -> void:
	for child in _inventory_list.get_children():
		child.queue_free()
	
	var dummy = _debug_data["inv"][index]
	var inv :Array = INVENTORY.get_inventory(dummy)
	for slot :INVENTORY.InventorySlot in inv:
		var button = Button.new()
		button.text = "%s %dx" % [ITEMS.get_item_name(slot.key), slot.count]
		_inventory_list.add_child(button)

# -----------------------------------------------------------------

@onready var _debug_console := $DebugConsole
@onready var _debug_input := $DebugConsole/LineEdit
@onready var _debug_results := $DebugConsole/DebugResults

var _debug_max_lines := 16
var _debug_data := {}

func _debug_setup() -> void:
	_debug_data["inv"] = []

func _run_command() -> void:
	# BASIC COMMANDS
	var cmd :Array = _debug_input.text.split(" ")
	match cmd[0]:
		"/ilc": # Item List Count
			_print_result("Items loaded: " + str(ITEMS.contents.size()))
		
		"crt_inv":
			var dummy :Node = Node.new()
			INVENTORY.create_inventory(dummy)
			_debug_data["inv"].append(dummy)
			_print_result("Debug inventory created at index %d." % _debug_data["inv"].find(dummy))
		
		"ref_inv":
			if StringValidator.check_type(cmd[1], StringValidator.Validation.ONLY_NUMBERS):
				if int(cmd[1]) + 1 >= _debug_data["inv"].size(): 
					_refresh_inventory(_debug_data["inv"][int(cmd[1])])
				else:
					_print_result("Inventory %d does not exists." % int(cmd[1]))
		
		"inv_add_item":
			INVENTORY.add_item(_debug_data["inv"][int(cmd[1])], ITEMS.note1)
		
		_:
			_print_result("Command %s not found." % cmd, "error")
	
	_debug_input.text = ""
	await get_tree().process_frame
	_debug_input.grab_focus()

func _command_check(cmd: Array) -> bool:
	return false

func _print_result(result: String, type:= "") -> void:
	if _debug_results.get_child_count() >= _debug_max_lines:
		_debug_results.get_child(0).queue_free()
	
	var label := Label.new()
	label.text = result
	label.modulate = Color.RED if type == "error" else Color.WHITE
	_debug_results.call_deferred("add_child", label)
	

# -----------------------------------------------------------------

func _cmd_create_inventory() -> void:
	pass

extends UI_API

var _item_img_path := "res://resources/"

func _ready() -> void:
	_debug_setup()

func _input(event: InputEvent) -> void:
	# DEBUG CONSOLE (USING SHIFT + BACKSLASH "\")
	if event is InputEventKey and event.keycode == 124:
		if event.is_pressed():
			if !_debug_just_toggled:
					_debug_console.visible = !_debug_console.visible
					if _debug_console.visible:
						_debug_just_toggled = true
						_debug_input.call_deferred("grab_focus")
		else:
			_debug_just_toggled = false

# -----------------------------------------------------------------
# UI CONTROL FUNCTIONS HERE

@onready var _inventory_list := $InventoryDisplay/HBoxContainer/Panel1/ScrollContainer/ContentList

func refresh_inventory(body: Node) -> void:
	for child in _inventory_list.get_children():
		child.queue_free()
	
	var inv :Array = INVENTORY.get_inventory(body)
	for slot :INVENTORY.InventorySlot in inv:
		var button = Button.new()
		button.text = "%s %dx" % [ITEMS.get_item_name(slot.key), slot.count]
		_inventory_list.add_child(button)

# -----------------------------------------------------------------

@onready var _debug_console := $DebugConsole
@onready var _debug_input := $DebugConsole/LineEdit
@onready var _debug_results := $DebugConsole/DebugResults

var _debug_max_lines := 16
var _debug_just_toggled := false

func _debug_setup() -> void:
	DEBUG1.debug_setup()
	DEBUG2.debug_setup()
	DEBUG3.debug_setup()
	DEBUG4.debug_setup()

func _run_command(new_text: String) -> void:
	var cmd :Array = new_text.split(" ")
	_debug_input.text = ""
	#_debug_input.call_deferred("grab_focus")
	
	if DEBUG1.run_command(cmd, self):
		return
	elif DEBUG2.run_command(cmd, self):
		return
	elif DEBUG3.run_command(cmd, self):
		return
	elif DEBUG4.run_command(cmd, self):
		return
	else:
		print_result("Command %s not found." % cmd, Color.RED)

func print_result(result: String, col:= Color.WHITE) -> void:
	if _debug_results.get_child_count() >= _debug_max_lines:
		_debug_results.get_child(0).queue_free()
	
	var label := Label.new()
	label.text = result
	label.modulate = col
	_debug_results.call_deferred("add_child", label)

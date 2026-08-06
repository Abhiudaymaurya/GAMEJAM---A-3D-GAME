extends Node3D

@onready var label: Label3D = $InteractLabel
@export var text_own = ""
@onready var note_ui: Control = $NoteUI
@onready var Note_Label : Label = note_ui.get_node("Label")
var is_reading : bool = false
var is_in_range : bool = false

func _on_detection_body_entered(body: Node3D):
	if body.name == "Player":
		label.visible = true
		is_in_range = true

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("Interact") and is_in_range:
		if is_reading == false:
			is_reading = true
			Note_Label.text = text_own
			note_ui.visible = true
		elif is_reading == true:
			is_reading = false
			is_reading = false
			note_ui.visible = false
		

func _on_detection_body_exited(body: Node3D):
	if body.name == "Player":
		label.visible = false
		is_in_range = false

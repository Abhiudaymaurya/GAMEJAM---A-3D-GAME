extends Node3D

@onready var label: Label3D = $InteractLabel
@export var Note_Name = ""
@onready var note_ui: Control = $NoteUI
@onready var Note_Label : Label = note_ui.get_node("Label")
@onready var Note_Title : Label = note_ui.get_node("Title")
var is_reading : bool = false
var is_in_range : bool = false
var Body_Note : String
var Title_Note : String
var is_Note_Name_Empty = false

func _ready() -> void:
	if Note_Name != "":
		var Dict_Note : Dictionary = NoteBookManager.get_note(str(Note_Name))
		Body_Note = Dict_Note["Body"]
		Title_Note = Dict_Note["Title"]
	else:
		is_Note_Name_Empty = true

func _on_detection_body_entered(body: Node3D):
	if body.name == "Player" and not is_Note_Name_Empty:
		label.visible = true
		is_in_range = true

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("Interact") and is_in_range and not is_Note_Name_Empty:
		if is_reading == false:
			is_reading = true
			Note_Label.text = Body_Note
			Note_Title.text = Title_Note
			note_ui.visible = true
		elif is_reading == true:
			is_reading = false
			is_reading = false
			note_ui.visible = false
		

func _on_detection_body_exited(body: Node3D):
	if body.name == "Player" and not is_Note_Name_Empty:
		label.visible = false
		is_in_range = false

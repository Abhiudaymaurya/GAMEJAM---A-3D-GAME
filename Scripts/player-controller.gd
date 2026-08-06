class_name Player;
extends CharacterBody3D

@export var Anim : AnimationPlayer;
@export var CameraRig : Node3D;

const SPEED := 2.0
const JUMP_VELOCITY := 4.5
const ROTATION_SPEED := 7.0

var IS_JUMPING := false
var IS_JUMPING_last_state := false
var IS_MOVING := false
var IS_RUNNING := false

func _ready() -> void:
	Anim.animation_finished.connect(_on_animation_finished_);
	
	var volume_db = (clamp(SETTINGS.volume, 0.0, 1.25) * 80) - 80
	node_audio_loop.volume_db = volume_db
	node_audio_single.volume_db = volume_db

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	if is_on_floor() and !Anim.is_playing() and !IS_JUMPING:
		Anim.play("Rig|man_idle")

	if Input.is_action_just_pressed("Space") and is_on_floor() and !IS_JUMPING:
		IS_JUMPING = true;
		velocity.y = JUMP_VELOCITY
		Anim.play("Rig|man_jump_in_place")
		
		if IS_JUMPING_last_state != IS_JUMPING:
			IS_JUMPING_last_state = IS_JUMPING
			_sound_execute(0)
		
	var input_dir := Input.get_vector("Forward", "Backward", "Right", "Left")
	var direction := Vector3(input_dir.x, 0, input_dir.y).normalized()
	
	if direction != Vector3.ZERO:
		IS_MOVING = true
		CameraRig.is_player_input_stopped = false;
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
		CameraRig.player_velocity_ = velocity.normalized();
		
		if !IS_JUMPING and Anim.current_animation != "Rig|man_walk_in_place":
			Anim.play("Rig|man_walk_in_place");
			
		var target_angle := atan2(direction.x, direction.z)
		rotation.y = lerp_angle(rotation.y, target_angle, ROTATION_SPEED * delta)
	else:
		IS_MOVING = false
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
		CameraRig.is_player_input_stopped = true;
		if !IS_JUMPING and Anim.current_animation != "Rig|man_idle":
			Anim.play("Rig|man_idle")
	
	move_and_slide()
	_sound_update()

func _on_animation_finished_(anim_name: String) -> void:
	if anim_name == "Rig|man_jump_in_place":
		IS_JUMPING = false
		if IS_JUMPING_last_state != IS_JUMPING:
			IS_JUMPING_last_state = IS_JUMPING
			_sound_execute(1)

# -----------------------------------------------------------------

@export var sound_walk: AudioStream
@export var sound_run: AudioStream
@export var sound_jump: AudioStream
@export var sound_land: AudioStream

@onready var node_audio_loop := $MovementLoop
@onready var node_audio_single := $MovementSingle

func _sound_execute(id: int) -> void:
	match id:
		0:
			node_audio_single.stream = sound_jump
			node_audio_single.play()
		1:
			node_audio_single.stream = sound_land
			node_audio_single.play()

func _sound_update() -> void:
	if IS_MOVING and not IS_JUMPING:
		var new_stream :AudioStream = sound_walk if !IS_RUNNING else sound_run
		if node_audio_loop.playing and node_audio_loop.stream == new_stream:
			return
		node_audio_loop.stop()
		node_audio_loop.stream = new_stream
		node_audio_loop.play()
	else:
		node_audio_loop.stop()

class_name Player;
extends CharacterBody3D

@export var Anim : AnimationPlayer;
@export var CameraRig : Node3D;

const SPEED = 2.0
const JUMP_VELOCITY = 4.5
const ROTATION_SPEED = 7.0
var IS_JUMPING = false


func _ready() -> void:
	Anim.animation_finished.connect(_on_animation_finished_);

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	if is_on_floor() and !Anim.is_playing() and !IS_JUMPING:
		Anim.play("Rig|man_idle")

	if Input.is_action_just_pressed("Space") and is_on_floor() and !IS_JUMPING:
		IS_JUMPING = true;
		velocity.y = JUMP_VELOCITY
		Anim.play("Rig|man_jump_in_place")
		
	var input_dir := Input.get_vector("Forward", "Backward", "Right", "Left")
	var direction := Vector3(input_dir.x, 0, input_dir.y).normalized()
	
	if direction != Vector3.ZERO:
		CameraRig.is_player_input_stopped = false;
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
		CameraRig.player_velocity_ = velocity.normalized();
		
		if !IS_JUMPING and Anim.current_animation != "Rig|man_walk_in_place":
			Anim.play("Rig|man_walk_in_place");
			
		var target_angle := atan2(direction.x, direction.z)
		rotation.y = lerp_angle(rotation.y, target_angle, ROTATION_SPEED * delta)
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
		CameraRig.is_player_input_stopped = true;
		if !IS_JUMPING and Anim.current_animation != "Rig|man_idle":
			Anim.play("Rig|man_idle")
	
	move_and_slide()

func _on_animation_finished_(anim_name: String) -> void:
	if anim_name == "Rig|man_jump_in_place":
		IS_JUMPING = false

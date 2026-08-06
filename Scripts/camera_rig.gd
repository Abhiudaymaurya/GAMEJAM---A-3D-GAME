extends Node3D

@export var player : Player;
@export var _side_scroll_speed_ := 1.0
@export var _jump_speed_ := 2.0;
@export var _forward_backward_speed_ := 0.5;
@export var _forward_rotation_speed_ := 0.5;

#Camera_limits
@export var max_camera_z := 0.0
@export var min_camera_z := -7.0

@export var max_camera_x := 0.4
@export var min_camera_x := -1.0

var default_rotaion : float = 0.5;
var target_rot = deg_to_rad(-10)
var player_velocity_  : Vector3;
var is_player_input_stopped : bool;

var distance;

var breath_time := 0.0
var breath_amount := deg_to_rad(1.0)   # 1 degrees
var breath_speed := 0.5


func _process(delta: float) -> void:
	if is_player_input_stopped:
		global_rotation.y = lerp(global_rotation.y , default_rotaion , _forward_rotation_speed_ * delta);
		_initial_camera_rotaion(delta)
		
	var target = player.global_position;
	target.x = clamp(target.x - 1.4, min_camera_x , max_camera_x);;
	target.y -= 0.5;
	target.z = clamp(target.z, min_camera_z , max_camera_z);
	
	global_position.x = lerp(global_position.x ,target.x ,_forward_backward_speed_ * delta)
	global_position.y = lerp(global_position.y ,target.y ,_jump_speed_ * delta)
	global_position.z = lerp(global_position.z ,target.z ,_side_scroll_speed_ * delta)
	# distance logic (future)
	
	
	#look ahead logic
	if player_velocity_:
		if player_velocity_.z > 0:
			#backward
			global_rotation.y = lerp(global_rotation.y , abs(target_rot) , _forward_rotation_speed_ * delta)
			global_rotation.z = lerp(global_rotation.z, 0.0, 5 * delta)
		elif player_velocity_.z < 0:
			#forward
			global_rotation.y = lerp(global_rotation.y , target_rot , _forward_rotation_speed_ * delta)
			global_rotation.z = lerp(global_rotation.z, 0.0, 5 * delta)
		else:
			#idle
			global_rotation.y = lerp(global_rotation.y , default_rotaion , _forward_rotation_speed_ * delta)
	
	
func _initial_camera_rotaion(delta) -> void:
	breath_time += delta
	var target = sin(breath_time * breath_speed) * breath_amount;
	
	global_rotation.z = lerp(global_rotation.z, target, 5.0 * delta)
	global_rotation.x = lerp(global_rotation.x, target, 5.0 * delta)
	

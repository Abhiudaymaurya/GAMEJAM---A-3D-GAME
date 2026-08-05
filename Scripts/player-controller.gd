extends CharacterBody3D

const SPEED = 5.0
const JUMP_VELOCITY = 4.5
const ROTATION_SPEED = 10.0
@onready var Anim : AnimationPlayer = self.get_node("Male").get_node("AnimationPlayer")
func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	if is_on_floor():
		Anim.play("Rig|man_idle")

	if Input.is_action_just_pressed("Space") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		Anim.play("Rig|man_jump_in_place")
		
	var input_dir := Input.get_vector("Forward", "Backward", "Right", "Left")
	var direction := Vector3(input_dir.x, 0, input_dir.y).normalized()
	
	if direction != Vector3.ZERO:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
		#HERE (the anim name is Anim.play("Rig|man_walk_root_motion") this part)
		var target_angle := atan2(direction.x, direction.z)
		rotation.y = lerp_angle(rotation.y, target_angle, ROTATION_SPEED * delta)
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()

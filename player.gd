extends RigidBody3D

@export var move_force: float= 100.0
@export var jump_velocity: float= 15.0
@export var gravity_factor: float= 5.0
@export var move_damping: float= 5.0
@export var friction: float= 0.2



func _ready() -> void:
	can_sleep= false
	continuous_cd= true
	lock_rotation= true
	contact_monitor= true
	max_contacts_reported= 1
	gravity_scale= gravity_factor
	physics_material_override= PhysicsMaterial.new()
	physics_material_override.friction= friction


func _physics_process(delta: float) -> void:
	var state: PhysicsDirectBodyState3D= PhysicsServer3D.body_get_direct_state(get_rid(), )
	var is_on_floor: bool= state.get_contact_count() > 0
	
	if is_on_floor:
		linear_damp= move_damping
		
		var move_vec: Vector2= Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
		move_vec*= move_force
		
		apply_central_force(Vector3(move_vec.x, 0.0, move_vec.y))
		 
		if Input.is_action_just_pressed("ui_select"):
			apply_central_impulse(Vector3.UP * jump_velocity)
	else:
		linear_damp= 0.0

class_name PlayerCharacter
extends BaseCharacter

@onready var state_machine: StateMachine = $StateMachine
#@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D 

#@onready var hitbox_collider: CollisionShape2D = $HitboxComponent/HitboxCollider
##@onready var hitbox_component: HitboxComponent = $HitboxComponent
#
#@onready var hurtbox_component: HurtboxComponent = $HurtboxComponent
#@onready var hurtbox_collider: CollisionShape2D = $HurtboxComponent/HurtboxCollider

@export var ATTACK_DAMAGE = 5


var damage_number_scene = preload("res://scenes/damage_number.tscn")

var screen_size: Vector2
# TODO fix statemachine
# TODO fix hurtbox_component
func _ready() -> void:
	super()
	#print("Children of ", name, ":")
	#for child in get_children():
		#print("- ", child.name)
	GameManager.player = self
	screen_size = get_viewport_rect().size
	state_machine.init(self)
	hurtbox_component.hit.connect(on_hit)
		
func _physics_process(delta) -> void:
	handle_player_input()

func handle_player_input():
	var input_direction: Vector2 = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	
	if is_animation_still_playing("attack"):
		handle_hitbox_collider()
		return
	
	if Input.is_action_pressed("action"):
		state_machine.change_to("Attack")
		return
		
	if input_direction != Vector2.ZERO:
		set_facing_direction(input_direction)
		state_machine.change_to("Run")
		pass
	else:
		state_machine.change_to("Idle")
	velocity = input_direction * speed
	move_and_slide()
		
func handle_hitbox_collider():
	pass
	#if animated_sprite_2d.frame == 2 && is_animation_still_playing("attack"):
		#hitbox_collider.disabled = false
	#else:
		#hitbox_collider.disabled = true
		
		
func is_animation_still_playing(animation_name: String):
	#return animated_sprite_2d.animation == animation_name && animated_sprite_2d.is_playing()
	return animation_player.current_animation == animation_name && animation_player.is_playing()


## for some reason all my actions are showing up as unhandled input
#func _unhandled_key_input(event):
	#print("unhandled key input detected "+ event.as_text())
func damage_vfx():
	## old
	# var sprite_material = animated_sprite_2d.material as ShaderMaterial
	var sprite_material = sprite_2d.material as ShaderMaterial
	
	sprite_material.set_shader_parameter("flash_modifier", 2.0) #intensity of flash
	var tween = create_tween()
	
	# how fast the effect fades
	tween.tween_property(sprite_material, "shader_parameter/flash_modifier", 0.0, .2)
	
func on_hit(attack_data: Attack):
	if health_component:
		damage_vfx()
		spawn_damage_numbers(attack_data.damage)
		health_component.take_damage(attack_data.damage)
		# NOTE: gamefeel variable
		GameManager.camera_shake_requested.emit(10.0, .1)

func spawn_damage_numbers(damage: int):
	var damage_number = damage_number_scene.instantiate()
	get_tree().current_scene.add_child(damage_number)
	var random_offset = Vector2(randf_range(-10, 10), randf_range(-20, 0))
	damage_number.start_animation(damage, global_position + random_offset)

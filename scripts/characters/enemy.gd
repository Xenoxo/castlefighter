extends BaseCharacter
class_name EnemyClass

@onready var hurtbox_component: HurtboxComponent = $HurtboxComponent
@onready var health_component: HealthComponent = $HealthComponent
#@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var attack_range: AttackRange = $AttackRange
@onready var state_machine: StateMachine = $StateMachine
@onready var hitbox_collider: CollisionShape2D = $HitboxComponent/HitboxCollider

@export var loot_table: LootTable
@export var flip_direction: bool = true

var damage_number_scene = preload("res://scenes/damage_number.tscn")
var is_pickupable: bool = false
var is_player_in_atk_range: bool = false

# NOTE: refactor ready func more?
func _ready() -> void:
	state_machine.init(self)
	
	print(state_machine.get_state("Attack").name)
	if state_machine:
		var attack_state: AttackState = state_machine.get_state("Attack")
		attack_state.on_enter = enemy_attack_logic # dependency injection
	
	hurtbox_component.hit.connect(on_hit)
	health_component.died.connect(die)
	attack_range.entered_attack_range.connect(update_is_player_in_atk_range)
	
	# logic to make the onhit flash unique to each instantiation
	if animated_sprite_2d.material:
		animated_sprite_2d.material = animated_sprite_2d.material.duplicate()	
	
	# begins playing idle animation on a randomized frame
	var random_frame = randi_range(0, animated_sprite_2d.sprite_frames.get_frame_count("idle"))
	animated_sprite_2d.set_frame_and_progress(random_frame, randf())
	
	## NOTE: hard coding facing left
	# eventually roll this into behavior tree
	set_facing_direction(Vector2.LEFT)

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

## custom enemy attack logic goes here
func enemy_attack_logic():
	if animated_sprite_2d.frame == 0:
		hitbox_collider.disabled = false
	else:
		hitbox_collider.disabled = true

func update_is_player_in_atk_range(in_range: bool):
	is_player_in_atk_range = in_range


func is_animation_still_playing(animation_name: String):
	return animated_sprite_2d.animation == animation_name && animated_sprite_2d.is_playing()
	# emit signal when attack is done playing from animation
	# this signal then ensures that SUCCESS triggers, else it's ongoing

func _physics_process(delta: float) -> void:
	if is_pickupable:
		if Input.is_action_pressed("player_click"):
			print("click")
	if Input.is_action_just_released("player_click"):
		print("LETTING GO")

func die():
	call_deferred("spawn_loot")
	call_deferred("queue_free")
	
func spawn_loot():
	if loot_table:
		var drops = loot_table.calculate_drops()

		for item_data in drops:
			if item_data.pickup_scene:
				var pickup_instance = item_data.pickup_scene.instantiate()
				get_parent().add_child(pickup_instance)
				pickup_instance.global_position = global_position
				pickup_instance.call_deferred("setup", item_data)
				
# NOTE: don't really understand how this all works, need to dig into shaders
func damage_vfx():
	var sprite_material = animated_sprite_2d.material as ShaderMaterial
	
	sprite_material.set_shader_parameter("flash_modifier", 2.0) #intensity of flash
	var tween = create_tween()
	
	# how fast the effect fades
	tween.tween_property(sprite_material, "shader_parameter/flash_modifier", 0.0, .2)

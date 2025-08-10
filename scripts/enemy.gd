extends CharacterBody2D
class_name EnemyClass

@onready var hurtbox_component: HurtboxComponent = $HurtboxComponent
@onready var health_component: HealthComponent = $HealthComponent
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

@export var loot_table: LootTable

var is_pickupable: bool = false

var damage_number_scene = preload("res://scenes/damage_number.tscn")

func _ready() -> void:
	# Connects take_damage(...) method to the "hit" signal inside the hurtbox component
	hurtbox_component.hit.connect(take_damage)
	health_component.died.connect(die)
	
	if animated_sprite_2d.material:
		animated_sprite_2d.material = animated_sprite_2d.material.duplicate()	
	
	# begins playing idle animation on a randomized frame
	animated_sprite_2d.play("idle")
	var random_frame = randi_range(0, animated_sprite_2d.sprite_frames.get_frame_count("idle"))
	animated_sprite_2d.set_frame_and_progress(random_frame, randf())
	

func _physics_process(delta: float) -> void:
	if is_pickupable:
		if Input.is_action_pressed("player_click"):
			print("click")
	if Input.is_action_just_released("player_click"):
		print("LETTING GO")

func _on_hurtbox_component_mouse_entered() -> void:
	is_pickupable = true
	pass # Replace with function body.

func _on_hurtbox_component_mouse_exited() -> void:
	is_pickupable = false
	pass # Replace with function body.

func take_damage(attack_data: Attack):
	if health_component:
		damage_vfx()
		# NOTE: gamefeel variable
		GameManager.camera_shake_requested.emit(10.0, .1)
		health_component.damage(attack_data.damage)
		

# --- Create the Damage Number ---
		# 1. Instance the scene.
		var damage_number = damage_number_scene.instantiate()

		# 2. Add it to the main level scene tree (NOT as a child of the enemy).
		# get_tree().current_scene is a robust way to get the main scene root.
		get_tree().current_scene.add_child(damage_number)
		
		# 3. Call its start function to begin the animation.
		# We add a slight random offset so numbers don't perfectly overlap.
		
		var random_offset = Vector2(randf_range(-10, 10), randf_range(-10, 10))
		damage_number.start_animation(attack_data.damage, global_position + random_offset)
		
	else:
		print("NO HEALTH COMPONENT")

# NOTE: don't really understand how this all works, need to dig into shaders
func damage_vfx():
	var sprite_material = animated_sprite_2d.material as ShaderMaterial
	
	sprite_material.set_shader_parameter("flash_modifier", 2.0) #intensity of flash
	var tween = create_tween()
	
	# how fast the effect fades
	tween.tween_property(sprite_material, "shader_parameter/flash_modifier", 0.0, .2)
	
#func die():
	#if loot_table:
		#var drops = loot_table.calculate_drops()
		#for item_data in drops:
			#if item_data.pickup_scene:
				#print("we in die")
				#var pickup_instance: PickupItem = item_data.pickup_scene.instantiate()
			#
				#get_parent().add_child(pickup_instance)
#
				#pickup_instance.global_position = global_position
				#await pickup_instance.ready
				#pickup_instance.setup(item_data)
#
	#self.queue_free()
func die():
	call_deferred("_spawn_loot")
	call_deferred("queue_free")
	
func _spawn_loot():
	if loot_table:
		var drops = loot_table.calculate_drops()

		for item_data in drops:
			if item_data.pickup_scene:
				var pickup_instance = item_data.pickup_scene.instantiate()
				get_parent().add_child(pickup_instance)
				pickup_instance.global_position = global_position

				pickup_instance.call_deferred("setup", item_data)

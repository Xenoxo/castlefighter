class_name PlayerCharacter
extends CharacterBody2D


@onready var state_machine: StateMachine = $StateMachine
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D

@onready var hitbox_collider: CollisionShape2D = $HitboxComponent/HitboxCollider
@onready var hitbox_component: HitboxComponent = $HitboxComponent

@export var speed: float = 100.0
@export var ATTACK_DAMAGE = 5

var screen_size: Vector2

func _ready() -> void:
	screen_size = get_viewport_rect().size
	state_machine.init(self)

	var tween = get_tree().create_tween()
	
	#tween.tween_property(animated_sprite_2d, "modulate", Color.RED, 1)
	#tween.tween_property(animated_sprite_2d, "scale", Vector2(), 1)
#	tween.tween_callback($Sprite.queue_free)
	
func _process(delta: float) -> void:	
	pass
	
func _physics_process(delta) -> void:
	#print("frame at " + str(animated_sprite_2d.frame))
	var input_direction: Vector2 = Vector2.ZERO
	if !is_animation_still_playing("attack"):
		if Input.is_action_pressed("action"):
			state_machine.change_to("Attack")
		else:
			if Input.is_action_pressed("move_right"):
				input_direction = Vector2.RIGHT	
			if Input.is_action_pressed("move_left"):
				input_direction = Vector2.LEFT	
			if Input.is_action_pressed("move_down"):
				input_direction = Vector2.DOWN	
			if Input.is_action_pressed("move_up"):
				input_direction = Vector2.UP

		input_direction = input_direction.normalized()
		velocity = input_direction * speed
		
		if velocity != Vector2.ZERO:
			state_machine.change_to("Run")
		# checks again else attack anim resets to idle before its done
		elif !is_animation_still_playing("attack"): 
			state_machine.change_to("Idle")
		move_and_slide()
	handle_hitbox_collider()
		
		
func handle_hitbox_collider():
	if animated_sprite_2d.frame == 2 && is_animation_still_playing("attack"):
		hitbox_collider.disabled = false
	else:
		hitbox_collider.disabled = true
		
		
func is_animation_still_playing(animation_name: String):
	return animated_sprite_2d.animation == animation_name && animated_sprite_2d.is_playing()

## for some reason all my actions are showing up as unhandled input
#func _unhandled_key_input(event):
	#print("unhandled key input detected "+ event.as_text())

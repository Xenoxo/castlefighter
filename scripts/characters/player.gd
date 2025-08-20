class_name PlayerCharacter
extends BaseCharacter

@onready var state_machine: StateMachine = $StateMachine
#@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

@onready var hitbox_collider: CollisionShape2D = $HitboxComponent/HitboxCollider
#@onready var hitbox_component: HitboxComponent = $HitboxComponent

@onready var hurtbox_component: HurtboxComponent = $HurtboxComponent
@onready var hurtbox_collider: CollisionShape2D = $HurtboxComponent/HurtboxCollider

@export var speed: float = 100.0
@export var ATTACK_DAMAGE = 5

var screen_size: Vector2

func _ready() -> void:
	screen_size = get_viewport_rect().size
	state_machine.init(self)
	
	
func _physics_process(delta) -> void:
	handle_player_input()

func handle_player_input():
	var input_direction: Vector2 = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	if !is_animation_still_playing("attack"):
		set_facing_direction(input_direction)
		if Input.is_action_pressed("action"):
			state_machine.change_to("Attack")
		else:
			velocity = input_direction * speed
			if velocity != Vector2.ZERO:
				#print(input_direction.x)
				state_machine.change_to("Run")
			else:
				state_machine.change_to("Idle")
		#input_direction = input_direction.normalized()
		move_and_slide()
	else:
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

extends CharacterBody2D
class_name BaseCharacter

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var hitbox_component: HitboxComponent = $HitboxComponent
@onready var health_component: HealthComponent = $HealthComponent

@export var speed: float = 50.0

func _ready() -> void:
	# 1. Safety Check: Ensure the component exists
	if not health_component:
		push_error("HealthComponent missing on " + name)
		return

	# 2. Initialization: Set the starting health
	# Since your HealthComponent's _ready is empty, we must do this here.
	health_component.current_health = health_component.starting_health

	# 3. Signal Connection: Listen for death
	health_component.died.connect(_on_death)

# Define the callback function for when the signal is received
func _on_death() -> void:
	# Default behavior (can be overridden by Player/Enemy scripts)
	print(name + " has died.")
	queue_free()
	
#var facing_left: bool = false
func set_facing_direction(direction: Vector2) -> void:
	if abs(direction.x) == 0:
		return
	animated_sprite_2d.flip_h = direction.x < 0.0
	
	if hitbox_component:
		var flip_scale = -1 if animated_sprite_2d.flip_h else 1
		hitbox_component.scale.x = flip_scale

extends CharacterBody2D
class_name BaseCharacter

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var hitbox_component: HitboxComponent = $HitboxComponent

#var facing_left: bool = false
func set_facing_direction(direction: Vector2) -> void:
	if direction.x == 0.0:
		return
	animated_sprite_2d.flip_h = direction.x < 0.0
	
	if hitbox_component:
		var flip_scale = -1 if animated_sprite_2d.flip_h else 1
		hitbox_component.scale.x = flip_scale

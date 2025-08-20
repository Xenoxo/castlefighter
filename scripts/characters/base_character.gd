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

# NOTE: don't really understand how this all works, need to dig into shaders
func damage_vfx():
	var sprite_material = animated_sprite_2d.material as ShaderMaterial
	
	sprite_material.set_shader_parameter("flash_modifier", 2.0) #intensity of flash
	var tween = create_tween()
	
	# how fast the effect fades
	tween.tween_property(sprite_material, "shader_parameter/flash_modifier", 0.0, .2)
	
	

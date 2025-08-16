# Area that HURTS, receives damage, always active
extends Area2D
class_name HurtboxComponent

signal hit(attack: Attack)

# NOTE: need to rework attack object instead of storing damage in hitbox, or static
func _on_area_entered(hitbox: HitboxComponent) -> void:
	if hitbox is HitboxComponent and hitbox.attack_data:
		#print(hitbox.attack_data.damage)
		hit.emit(hitbox.attack_data)

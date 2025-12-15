# Area that HURTS, receives damage, always active
extends Area2D
class_name HurtboxComponent

signal hit(attack: Attack)

func _ready() -> void:
	# on ready, take the pre-existing class signal of "area_entered" and
	# connect it to the function I defined called _on_area_entered
	area_entered.connect(_on_area_entered)

# NOTE: need to rework attack object instead of storing damage in hitbox, or static
func _on_area_entered(hitbox: HitboxComponent) -> void:
	if hitbox is HitboxComponent and hitbox.attack_data:
		#print(hitbox.attack_data.damage)
		hit.emit(hitbox.attack_data)
	else:
		print("Not a hitbox or no attack data")

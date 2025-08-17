extends Area2D
class_name AttackRange

signal entered_attack_range(in_range: bool)

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		print("Player detected in area 2D!")
		entered_attack_range.emit(true)

func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		print("Player leaving the area 2D!")
		entered_attack_range.emit(false)

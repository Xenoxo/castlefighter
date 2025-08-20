extends Node2D
class_name HealthComponent

@export var MAX_HEALTH := 100.0
signal died

var health : float 

func _ready() -> void:
	health = MAX_HEALTH

func take_damage(amount: int) -> void:
	health -= amount
	if health <= 0:
		died.emit()

func heal_health(amount: int) -> void:
	pass

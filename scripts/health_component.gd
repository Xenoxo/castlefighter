extends Node2D
class_name HealthComponent

@export var MAX_HEALTH := 100.0
var health : float 

func _ready() -> void:
	health = MAX_HEALTH

func damage(attack: int):
	health -= attack
	if health <= 0:
		if get_parent().has_method("die"):
			get_parent().die()

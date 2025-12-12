extends Node2D
class_name HealthComponent

@export var MAX_HEALTH := 100.0
@export var starting_health: float = 100.0

#@onready var health_component: HealthComponent = $HealthComponent

signal died

var current_health : float 

func _ready() -> void:
	pass

func take_damage(amount: int) -> void:
	current_health -= amount
	if current_health <= 0:
		died.emit()

func heal_health(amount: float) -> void:
	pass

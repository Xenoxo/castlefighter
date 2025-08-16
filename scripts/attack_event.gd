class_name Attack
extends Resource

@export var damage: int = 10
@export var knockback_force: float = 0.0
@export_enum("Slash", "Blunt", "Fire", "Ice") var damage_type: String = "Slash"

# You can even link to other resources or scenes!
@export var status_effect: Resource # (e.g., a custom "BurnEffect.tres")
@export var hit_vfx: PackedScene # (e.g., "hit_spark_effect.tscn")

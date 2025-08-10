class_name PickupItem
extends Area2D
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

func _ready() -> void:
	print("pickupitem ready")
	#animated_sprite_2d.play()
	animated_sprite_2d

func setup(item_data: ItemData):
	if item_data.animation_frames:
		animated_sprite_2d.sprite_frames = item_data.animation_frames
		animated_sprite_2d.play("spin")
	else:
		print("ERROR: pickup item contains no animation data")
	self.scale = Vector2(item_data.scale, item_data.scale)
	
	animated_sprite_2d.position.y = -30
	animated_sprite_2d.scale = Vector2(1.5, 1.5)
	
	var tween = create_tween()
	#tween.tween_property(animated_sprite_2d, "position", Vector2(0.0, 0.0), 3.0)
	# Animate the position back to (0,0) over 0.3 seconds with a bounce effect.
	tween.tween_property(animated_sprite_2d, "position", Vector2.ZERO, .75).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BOUNCE)
	
	# Animate the scale back to (1,1) at the same time.
	tween.parallel().tween_property(animated_sprite_2d, "scale", Vector2.ONE, .3)


func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("player_pickup_area"):
		print("Player picked up a coin!")
		# For example: GameManager.add_gold(1)
		call_deferred("queue_free")

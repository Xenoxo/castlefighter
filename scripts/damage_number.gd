extends Node2D

@onready var label = $Label

# This is the main function we'll call from our enemy.
func start_animation(damage_amount: int, start_position: Vector2):
	# Set the text and position when the number is created.
	label.text = str(damage_amount)
	global_position = start_position
	
	# Create a tween to handle the animation.
	var tween = create_tween()
	
	# 1. Animate the upward movement.
	# We'll tween its position relative to its starting point.
	# This moves it 50 pixels up over 0.6 seconds.
	tween.tween_property(self, "position:y", position.y - 50, 0.6).set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_OUT)
	
	# 2. Animate the fade-out effect at the same time.
	# We tween the 'modulate' property's alpha (transparency) from fully visible to fully invisible.
	# We add a small delay so it starts fading after 0.2 seconds.
	tween.tween_property(self, "modulate:a", 0.0, 0.2).set_delay(.1)
	
	# 3. Clean up the node when the tween is finished.
	# The 'tween.finished' signal is emitted when all tweens are done.
	tween.finished.connect(queue_free)

extends Node

@onready var camera: Camera2D = %Camera2D
var shake_strength: float = 0.0

func _ready():
	# Connect this scene's shake_screen function to the global signal.
	# Now, whenever ANYONE in the game emits camera_shake_requested, this function will run.
	GameManager.camera_shake_requested.connect(shake_screen)

func _physics_process(delta):
	if shake_strength > 0:
		# Apply a random offset based on the current strength
		var random_offset = Vector2(randf_range(-shake_strength, shake_strength), randf_range(-shake_strength, shake_strength))
		camera.offset = random_offset
		
func shake_screen(strength: float, duration: float):
	if not is_instance_valid(camera):
		print("ERROR: Camera node is not valid.")
		return
	
	# Set the initial shake strength
	shake_strength = strength
	
	# Create a tween that will smoothly animate the shake_strength
	# property of THIS script from its current value down to 0.
	var tween = create_tween()
	tween.tween_property(self, "shake_strength", 0.0, duration)

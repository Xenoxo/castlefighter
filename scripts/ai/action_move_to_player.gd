extends ActionLeaf

class_name MoveToAttackRangeAction

# Set these in the Godot Inspector
@export var attack_range_node_path: NodePath
@export var stopping_distance: float = 5.0

func tick(actor: Node, blackboard: Blackboard) -> int:
	# --- Initial Checks ---
	if not GameManager.player:
		return FAILURE
	var enemy: EnemyClass = actor
	if not enemy:
		return FAILURE
	
	var target_position: Vector2

	# --- 1. Check if we already have a target point in the Blackboard ---
	#if blackboard.has_value("move_target_position"):
		#target_position = blackboard.get_value("move_target_position")
	#
	## --- 2. If not, calculate a new target point ---
	#else:
	var player_pos = GameManager.player.global_position
	var enemy_pos = enemy.global_position
	#var attack_range_shape = enemy.get_node(attack_range_node_path).shape
	var attack_range_shape = enemy.attack_range_shape.shape
	# For a horizontal capsule, 'height' is the length of the central part.
	var attack_distance = attack_range_shape.height / 2.0
	
	# Decide whether to approach from the left or right
	var direction_to_player = sign(player_pos.x - enemy_pos.x)
	if direction_to_player == 0: direction_to_player = 1 # Default to the right
	
	# Calculate the offset from the player's center
	var offset = Vector2(attack_distance * -direction_to_player, 0)
	target_position = player_pos + offset
	
	# Store the new target in the blackboard for next time
	blackboard.set_value("move_target_position", target_position)

	# --- 3. Check if we've reached the target ---
	if enemy.global_position.distance_to(target_position) <= stopping_distance:
		enemy.velocity = Vector2.ZERO
		enemy.move_and_slide()
		blackboard.erase_value("move_target_position")
		return SUCCESS

	# --- 4. If not, move towards the target ---
	else:
		var direction = enemy.global_position.direction_to(target_position)
		enemy.velocity = direction * enemy.speed
		enemy.set_facing_direction(direction)
		enemy.move_and_slide()
		enemy.state_machine.change_to("Run")
		
		# The action is still in progress.
		return RUNNING

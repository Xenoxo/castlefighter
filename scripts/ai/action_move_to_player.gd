	# if player is a thing
	# get player's positino
	# move and slide towards player in the direction
	
extends ActionLeaf

# NOTE: need to integrate stage changes into this as well
#		might also simplify it so that it just calls the run state and that handles
#		logic for finding and going towards player
func tick(actor:Node, _blackboard:Blackboard) -> int:
	if not GameManager.player:
		return FAILURE
	
	var enemy: EnemyClass = actor
	if enemy:
		var direction = enemy.global_position.direction_to(GameManager.player.global_position)
		enemy.velocity = direction * enemy.speed
		enemy.set_facing_direction(direction)
		enemy.move_and_slide()
		enemy.state_machine.change_to("Run")
		return RUNNING
	return FAILURE

# what I want is the enemy to move towards the player until it gets within the
# radius of the attack range, after which I want to move up.

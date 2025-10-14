extends ConditionLeaf  

func tick(actor, _blackboard):
	if owner:
		var player = get_tree().get_first_node_in_group("player")
		if not player:
			return FAILURE
			
		var enemy: EnemyClass = actor
		if enemy.is_player_in_atk_range or enemy.is_animation_still_playing("attack"):
			enemy.set_facing_direction(GameManager.player.position - enemy.position)
			return SUCCESS  
	return FAILURE

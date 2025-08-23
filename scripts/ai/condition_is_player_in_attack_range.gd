extends ConditionLeaf

func tick(actor: Node, _blackboard: Blackboard) -> int:
	var enemy: EnemyClass = actor
	if enemy.is_player_in_atk_range:
		return SUCCESS
	return FAILURE

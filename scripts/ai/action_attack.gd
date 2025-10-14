extends ActionLeaf  
  
func tick(actor, _blackboard: Blackboard):
	var enemy: EnemyClass = actor
	actor.state_machine.change_to("Attack")
	return SUCCESS

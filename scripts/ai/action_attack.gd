extends ActionLeaf  
  
func tick(actor, _blackboard):
	var enemy: EnemyClass = actor
	print("in attack action")	

	actor.state_machine.change_to("Attack")
	return SUCCESS

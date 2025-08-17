extends ActionLeaf

func tick(actor, _blackboard):
	var enemy: EnemyClass = actor
	print("in attack idle action")	
	actor.state_machine.change_to("Idle")
	#enemy.idle()
	return SUCCESS

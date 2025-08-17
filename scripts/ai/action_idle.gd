extends ActionLeaf

func tick(actor, _blackboard):
	var enemy: EnemyClass = actor
	print("in attack idle action")	
	
	enemy.idle()
	return SUCCESS

extends ActionLeaf  
  
func tick(actor, _blackboard):
	
	var enemy: EnemyClass = actor
	print("in attack action")	
	
	enemy.attack()
	return SUCCESS
	
	## NOT SURE: which status to return when...
	## getting tied 
	
	#if enemy.is_animation_still_playing("attack"):
		#return RUNNING
	##if actor.cant_do_your_action:  
		##return FAILURE  
	#if not enemy.is_animation_still_playing("attack"):
		#actor.attack()
		##return RUNNING

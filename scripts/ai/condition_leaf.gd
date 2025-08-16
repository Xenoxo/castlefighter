extends ConditionLeaf  
  
func tick(actor, _blackboard):  
 if owner:
  return SUCCESS  
 return FAILURE

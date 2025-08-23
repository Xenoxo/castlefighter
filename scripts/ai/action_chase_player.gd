extends ActionLeaf

# This action's only job is to command the FSM to enter the Run state.
func tick(actor: Node, _blackboard: Blackboard) -> int:
	var enemy: EnemyClass = actor

	# If the FSM is already doing what we want, the action is still "RUNNING".
	if enemy.state_machine.current_state.name == "Run":
		return RUNNING

	# If the FSM is in a neutral state, give it the command.
	if enemy.state_machine.current_state.name == "Idle":
		enemy.state_machine.change_to("Run")
		return RUNNING

	# If the FSM is busy with something else (like attacking), this action fails for now.
	return FAILURE

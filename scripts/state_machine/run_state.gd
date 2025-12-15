extends Node
class_name RunState

var fsm: StateMachine
var animation_player: AnimationPlayer

func enter():
	if not animation_player:
		push_error("animation player not found")
		return
	animation_player.play("run")
	#print("run state")

func exit(next_state):
	animation_player.stop()
	fsm.change_to(next_state)

extends Node
class_name AttackState

var fsm: StateMachine
var animation_player: AnimatedSprite2D

func enter():
	if not animation_player:
		push_error("animation player not found")
		return
	animation_player.play("attack")
	# logic for attack goes here

func exit(next_state):
	animation_player.stop()
	fsm.change_to(next_state)

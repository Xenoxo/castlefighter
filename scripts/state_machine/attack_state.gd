extends Node

class_name AttackState

var fsm: StateMachine
var player_reference: PlayerCharacter

func set_player_reference(player_node: CharacterBody2D):
	player_reference = player_node
	
func enter():
	player_reference.animated_sprite_2d.play("attack")
	print("Hello from attack!")


func exit(next_state):
	player_reference.animated_sprite_2d.stop()
	fsm.change_to(next_state)


#func _unhandled_key_input(event):
	#if event.pressed:
		#print("From Idle")

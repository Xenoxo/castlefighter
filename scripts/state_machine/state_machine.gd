extends Node
class_name StateMachine
# via https://gdscript.com/solutions/godot-state-machine/
## GOAL: a generic statemachine component

# statemachine internals
var current_state: Object
var history = []
var states = {}

func _ready() -> void:
	pass

func init(character_node: CharacterBody2D) -> void:
	for state in get_children():
		state.fsm = self
		state.animation_player = character_node.animated_sprite_2d		
		states[state.name] = state
		if current_state:
			remove_child(state)
		else:
			current_state = state
	current_state.enter()


func change_to(state_name):
	history.append(current_state.name)
	set_state(state_name)

func back():
	if history.size() > 0:
		set_state(history.pop_back())


func set_state(state_name):
	remove_child(current_state)
	current_state = states[state_name]
	add_child(current_state)
	current_state.enter()

func get_state(state_name: String) -> Node:
	return states.get(state_name, null)

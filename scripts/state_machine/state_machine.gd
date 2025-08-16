extends Node
# via https://gdscript.com/solutions/godot-state-machine/
class_name StateMachine

var current_state: Object
var parent_player: PlayerCharacter


var history = []
var states = {}

func _ready() -> void:
	pass

func init(player_node: CharacterBody2D) -> void:
	parent_player = player_node
	for state in get_children():
		print(state.name)
		state.fsm = self
		if state.has_method("set_player_reference"):
			state.set_player_reference(parent_player)
		states[state.name] = state
		if current_state:
			remove_child(state)
		else:
			current_state = state
	current_state.enter()


func change_to(state_name):
	#if current_state.name != "Attack" && parent_player.animated_sprite_2d.is_playing():
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

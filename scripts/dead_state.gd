# useful death state, need to tweak a bit

#class_name DeadState
#extends Node
#
#var fsm: StateMachine
#var enemy_reference: CharacterBody2D
#
#func set_player_reference(player_node: CharacterBody2D):
	#enemy_reference = player_node
	#
#func enter():
	## The Dead state is now in control. No other states will run their logic.
	#
	## 1. Stop all movement and disable collisions
	#enemy_reference.velocity = Vector2.ZERO
	#enemy_reference.get_node("CollisionShape2D").disabled = true
	#
	## 2. Handle Loot Drops
	#if enemy_reference.loot_table:
		#var drops = enemy_reference.loot_table.calculate_drops()
		#for item_data in drops:
			#if item_data.pickup_scene:
				#var pickup_instance = item_data.pickup_scene.instantiate()
				#enemy_reference.get_parent().add_child(pickup_instance)
				#pickup_instance.global_position = enemy_reference.global_position
				#await pickup_instance.ready
				#pickup_instance.setup(item_data)
	#
	## 3. Handle Death Animation (if you have one)
	#if enemy_reference.animated_sprite_2d.sprite_frames.has_animation("death"):
		#enemy_reference.animated_sprite_2d.play("death")
		## Wait for the animation to finish before removing the enemy
		#await enemy_reference.animated_sprite_2d.animation_finished
	#
	## 4. Finally, free the enemy node
	#enemy_reference.queue_free()
#
#func exit(next_state):
	## This state should never exit, as the enemy will be deleted.
	#pass

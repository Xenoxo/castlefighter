@tool
extends Node2D

# --- CONFIGURE THIS ---
# In the TileSet, find your single collidable water tile.
# Temporarily place it somewhere and use the print() method from the previous
# example to get its Source ID and Atlas Coords.
@export var collider_tile_source_id: int = 2
@export var collider_tile_atlas_coords: Vector2i = Vector2i(0, 0)
# --------------------


@export var bake_physics: bool = false:
	set(value):
		if value:
			print("RUNNING PHYSICS BAKER")
			_bake_physics_layer()

func _bake_physics_layer():
	# Get references to the layers
	var visual_water: TileMapLayer = get_node_or_null("Water")
	var visual_ground: TileMapLayer = get_node_or_null("Ground")
	var physics_layer: TileMapLayer = get_node_or_null("PhysicsLayer")

	if not visual_water or not visual_ground or not physics_layer:
		print("Error: Make sure 'VisualWaterLayer', 'VisualGroundLayer', and 'PhysicsLayer' nodes exist as children.")
		return
	
	print("Baking collision layer...")
	
	# 1. Clear the old physics layer completely
	physics_layer.clear()
	
	# 2. Get all the cells that have water tiles
	var water_cells = visual_water.get_used_cells()
	var ground_cells = visual_ground.get_used_cells()
	
	
	
	# 3. For each water cell...
	for cell in water_cells:
		
		# if there is NOT groung on top, returns null
		if not visual_ground.get_cell_tile_data(cell):
			
			# If there's NO ground tile, this is an obstacle.
			# Place a collidable water tile on the PhysicsLayer.
			physics_layer.set_cell(cell, collider_tile_source_id, collider_tile_atlas_coords)
	for cell in ground_cells:
			#print(str(visual_ground.get_cell_tile_data(cell).terrain))
			# NOTE: need to check for land tiles that have both nothing above and 
			# nothing below - these are individual cells that visually occupy 2 spaces
			var cell_above = visual_ground.get_neighbor_cell(cell,TileSet.CELL_NEIGHBOR_TOP_SIDE)
			var cell_below = visual_ground.get_neighbor_cell(cell, TileSet.CELL_NEIGHBOR_BOTTOM_SIDE)
			if visual_ground.get_cell_source_id(cell_above) == -1 && visual_ground.get_cell_source_id(cell_below) == -1:
				#var source = visual_ground.get_cell_source_id(cell_above)
				#print(visual_ground.get_cell_source_id(cell_above))
				physics_layer.set_cell(cell_above)
				print("actual cell: " + str(cell))
				pass
	print("Physics layer baking complete.")

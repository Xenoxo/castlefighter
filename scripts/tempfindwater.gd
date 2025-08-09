extends TileMapLayer
func _ready():
	# The coordinate of the tile you just placed.
	var coords = Vector2i(0, 0) 

	var source_id = get_cell_source_id(coords)
	var atlas_coords = get_cell_atlas_coords(coords)

	print("--- Collider Tile Info ---")
	print("Source ID: ", source_id)
	print("Atlas Coords: ", atlas_coords)
	print("------------------------")

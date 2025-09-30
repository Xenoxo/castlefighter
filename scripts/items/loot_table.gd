class_name LootTable
extends Resource

# This is the array of all possible items that can drop from this table.
@export var items: Array[LootDropItem]

## This function calculates and returns an array of items to drop.
func calculate_drops() -> Array[ItemData]:
	var drops: Array[ItemData] = []
	if items.is_empty():
		return drops

	var total_weight: float = 0.0
	for item_entry in items:
		total_weight += item_entry.weight
	
	print(total_weight)
	var random_value = randf_range(0, total_weight)
	
	for item_entry in items:
		print(random_value)
		if random_value < item_entry.weight:
			# We've chosen this item to drop.
			for i in item_entry.quantity:
				drops.append(item_entry.item)
			break # Stop after finding one drop type.
		else:
			random_value -= item_entry.weight
			
	return drops

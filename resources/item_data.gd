class_name ItemData
extends Resource


## The name of the item, e.g., "Gold Coin".
@export var item_name: String = "Item"
## The scene to instance when this item is dropped in the world.
@export var pickup_scene: PackedScene

@export var animation_frames: SpriteFrames
@export var scale: float = 1.0

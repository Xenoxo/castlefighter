extends Node

# This signal can be emitted from anywhere in the game.
# It will carry information about how strong and how long the shake should be.
signal camera_shake_requested(strength: float, duration: float)

# You can add other global variables here later, like score, lives, etc.

extends Node2D
class_name Card

signal slot_freed

# ---- VARIABLES ----

onready var pivot_node = $Pivot
onready var states_node = $States

# how many doors the card can have, between the range
export var min_door : int = 2
export var max_door : int = 2

# chances to get a color
# To prevent a color from being chosen, set the color value to 0
export(int) var blue : int = 0
export(int) var grey : int = 100
export(int) var red : int = 0

onready var color_chance : Dictionary = {
	"blue" : blue,
	"grey" : grey,
	"red" : red
}

var tiles_array : Array = []
var tiles_touched : int = 0

# ---- STATE MACHINE ACCESSORS -----

func set_state(value : StateBase):
	states_node.set_state(value)

func get_state() -> StateBase:
	return states_node.get_state()

func set_state_by_name(value : String):
	states_node.set_state_by_name(value)

func get_state_name() -> String:
	return states_node.get_state_name()

# ---- ONREADY ----

func _ready():
	# Get every tiles of the card
	for child in get_children():
		if child is Tile:
			tiles_array.append(child)
	
	states_node.setup()


# -- drag & drop & rotate functions --

# Triggered by (and connected from) a child tile
# Compute the offset between the mouse position and the position of the card to move the card accordingly
func on_tile_grabed():
	if get_state_name() == "Hand":
		set_state_by_name("Grabed")


# Triggered by (and connected from) a child tile
# Reset the offset at zero, and snap the card to the nearest position
# If the position isn't empty, reset its position in the hand of the player
func on_tile_droped():
	if get_state_name() == "Grabed":
		set_state_by_name("Drop")


# -- Card destruction --

# Replace every tile of the card by a void_tile in the grid,
# Emit a signal to the hand, to signify that a slot has been freed, and tell which one
# Then queue free the card
func destroy():
	if SCENES.scene_transitioning:
		return
	
	for tile in tiles_array:
		if tile.is_inside_tree():
			var tile_pos = tile.get_global_position()
			var grid_node = get_tree().get_current_scene().find_node("Grid")
			var void_tile = grid_node.void_tile_scene.instance()
			void_tile.set_global_position(tile_pos)
			grid_node.call_deferred("add_child", void_tile)
	
	emit_signal("slot_freed", get_parent())
	queue_free()

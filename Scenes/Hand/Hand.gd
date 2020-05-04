extends Node2D
class_name Hand

var cards_array : Array = [
	preload("res://Scenes/Cards/LineX2.tscn"),
	preload("res://Scenes/Cards/LineX3.tscn"),
	preload("res://Scenes/Cards/LX1.tscn"),
	preload("res://Scenes/Cards/LX2.tscn"),
	preload("res://Scenes/Cards/LX3.tscn"),
	preload("res://Scenes/Cards/RLX2.tscn"),
	preload("res://Scenes/Cards/Square.tscn")
]


func _ready():
	for slot in $CardsSlots.get_children():
		generate_card(slot)


# Generate a random card and insticiate it inside the given slot
func generate_card(slot: Position2D):
	var rng = randi() % len(cards_array)
	var new_card = cards_array[rng].instance()
	new_card.connect("slot_freed", self, "on_slot_freed")
	slot.call_deferred("add_child", new_card)


# Tiggered whenever a slot is freed
# Generate a new card
func on_slot_freed(slot: Position2D):
	generate_card(slot)

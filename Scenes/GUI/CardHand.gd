extends Node2D

onready var card_in_hand = preload("res://Scenes/GUI/Cards/CardInHand.tscn")

onready var LineX2_scene = preload("res://Scenes/Cards/LineX2.tscn")
onready var LineX3_scene = preload("res://Scenes/Cards/LineX3.tscn")
onready var LX1_scene = preload("res://Scenes/Cards/LX1.tscn")
onready var LX2_scene = preload("res://Scenes/Cards/LX2.tscn")
onready var RLX2_scene = preload("res://Scenes/Cards/RLX2.tscn")
onready var square_scene = preload("res://Scenes/Cards/Square.tscn")

onready var possible_cards_array : Array = [LineX2_scene, LineX3_scene, LX1_scene, LX2_scene, RLX2_scene, square_scene]


export var cards_number : int = 4

var screen_width : float = ProjectSettings.get("display/window/size/width")
var screen_height : float =  ProjectSettings.get("display/window/size/height")

var hand_x_pos = screen_width - 20

var card_margin = screen_height / (cards_number - 1)

var rng = RandomNumberGenerator.new()

func _ready():
	for i in range(cards_number):
		# Generate a random card
		var new_card_in_hand_node = card_in_hand.instance()
		add_child(new_card_in_hand_node)
		
		# Place the card on the right position
		new_card_in_hand_node.set_position(Vector2(hand_x_pos, card_margin * i))
		
		rng.randomize()
		var index = rng.randi_range(0, len(possible_cards_array) -1)
		var new_card = possible_cards_array[index].instance()
		
		new_card_in_hand_node.add_child(new_card)


extends Control

onready var music_slider_node = $MusicSlider
onready var sounds_slider_node = $SoundsSlider

onready var music_bus_id = AudioServer.get_bus_index("Music")
onready var sounds_bus_id = AudioServer.get_bus_index("Sounds")

func _ready():
	music_slider_node.set_value(db2linear(AudioServer.get_bus_volume_db(music_bus_id)))
	sounds_slider_node.set_value(db2linear(AudioServer.get_bus_volume_db(sounds_bus_id)))
	
	music_slider_node.connect("value_changed", self, "on_music_value_changed")
	sounds_slider_node.connect("value_changed", self, "on_sounds_value_changed")


func on_music_value_changed(value : float):
	AudioServer.set_bus_volume_db(music_bus_id, linear2db(value))


func on_sounds_value_changed(value : float):
	AudioServer.set_bus_volume_db(sounds_bus_id, linear2db(value))


func _input(_event : InputEvent):
	if Input.is_action_just_pressed("ui_cancel"):
		var _err = get_tree().change_scene_to(SCENES.screen_title)

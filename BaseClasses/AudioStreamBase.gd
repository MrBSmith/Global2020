extends AudioStreamPlayer

class_name AudioStreamBase

onready var original_volume = get_volume_db()

var fade_in : bool = false
var fade_out : bool = false

export var fade_speed : float = 6

func _process(_delta):
	if fade_in == true:
		fading_in()
	elif fade_out == true:
		fading_out()


func fading_in():
	set_fade_out(false)
	volume_db += fade_speed
	if get_volume_db() >= original_volume:
		volume_db = original_volume
		set_fade_in(false)


func fading_out():
	set_fade_in(false)
	volume_db -= fade_speed * 0.3
	if get_volume_db() <= -80:
		set_fade_out(false)


func mute():
	set_volume_db(-80)


func set_fade_in(value : bool):
	fade_in = value


func set_fade_out(value : bool):
	fade_out = value

extends AudioStreamPlayer

class_name AudioStreamBase

onready var original_volume = get_volume_db()

enum STATE_MAP {
	NONE,
	FADE_IN,
	FADE_OUT
}

var state = STATE_MAP.NONE

export var fade_speed : float = 6

func _process(_delta):
	if state == STATE_MAP.FADE_IN:
		fading_in()
	elif state == STATE_MAP.FADE_OUT:
		fading_out()


func fading_in():
	volume_db += fade_speed
	if get_volume_db() >= original_volume:
		volume_db = original_volume
		state = STATE_MAP.NONE


func fading_out():
	volume_db -= fade_speed * 0.3
	if get_volume_db() <= -80:
		state = STATE_MAP.NONE


func mute():
	set_volume_db(-80)


func set_fade_in():
	state = STATE_MAP.FADE_IN


func set_fade_out():
	state = STATE_MAP.FADE_OUT

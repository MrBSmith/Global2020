extends Timer

class_name TimerBase

signal start_timer

func setup():
	var _err = connect("start_timer", get_parent(), "on_timer_started")
	_err = connect("timeout", get_parent(), "on_timer_timeout")

func start_timer():
	start()
	emit_signal("start_timer")

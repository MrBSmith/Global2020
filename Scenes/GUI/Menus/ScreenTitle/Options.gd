extends MenuOptionsBase

func options_action():
	var _err = get_tree().change_scene_to(SCENES.sound_menu)

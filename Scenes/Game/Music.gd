extends Node

func play_music(node_name : String):
	var stream_node = get_node_or_null(node_name)
	
	if stream_node != null:
		stream_node.play()
	else:
		print("Le stream spécifié n'existe pas.")

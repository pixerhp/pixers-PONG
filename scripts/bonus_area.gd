extends Node

func _process(_delta):
	if Input.is_action_just_pressed("pause_escape"):
		get_tree().change_scene_to_file("res://scenes/topscenes/titlescreen_topscene.tscn")

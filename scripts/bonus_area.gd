extends Node

func _ready():
	reset_framing(Vector2i(2048, 1536))

func reset_framing(content_size: Vector2i):
	get_window().set_content_scale_size(content_size)
	%CenteringParent.set_size(content_size)
	%CenteringParent.set_position(
		(get_viewport().get_visible_rect().size / 2.0) - (content_size / 2.0))
	%ClippingParent.set_size(content_size)
	%ClippingParent.set_position(Vector2(0,0))

func _process(_delta):
	if Input.is_action_just_pressed("pause_escape"):
		get_tree().change_scene_to_file("res://scenes/topscenes/titlescreen_topscene.tscn")

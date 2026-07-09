extends Node

func _ready():
	reset_framing(Vector2i(800, 600))

func _process(_delta: float):
	if (
		(not Globals.listening_for_input) and 
		Input.is_action_just_pressed("pause_escape") and 
		%SettingsMenu.visible
	):
		%SettingsMenu.visible = false

func reset_framing(content_size: Vector2i):
	get_window().set_content_scale_size(content_size)
	%CenteringParent.set_size(content_size)
	%CenteringParent.set_position(
		(get_viewport().get_visible_rect().size / 2.0) - (content_size / 2.0))
	%ClippingParent.set_size(content_size)
	%ClippingParent.set_position(Vector2(0,0))


func _on_play_button_pressed():
	get_tree().change_scene_to_file("res://scenes/topscenes/gameplay_topscene.tscn")

func _on_settings_button_pressed():
	%SettingsMenu.visible = true

func _on_extras_button_pressed():
	pass # Replace with function body.

func _on_quit_button_pressed():
	get_tree().quit()


func _on_ts_area_entered(which: String):
	var node_ref: Control
	match which:
		"exit":
			node_ref = %TSExitTexture
		"play":
			node_ref = %TSPlayTexture
		"settings":
			node_ref = %TSSettingsTexture
		"bonus":
			node_ref = %TSBonusTexture
	node_ref.modulate = Color.WHITE

func _on_ts_area_exited(which: String):
	var node_ref: Control
	match which:
		"exit":
			node_ref = %TSExitTexture
		"play":
			node_ref = %TSPlayTexture
		"settings":
			node_ref = %TSSettingsTexture
		"bonus":
			node_ref = %TSBonusTexture
	node_ref.modulate = Color(0.8, 0.8, 0.8, 1.0)

func _on_ts_area_input_event(_viewport, event, _shape_idx, which: String):
	if (event is InputEventMouseButton) and (event.button_index == MouseButton.MOUSE_BUTTON_LEFT) and event.pressed:
		match which:
			"exit":
				get_tree().quit()
			"play":
				get_tree().change_scene_to_file("res://scenes/topscenes/gameplay_topscene.tscn")
			"settings":
				%SettingsMenu.visible = true
			"bonus":
				pass

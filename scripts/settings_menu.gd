extends Control

func _on_close_settings_button_pressed():
	self.visible = false


func _on_plr_1_move_up_item_list_item_clicked(index, at_position, mouse_button_index):
	print("CLICKED")

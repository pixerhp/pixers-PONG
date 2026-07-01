extends Control

func _ready():
	%ApplyCourtSizeButton.visible = (get_tree().current_scene.name == "GameplayTopscene")
	# !!! remember to make field changes auto apply from the titlescreen
	# !!! but require the button from gameplay.
	keybinds_itemlist_refresh()

func _on_close_settings_button_pressed():
	self.visible = false

func _on_settings_tab_button_pressed(tab_name: String):
	%GeneralTabButton.disabled = false
	%KeybindsTabButton.disabled = false
	%AdvancedTabButton.disabled = false
	%GeneralSettingsArea.visible = false
	%KeybindsSettingsArea.visible = false
	%AdvancedSettingsArea.visible = false
	match tab_name:
		"General":
			%GeneralTabButton.disabled = true
			%GeneralSettingsArea.visible = true
		"Keybinds":
			%KeybindsTabButton.disabled = true
			%KeybindsSettingsArea.visible = true
		"Advanced":
			%AdvancedTabButton.disabled = true
			%AdvancedSettingsArea.visible = true


func _on_keybinds_itemlist_clicked(index, _at_position, mouse_button_index, action_name: String):
	if not (mouse_button_index == MouseButton.MOUSE_BUTTON_LEFT):
		return
	print(action_name)
	print(keybinds_itemlist_from_action(action_name))
	if index == 0:
		keybinds_initiate_add(action_name)
	else:
		keybinds_initiate_remove(action_name, index)

func keybinds_initiate_add(action_name: String):
	var itemlist_ref: ItemList = keybinds_itemlist_from_action(action_name)
	
	
	pass

func keybinds_initiate_remove(action_name: String, index: int):
	var itemlist_ref: ItemList = keybinds_itemlist_from_action(action_name)
	
	
	pass

func keybinds_itemlist_from_action(action_name: String) -> ItemList:
	match action_name:
		"plr1_up":
			return %Plr1MoveUpItemList
		"plr1_down":
			return %Plr1MoveDownItemList
		"plr1_bump_left":
			return %Plr1BumpOutItemList
		"plr1_bump_right":
			return %Plr1BumpInItemList
		"plr1_slow":
			return %Plr1SlowItemList
		"plr2_up":
			return %Plr2MoveUpItemList
		"plr2_down":
			return %Plr2MoveDownItemList
		"plr2_bump_left":
			return %Plr2BumpInItemList
		"plr2_bump_right":
			return %Plr2BumpOutItemList
		"plr2_slow":
			return %Plr2SlowItemList
		"pause_escape":
			return %PauseEscapeItemList
		"fullscreen_toggle":
			return %FullscreenToggleItemList
		_:
			return null

func keybinds_itemlist_refresh(action_name: String = ""):
	if action_name == "":
		keybinds_itemlist_refresh("plr1_up")
		keybinds_itemlist_refresh("plr1_down")
		keybinds_itemlist_refresh("plr1_bump_left")
		keybinds_itemlist_refresh("plr1_bump_right")
		keybinds_itemlist_refresh("plr1_slow")
		keybinds_itemlist_refresh("plr2_up")
		keybinds_itemlist_refresh("plr2_down")
		keybinds_itemlist_refresh("plr2_bump_left")
		keybinds_itemlist_refresh("plr2_bump_right")
		keybinds_itemlist_refresh("plr2_slow")
		keybinds_itemlist_refresh("pause_escape")
		keybinds_itemlist_refresh("fullscreen_toggle")
		return
	var itemlist_noderef: ItemList = keybinds_itemlist_from_action(action_name)
	if itemlist_noderef == null:
		push_error(
			"Failed to get settings keybinds itemlist node reference for action: ",
			action_name)
		return
	while itemlist_noderef.item_count > 1:
		itemlist_noderef.remove_item(1)
	for input_event in InputMap.action_get_events(action_name):
		itemlist_noderef.add_item("    "+input_event.as_text(), null, false)

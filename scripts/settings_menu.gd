extends Control

#### UNIVERSAL ####

func _ready():
	%ApplyCourtSizeButton.visible = (get_tree().current_scene.name == "GameplayTopscene")
	refresh_general_settings()
	refresh_keybinds_settings()
	refresh_advanced_settings()

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

#### GENERAL SETTINGS ####

# !!! remember to involve audio stuff later

func refresh_general_settings():
	%MusicVolumeSlider.value = Globals.music_volume
	%SoundsVolumeSlider.value = Globals.sounds_volume
	%Plr1CPUDropdown.clear()
	%Plr2CPUDropdown.clear()
	for cpu_mode in Globals.CPU_MODES:
		%Plr1CPUDropdown.add_item(cpu_mode)
		%Plr2CPUDropdown.add_item(cpu_mode)
	%Plr1CPUDropdown.selected = Globals.plr1_cpu_mode
	%Plr2CPUDropdown.selected = Globals.plr2_cpu_mode
	%Plr1ForceSlowTickbox.button_pressed = Globals.plr1_force_slow
	%Plr2ForceSlowTickbox.button_pressed = Globals.plr2_force_slow
	%CourtWidthEntry.value = Globals.court_size.x
	%CourtHeightEntry.value = Globals.court_size.y
	%ApplyCourtSizeButton.disabled = true

# !!! remember to make court size changes auto apply from the titlescreen,
# !!! but require the button from gameplay.

#### KEYBINDS SETTINGS ####

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

func refresh_keybinds_settings(action_name: String = ""):
	if action_name == "":
		refresh_keybinds_settings("plr1_up")
		refresh_keybinds_settings("plr1_down")
		refresh_keybinds_settings("plr1_bump_left")
		refresh_keybinds_settings("plr1_bump_right")
		refresh_keybinds_settings("plr1_slow")
		refresh_keybinds_settings("plr2_up")
		refresh_keybinds_settings("plr2_down")
		refresh_keybinds_settings("plr2_bump_left")
		refresh_keybinds_settings("plr2_bump_right")
		refresh_keybinds_settings("plr2_slow")
		refresh_keybinds_settings("pause_escape")
		refresh_keybinds_settings("fullscreen_toggle")
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

#### ADVANCED SETTINGS ####

func refresh_advanced_settings():
	%BallMinSpeedEntry.value = Globals.ball_min_speed
	%BallMaxSpeedEntry.value = Globals.ball_max_speed
	%PadHitSpeedupEntry.value = Globals.ball_padhit_speedup
	%PreventBackhitsTickbox.button_pressed = Globals.prevent_ball_backhits
	%SidebumpDurationEntry.value = Globals.pad_sidebump_duration
	%SidebumpStrengthEntry.value = Globals.pad_sidebump_strength
	%PaddleKnockbackDurationEntry.value = Globals.pad_knockback_duration
	%BallTrailDurationEntry.value = Globals.balltrail_duration
	%FirstServeDurationEntry.value = Globals.firstserve_anim_duration
	%WinlossDurationEntry.value = Globals.winloss_anim_duration
	%FoulSuspicionDurationEntry.value = Globals.foulball_suspicion_anim_duration
	%FoulNevermindDurationEntry.value = Globals.foulball_nevermind_anim_duration
	%FoulReserveDurationEntry.value = Globals.foulball_reserve_anim_duration
	%PostServeDurationEntry.value = Globals.postserve_anim_duration

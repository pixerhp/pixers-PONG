extends Control

func _ready():
	%ApplyCourtSizeButton.visible = (get_tree().current_scene.name == "GameplayTopscene")
	refresh_general_settings()
	refresh_keybinds_settings()
	refresh_advanced_settings()
	_on_settings_tab_button_pressed("General")

func _process(_delta):
	# Intentional 1 frame delay, to avoid a possible 'pause_escape' action from closing settings.
	if (Globals.listening_for_input and not %ListeningForInputRect.visible):
		Globals.listening_for_input = false

func _on_close_settings_button_pressed():
	self.visible = false
	Globals.listening_for_input = false

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

# Used to help release focus for when you click off of a thing:
func _on_settings_area_gui_input(event):
	if (
		(event is InputEventMouseButton) and
		(event.button_index == MOUSE_BUTTON_LEFT) and
		event.pressed
	):
		get_viewport().gui_release_focus()

# NOTE consider making a global function rather than this hacky duplicate?
func set_input(action_name: String, state: bool):
	var input_event = InputEventAction.new()
	input_event.action = action_name
	input_event.pressed = state
	Input.parse_input_event(input_event)

#### GENERAL SETTINGS ####

# NOTE remember to involve audio stuff later

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

# NOTE consider "using a debouncing timer to call the function less often"
# NOTE for repeatedly playing a volume-reference sound when audio volume is changed?
func _audio_slider_value_changed(value: float, which: String):
	match which:
		"music":
			Globals.music_volume = value
		"sounds":
			Globals.sounds_volume = value

func _plr_cpu_mode_selected(index: int, is_plr2: bool):
	if is_plr2:
		Globals.plr2_cpu_mode = index
	else:
		Globals.plr1_cpu_mode = index

func _plr_force_slow_toggled(bool_val: bool, is_plr2: bool):
	if is_plr2:
		Globals.plr2_force_slow = bool_val
		set_input("plr2_slow", bool_val)
	else:
		Globals.plr1_force_slow = bool_val
		set_input("plr1_slow", bool_val)

func _court_size_entry_value_changed(value: float, is_height: bool):
	print(value)
	if get_tree().current_scene.name == "GameplayTopscene":
		%ApplyCourtSizeButton.disabled = false
	else:
		if is_height:
			Globals.court_size.y = int(value)
		else:
			Globals.court_size.x = int(value)
func _on_apply_court_size_button_pressed():
	Globals.court_size.x = int(%CourtWidthEntry.value)
	Globals.court_size.y = int(%CourtHeightEntry.value)
	Globals.reset_court_for_new_court_size = true
	%ApplyCourtSizeButton.disabled = true

#### KEYBINDS SETTINGS ####

func _on_keybinds_itemlist_clicked(index, _at_position, mouse_button_index, action_name: String):
	if not (mouse_button_index == MouseButton.MOUSE_BUTTON_LEFT):
		return
	print(action_name)
	print(keybinds_itemlist_from_action(action_name))
	if index == 0:
		keybinds_initiate_add(action_name)
	else:
		InputMap.action_erase_event(action_name, InputMap.action_get_events(action_name)[index-1])
		refresh_keybinds_settings(action_name)

var _keybinds_action_to_add_to: String = ""
func keybinds_initiate_add(action_name: String):
	_keybinds_action_to_add_to = action_name
	Globals.listening_for_input = true
	%ListeningForInputRect.visible = true

func _input(event: InputEvent) -> void:
	if Globals.listening_for_input == false:
		return
	if not (
		(event is InputEventKey) or 
		((event is InputEventMouseButton) and event.pressed) or 
		(event is InputEventJoypadButton) or 
		(event is InputEventJoypadMotion)
	):
		return
	
	InputMap.action_add_event(_keybinds_action_to_add_to, event)
	
	refresh_keybinds_settings(_keybinds_action_to_add_to)
	%ListeningForInputRect.hide()

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
	if action_name.is_empty():
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

func _prevent_ball_backhits_toggled(bool_val: bool):
	Globals.prevent_ball_backhits = bool_val

func _advanced_entry_value_changed(value: float, var_name: String):
	match var_name:
		"ball_min_speed":
			Globals.ball_min_speed = value
			%BallMinSpeedEntry.value = Globals.ball_min_speed
		"ball_max_speed":
			Globals.ball_max_speed = value
			%BallMaxSpeedEntry.value = Globals.ball_max_speed
		"ball_padhit_speedup":
			Globals.ball_padhit_speedup = value
			%PadHitSpeedupEntry.value = Globals.ball_padhit_speedup
		"pad_sidebump_duration":
			Globals.pad_sidebump_duration = int(value)
			%SidebumpDurationEntry.value = Globals.pad_sidebump_duration
		"pad_sidebump_strength":
			Globals.pad_sidebump_strength = value
			%SidebumpStrengthEntry.value = Globals.pad_sidebump_strength
		"pad_knockback_duration":
			Globals.pad_knockback_duration = int(value)
			%PaddleKnockbackDurationEntry.value = Globals.pad_knockback_duration
		"balltrail_duration":
			Globals.balltrail_duration = int(value)
			%BallTrailDurationEntry.value = Globals.balltrail_duration
		"firstserve_anim_duration":
			Globals.firstserve_anim_duration = int(value)
			%FirstServeDurationEntry.value = Globals.firstserve_anim_duration
		"winloss_anim_duration":
			Globals.winloss_anim_duration = int(value)
			%WinlossDurationEntry.value = Globals.winloss_anim_duration
		"foulball_suspicion_anim_duration":
			Globals.foulball_suspicion_anim_duration = int(value)
			%FoulSuspicionDurationEntry.value = Globals.foulball_suspicion_anim_duration
		"foulball_nevermind_anim_duration":
			Globals.foulball_nevermind_anim_duration = int(value)
			%FoulNevermindDurationEntry.value = Globals.foulball_nevermind_anim_duration
		"foulball_reserve_anim_duration":
			Globals.foulball_reserve_anim_duration = int(value)
			%FoulReserveDurationEntry.value = Globals.foulball_reserve_anim_duration
		"postserve_anim_duration":
			Globals.postserve_anim_duration = int(value)
			%PostServeDurationEntry.value = Globals.postserve_anim_duration
		_:
			push_error("Unhandled var_name parameter: ", var_name)

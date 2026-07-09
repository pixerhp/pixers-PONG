extends Node

var window_mode_pre_fullscreen: int = ProjectSettings.get_setting("display/window/size/mode")
func _process(_delta):
	if (not listening_for_input) and Input.is_action_just_pressed("fullscreen_toggle"):
		if not DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN:
			window_mode_pre_fullscreen = DisplayServer.window_get_mode()
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
		else:
			DisplayServer.window_set_mode(window_mode_pre_fullscreen)

#### GENERAL SETTINGS:

var music_volume: float = 0.5
var sounds_volume: float = 0.5

enum CPU_MODES {
	OFF,
	OFF_BUT_YOURE_A_ROBOT, # Beep boop.
	COPYCAT, # Copies the other player's inputs with a one-frame delay.
	RANDOM_MASH, # Mashes random movement inputs. (It's not very effective.)
	ZIGZAGGER, # Alternately moves between the top and bottom paddle positions. 
	CHASER, # Simply "chases" the ball's y-position.
	CONVERGER, # "Converges" onto where the ball will go if it continues on its current path.
	PATIENT_CONVERGER, # Like converger, but situationally waits in the middle.
	BOUNCE_PREDICTOR, # Similar to converger, but can account for one bounce.
	DOUBLE_PREDICTOR, # Similar to bounce predictor, but accounts for up to two bounces.
	DEEP_PREDICTOR, # Predicts where the ball will go after an arbitrary number of bounces.
	MASTER, # Predicts their opponent's paddle hit, and strategically tries to defeat them. Good luck.
}
var plr1_cpu_mode: int = CPU_MODES.OFF
var plr1_force_slow: bool = false
var plr2_cpu_mode: int = CPU_MODES.OFF
var plr2_force_slow: bool = false

var court_size: Vector2i = Vector2i(1260, 648)
var reset_court_for_new_court_size: bool = false

#### KEYBINDS SETTINGS:

var listening_for_input: bool = false

#### ADVANCED SETTINGS:

var ball_min_speed: float = 300
var ball_max_speed: float = 4500
var ball_padhit_speedup: float = 35
var prevent_ball_backhits: bool = true
var pad_sidebump_duration: int = 400
var pad_sidebump_strength: float = 25.0

var pad_knockback_duration: int = 120
var balltrail_duration: int = 250

var firstserve_anim_duration: int = 5000
var winloss_anim_duration: int = 4500
var foulball_suspicion_anim_duration: int = 2000
var foulball_nevermind_anim_duration: int = 500
var foulball_reserve_anim_duration: int = 5000
var postserve_anim_duration: int = 1250

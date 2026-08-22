extends Node2D

@onready var dialog = $player/canvaslayer
@onready var camera = $player/camera
@onready var skip_button = $player/canvaslayer/skip
@onready var clues = $player/canvaslayer/clues

var camera_move_time := 2.0
var skip_requested := false

var conversation: Array[Dictionary] = [
	{"name": "Mayor Oinker", "text": "How could this have happened? It's horrible! This is intolerable!"},
	{"name": "Mayor Oinker", "text": "Out of everyone in Animal Village, they had to rob me! The mayor!"},
	{"name": "Mayor Oinker", "text": "Intolerable, this is intolerable…"},
	{"name": "Detective Fox", "text": "(...)"},
	{"name": "Detective Fox", "text": "(The mayor looks pretty shaken up. I guess that's understandable.)"},
	{"name": "Detective Fox", "text": "(Today at 3 AM the police got a call from a villager.)"},
	{"name": "Detective Fox", "text": "(She said she'd heard a noise coming from her neighbor's house: Mayor Oinker's house.)"},
	{"name": "Detective Fox", "text": "(When they arrived, they found this scene. Looks like a robbery took place here.)"},
	{"name": "Partner Woof", "text": "Mayor Oinker, tell us. What exactly was stolen?"},
	{"name": "Mayor Oinker", "text": "My briefcase! My beloved work briefcase... That's where I keep documents about construction projects, events, and lots of other things!"},
	{"name": "Mayor Oinker", "text": "It's extremely important that you find it as soon as possible, detective!"},
	{"name": "Mayor Oinker", "text": "All of Animal Village depends on those documents to function!"},
	{"name": "Detective Fox", "text": "(This is Oinker. He's the mayor of Animal Village.)"},
	{"name": "Detective Fox", "text": "(He's an old bastard who acts all nice whenever elections are coming up.)"},
	{"name": "Detective Fox", "text": "(Whatever's happening to him, he's got it coming, that's for sure.)"},
	{"name": "Detective Fox", "text": "(Still, it's strange that someone tried to rob him. Oinker isn't someone you'd want to mess with.)"},
	{"name": "Partner Woof", "text": "Don't worry, Mayor Oinker! We'll have this case closed before you know it!"},
	{"name": "Partner Woof", "text": "Mr. Fox, let's start searching this house from top to bottom!"},
	{"name": "Detective Fox", "text": "(This is Woof. They've put her under my charge as a detective trainee and assistant.)"},
	{"name": "Detective Fox", "text": "(I never asked for an assistant. But I can't exactly go against the boss's orders either.)"},
	{"name": "Detective Fox", "text": "(I hope she turns out to be more useful than she looks.)"},
	{"name": "Detective Fox", "text": "Don't touch anything. Just watch me work and learn the procedure."},
	{"name": "Partner Woof", "text": "Ehhh? That's no fun at all!"},
	{"name": "Partner Woof", "text": "You're not in on it with the thief, are you?"},
	{"name": "Detective Fox", "text": "(... This is going to be a long day.)"}
]

func _ready() -> void:
	skip_button.pressed.connect(func(): skip_requested = true)
	clues.visible = false
	await _play_intro()
	skip_button.visible = false
	clues.visible = true

func _wait(seconds: float) -> void:
	var timer := get_tree().create_timer(seconds)
	while timer.time_left > 0.0 and not skip_requested:
		await get_tree().process_frame

func _play_tween(tween: Tween) -> void:
	while tween.is_running() and not skip_requested:
		await get_tree().process_frame
	if skip_requested:
		tween.kill()

func _play_intro() -> void:
	dialog.external_lock = true
	await _wait(1.0)

	var tween_out := create_tween()
	tween_out.tween_property(camera, "position:x", -1261, camera_move_time)\
		.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	await _play_tween(tween_out)
	await _wait(1.5)

	var tween_back := create_tween()
	tween_back.tween_property(camera, "position:x", -581, camera_move_time)\
		.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	await _play_tween(tween_back)
	await _wait(1.0)

	camera.position.x = -581
	dialog.external_lock = false
	dialog.show_next()

	if skip_requested:
		return

	dialog.start_dialog(conversation)
	while dialog.state != dialog.State.CLOSED and not skip_requested:
		await get_tree().process_frame

	if skip_requested and dialog.state != dialog.State.CLOSED:
		dialog.force_close()

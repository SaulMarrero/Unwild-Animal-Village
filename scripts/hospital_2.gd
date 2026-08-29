extends Node2D

@onready var canvaslayer = $player/canvaslayer
@onready var areas: Array[Node] = [$wolf, $meow, $paintings, $books]

var fade_time := 1.0
var visitedCount := 0

var introConversation: Array[Dictionary] = [
	{"name": "Guard Wolf", "text": "What do you think, doctor? Nothing hurts anymore and I can move around fine."},
	{"name": "Doctor Meow", "text": "Yeah, your condition's improved quite a bit."},
	{"name": "Doctor Meow", "text": "Still, I'd recommend staying here a few more days before going back to work."},
	{"name": "Doctor Meow", "text": "I'll lower your pill dosage. Try to stay in bed as much as you can."},
	{"name": "Doctor Meow", "text": "[Turns around]"},
	{"name": "Doctor Meow", "text": "Oh… are you the detectives? Chief Teddy told me you'd be coming."},
	{"name": "Doctor Meow", "text": "Since I'm already here with Mr. Wolf, it'd be better if you talked to him now too."},
	{"name": "Doctor Meow", "text": "I'll have to run some checkups on him later, so it won't be possible then… that's fine with you, right, Mr. Wolf?"},
	{"name": "Guard Wolf", "text": "Yeah, sure. No problem, I guess."}
]

var finalConversation: Array[Dictionary] = [
	{"name": "Detective Fox", "text": "(There's nothing else to do here. We should keep gathering clues somewhere else.)"}
]

func _ready() -> void:
	canvaslayer.external_lock = true

	var layer := CanvasLayer.new()
	layer.layer = 10
	add_child(layer)

	var rect := ColorRect.new()
	rect.color = Color.BLACK
	rect.set_anchors_preset(Control.PRESET_FULL_RECT)
	layer.add_child(rect)

	var tween := create_tween()
	tween.tween_property(rect, "modulate:a", 0.0, 1.0)
	await tween.finished
	layer.queue_free()

	canvaslayer.external_lock = false
	canvaslayer.show_next()
	canvaslayer.start_dialog(introConversation)

	for area in areas:
		area.investigated.connect(_onAreaVisited)

func _onAreaVisited() -> void:
	visitedCount += 1

	if visitedCount >= areas.size():
		while canvaslayer.state != canvaslayer.State.CLOSED:
			await get_tree().process_frame

		canvaslayer.start_dialog(finalConversation)

		while canvaslayer.state != canvaslayer.State.CLOSED:
			await get_tree().process_frame

		canvaslayer.hide_next()

		for area in areas:
			area.caseClosed = true

		await _fadeOut()

func _fadeOut() -> void:
	var layer := CanvasLayer.new()
	layer.layer = 10
	add_child(layer)

	var rect := ColorRect.new()
	rect.color = Color.BLACK
	rect.modulate.a = 0.0
	rect.set_anchors_preset(Control.PRESET_FULL_RECT)
	layer.add_child(rect)

	var tween := create_tween()
	tween.tween_property(rect, "modulate:a", 1.0, fade_time)
	await tween.finished

	get_tree().change_scene_to_file("res://scenes/street.tscn")
	layer.queue_free()

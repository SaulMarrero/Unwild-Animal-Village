extends Node2D

@onready var canvaslayer = $player/canvaslayer
@onready var nextText = $player/canvaslayer/next/Label
@onready var player = $player
@onready var policeCall = $policeCall

func _ready() -> void:
	canvaslayer.show_next()
	_updatePlayerPosition()
	_updateNextText()

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

	if Clues.unlockedCount() >= 10 and not Clues.policeCallShown:
		await _playPoliceCall()

func _updatePlayerPosition() -> void:
	var count := Clues.unlockedCount()
	if count <= 5:
		player.position.x = 1150.0
	elif count <= 7:
		player.position.x = 3100.0
	elif count <= 9:
		player.position.x = 11000.0
	else:
		player.position.x = 9200

func _updateNextText() -> void:
	var count := Clues.unlockedCount()
	if count >= 10:
		nextText.text = "Go to the police station"
	elif count >= 8:
		nextText.text = "Go to the hospital"
	elif Clues.clue6:
		nextText.text = "Go to the police station"

func _playPoliceCall() -> void:
	Clues.policeCallShown = true
	policeCall.visible = true

	var conversation: Array[Dictionary] = [
		{"name": "Chief Teddy", "text": "Detective Fox, I've got two possible suspects gathered in my office."},
		{"name": "Chief Teddy", "text": "According to my sources, they're the only two poisonous animals in Animal Village."},
		{"name": "Chief Teddy", "text": "So at least one of them has to be guilty, or an accomplice in the robbery."},
		{"name": "Chief Teddy", "text": "Come down to the station right away, we're already holding them there."}
	]

	canvaslayer.start_dialog(conversation)

	await get_tree().process_frame

	while canvaslayer.state != canvaslayer.State.CLOSED:
		await get_tree().process_frame

	await _fadeToPolice()

func _fadeToPolice() -> void:
	var layer := CanvasLayer.new()
	layer.layer = 10
	add_child(layer)

	var rect := ColorRect.new()
	rect.color = Color.BLACK
	rect.modulate.a = 0.0
	rect.set_anchors_preset(Control.PRESET_FULL_RECT)
	layer.add_child(rect)

	var tween := create_tween()
	tween.tween_property(rect, "modulate:a", 1.0, 1.0)
	await tween.finished

	get_tree().change_scene_to_file("res://scenes/police.tscn")
	layer.queue_free()

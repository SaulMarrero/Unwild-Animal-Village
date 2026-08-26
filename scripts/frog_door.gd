extends Area2D

var doorId := "frogDoor"
var targetScene := "res://scenes/frog_house.tscn"
var fade_time := 1.0

@onready var dialog = $"../player/canvaslayer"

func _on_input_event(_viewport, event, _shape_idx) -> void:
	if event.is_action_pressed("click") and not get_viewport().gui_get_hovered_control():
		get_viewport().set_input_as_handled()

		if Clues.currentDoor() == doorId:
			_fadeToScene()
		else:
			dialog.start_dialog(Clues.currentDoorMessage())

func _fadeToScene() -> void:
	var layer := CanvasLayer.new()
	layer.layer = 10
	get_tree().root.add_child(layer)

	var rect := ColorRect.new()
	rect.color = Color.BLACK
	rect.modulate.a = 0.0
	rect.set_anchors_preset(Control.PRESET_FULL_RECT)
	layer.add_child(rect)

	var tween := create_tween()
	tween.tween_property(rect, "modulate:a", 1.0, fade_time)
	await tween.finished

	get_tree().change_scene_to_file(targetScene)
	layer.queue_free()

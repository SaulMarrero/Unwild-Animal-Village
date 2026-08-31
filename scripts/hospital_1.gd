extends Node2D

@onready var canvaslayer = $player/canvaslayer
@onready var nextText = $player/canvaslayer/next/Label

func _ready() -> void:
	var layer := CanvasLayer.new()
	layer.layer = 10
	add_child(layer)

	var rect := ColorRect.new()
	rect.color = Color.BLACK
	rect.set_anchors_preset(Control.PRESET_FULL_RECT)
	layer.add_child(rect)

	var tween := create_tween()
	tween.tween_property(rect, "modulate:a", 0.0, 1.0)
	tween.tween_callback(layer.queue_free)

	canvaslayer.show_next()

	if Clues.unlockedCount() >= 12:
		nextText.text = "Look behind the sign"

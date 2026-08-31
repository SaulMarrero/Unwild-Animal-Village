extends Node2D

@onready var blackOverlay = $BlackOverlay
@onready var playButton: TextureButton = $play
@onready var label1: Label = $Label1
@onready var label2: Label = $Label2

const FADE_IN_TIME := 0.8
const LABEL_FADE_TIME := 1.5

func _ready() -> void:
	music.play_music(preload("res://music/main.mp3"))
	
	blackOverlay.visible = true
	blackOverlay.modulate.a = 1.0
	label1.visible = false
	label1.modulate.a = 0.0
	label2.visible = false
	label2.modulate.a = 0.0

	var tween := create_tween()
	tween.tween_property(blackOverlay, "modulate:a", 0.0, FADE_IN_TIME)
	tween.tween_callback(func(): blackOverlay.visible = false)

func _on_play_pressed() -> void:
	playButton.disabled = true

	blackOverlay.visible = true
	var tween := create_tween()
	tween.tween_property(blackOverlay, "modulate:a", 1.0, FADE_IN_TIME)
	tween.tween_callback(_onScreenBlack)

func _onScreenBlack() -> void:
	label1.visible = true
	label2.visible = true

	var tween := create_tween()
	tween.tween_property(label1, "modulate:a", 1.0, LABEL_FADE_TIME)
	tween.tween_property(label2, "modulate:a", 1.0, LABEL_FADE_TIME)
	tween.tween_interval(0.0)
	tween.tween_callback(_fadeOutLabels)

func _fadeOutLabels() -> void:
	var tween := create_tween().set_parallel(true)
	tween.tween_property(label1, "modulate:a", 0.0, LABEL_FADE_TIME)
	tween.tween_property(label2, "modulate:a", 0.0, LABEL_FADE_TIME)
	tween.chain().tween_callback(_goToHouse)

func _goToHouse() -> void:
	get_tree().change_scene_to_file("res://scenes/house.tscn")


func _on_exit_pressed() -> void:
	get_tree().quit()

extends Node

@onready var player: AudioStreamPlayer = AudioStreamPlayer.new()

func _ready() -> void:
	add_child(player)
	player.finished.connect(func(): player.play())

func play_music(track: AudioStream) -> void:
	if player.stream == track and player.playing:
		return
	player.stream = track
	player.play()

func stop_music() -> void:
	player.stop()

func restart_music() -> void:
	player.play(0.0)

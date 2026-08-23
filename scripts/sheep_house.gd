extends Node2D

@onready var canvaslayer = $player/canvaslayer

func _ready() -> void:
	canvaslayer.show_next()

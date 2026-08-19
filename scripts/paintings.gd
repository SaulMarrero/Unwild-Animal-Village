extends Area2D

@onready var cl = $"../player/canvaslayer"
@onready var labelName = $"../player/canvaslayer/characterSprite/labelName"
@onready var labelText = $"../player/canvaslayer/characterSprite/labelText"

var textos: Array[String] = [
	"Hola soy la oveja",
	"Vivo aquí en el pueblo",
	"Ten cuidado con el lobo"
]

var dialog_index := 0
var active := false

func _on_input_event(viewport, event, shape_idx) -> void:
	if event.is_action_pressed("click") and not active:
		active = true
		cl.visible = true
		labelName.text = "Miss\nSheep"
		labelText.text = textos[dialog_index]

func _input(event: InputEvent) -> void:
	if active and event.is_action_pressed("click"):
		dialog_index += 1
		if dialog_index < textos.size():
			labelText.text = textos[dialog_index]
		else:
			cl.visible = false
			active = false
			dialog_index = 0

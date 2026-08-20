extends Area2D
@onready var cl = $"../player/canvaslayer"
@onready var marco = $"../player/canvaslayer/Marco"
@onready var characterSprite = $"../player/canvaslayer/characterSprite"
@onready var labelText = $"../player/canvaslayer/characterSprite/labelText"
@onready var labelName = $"../player/canvaslayer/characterSprite/labelName"

var textos: Array[String] = [
	"Hola soy la oveja",
	"Vivo aquí en el pueblo",
	"Ten cuidado con el lobo"
]

var index := 0
var active := false
var typing := false
var skip_typing := false

var marco_pos: Vector2
var sprite_pos: Vector2
var offset := Vector2(0, 1000)
var slide_time := 0.5

func _ready() -> void:
	marco_pos = marco.position
	sprite_pos = characterSprite.position
	marco.position = marco_pos + offset
	characterSprite.position = sprite_pos + offset

func _on_input_event(viewport, event, shape_idx) -> void:
	if event.is_action_pressed("click") and not active:
		active = true
		index = 0
		labelName.text = "Miss\nSheep"
		_open_dialog()
		get_viewport().set_input_as_handled()

func _unhandled_input(event: InputEvent) -> void:
	if not active or not event.is_action_pressed("click"):
		return
	if typing:
		skip_typing = true
	else:
		index += 1
		if index < textos.size():
			_type_line(textos[index])
		else:
			_close_dialog()

func _open_dialog() -> void:
	cl.visible = true
	labelText.text = ""
	var tween := create_tween()
	tween.set_parallel(true)
	tween.tween_property(marco, "position", marco_pos, slide_time)\
		.set_trans(Tween.TRANS_QUART).set_ease(Tween.EASE_OUT)
	tween.tween_property(characterSprite, "position", sprite_pos, slide_time)\
		.set_trans(Tween.TRANS_QUART).set_ease(Tween.EASE_OUT)
	tween.chain().tween_callback(func(): _type_line(textos[index]))

func _type_line(text: String) -> void:
	typing = true
	skip_typing = false
	labelText.text = ""
	for c in text:
		if skip_typing:
			break
		labelText.text += c
		await get_tree().create_timer(0.03).timeout
	labelText.text = text
	typing = false

func _close_dialog() -> void:
	var tween := create_tween()
	tween.set_parallel(true)
	tween.tween_property(marco, "position", marco_pos + offset, slide_time * 0.6)\
		.set_trans(Tween.TRANS_QUART).set_ease(Tween.EASE_IN)
	tween.tween_property(characterSprite, "position", sprite_pos + offset, slide_time * 0.6)\
		.set_trans(Tween.TRANS_QUART).set_ease(Tween.EASE_IN)
	tween.chain().tween_callback(func():
		cl.visible = false
		active = false
		index = 0
	)

extends CanvasLayer
@onready var marco = $Marco
@onready var characterSprite = $characterSprite
@onready var labelText = $labelText
@onready var labelName = $labelName
enum State { CLOSED, OPENING, TYPING, WAITING, CLOSING }
var lines: Array[Dictionary] = []
var index := 0
var state := State.CLOSED
var skip_typing := false
var marco_pos: Vector2
var sprite_pos: Vector2
var labelText_pos: Vector2
var labelName_pos: Vector2
var spriteOffset := Vector2(0, 1000)
var slide_time := 0.5
var dialog_id := 0
var current_tween: Tween
var external_lock := false

func _ready() -> void:
	marco_pos = marco.position
	sprite_pos = characterSprite.position
	labelText_pos = labelText.position
	labelName_pos = labelName.position
	marco.position = marco_pos + spriteOffset
	characterSprite.position = sprite_pos + spriteOffset
	labelText.position = labelText_pos + spriteOffset
	labelName.position = labelName_pos + spriteOffset

func start_dialog(dialog_lines: Array[Dictionary]) -> void:
	if state != State.CLOSED or external_lock:
		return
	dialog_id += 1
	index = 0
	lines = dialog_lines
	_open_dialog(dialog_id)

func _unhandled_input(event: InputEvent) -> void:
	if not event.is_action_pressed("click"):
		return
	if state != State.TYPING and state != State.WAITING:
		return
	get_viewport().set_input_as_handled()
	if state == State.TYPING:
		skip_typing = true
	else:
		index += 1
		if index < lines.size():
			_type_line(dialog_id)
		else:
			_close_dialog(dialog_id)

func _open_dialog(id: int) -> void:
	state = State.OPENING
	visible = true
	labelText.text = ""
	labelName.text = lines[index].get("name", "")
	if current_tween:
		current_tween.kill()
	current_tween = create_tween()
	current_tween.set_parallel(true)
	current_tween.tween_property(marco, "position", marco_pos, slide_time)\
		.set_trans(Tween.TRANS_QUART).set_ease(Tween.EASE_OUT)
	current_tween.tween_property(characterSprite, "position", sprite_pos, slide_time)\
		.set_trans(Tween.TRANS_QUART).set_ease(Tween.EASE_OUT)
	current_tween.tween_property(labelText, "position", labelText_pos, slide_time)\
		.set_trans(Tween.TRANS_QUART).set_ease(Tween.EASE_OUT)
	current_tween.tween_property(labelName, "position", labelName_pos, slide_time)\
		.set_trans(Tween.TRANS_QUART).set_ease(Tween.EASE_OUT)
	current_tween.chain().tween_callback(func():
		if id == dialog_id:
			_type_line(id)
	)

func _type_line(id: int) -> void:
	state = State.TYPING
	skip_typing = false
	var line: Dictionary = lines[index]
	labelName.text = line.get("name", "")
	var text: String = line.get("text", "")
	labelText.text = ""
	for c in text:
		if id != dialog_id:
			return
		if skip_typing:
			break
		labelText.text += c
		await get_tree().create_timer(0.03).timeout
	if id != dialog_id:
		return
	labelText.text = text
	state = State.WAITING

func _close_dialog(id: int) -> void:
	state = State.CLOSING
	if current_tween:
		current_tween.kill()
	current_tween = create_tween()
	current_tween.set_parallel(true)
	current_tween.tween_property(marco, "position", marco_pos + spriteOffset, slide_time * 0.6)\
		.set_trans(Tween.TRANS_QUART).set_ease(Tween.EASE_IN)
	current_tween.tween_property(characterSprite, "position", sprite_pos + spriteOffset, slide_time * 0.6)\
		.set_trans(Tween.TRANS_QUART).set_ease(Tween.EASE_IN)
	current_tween.tween_property(labelText, "position", labelText_pos + spriteOffset, slide_time * 0.6)\
		.set_trans(Tween.TRANS_QUART).set_ease(Tween.EASE_IN)
	current_tween.tween_property(labelName, "position", labelName_pos + spriteOffset, slide_time * 0.6)\
		.set_trans(Tween.TRANS_QUART).set_ease(Tween.EASE_IN)
	current_tween.chain().tween_callback(func():
		if id == dialog_id:
			visible = false
			state = State.CLOSED
			index = 0
	)

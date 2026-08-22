extends CanvasLayer

@onready var marco = $Marco
@onready var characterSprite = $characterSprite
@onready var labelText = $labelText
@onready var labelName = $labelName
@onready var next = $next
@onready var clues = $clues
@onready var cluesSprite = $cluesSprite
@onready var cluesBlocker = $cluesBlocker

enum State { CLOSED, OPENING, TYPING, WAITING, CLOSING }

var lines: Array[Dictionary] = []
var index := 0
var state := State.CLOSED
var skip_typing := false
var slide_time := 0.5
var dialog_id := 0
var current_tween: Tween
var external_lock := false
var spriteOffset := Vector2(0, 1000)
var base_positions: Dictionary = {}

var buttons: Array = []
var buttons_tween: Tween
var buttons_fade_time := 0.3

var clues_open := false
var clues_tween: Tween
var clues_fade_time := 0.3

func _ready() -> void:
	follow_viewport_enabled = false
	for node in [marco, characterSprite, labelText, labelName]:
		base_positions[node] = node.position
		node.position += spriteOffset
	buttons = [next, clues]
	for btn in buttons:
		btn.top_level = true
		btn.modulate.a = 0.0
	cluesSprite.modulate.a = 0.0
	cluesSprite.visible = false
	cluesBlocker.visible = false
	cluesBlocker.mouse_filter = Control.MOUSE_FILTER_STOP

func _fade_buttons(target_alpha: float) -> void:
	if buttons_tween:
		buttons_tween.kill()
	buttons_tween = create_tween().set_parallel(true)
	for btn in buttons:
		buttons_tween.tween_property(btn, "modulate:a", target_alpha, buttons_fade_time)

func show_next() -> void:
	_fade_buttons(1.0)
func hide_next() -> void:
	_fade_buttons(0.0)

func _on_clues_pressed() -> void:
	clues_open = not clues_open
	external_lock = clues_open
	next.visible = not clues_open
	if clues_tween:
		clues_tween.kill()
	if clues_open:
		cluesSprite.visible = true
		cluesBlocker.visible = true
		clues_tween = create_tween()
		clues_tween.tween_property(cluesSprite, "modulate:a", 1.0, clues_fade_time)
	else:
		clues_tween = create_tween()
		clues_tween.tween_property(cluesSprite, "modulate:a", 0.0, clues_fade_time)
		clues_tween.tween_callback(func():
			cluesSprite.visible = false
			cluesBlocker.visible = false
		)

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

func _slide(offset: Vector2, duration: float, ease_type: int, on_done: Callable) -> void:
	if current_tween:
		current_tween.kill()
	current_tween = create_tween().set_parallel(true)
	for node in base_positions:
		current_tween.tween_property(node, "position", base_positions[node] + offset, duration)\
			.set_trans(Tween.TRANS_QUART).set_ease(ease_type)
	current_tween.chain().tween_callback(on_done)

func _open_dialog(id: int) -> void:
	state = State.OPENING
	labelText.text = ""
	labelName.text = lines[index].get("name", "")
	_fade_buttons(0.0)
	_slide(Vector2.ZERO, slide_time, Tween.EASE_OUT, func():
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
		if id != dialog_id or skip_typing:
			break
		labelText.text += c
		await get_tree().create_timer(0.03).timeout
	if id != dialog_id:
		return
	labelText.text = text
	state = State.WAITING

func _close_dialog(id: int) -> void:
	state = State.CLOSING
	_slide(spriteOffset, slide_time * 0.6, Tween.EASE_IN, func():
		if id == dialog_id:
			state = State.CLOSED
			index = 0
			_fade_buttons(1.0)
	)

func force_close() -> void:
	dialog_id += 1
	var id := dialog_id
	state = State.CLOSING
	_slide(spriteOffset, slide_time * 0.6, Tween.EASE_IN, func():
		if id == dialog_id:
			state = State.CLOSED
			index = 0
			_fade_buttons(1.0)
	)

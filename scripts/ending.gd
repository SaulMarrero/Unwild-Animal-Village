extends Node2D

@onready var textLabel: Label = $TextLabel
@onready var leakButton: TextureButton = $Leak
@onready var returnButton: TextureButton = $Return
@onready var blackOverlay: Sprite2D = $BlackOverlay
@onready var outroLabel1: Label = $Label1
@onready var outroLabel2: Label = $Label2

const TYPE_SPEED := 0.02
const INITIAL_DELAY := 3.0
const BUTTON_FADE_TIME := 0.4
const OVERLAY_FADE_TIME := 0.8
const OUTRO_LABEL_FADE_TIME := 1.5

var endingLines: Array[String] = [
	"State Surveillance Bill",
	"With the approval of this bill, a law never seen before will be imposed on Animal Village.",
	"Cameras will be installed on every corner and in every establishment in the village, under the direct control of officials working for the Mayor.",
	"This law will be imposed under the pretense of seeking greater safety for the villagers.",
	"Any conversation picked up by the cameras and their built-in microphones will be recorded and studied.",
	"Any villager who has thoughts or engages in activities against the Mayor's interests will later be visited by the police.",
	"This way, the State will have complete control over society.",
	"While the rest of the villagers keep believing they live with freedom and power in their own hands.",
	"Document approved by Mayor Oinker on April 4th, 1984.",
	"(...what the hell.)",
	"(This can't be real. It would go against every citizen's freedom!)",
	"(It can't be...)",
	"(Is this what Doctor Meow read at the hospital? Is that why he tried to steal the documents?)",
	"(That explains everything.)",
	"(He couldn't hand it over to the press because he didn't have the keys to open the safe.)",
	"(He was counting on me to do it, in case he got arrested.)",
	"(Me...)",
	"(But what about me?)",
	"(What'll happen to me if I leak this document to the press? Will they arrest me too?)",
	"(Would this be the end of my life?)",
	"(Is it worth dying on your feet rather than living on your knees?)",
	"(...)"
]

var leakLines: Array[String] = [
	"Boceto: primera línea del final leak.",
	"Boceto: segunda línea del final leak.",
	"Boceto: tercera línea del final leak."
]

var returnLines: Array[String] = [
	"Boceto: primera línea del final return.",
	"Boceto: segunda línea del final return.",
	"Boceto: tercera línea del final return."
]

var currentLines: Array[String] = []
var currentLine := 0
var typing := false
var skipTyping := false
var started := false
var choiceMade := false

func _ready() -> void:
	music.play_music(preload("res://music/ending.mp3"))
	textLabel.text = ""
	blackOverlay.visible = false
	blackOverlay.modulate.a = 0.0
	outroLabel1.visible = false
	outroLabel1.modulate.a = 0.0
	outroLabel2.visible = false
	outroLabel2.modulate.a = 0.0
	currentLines = endingLines
	await get_tree().create_timer(INITIAL_DELAY).timeout
	started = true
	_showLine()

func _showLine() -> void:
	_typeText(currentLines[currentLine])

func _typeText(text: String) -> void:
	typing = true
	skipTyping = false
	textLabel.text = ""
	for c in text:
		if skipTyping:
			break
		textLabel.text += c
		await get_tree().create_timer(TYPE_SPEED).timeout
	textLabel.text = text
	typing = false

func _unhandled_input(event: InputEvent) -> void:
	if not started or not event.is_action_pressed("click"):
		return
	get_viewport().set_input_as_handled()
	_advanceDialogue()

func _advanceDialogue() -> void:
	if typing:
		skipTyping = true
	elif currentLine + 1 < currentLines.size():
		currentLine += 1
		_showLine()
	elif not choiceMade:
		_showChoiceButtons()
	else:
		_startOutro()

func _showChoiceButtons() -> void:
	leakButton.visible = true
	returnButton.visible = true
	leakButton.modulate.a = 0.0
	returnButton.modulate.a = 0.0
	var tween := create_tween().set_parallel(true)
	tween.tween_property(leakButton, "modulate:a", 1.0, BUTTON_FADE_TIME)
	tween.tween_property(returnButton, "modulate:a", 1.0, BUTTON_FADE_TIME)

func _on_leak_pressed() -> void:
	_startChoice(leakLines)

func _on_return_pressed() -> void:
	_startChoice(returnLines)

func _startChoice(lines: Array[String]) -> void:
	choiceMade = true
	leakButton.visible = false
	returnButton.visible = false
	currentLines = lines
	currentLine = 0
	_showLine()

func _startOutro() -> void:
	started = false
	blackOverlay.visible = true
	var tween := create_tween()
	tween.tween_property(blackOverlay, "modulate:a", 1.0, OVERLAY_FADE_TIME)
	tween.tween_callback(_showOutroLabels)

func _showOutroLabels() -> void:
	outroLabel1.visible = true
	outroLabel2.visible = true

	var tween := create_tween()
	tween.tween_property(outroLabel1, "modulate:a", 1.0, OUTRO_LABEL_FADE_TIME)
	tween.tween_property(outroLabel2, "modulate:a", 1.0, OUTRO_LABEL_FADE_TIME)
	tween.tween_callback(_hideOutroLabels)

func _hideOutroLabels() -> void:
	var tween := create_tween().set_parallel(true)
	tween.tween_property(outroLabel1, "modulate:a", 0.0, OUTRO_LABEL_FADE_TIME)
	tween.tween_property(outroLabel2, "modulate:a", 0.0, OUTRO_LABEL_FADE_TIME)
	tween.chain().tween_callback(_goToMain)

func _goToMain() -> void:
	get_tree().change_scene_to_file("res://scenes/main.tscn")

extends Node2D

@onready var nameLabel: Label = $NameLabel
@onready var textLabel: Label = $TextLabel
@onready var characterSprite: Sprite2D = $CharacterSprite
@onready var hintButton: TextureButton = $HintButton
@onready var answerButton: TextureButton = $AnswerButton
@onready var disagreeButton: TextureButton = $DisagreeButton
@onready var blackOverlay: Sprite2D = $BlackOverlay
@onready var clueLabel: Label = $ClueLabel
@onready var clueButtons: Array[TextureButton] = [
	$clue1, $clue2, $clue3, $clue4, $clue5, $clue6,
	$clue7, $clue8, $clue9, $clue10, $clue11, $clue12
]

@export var foxTexture: Texture2D
@export var woofTexture: Texture2D
@export var teddyTexture: Texture2D
@export var croakTexture: Texture2D
@export var stingerTexture: Texture2D
@export var platypusTexture: Texture2D

var speakerTextures: Dictionary = {}

const TYPE_SPEED := 0.02

var clueDescriptions: Array[String] = [
	"The door wasn't forced open. There was a bit of nylon left under it.",
	"The thief got in by entering the password. Only Oinker and Police Chief Teddy knew it.",
	"There were no marks or traces on the window. The gap isn't very big either.",
	"A witness called the police after hearing a loud noise. They showed up really fast.",
	"Miss Sheep saw the police arrive a few minutes after the noises.",
	"Teddy's briefcase contains the passwords that opened Oinker's door.",
	"Chief Teddy has heart failure and cannot run.",
	"Guard Wolf felt a sharp pain right after closing the door and passed out from it.",
	"A pin was found stuck in Guard Wolf's hand. No one knows why it was there.",
	"It has a lot of interesting info about the village's animals.",
	"Stinger's venom has to be delivered through a direct attack. Croak has an alibi.",
	"She suspects someone tried to break into her house."
]

var introConversation: Array[Dictionary] = [
	{"name": "Detective Fox", "text": "Alright, let's go over everything we've found so far."},
	{"name": "Chief Teddy", "text": "If any of you hear something that doesn't add up, speak up."},
	{"name": "Detective Fox", "text": "Press Disagree whenever you think a clue contradicts what's being said."},
	{"name": "Partner Woof", "text": "Got it! I'll be paying close attention."}
]

var finalConversation: Array[Dictionary] = [
	{"name": "Detective Fox", "text": ""},
	{"name": "Detective Fox", "text": ""},
	{"name": "Chief Teddy", "text": ""},
	{"name": "Detective Fox", "text": ""},
	{"name": "Partner Woof", "text": ""}
]

# targetLine = índice (0-based) de la línea que contiene la contradicción.
# El jugador SOLO acierta el "momento" si pulsa Disagree estando en esa línea exacta.
# clue = número de pista (1-12) que contradice esa línea concretamente.
var waves: Array[Dictionary] = [
	{
		"lines": [
			{"name": "Partner Woof", "text": "First, we should talk about the two main suspects!"},
			{"name": "Chief Teddy", "text": "Lady Stinger and Mister Croak, the only poisonous animals in Animal Village."},
			{"name": "Lady Stinger", "text": "I've said it a thousand times, I haven't committed any crime."},
			{"name": "Lady Stinger", "text": "Why would I steal documents from Mayor Oinker? Politics isn't my thing!"},
			{"name": "Partner Woof", "text": "This isn't about figuring out your motives, it's about figuring out if you're guilty!"},
			{"name": "Mister Croak", "text": "It wasn't us. I've known Lady Stinger since we were kids, she'd never do that! Neither would I!"},
			{"name": "Chief Teddy", "text": "Say whatever you want, you're still the only two poisonous animals around."},
			{"name": "Chief Teddy", "text": "One of you must have committed the crime, there's no denying it!"}
		],
		"targetLine": 7, "clue": 11,
		"resolution": [{"name": "Detective Fox", "text": "Jaja acertaste"}],
		"hint": "One of the clues rules out possible suspects.",
		"solution": "Use clue 11 when Teddy claims that one of the two must be the culprit."
	},
	{
		"lines": [
			{"name": "Chief Teddy", "text": "Hola esta es otra wave"}, {"name": "Detective Fox", "text": ""},
			{"name": "Partner Woof", "text": ""}, {"name": "Chief Teddy", "text": ""},
			{"name": "Detective Fox", "text": ""}
		],
		"targetLine": 0, "clue": 7,
		"resolution": [{"name": "Detective Fox", "text": ""}],
		"hint": "Pista 2", "solution": "Solucion 2"
	},
	{
		"lines": [
			{"name": "Detective Fox", "text": ""}, {"name": "Partner Woof", "text": ""},
			{"name": "Detective Fox", "text": ""}, {"name": "Chief Teddy", "text": ""},
			{"name": "Partner Woof", "text": ""}
		],
		"targetLine": 0, "clue": 8,
		"resolution": [{"name": "Detective Fox", "text": ""}],
		"hint": "Pista 3", "solution": "Solucion 3"
	},
	{
		"lines": [
			{"name": "Partner Woof", "text": ""}, {"name": "Detective Fox", "text": ""},
			{"name": "Chief Teddy", "text": ""}, {"name": "Detective Fox", "text": ""},
			{"name": "Partner Woof", "text": ""}
		],
		"targetLine": 0, "clue": 9,
		"resolution": [{"name": "Detective Fox", "text": ""}],
		"hint": "Pista 4", "solution": "Solucion 4"
	},
	{
		"lines": [
			{"name": "Detective Fox", "text": ""}, {"name": "Chief Teddy", "text": ""},
			{"name": "Partner Woof", "text": ""}, {"name": "Detective Fox", "text": ""},
			{"name": "Chief Teddy", "text": ""}
		],
		"targetLine": 0, "clue": 1,
		"resolution": [{"name": "Detective Fox", "text": ""}],
		"hint": "Pista 5", "solution": "Solucion 5"
	},
	{
		"lines": [
			{"name": "Chief Teddy", "text": ""}, {"name": "Partner Woof", "text": ""},
			{"name": "Detective Fox", "text": ""}, {"name": "Chief Teddy", "text": ""},
			{"name": "Detective Fox", "text": ""}
		],
		"targetLine": 0, "clue": 3,
		"resolution": [{"name": "Detective Fox", "text": ""}],
		"hint": "Pista 6", "solution": "Solucion 6"
	},
	{
		"lines": [
			{"name": "Detective Fox", "text": ""}, {"name": "Partner Woof", "text": ""},
			{"name": "Chief Teddy", "text": ""}, {"name": "Detective Fox", "text": ""},
			{"name": "Partner Woof", "text": ""}
		],
		"targetLine": 0, "clue": 4,
		"resolution": [{"name": "Detective Fox", "text": ""}],
		"hint": "Pista 7", "solution": "Solucion 7"
	},
	{
		"lines": [
			{"name": "Partner Woof", "text": ""}, {"name": "Chief Teddy", "text": ""},
			{"name": "Detective Fox", "text": ""}, {"name": "Partner Woof", "text": ""},
			{"name": "Detective Fox", "text": ""}
		],
		"targetLine": 0, "clue": 5,
		"resolution": [{"name": "Detective Fox", "text": ""}],
		"hint": "Pista 8", "solution": "Solucion 8"
	},
	{
		"lines": [
			{"name": "Detective Fox", "text": ""}, {"name": "Chief Teddy", "text": ""},
			{"name": "Detective Fox", "text": ""}, {"name": "Partner Woof", "text": ""},
			{"name": "Chief Teddy", "text": ""}
		],
		"targetLine": 0, "clue": 2,
		"resolution": [{"name": "Detective Fox", "text": ""}],
		"hint": "Pista 9", "solution": "Solucion 9"
	},
	{
		"lines": [
			{"name": "Chief Teddy", "text": ""}, {"name": "Detective Fox", "text": ""},
			{"name": "Partner Woof", "text": ""}, {"name": "Chief Teddy", "text": ""},
			{"name": "Detective Fox", "text": ""}
		],
		"targetLine": 0, "clue": 6,
		"resolution": [{"name": "Detective Fox", "text": ""}],
		"hint": "Pista 10", "solution": "Solucion 10"
	},
	{
		"lines": [
			{"name": "Detective Fox", "text": ""}, {"name": "Partner Woof", "text": ""},
			{"name": "Chief Teddy", "text": ""}, {"name": "Detective Fox", "text": ""},
			{"name": "Partner Woof", "text": ""}
		],
		"targetLine": 0, "clue": 10,
		"resolution": [{"name": "Detective Fox", "text": ""}],
		"hint": "Pista 11", "solution": "Solucion 11"
	},
	{
		"lines": [
			{"name": "Chief Teddy", "text": ""}, {"name": "Partner Woof", "text": ""},
			{"name": "Detective Fox", "text": ""}, {"name": "Chief Teddy", "text": ""},
			{"name": "Detective Fox", "text": ""}
		],
		"targetLine": 0, "clue": 12,
		"resolution": [{"name": "Detective Fox", "text": ""}],
		"hint": "Pista 12", "solution": "Solucion 12"
	}
]

var retryLines: Array[Dictionary] = [
	{"name": "Detective Fox", "text": "(Someone here must be getting their analysis wrong.)"},
	{"name": "Detective Fox", "text": "(I'm sure if I go through it again, I'll find a moment to push back.)"}
]

var incorrectLines: Array[Dictionary] = [
	{"name": "Partner Woof", "text": "..."},
	{"name": "Chief Teddy", "text": "That doesn't make sense. Focus!"}
]

var currentWave := 0
var currentLine := 0
var currentLines: Array[Dictionary] = []
var currentSpeaker := ""
var typing := false
var skipTyping := false
var busy := false
var insertCallback: Callable = Callable()
var savedLine := 0
var selectedClue := 0
var trialStarted := false

func _ready() -> void:
	speakerTextures = {
		"Detective Fox": foxTexture,
		"Partner Woof": woofTexture,
		"Chief Teddy": teddyTexture,
		"Mister Croak": croakTexture,
		"Lady Stinger": stingerTexture,
		"Lady Platypus": platypusTexture
	}

	hintButton.pressed.connect(_onHintButtonPressed)
	answerButton.pressed.connect(_onAnswerButtonPressed)
	disagreeButton.pressed.connect(_onDisagreeButtonPressed)

	for i in clueButtons.size():
		clueButtons[i].pressed.connect(_onClueButtonPressed.bind(i + 1))

	_setPickerVisible(false)

	_playInsert(introConversation, func():
		trialStarted = true
		_startWave(0)
	)

func _startWave(index: int) -> void:
	currentWave = index
	currentLines = _toDialogArray(waves[currentWave].lines)
	currentLine = 0
	_showLine()

func _showLine() -> void:
	var line: Dictionary = currentLines[currentLine]
	var speaker: String = line.get("name", "")

	nameLabel.text = speaker
	if speaker != currentSpeaker:
		currentSpeaker = speaker
		_changeSprite(speaker)

	_typeText(line.get("text", ""))

func _changeSprite(speaker: String) -> void:
	var tween := create_tween()
	tween.tween_property(characterSprite, "modulate:a", 0.0, 0.15)
	tween.tween_callback(func(): characterSprite.texture = speakerTextures.get(speaker))
	tween.tween_property(characterSprite, "modulate:a", 1.0, 0.15)

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
	if not event.is_action_pressed("click") or blackOverlay.visible:
		return
	get_viewport().set_input_as_handled()
	_advanceDialogue()

func _advanceDialogue() -> void:
	if typing:
		skipTyping = true
		return

	currentLine += 1
	if currentLine < currentLines.size():
		_showLine()
	elif insertCallback.is_valid():
		var callback := insertCallback
		insertCallback = Callable()
		busy = false
		callback.call()
	else:
		_onWaveExhausted()

func _playInsert(lines: Array[Dictionary], onDone: Callable) -> void:
	busy = true
	currentLines = lines
	currentLine = 0
	insertCallback = onDone
	_showLine()

func _onWaveExhausted() -> void:
	if trialStarted:
		_playInsert(retryLines, func(): _startWave(currentWave))

func _onHintButtonPressed() -> void:
	if not busy and not blackOverlay.visible and trialStarted:
		textLabel.text = waves[currentWave].hint

func _onAnswerButtonPressed() -> void:
	if not busy and not blackOverlay.visible and trialStarted:
		textLabel.text = waves[currentWave].solution

func _onDisagreeButtonPressed() -> void:
	if busy or not trialStarted:
		return

	if not blackOverlay.visible:
		if typing:
			skipTyping = true
		savedLine = currentLine
		selectedClue = 0
		clueLabel.text = ""
		_setPickerVisible(true)
	elif selectedClue != 0:
		_setPickerVisible(false)
		_onClueChosen(selectedClue)

func _onClueButtonPressed(clueNumber: int) -> void:
	selectedClue = clueNumber
	clueLabel.text = clueDescriptions[clueNumber - 1]

func _setPickerVisible(v: bool) -> void:
	blackOverlay.visible = v
	clueLabel.visible = v
	for btn in clueButtons:
		btn.visible = v

func _toDialogArray(source: Array) -> Array[Dictionary]:
	var result: Array[Dictionary] = []
	for item in source:
		result.append(item)
	return result

func _onClueChosen(clueNumber: int) -> void:
	var wave: Dictionary = waves[currentWave]
	var correct: bool = savedLine == wave.targetLine and clueNumber == wave.clue

	if correct:
		_playInsert(_toDialogArray(wave.resolution), func(): _advanceWave())
	else:
		var waveLines := _toDialogArray(wave.lines)
		_playInsert(incorrectLines, func():
			currentLines = waveLines
			currentLine = savedLine
			_showLine()
		)

func _advanceWave() -> void:
	if currentWave + 1 >= waves.size():
		_playInsert(finalConversation, func(): _onTrialComplete())
	else:
		_startWave(currentWave + 1)

func _onTrialComplete() -> void:
	pass # TODO: aquí va lo que pase tras el diálogo de conclusión

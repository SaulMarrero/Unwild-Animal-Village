extends Sprite2D

@onready var clueButtons: Array[TextureButton] = [$tb1, $tb2, $tb3, $tb4, $tb5, $tb6]
@onready var nextButton: TextureButton = $next
@onready var backButton: TextureButton = $back
@onready var clueName: Label = $ClueName
@onready var clueText: Label = $ClueText

const PAGE_SIZE := 6

var clues: Array[Dictionary] = [
	{"name": "Nylon Scrap", "text": "The door wasn't forced open. There was a bit of nylon left under it."},
	{"name": "Unlocked Door", "text": "The thief got in by entering the password. Only Oinker and Police Chief Teddy knew it."},
	{"name": "Broken Window", "text": "There were no marks or traces on the window. The gap isn't very big either."},
	{"name": "Witness", "text": "A witness called the police after hearing a loud noise and watching someone run."},
	{"name": "Miss Sheep", "text": "Miss Sheep saw the police arrive a few minutes after the noises."},
	{"name": "Teddy's briefcase", "text": "Teddy's briefcase contains the passwords that opened Oinker's door."},
	{"name": "Chief Teddy", "text": "Chief Teddy has heart failure and cannot run."},
	{"name": "Guard Wolf", "text": "Guard Wolf felt a sharp pain right after closing the door and passed out from it."},
	{"name": "Pin", "text": "A pin was found stuck in Guard Wolf's hand. No one knows why it was there."},
	{"name": "Hospital Book", "text": "It has a lot of interesting info about the village's animals."},
	{"name": "Stinger", "text": "Stinger's venom has to be delivered through a direct attack. Croak has an alibi."},
	{"name": "Lady Platypus", "text": "She suspects someone tried to break into her house."}
]

var page := 0

func _ready() -> void:
	for i in clueButtons.size():
		clueButtons[i].pressed.connect(showClue.bind(i))
	nextButton.pressed.connect(func(): changePage(1))
	backButton.pressed.connect(func(): changePage(-1))
	updatePage()

func showClue(slot: int) -> void:
	var index := page * PAGE_SIZE + slot
	if not Clues.isUnlocked(index + 1):
		return
	var clue = clues[index]
	clueName.text = clue.name
	clueText.text = clue.text

func changePage(dir: int) -> void:
	page += dir
	updatePage()

func updatePage() -> void:
	for i in clueButtons.size():
		var index := page * PAGE_SIZE + i
		clueButtons[i].visible = index < clues.size()
	backButton.disabled = page == 0
	nextButton.disabled = (page + 1) * PAGE_SIZE >= clues.size()

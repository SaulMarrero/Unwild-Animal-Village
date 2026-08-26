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
	{"name": "Security Guard", "text": "A guard was watching the entrance, but he got poisoned."},
	{"name": "Witness", "text": "A witness called the police after hearing a loud noise. They showed up really fast."},
	{"name": "Miss Sheep", "text": "Miss Sheep saw the police arrive a few minutes after the noises."},
	{"name": "Teddy's briefcase", "text": "Teddy's briefcase contains the passwords that opened Oinker's door."},
	{"name": "Chief Teddy", "text": "Chief Teddy has heart failure and cannot run."},
	{"name": "Empty Vial", "text": "Smells faintly of a sleeping draught."},
	{"name": "Coded Letter", "text": "Written in a cipher no one recognizes yet."},
	{"name": "Muddy Coin", "text": "An old coin dropped near the back door."},
	{"name": "Scratched Desk", "text": "Claw-like marks scratched into the wood."},
	{"name": "Faded Photo", "text": "Shows the mayor with an unknown figure."},
	{"name": "Loose Thread", "text": "Matches the fabric of a guard's uniform."},
	{"name": "Burnt Match", "text": "Found near the study's open window."},
	{"name": "Missing Page", "text": "A page torn out of the mayor's ledger."},
	{"name": "Strange Odor", "text": "A chemical smell lingers in the hallway."},
	{"name": "Cracked Glass", "text": "A shattered picture frame on the floor."}
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
	

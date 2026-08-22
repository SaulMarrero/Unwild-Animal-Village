extends Area2D
@onready var dialog = $"../player/canvaslayer"

var conversation1: Array[Dictionary] = [
	{"name": "Detective\nFox", "text": "Tell me, Mayor Oinker. What security systems does this house have?"},
	{"name": "Mayor\nOinker", "text": "All of them! I've got plenty of money, you know? I'm the backbone of Animal Village after all!"},
	{"name": "Mayor\nOinker", "text": "My briefcase was in my room, and the door has a lock with a password!"},
	{"name": "Partner\nWoof", "text": "Did anyone besides you know the door's password?"},
	{"name": "Mayor\nOinker", "text": "Only the police chief, Chief Teddy… but he would never do something like that! He works for me!"},
	{"name": "Detective\nFox", "text": "(The police chief…)"},
	{"name": "Detective\nFox", "text": "(We'll have to pay this Chief Teddy a visit later)"},
	{"name": "Detective\nFox", "text": "Any other security measures worth knowing about?"},
	{"name": "Mayor\nOinker", "text": "Oh, yes! My security guard! That useless idiot… he let me get robbed! It's unacceptable!"},
	{"name": "Partner\nWoof", "text": "You had a security guard? Was he in on it with the thief?"},
	{"name": "Mayor\nOinker", "text": "No, I don't think that's the case. He's in the hospital. Apparently he was poisoned!"},
	{"name": "Detective\nFox", "text": "(Poisoned, huh?)"},
	{"name": "Detective\nFox", "text": "(The thief, or one of their accomplices, must be a poisonous animal then)"},
	{"name": "Detective\nFox", "text": "We'll need to pay a visit to the hospital and Chief Teddy's office next"},
]

func _on_input_event(_viewport, event, _shape_idx) -> void:
	if event.is_action_pressed("click") and not get_viewport().gui_get_hovered_control():
		dialog.start_dialog(conversation1)
		get_viewport().set_input_as_handled()

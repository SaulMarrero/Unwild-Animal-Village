extends Node

var clue1 := false
var clue2 := false
var clue3 := false
var clue4 := false
var clue5 := false
var clue6 := false
var clue7 := false
var clue8 := false
var clue9 := false
var clue10 := false
var clue11 := false
var clue12 := false

var policeCallShown := false

func isUnlocked(number: int) -> bool:
	match number:
		1: return clue1
		2: return clue2
		3: return clue3
		4: return clue4
		5: return clue5
		6: return clue6
		7: return clue7
		8: return clue8
		9: return clue9
		10: return clue10
		11: return clue11
		12: return clue12
	return false

func unlockedCount() -> int:
	var count := 0
	for i in range(1, 13):
		if isUnlocked(i):
			count += 1
	return count

func currentDoor() -> String:
	var count := unlockedCount()
	if count <= 4:
		return "missSheepDoor"
	elif count <= 6:
		return "policeDoor"
	elif count <= 8:
		return "hospitalDoor"
	else:
		return "policeDoor"

func currentDoorMessage() -> Array[Dictionary]:
	var count := unlockedCount()
	var door := currentDoor()

	match door:
		"missSheepDoor":
			return [
				{"name": "Detective Fox", "text": "(I should go visit the witness, Miss Sheep.)"}
			]
		"policeDoor":
			if count >= 9:
				return [
					{"name": "Detective Fox", "text": "(I need to go to the police station to question the suspects.)"}
				]
			else:
				return [
					{"name": "Detective Fox", "text": "(I should go visit Chief Teddy at the police station.)"}
				]
		"hospitalDoor":
			return [
				{"name": "Detective Fox", "text": "(I need to go to the hospital to question the poisoned guard.)"},
				{"name": "Detective Fox", "text": "(I should also talk to this Doctor Meow to confirm Chief Teddy's heart condition.)"}
			]
	return []

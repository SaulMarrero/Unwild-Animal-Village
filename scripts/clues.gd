extends Node

var clue1 := true
var clue2 := true
var clue3 := true
var clue4 := true
var clue5 := true
var clue6 := true
var clue7 := true
var clue8 := true
var clue9 := true
var clue10 := true
var clue11 := false
var clue12 := false
var clue13 := false
var clue14 := false
var clue15 := false
var clue16 := false
var clue17 := false
var clue18 := false
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
		13: return clue13
		14: return clue14
		15: return clue15
		16: return clue16
		17: return clue17
		18: return clue18
	return false

func unlockedCount() -> int:
	var count := 0
	for i in range(1, 19):
		if isUnlocked(i):
			count += 1
	return count

func currentDoor() -> String:
	var count := unlockedCount()
	if count <= 5:
		return "missSheepDoor"
	elif count == 6:
		return "policeDoor"
	elif count == 8:
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
			if count >= 10:
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

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
var clue13 := false
var clue14 := false
var clue15 := false
var clue16 := false
var clue17 := false
var clue18 := false

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

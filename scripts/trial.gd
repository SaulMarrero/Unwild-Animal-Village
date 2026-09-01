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
@onready var completionLabel: Label = $completion

@export var foxTexture: Texture2D
@export var woofTexture: Texture2D
@export var teddyTexture: Texture2D
@export var croakTexture: Texture2D
@export var stingerTexture: Texture2D
@export var platypusTexture: Texture2D
@export var sheepTexture: Texture2D
@export var meowTexture: Texture2D
@export var wolfTexture: Texture2D

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
	{"name": "Detective Fox", "text": "Doctor Meow, were you the one behind this crime?"},
	{"name": "Chief Teddy", "text": "What?!"},
	{"name": "Doctor Meow", "text": "Excuse me?"},
	{"name": "Detective Fox", "text": "The question is clear, Doctor. Answer it, did you steal Mayor Oinker's documents?"},
	{"name": "Doctor Meow", "text": "No! I flat-out deny it! How could I possibly be the thief?"},
	{"name": "Detective Fox", "text": "It wouldn't be that strange. Your profile fits this case better than anyone's. Take this, for example."},
	{"name": "Detective Fox", "text": "A doctor like you would know exactly how much poison to use, how long it'd take to kick in, and what dose to apply."},
	{"name": "Doctor Meow", "text": "You're accusing me without any proof, detective. How would I have found out the password to Mayor Oinker's inner door?"},
	{"name": "Detective Fox", "text": "Chief Teddy's been your patient for months now, hasn't he?"},
	{"name": "Detective Fox", "text": "Taking advantage of any moment he wasn't looking to read his papers wouldn't have been hard, you must've had plenty of chances."},
	{"name": "Chief Teddy", "text": "How could Doctor Meow have found out about Lady Platypus being trans?"},
	{"name": "Partner Woof", "text": "If you think about it, it's not that strange, right? Meow must have medical records for all his patients."},
	{"name": "Partner Woof", "text": "All it takes is Lady Platypus going to the hospital at least once for Meow to have found out."},
	{"name": "Doctor Meow", "text": "That's all just guesswork! There's no proof backing any of it!"},
	{"name": "Detective Fox", "text": "And still, you're the profile that fits best, Doctor."},
	{"name": "Detective Fox", "text": "Tell me, if we search Animal Village from top to bottom, will we end up finding the stolen documents?"},
	{"name": "Detective Fox", "text": "If we do, it's better for you to confess now before your sentence gets worse."},
	{"name": "Doctor Meow", "text": "..."},
	{"name": "Detective Fox", "text": "You read Chief Teddy's papers while he was your patient!"},
	{"name": "Doctor Meow", "text": "..."},
	{"name": "Detective Fox", "text": "You snuck into Lady Platypus's house to get her venom and use it against Guard Wolf!"},
	{"name": "Doctor Meow", "text": "..."},
	{"name": "Detective Fox", "text": "You poisoned Guard Wolf by tying a venom-coated needle to the door handle while he was in the bathroom!"},
	{"name": "Doctor Meow", "text": "..."},
	{"name": "Detective Fox", "text": "You snuck in through the chimney and broke the window to throw off our investigation!"},
	{"name": "Doctor Meow", "text": "ENOUGH!"},
	{"name": "Detective Fox", "text": "..."},
	{"name": "Partner Woof", "text": "It's over, Doctor."},
	{"name": "Chief Teddy", "text": "Oinker's documents were kept in a safe."},
	{"name": "Chief Teddy", "text": "He probably hasn't been able to get into it yet, so he must have just hidden the safe somewhere."},
	{"name": "Doctor Meow", "text": "Fine. I admit it."},
	{"name": "Doctor Meow", "text": "It was me. I committed the robbery. I poisoned Guard Wolf. I broke into Lady Platypus's house."},
	{"name": "Doctor Meow", "text": "But I already figured this might happen. I haven't lost yet, Teddy."},
	{"name": "Detective Fox", "text": "Teddy?"},
	{"name": "Chief Teddy", "text": "That's enough. Take him to the cells!"},
	{"name": "Detective Fox", "text": "(I watched in silence as Doctor Meow was dragged off to the cells by the guards.)"},
	{"name": "Detective Fox", "text": "(This trial was finally over…)"}
]

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
		"resolution": [
			{"name": "Detective Fox", "text": "That's not true. The evidence shows neither of them could've been the thief."},
			{"name": "Detective Fox", "text": "Maybe they were accomplices, but they can't be the ones who broke into the house."},
			{"name": "Partner Woof", "text": "Then who could've done it? Who else could've figured out the password?"},
			{"name": "Partner Woof", "text": "The only one who knew it besides Mayor Oinker was Chief Teddy, right?"},
			{"name": "Detective Fox", "text": "We can't say for sure, but yeah, that's what the evidence points to."}
		],
		"hint": "One of the clues rules out possible suspects.",
		"solution": "Use clue 11 when Teddy claims that one of the two must be the culprit."
	},
		{
		"lines": [
			{"name": "Chief Teddy", "text": "There's nothing to discuss. I couldn't have been the one who did it."},
			{"name": "Partner Woof", "text": "Do you have any way to prove that?"},
			{"name": "Chief Teddy", "text": "I couldn't have done it. I suffer from heart failure."},
			{"name": "Chief Teddy", "text": "If I'd run off from the scene, they would've caught up to me eventually."},
			{"name": "Mister Croak", "text": "And how do we know you're not just making up some illness that doesn't exist?"},
			{"name": "Mister Croak", "text": "A suspect's word isn't proof of anything."}
		],
		"targetLine": 4, "clue": 7,
		"resolution": [
			{"name": "Detective Fox", "text": "No, he's not making it up."},
			{"name": "Detective Fox", "text": "Doctor Meow, from the hospital, confirmed it to me himself, didn't he?"},
			{"name": "Doctor Meow", "text": "Yes, that's right. Chief Teddy's been coming to my hospital for treatment for his heart failure for several months now."},
			{"name": "Mister Croak", "text": "Huh. You could've said that earlier, couldn't you?"},
			{"name": "Doctor Meow", "text": "My apologies. Trials make me a bit nervous…"},
			{"name": "Detective Fox", "text": "(What a bad time to be shy.)"}
		],
		"hint": "There's someone who can vouch for what Teddy is saying.",
		"solution": "Use clue 7 when Croak accuses him of making up his illness."
	},
		{
		"lines": [
			{"name": "Partner Woof", "text": "Let's think about something else. Guard Wolf's poisoning, for example."},
			{"name": "Partner Woof", "text": "When could he have been poisoned?"},
			{"name": "Guard Wolf", "text": "I was outside the door the whole time. I didn't see anyone who could've poisoned me."},
			{"name": "Guard Wolf", "text": "I only went in for a minute to use the bathroom, right before I passed out."},
			{"name": "Lady Stinger", "text": "Maybe he was poisoned before going to the bathroom? When he turned around to enter Mayor Oinker's house!"},
			{"name": "Chief Teddy", "text": "I doubt it. A trained guard like Wolf would've heard someone coming up behind him."},
			{"name": "Mister Croak", "text": "Maybe he was poisoned right when he stepped out and went back to his post?"},
			{"name": "Lady Stinger", "text": "That's impossible. Guard Wolf must have been poisoned before leaving the house!"},
			{"name": "Partner Woof", "text": "Ugh... how are we supposed to figure this out?!"}
		],
		"targetLine": 7, "clue": 8,
		"resolution": [
			{"name": "Detective Fox", "text": "No, Guard Wolf was definitely poisoned when he stepped out."},
			{"name": "Detective Fox", "text": "He felt sudden, sharp pain and passed out very soon after."},
			{"name": "Detective Fox", "text": "If he'd been poisoned before going into the bathroom, he would've felt it long before he left."},
			{"name": "Chief Teddy", "text": "I see. That makes sense."}
		],
		"hint": "Guard Wolf felt a sudden, sharp pain. It couldn't have been a poison that builds up slowly over time.",
		"solution": "Use clue 8 when Lady Stinger claims Guard Wolf couldn't have been poisoned as he left."
	},
		{
		"lines": [
			{"name": "Chief Teddy", "text": "Still, there's something that doesn't add up."},
			{"name": "Chief Teddy", "text": "Guard Wolf is a trained, sharp-eyed guard."},
			{"name": "Chief Teddy", "text": "How could someone poison him without him noticing?"},
			{"name": "Partner Woof", "text": "Maybe the poison wasn't given through an attack, but through a trap."},
			{"name": "Mister Croak", "text": "How could someone poison him without even being there?"},
			{"name": "Mister Croak", "text": "If that were the case, we would've already found evidence to back it up, and that's not the case."},
			{"name": "Partner Woof", "text": "If it were that easy, we would've caught the thief a long time ago!"},
			{"name": "Lady Stinger", "text": "Maybe the animal who poisoned him attacked really fast?"},
			{"name": "Detective Fox", "text": "I doubt there's an animal that fast in Animal Village..."}
		],
		"targetLine": 5, "clue": 9,
		"resolution": [
			{"name": "Detective Fox", "text": "Actually, there is a clue at the crime scene that could prove it."},
			{"name": "Detective Fox", "text": "Woof and I found a pin lying on the ground under the door."},
			{"name": "Detective Fox", "text": "If the poison had been put on that pin, it could've poisoned anyone."},
			{"name": "Miss Sheep", "text": "And there'd be no need for the thief to poison him through an attack!"},
			{"name": "Chief Teddy", "text": "That makes sense, but we still need to narrow that possibility down."}
		],
		"hint": "There's an object that supports one of the theories brought up.",
		"solution": "Use clue 9 when Croak says no evidence was found at the crime scene."
	},
		{
		"lines": [
			{"name": "Chief Teddy", "text": "If the poison really was delivered through that pin..."},
			{"name": "Chief Teddy", "text": "How exactly did it end up stuck in Guard Wolf?"},
			{"name": "Miss Sheep", "text": "Maybe someone threw it at him like a dart?"},
			{"name": "Partner Woof", "text": "I doubt it. A wolf would've heard the pin if it had been thrown at high speed."},
			{"name": "Lady Stinger", "text": "Maybe Guard Wolf touched a surface where someone had left the pin."},
			{"name": "Mister Croak", "text": "And how did the pin stay stuck upright, with magic? Impossible."},
			{"name": "Miss Sheep", "text": "Maybe he stuck the pin in himself!"},
			{"name": "Detective Fox", "text": "That wouldn't make any sense at all..."}
		],
		"targetLine": 5, "clue": 1,
		"resolution": [
			{"name": "Detective Fox", "text": "Maybe it doesn't take magic, just nylon."},
			{"name": "Detective Fox", "text": "A piece of nylon string was found at the door."},
			{"name": "Detective Fox", "text": "So there was a way to make sure he'd stick himself with the pin."},
			{"name": "Partner Woof", "text": "The doorknob!"},
			{"name": "Detective Fox", "text": "Yeah. The thief waited for Guard Wolf to go into Oinker's house to use the bathroom."},
			{"name": "Detective Fox", "text": "Then tied the poisoned pin to the doorknob with a piece of nylon string. Undetectable."},
			{"name": "Detective Fox", "text": "When Guard Wolf closed the door, the pin stuck him and the poison took effect."},
			{"name": "Chief Teddy", "text": "There are still a lot of unknowns in this case. We need to change the direction of this conversation."}
		],
		"hint": "Magic doesn't exist, but maybe an object found at the scene is a good substitute...",
		"solution": "Use clue 1 when Mister Croak claims only magic could explain this mystery."
	},
		{
		"lines": [
			{"name": "Detective Fox", "text": "I want to bring up an idea I've been thinking about for a few hours now..."},
			{"name": "Detective Fox", "text": "Where did the thief get in to steal the documents?"},
			{"name": "Partner Woof", "text": "Well... through the window, right? It was broken during the robbery."},
			{"name": "Lady Stinger", "text": "Couldn't the thief have gotten in through the door?"},
			{"name": "Detective Fox", "text": "No, the evidence shows the door wasn't forced open."},
			{"name": "Miss Sheep", "text": "Then there's no other way in."},
			{"name": "Detective Fox", "text": "(I'm not so sure about that.)"},
			{"name": "Chief Teddy", "text": "If we analyze the window, we'll end up finding evidence that someone climbed through it."}
		],
		"targetLine": 7, "clue": 3,
		"resolution": [
			{"name": "Detective Fox", "text": "That's exactly the problem. There's no way the thief got in through the window."},
			{"name": "Detective Fox", "text": "After analyzing it, not a single trace was found of anyone climbing through it."},
			{"name": "Detective Fox", "text": "That shows the thief didn't get in through the door or the window. Instead..."},
			{"name": "Detective Fox", "text": "I think the thief got in through the chimney."},
			{"name": "Partner Woof", "text": "Huh? Through the chimney?"},
			{"name": "Detective Fox", "text": "The window's gap was too small to climb through, but the chimney is quite roomy..."},
			{"name": "Detective Fox", "text": "It's the only opening someone could've gotten in and out of without any trouble."},
			{"name": "Partner Woof", "text": "I don't get it. Then why didn't we find any traces in the chimney pointing to the thief?"},
			{"name": "Detective Fox", "text": "Because Mayor Oinker lit the chimney while we were investigating."},
			{"name": "Detective Fox", "text": "Any evidence that could've been found was reduced to ashes..."},
			{"name": "Detective Fox", "text": "(Thanks a lot for the help, Oinker.)"}
		],
		"hint": "One of the statements clashes with a clue that contradicts it.",
		"solution": "Use clue 3 when Teddy claims evidence would be found on the window."
	},
		{
		"lines": [
			{"name": "Partner Woof", "text": "But something doesn't add up. If the thief got in through the chimney, why was the window broken?"},
			{"name": "Detective Fox", "text": "It couldn't have been to get in or out, since the chimney had to be the way."},
			{"name": "Lady Stinger", "text": "Maybe the thief broke the window before going in, to throw off the detectives analyzing the scene?"},
			{"name": "Chief Teddy", "text": "Or maybe the thief wanted to check if the sleeping Guard Wolf would wake up to loud noises."},
			{"name": "Miss Sheep", "text": "Would someone really do all that just to throw people off? I doubt it, hard to believe."},
			{"name": "Partner Woof", "text": "You'd be surprised how eccentric some criminal profiles can be!"}
		],
		"targetLine": 2, "clue": 4,
		"resolution": [
			{"name": "Detective Fox", "text": "No, the thief broke the window on the way out, not on the way in."},
			{"name": "Detective Fox", "text": "The witness called the police right after hearing a loud noise, and saw someone running out of the place."},
			{"name": "Miss Sheep", "text": "That's right, I saw someone run off right after I heard the noise. I called it in right away."},
			{"name": "Mister Croak", "text": "Right, if the thief had broken the window on the way in..."},
			{"name": "Partner Woof", "text": "It wouldn't match Miss Sheep's testimony!"}
		],
		"hint": "One of the pieces of evidence shows whether the window was broken before or after leaving Oinker's house.",
		"solution": "Use clue 4 when Stinger says the thief broke the window before going in."
	},
		{
		"lines": [
			{"name": "Chief Teddy", "text": "Something's fishy here. I don't think the thief got in through the chimney."},
			{"name": "Chief Teddy", "text": "The thief could've gotten in through the window and then cleaned up the tracks!"},
			{"name": "Partner Woof", "text": "How could the thief have cleaned up so well in the middle of the night?"},
			{"name": "Chief Teddy", "text": "The thief could've used a flashlight and cleaned everything up in five or ten minutes."},
			{"name": "Chief Teddy", "text": "The police must have taken long enough for the thief to pull that off."},
			{"name": "Chief Teddy", "text": "And that's when they made their triumphant escape!"}
		],
		"targetLine": 4, "clue": 5,
		"resolution": [
			{"name": "Detective Fox", "text": "You're wrong. Miss Sheep said the police took only a few minutes to arrive."},
			{"name": "Detective Fox", "text": "If the thief had stayed even a few minutes to clean up the tracks..."},
			{"name": "Partner Woof", "text": "The police would've caught them fleeing the scene."},
			{"name": "Detective Fox", "text": "(Which confirms the thief really did just break the window to throw us off.)"},
			{"name": "Detective Fox", "text": "(That's a pretty clever plan. This must have been planned well in advance.)"}
		],
		"hint": "One of the statements is impossible given the timeline of events.",
		"solution": "Use clue 5 when Teddy claims the police took a while to arrive."
	},
		{
		"lines": [
			{"name": "Partner Woof", "text": "Detective, there's something we should start asking ourselves."},
			{"name": "Partner Woof", "text": "If the thief wasn't Oinker or Teddy, the only two who knew the password to open the door where the documents were..."},
			{"name": "Partner Woof", "text": "How did the thief figure out the password?"},
			{"name": "Miss Sheep", "text": "Did they really have to figure it out?"},
			{"name": "Partner Woof", "text": "Huh? What do you mean?"},
			{"name": "Miss Sheep", "text": "I mean... I don't think either of them would go around telling important info to just anyone."},
			{"name": "Miss Sheep", "text": "Maybe the thief just forced open the door hiding the documents to get in!"},
			{"name": "Chief Teddy", "text": "The detectives would've found evidence of that, if it were the case."},
			{"name": "Miss Sheep", "text": "Well, I'm just trying to throw out ideas!"}
		],
		"targetLine": 6, "clue": 2,
		"resolution": [
			{"name": "Detective Fox", "text": "No, the thief definitely had to have figured out the password."},
			{"name": "Detective Fox", "text": "Because when we investigated the crime scene, we confirmed the door hiding the documents wasn't forced open."},
			{"name": "Partner Woof", "text": "Yeah, the thief typed in the password to get in, no doubt about it."}
		],
		"hint": "One of the pieces of evidence disproves a bold claim that's been made.",
		"solution": "Use clue 2 when Miss Sheep says the thief might have forced the door to get in."
	},
		{
		"lines": [
			{"name": "Lady Stinger", "text": "But that still doesn't explain something. How did the thief figure out the password?"},
			{"name": "Lady Stinger", "text": "Did they just try combinations until one worked?"},
			{"name": "Chief Teddy", "text": "No, impossible. If you enter the wrong password, an alarm goes off."},
			{"name": "Chief Teddy", "text": "The thief typed in the correct password on the first try."},
			{"name": "Detective Fox", "text": "Is there any subordinate you told the password to, Chief Teddy?"},
			{"name": "Chief Teddy", "text": "Never! And the same goes for Mister Oinker... this was the biggest secret in Animal Village."},
			{"name": "Chief Teddy", "text": "No one could've found out because of me, that's for sure."},
			{"name": "Mister Croak", "text": "There has to be some way the thief could've found out."},
			{"name": "Chief Teddy", "text": "There's no way that's possible, unless Mayor Oinker revealed that information to someone else."},
			{"name": "Partner Woof", "text": "I don't think that's the case, Oinker seemed really stressed about the whole thing."},
			{"name": "Detective Fox", "text": "(Yeah, it's hard to believe he'd go around blabbing about it if it mattered that much to him.)"}
		],
		"targetLine": 6, "clue": 6,
		"resolution": [
			{"name": "Detective Fox", "text": "Are you sure about that, Chief Teddy? Because I actually think this was your fault."},
			{"name": "Chief Teddy", "text": "What? Are you saying I'm lying when I say I never told anyone?!"},
			{"name": "Detective Fox", "text": "No, that's not it. What I'm saying is... you told me you kept the passwords written down in your own briefcase!"},
			{"name": "Detective Fox", "text": "If that's true, it wouldn't be strange to think someone read it without you noticing, in a moment of carelessness!"},
			{"name": "Chief Teddy", "text": "U-Uh... well, put that way, I guess that's a reasonable explanation."},
			{"name": "Chief Teddy", "text": "But if that's really what happened, it's very hard to pull off, because I always keep those papers close at hand!"},
			{"name": "Chief Teddy", "text": "If the thief really found out that way, they must have been really skilled."},
			{"name": "Detective Fox", "text": "(Probably. I can't think of another way to explain it for now.)"}
		],
		"hint": "Either Oinker or Teddy, one of the two must have let the password slip to the thief somehow.",
		"solution": "Use clue 6 when Teddy says no one could have found out because of him."
	},
		{
		"lines": [
			{"name": "Detective Fox", "text": "Now we have an idea of how the password was figured out."},
			{"name": "Detective Fox", "text": "But it's an incomplete picture, and there's still another question left unanswered..."},
			{"name": "Detective Fox", "text": "If neither Stinger nor Croak can be guilty, who on earth poisoned Guard Wolf?"},
			{"name": "Partner Woof", "text": "Are we sure they're the only poisonous animals in Animal Village?"},
			{"name": "Chief Teddy", "text": "Yes, no doubt about it, I checked it myself before questioning them."},
			{"name": "Lady Stinger", "text": "I can say for a fact that my venom can't be extracted easily."},
			{"name": "Lady Stinger", "text": "Any doctor or family member would've noticed if they'd seen someone trying to extract it from me."},
			{"name": "Mister Croak", "text": "Same goes for me. We couldn't have been accomplices."},
			{"name": "Chief Teddy", "text": "Or maybe one of you is lying!"}
		],
		"targetLine": 3, "clue": 10,
		"resolution": [
			{"name": "Detective Fox", "text": "Maybe... there's one possibility. Just one."},
			{"name": "Detective Fox", "text": "Tell me, Lady Platypus. Could I ask you something?"},
			{"name": "Lady Platypus", "text": "Huh? Me? Um... yeah, sure, I guess. No problem."},
			{"name": "Detective Fox", "text": "Are you transgender?"},
			{"name": "Lady Stinger", "text": "Huh?!"},
			{"name": "Partner Woof", "text": "D-Detective! You can't just ask that out of nowhere!"},
			{"name": "Detective Fox", "text": "(Why are they all making such a big deal out of this? We're in the middle of a robbery trial.)"},
			{"name": "Detective Fox", "text": "Just answer me. Yes or no?"},
			{"name": "Lady Platypus", "text": "Um...."},
			{"name": "Lady Platypus", "text": "Yeah, I am, dammit. So what? Does that have any relevance to this trial?"},
			{"name": "Detective Fox", "text": "It does."},
			{"name": "Detective Fox", "text": "At the hospital, I read a book about the different animals of Animal Village."},
			{"name": "Detective Fox", "text": "It said that male platypuses, only males, have venom in their hind legs. Is that true?"},
			{"name": "Lady Platypus", "text": "W-Well... yeah, that's true, I guess."},
			{"name": "Chief Teddy", "text": "Huh? Then why didn't you mention that before, Lady Platypus?"},
			{"name": "Lady Platypus", "text": "Because it's nobody's business, my personal stuff and my identity, got it?"},
			{"name": "Lady Platypus", "text": "Yeah, it's true. But I have an alibi, you know? I couldn't have committed the robbery!"},
			{"name": "Detective Fox", "text": "(Doesn't matter. This has already given us a huge clue.)"}
		],
		"hint": "If you looked closely at your investigation, you'll know who's stumbled onto the key to this whole thing.",
		"solution": "Use clue 10 when Woof brings up whether there could be more poisonous animals."
	},
		{
		"lines": [
			{"name": "Chief Teddy", "text": "So, it's true that Lady Platypus has an alibi?"},
			{"name": "Detective Fox", "text": "Yeah, she couldn't have been the thief."},
			{"name": "Detective Fox", "text": "(That doesn't rule out her being an accomplice, but I think there's a more reasonable explanation.)"},
			{"name": "Partner Woof", "text": "Maybe the thief talked her into lending some of her venom to pull off the robbery?"},
			{"name": "Lady Platypus", "text": "No! I never told anyone I'm transgender, I promise!"},
			{"name": "Chief Teddy", "text": "Well, you're going to have to explain to us how your venom ended up in Guard Wolf, Lady Platypus."},
			{"name": "Lady Platypus", "text": "How should I know?! I wasn't there, and I didn't help anyone! It couldn't have been my venom!"},
			{"name": "Detective Fox", "text": "(Someone should calm her down before this escalates.)"}
		],
		"targetLine": 6, "clue": 12,
		"resolution": [
			{"name": "Detective Fox", "text": "Don't get so worked up, Lady Platypus. I don't think you're an accomplice or guilty of anything."},
			{"name": "Lady Platypus", "text": "Really? I swear that's true, really..."},
			{"name": "Detective Fox", "text": "That said, it was your venom that was used against Guard Wolf."},
			{"name": "Chief Teddy", "text": "Aren't you contradicting what you just said, detective?"},
			{"name": "Detective Fox", "text": "No. Because Lady Platypus called us before the trial started."},
			{"name": "Detective Fox", "text": "She said she suspected her house had been broken into a few days ago..."},
			{"name": "Detective Fox", "text": "But that she'd failed to find anything stolen when she checked on her own, isn't that right?"},
			{"name": "Lady Platypus", "text": "Yeah, that's true. What are you getting at?"},
			{"name": "Detective Fox", "text": "I'm getting at the possibility that what was stolen that night was your venom!"},
			{"name": "Detective Fox", "text": "The thief snuck into your home while you were sleeping and extracted venom from you to commit the crime."},
			{"name": "Partner Woof", "text": "I see, that would explain this whole situation."},
			{"name": "Detective Fox", "text": "(And if that's the case...)"},
			{"name": "Detective Fox", "text": "(There's only one person who could have committed the robbery.)"},
			{"name": "Detective Fox", "text": "(There was only one person who could have found out Lady Platypus was transgender.)"},
			{"name": "Detective Fox", "text": "(And only one person who had a natural opportunity to secretly read Teddy's documents.)"}
		],
		"hint": "It's clear the venom wasn't Stinger's or Croak's, so there's only one option left.",
		"solution": "Use clue 12 when Platypus claims it couldn't have been her venom."
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
		"Lady Platypus": platypusTexture,
		"Miss Sheep": sheepTexture,
		"Doctor Meow": meowTexture,
		"Guard Wolf": wolfTexture
	}

	hintButton.pressed.connect(_onHintButtonPressed)
	answerButton.pressed.connect(_onAnswerButtonPressed)
	disagreeButton.pressed.connect(_onDisagreeButtonPressed)

	for i in clueButtons.size():
		clueButtons[i].pressed.connect(_onClueButtonPressed.bind(i + 1))

	_setPickerVisible(false)
	_updateCompletion()

	await _fadeIn()

	_playInsert(introConversation, func():
		trialStarted = true
		_startWave(0)
	)
	
	music.play_music(preload("res://music/trial.mp3"))

func _fadeIn() -> void:
	var layer := CanvasLayer.new()
	layer.layer = 10
	add_child(layer)

	var rect := ColorRect.new()
	rect.color = Color.BLACK
	rect.set_anchors_preset(Control.PRESET_FULL_RECT)
	layer.add_child(rect)

	var tween := create_tween()
	tween.tween_property(rect, "modulate:a", 0.0, 3.0)
	await tween.finished

	layer.queue_free()

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
	var texture: Texture2D = speakerTextures.get(speaker)
	if texture == null:
		return
	characterSprite.texture = texture

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
		currentWave = waves.size()
		_updateCompletion()
		music.play_music(preload("res://music/trial2.mp3"))
		_playInsert(finalConversation, func(): _onTrialComplete())
	else:
		_startWave(currentWave + 1)
		_updateCompletion()

func _updateCompletion() -> void:
	var percent := int(round((float(currentWave) / float(waves.size())) * 100.0))
	completionLabel.text = str(percent) + "% of trial completed"

func _onTrialComplete() -> void:
	await _fadeToPrison()

func _fadeToPrison() -> void:
	var layer := CanvasLayer.new()
	layer.layer = 10
	add_child(layer)

	var rect := ColorRect.new()
	rect.color = Color.BLACK
	rect.modulate.a = 0.0
	rect.set_anchors_preset(Control.PRESET_FULL_RECT)
	layer.add_child(rect)

	var tween := create_tween()
	tween.tween_property(rect, "modulate:a", 1.0, 1.0)
	await tween.finished

	get_tree().change_scene_to_file("res://scenes/prison.tscn")
	layer.queue_free()

extends Node2D

enum MainQuestState {
	INTRO,
	KILL_FIRST_BATCH_RATS,
	COMPLETE_FIRST_BATCH_RATS,
	ASK_HANK_ABOUT_FOOD,
	GET_FOOD_INGREDIENTS,
	RETURN_FOOD_INGREDIENTS,
	GIVE_FOOD_TO_KARL,
	ASK_HANK_ABOUT_WEED,
	GET_WEED_INGREDIENTS,
	RETURN_WEED_INGREDIENTS,
	GIVE_WEED_TO_KARL,
	KILL_SECOND_BATCH_RATS,
	COMPLETE_SECOND_BATCH_RATS,
	ASK_HANK_ABOUT_DUST,
	GET_DUST_INGREDIENTS,
	RETURN_DUST_INGREDIENTS,
	GIVE_DUST_TO_KARL,
	KILL_THIRD_BATCH_RATS,
	CHECK_ON_KARL,
	OUTRO
}

enum QuestSpeaker { NONE, HANK, KARL }

var main_quest_state: MainQuestState = MainQuestState.INTRO

var quests = {
	MainQuestState.KILL_FIRST_BATCH_RATS: {
		"speaker": QuestSpeaker.NONE,
		"speech": "",
		"description": "Shoot __COUNTER__ rats",
		"counter": 10,
	},
	MainQuestState.COMPLETE_FIRST_BATCH_RATS: {
		"speaker": QuestSpeaker.KARL,
		"speech": "Hey good work. Don't feel bad, no one rides for free. Except Hank. Hey go tell Hank to make himself useful and whip us up some food. Oh and don't forget to keep the coal flowing!",
		"description": "Report back to Karl",
		"counter": 0,
	},
	MainQuestState.ASK_HANK_ABOUT_FOOD: {
		"speaker": QuestSpeaker.HANK,
		"speech": "Ol' Karl is hungry huh? Well let me think... You know, if you get me some rat tails, I think I can put together somethin' nice.",
		"description": "Ask Hank about food",
		"counter": 0,
	},
	MainQuestState.GET_FOOD_INGREDIENTS: {
		"speaker": QuestSpeaker.NONE,
		"speech": "",
		"description": "Harvest __COUNTER__ rat tails",
		"counter": 5,
	},
	MainQuestState.RETURN_FOOD_INGREDIENTS: {
		"speaker": QuestSpeaker.HANK,
		"speech": "Hey, these are some beefy tails! Here let me just throw these on here and.. There ya go! Rat tail tacos!",
		"description": "Return rat tails to Hank",
		"counter": 0,
	},
	MainQuestState.GIVE_FOOD_TO_KARL: {
		"speaker": QuestSpeaker.KARL,
		"speech": "Oh well would you look at that! Hank is good for somethin'. This should keep me going for oh, I don't know, a few more minutes? You know what I really need to keep this operation running? Some good strong tumbleweed. Ask Hank for some, he'll know what you mean.",
		"description": "Deliver taco to Karl",
		"counter": 0,
	},
	MainQuestState.ASK_HANK_ABOUT_WEED: {
		"speaker": QuestSpeaker.HANK,
		"speech": "Tumbleweed huh? Well who am I to ask questions. I'll need 5 rat whiskers if you want that.",
		"description": "Ask Hank about tumbleweed",
		"counter": 0,
	},
	MainQuestState.GET_WEED_INGREDIENTS: {
		"speaker": QuestSpeaker.NONE,
		"speech": "",
		"description": "Harvest __COUNTER__ rat whiskers",
		"counter": 5,
	},
	MainQuestState.RETURN_WEED_INGREDIENTS: {
		"speaker": QuestSpeaker.HANK,
		"speech": "Perfect! Now let me just.. hng.. and.. There! Tumbleweed!",
		"description": "Return rat whiskers to Hank",
		"counter": 0,
	},
	MainQuestState.GIVE_WEED_TO_KARL: {
		"speaker": QuestSpeaker.KARL,
		"speech": "Well hot diggity dog! That's the stuff! Alright partner, this should really keep us going steady. I'll keep shovelin' and you go kill us some more rats ok? Those suckers don't know when to give up.",
		"description": "Deliver tumbleweed to Karl",
		"counter": 0,
	},
	MainQuestState.KILL_SECOND_BATCH_RATS: {
		"speaker": QuestSpeaker.NONE,
		"speech": "",
		"description": "Shoot __COUNTER__ more rats",
		"counter": 10,
	},
	MainQuestState.COMPLETE_SECOND_BATCH_RATS: {
		"speaker": QuestSpeaker.KARL,
		"speech": "Alright man, good work, but I gotta be honest, we're not gonna make it to Frontierado unless I have something to really light my furnace. Tell Hank to stop holding out on the dunedust.",
		"description": "Report back to Karl",
		"counter": 0,
	},
	MainQuestState.ASK_HANK_ABOUT_DUST: {
		"speaker": QuestSpeaker.HANK,
		"speech": "Dunedust? Karl said that? Hey is everything alright up there? Listen, if you really need it, I can make it happen. I just need some rat fangs.",
		"description": "Ask Hank about dunedust",
		"counter": 0,
	},
	MainQuestState.GET_DUST_INGREDIENTS: {
		"speaker": QuestSpeaker.NONE,
		"speech": "",
		"description": "Harvest __COUNTER__ rat fangs",
		"counter": 5,
	},
	MainQuestState.RETURN_DUST_INGREDIENTS: {
		"speaker": QuestSpeaker.HANK,
		"speech": "Yep. Yeah that'll do. Let me just.. HIYAH!!! and RAAAHH!!.. Ok... Alright. I hope you know what you're doing with this.",
		"description": "Return rat fangs to Hank",
		"counter": 0,
	},
	MainQuestState.GIVE_DUST_TO_KARL: {
		"speaker": QuestSpeaker.KARL,
		"speech": "Woo! Whoa! Ok! That's the stuff. Alright feller, step back and let me get to work. Keep those rats at bay and we'll be there in no time",
		"description": "Deliver dunedust to Karl",
		"counter": 0,
	},
	MainQuestState.KILL_THIRD_BATCH_RATS: {
		"speaker": QuestSpeaker.NONE,
		"speech": "",
		"description": "Shoot __COUNTER__ extra rats",
		"counter": 10,
	},
	MainQuestState.CHECK_ON_KARL: {
		"speaker": QuestSpeaker.KARL,
		"speech": "Oh crap! Looks like that dunedust did a number on Karl! I think it's up to us to take it from here...",
		"description": "Check on Karl",
		"counter": 0,
	},
	MainQuestState.OUTRO: {
		"speaker": QuestSpeaker.NONE,
		"speech": "",
		"description": "",
		"counter": 0,
	}
}

var karl_intro_line = "Howdy partner, glad to have you with us. We're a little short-handed, so you're gonna have to help out to keep us running steady alright? You can start by taking care of some these pesky rats who think they own the place"
var did_karl_intro: bool = false

var hank_intro_line = "Hi there friend, nice to meet you. I'm Hank. I like to sit back here in the caboose so Karl can't yell at me"
var did_hank_intro: bool = false

var quest_counter: int = 0

func _ready():
	pass


func _process(delta):
	pass

func progress_main_quest():
	main_quest_state += 1
	quest_counter = quests[main_quest_state].counter
	Main.game.hud.update_journal_details()

	if main_quest_state == MainQuestState.CHECK_ON_KARL:
		Main.game.set_music_state(Game.MusicState.NONE)
		Main.karl.pass_out()
	elif main_quest_state == MainQuestState.OUTRO:
		Main.game.you_win = true

	# These are the checkpoints that you can restart from
	if main_quest_state in [
		MainQuestState.GET_FOOD_INGREDIENTS,
		MainQuestState.RETURN_FOOD_INGREDIENTS,
		MainQuestState.GIVE_FOOD_TO_KARL,
		MainQuestState.ASK_HANK_ABOUT_WEED,
		MainQuestState.GET_WEED_INGREDIENTS,
		MainQuestState.RETURN_WEED_INGREDIENTS,
		MainQuestState.GIVE_WEED_TO_KARL,
		MainQuestState.KILL_SECOND_BATCH_RATS,
		MainQuestState.COMPLETE_SECOND_BATCH_RATS,
		MainQuestState.ASK_HANK_ABOUT_DUST,
		MainQuestState.GET_DUST_INGREDIENTS,
		MainQuestState.RETURN_DUST_INGREDIENTS,
		MainQuestState.GIVE_DUST_TO_KARL,
	]:
		Main.continue_starting_point = main_quest_state

func decrement_counter(amount: int = 1):
	quest_counter -= amount

	if quest_counter <= 0:
		progress_main_quest()
	else:
		Main.game.hud.update_journal_details()

func reset():
	main_quest_state = MainQuestState.INTRO
	did_karl_intro = false
	did_hank_intro = false

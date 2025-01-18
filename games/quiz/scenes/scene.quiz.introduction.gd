extends EventQueue

# Common tags/names
# TODO: Replace remaining with local tags
# TODO: Finish contestant Presenter/A/B animated pixel sprites
# TODO: Refactor Variables, remove .global and replace with something better
# TODO: Add O / X in monitor images
# TODO: Add sound effects, music + O / X + character voices
# TODO: Add framed sprites with fixed dimensions
# TODO: Add sound effects
# TODO: Replace Variables strings/keys with ints, pulled from the enum Scene.Tags
# TODO: Add CommonGameEvents class and load all utilities into it
enum lTags {presenter_introduction, presenter, stage, scene,  Stage, Presenter, Contestant_A, Contestant_B, Contestant_C}

enum lCharacters {A, B, Presenter, lMonitor, lStage}

# var SCENE = "SCENE"
var PRESENTER_INTRODUCTION = "PRESENTER_INTRODUCTION"
var PRESENTER = "PRESENTER"
var STAGE = "STAGE"

var Contestant_A = "Contestant_A"
var Contestant_B = "Contestant_B"
var Presenter = "Presenter"

# var Contestant_A_Position = Vector2(-192, -50)
# var Contestant_B_Position = Vector2(192, -50)
# var Presenter_Position =  Vector2(0, -15)


var lPortraits = {
	lCharacters.A: "res://games/quiz/portraits/pallet.contestant.jones.tscn" , 
	lCharacters.B: "res://games/quiz/portraits/pallet.contestant.B.tscn", 
	lCharacters.Presenter: "res://games/quiz/portraits/pallet.contestant.presenter.tscn"
	}
	

var lPositions = {
	lCharacters.A: Vector2(-192, -50),
	lCharacters.B: Vector2(192, -50),
	lCharacters.Presenter: Vector2(0, -15),
	}

var DEBUG = true

var utilities = preload("res://games/quiz/scenes/utilities.stage.gd")
var common_events_1 = preload("res://games/quiz/scenes/common.stage.gd")


func add_contestant_portraits():
	
	common_events_1.add_contestant(lCharacters.Presenter, lPortraits[lCharacters.Presenter], lPositions[lCharacters.Presenter])
	
	Queue.queue.append(Event.message_box().initialise(["Ladies and gentlemen.", "Let's welcome our contestants
	to the stage."]))
	# common_events_1.add_contestant(Contestant_A, lPortraits[lCharacters.A], lPositions[lCharacters.A])
	common_events_1.add_contestant(lCharacters.A, lPortraits[lCharacters.A], lPositions[lCharacters.A])
	common_events_1.add_contestant(lCharacters.B, lPortraits[lCharacters.B], lPositions[lCharacters.B])
	
func contestant_introductions():
	# Contestant A
	Queue.queue.append(Event.play_portrait_animation().initialise(lCharacters.Presenter, "Exclaim", true))
	Queue.queue.append(Event.message_box().initialise(["Our first contestant is Alexander Bones.", "Introduce yourself !"]))
	Queue.queue.append(Event.play_portrait_animation().initialise(lCharacters.A, "Exclaim", true))
	Queue.queue.append(Event.message_box().initialise(["Globalists are taking over.", "But.."]))
	Queue.queue.append(Event.play_portrait_animation().initialise(lCharacters.A, "Exclaim", true))
	Queue.queue.append(Event.message_box().initialise(["We will NOT, FALTER !"]))
	Queue.queue.append(Event.play_portrait_animation().initialise(lCharacters.A, "Laugh", true))
	Queue.queue.append(Event.play_portrait_animation().initialise(lCharacters.A, "Idle", false))
	Queue.queue.append(Event.wait().initialise(2))

	# Contestant B
	Queue.queue.append(Event.play_portrait_animation().initialise(lCharacters.Presenter, "Exclaim", true))
	Queue.queue.append(Event.message_box().initialise(["Our second contestant is John Morgan.", "Introduce yourself !"]))	
	Queue.queue.append(Event.play_portrait_animation().initialise(lCharacters.B, "Exclaim", true))
	Queue.queue.append(Event.message_box().initialise(["Aliens are among us in the other realms."]))
	Queue.queue.append(Event.play_portrait_animation().initialise(lCharacters.B, "Exclaim", true))
	Queue.queue.append(Event.message_box().initialise(["...",  "What was I just saying ?"]))
	Queue.queue.append(Event.play_portrait_animation().initialise(lCharacters.B, "Laugh", true))
	Queue.queue.append(Event.play_portrait_animation().initialise(lCharacters.B, "Idle", false))
	Queue.queue.append(Event.wait().initialise(2))
	

func present_next_question(question: String, answers: Array):
	Queue.queue.append(Event.wait().initialise(0.5))
	Queue.queue.append(Event.lambda().initialise(utilities.lambda_play_monitor_animation, ["Enter"]))
	Queue.queue.append(Event.wait().initialise(0.5))
	Queue.queue.append(Event.message_box().initialise(["And the next question is:"]))
	Queue.queue.append(Event.wait().initialise(0.5))
	Queue.queue.append(Event.lambda().initialise(utilities.lambda_update_monitor_messages, [question]))
	Queue.queue.append(Event.wait().initialise(1))
	Queue.queue.append(Event.message_box().initialise(["That's quite a question."]))
	Queue.queue.append(Event.message_box().initialise(["So contestant, what will be 
	your answer ?"]))
	Queue.queue.append(Event.wait().initialise(0.25))
	utilities.display_question_and_options(lCharacters.Presenter, "Select the correct answer:", ["1920 AD", "20 AD", "1 AD", "200 BC"])


	
func introduce_the_quiz_show():
	Queue.queue.append(Event.settings().initialise({"message_box_position": [0,150]}))
	Queue.queue.append(Event.add_node().initialise("res://games/quiz/nodes/stage/node.quiz.stage.tscn", [], STAGE))
	utilities.setup_monitor()
	
	Queue.queue.append(Event.fade_in().initialise())
	
	if not DEBUG:
		Queue.queue.append(Event.play_event_queue().initialise(lTags.presenter_introduction))
	else:
		pass
		# Queue.queue.append(Event.message_box().initialise(["Skipping VAIN.."]))

	add_contestant_portraits()
	Queue.queue.append(Event.wait().initialise(1))
	
	if DEBUG:
		contestant_introductions()
	
	Queue.queue.append(Event.wait().initialise(1))
	Queue.queue.append(Event.message_box().initialise(["Is everyone ready ?"]))
	Queue.queue.append(Event.message_box().initialise(["Bring the board in !"]))
	
	# TODO: Fix lambda interrupting quit_game, waiting for input ?
	# TODO: Update RunEverythingReference game
	present_next_question("When did Rome fall ?", ["1920 AD", "20 AD", "1 AD", "200 BC"])
	
	Queue.queue.append(Event.wait().initialise(1))
	Queue.add(Event.lambda().initialise(utilities.lambda_play_monitor_animation, ["Exit"]))
	Queue.queue.append(Event.message_box().initialise(["That does it for the first
	round."]))
	Queue.queue.append(Event.message_box().initialise(["See you in the next one !"]))
	Queue.add(Event.wait().initialise(1))
	Queue.add(Event.play_portrait_animation().initialise(lCharacters.Presenter, "Exit", false))
	
	Queue.queue.append(Event.wait().initialise(1))
	Queue.queue.append(Event.quit_game().initialise())


func initialise_global_queue():
	utilities.load_and_generate_assets(DEBUG, PRESENTER_INTRODUCTION)
	introduce_the_quiz_show()

func _comments_and_todos():
	# Sprite Order: # Background # Contestants 10 # Panels 20 # Hud 100
	# TODO: Add contestants as portraits + pallets [DONE]
	# TODO: Add idle "Breathing" animation to contestants [DONE]
	# TODO: Add sounds effects to contestant pallets (talking SEs)
	# TODO: Make first playable VAIN of quiz
	pass

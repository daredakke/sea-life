extends Node


const SCORE_LIST: String = "user://scores.dat"
const BLANK_SCORES: Dictionary = { "scores": [], "names": [] }

var scores: Dictionary


func _ready() -> void:
	load_scores()
	
	print(scores)


func save_scores() -> void:
	var file = FileAccess.open(SCORE_LIST, FileAccess.WRITE_READ)
	file.store_var(scores)
	file = null


func save_single_score(score: int, name: String) -> void:
	if scores["scores"].is_empty():
		scores["names"].append(name)
		scores["scores"].append(score)
		save_scores()
		return
		
	var index: int = -1
	
	# Get index to splice new score
	for i in range(scores["scores"].size()):
		if score > scores["scores"][i]:
			index = i
			break
	
	# Otherwise add to the end
	if index == -1:
		index = scores["scores"].size()
	
	scores["scores"].insert(index, score)
	scores["names"].insert(index, name)
	save_scores()


func load_scores() -> void:
	# Load scores
	if FileAccess.file_exists(SCORE_LIST):
		var file = FileAccess.open(SCORE_LIST, FileAccess.READ)
		scores = file.get_var()
		file = null
		return
	
	# Or create scores.dat if it does not exist
	var file = FileAccess.open(SCORE_LIST, FileAccess.WRITE_READ)
	file.store_var(BLANK_SCORES)
	file = null

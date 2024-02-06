extends Node


const SCORE_LIST: String = "user://scores.dat"
const BLANK_SCORES: Dictionary = { "scores": [], "names": [] }
const MAX_SCORES: int = 8

var scores: Dictionary


func _ready() -> void:
	load_scores()


func save_scores() -> void:
	var file = FileAccess.open(SCORE_LIST, FileAccess.WRITE_READ)
	file.store_var(scores)
	file = null


func is_new_highscore(score: int) -> bool:
	if score == 0:
		return false
	
	if scores["scores"].size() < MAX_SCORES:
		return true
	
	for saved_score in scores["scores"]:
		if score > saved_score:
			return true
	
	return false


func save_single_score(score: int, score_name: String) -> void:
	if scores["scores"].is_empty():
		scores["names"].append(score_name)
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
	
	# Truncate scores if there are too many
	if scores["scores"].size() > MAX_SCORES:
		scores["names"] = scores["names"].slice(0, MAX_SCORES)
		scores["scores"] = scores["scores"].slice(0, MAX_SCORES)
	
	save_scores()


func load_scores() -> void:
	# Load scores
	if FileAccess.file_exists(SCORE_LIST):
		var file = FileAccess.open(SCORE_LIST, FileAccess.READ)
		scores = file.get_var()
		file = null
		
	# Or create scores.dat if it does not exist
	else:
		var file = FileAccess.open(SCORE_LIST, FileAccess.WRITE_READ)
		file.store_var(BLANK_SCORES)
		file = null

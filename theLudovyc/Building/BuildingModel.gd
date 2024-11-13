extends Resource
class_name BuildingModel

var id: String
var current_ticks: int = 0
var current_worker: int = 0
var building_id: Buildings.Ids

func _init(_buildings_id: Buildings.Ids, _id: String):
	building_id = _buildings_id
	id = _id
	

func add_worker(possibleWorker: int ) -> int:
	var maxWorker: int = Buildings.get_max_workers(building_id)
	if current_worker <= maxWorker:
		var needed_worker: int = maxWorker - current_worker
		if needed_worker <= possibleWorker:
			current_worker = current_worker + needed_worker
			return needed_worker

	return 0

	
func rem_all_worker() -> int:
	var removed_worker: int = current_worker
	current_worker = 0
	return removed_worker

	
func needed_worker() -> int:
	var max_worker: int = Buildings.get_max_workers(building_id)
	return max_worker - current_worker

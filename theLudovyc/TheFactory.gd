extends Node
class_name TheFactory

@onready var game: Game2D = get_parent()
@onready var storage: TheStorage = $"../TheStorage"
@onready var event_bus: EventBus = $"../EventBus"

var buildings: Array[Building2D] = []

var workers := 0:
	set(value):
		workers = value
		event_bus.available_workers_updated.emit(game.population - workers)

var waiting_line_buildings: Array[Building2D] = []

func add_workers(building: Building2D) -> void:
	if (game.population - workers) > 0:
		var available_worker: int = game.population - workers
		var addedWorkers: int = building.add_worker(available_worker)
		workers = workers + addedWorkers
		buildings.append(building)
	else:
		waiting_line_buildings.append(building)

		
func rem_workers(building: Building2D) -> void:
	var removed_workers: int = building.rem_all_worker()
	workers = workers - removed_workers;
	if not waiting_line_buildings.is_empty():
		var i := waiting_line_buildings.rfind(building)

		if i != -1:
			waiting_line_buildings.remove_at(i)
			return
	
	if buildings.has(building):
		var position: int = buildings.find(building)
		buildings.remove_at(position)



func population_increase(amount: int):
	var population_pool: int = amount

	var i := 0

	while i < waiting_line_buildings.size():
		var waiting_building: Building2D = waiting_line_buildings[i]
		var needed_worker: int = waiting_building.needed_worker()
		if needed_worker <= population_pool:
			waiting_line_buildings.remove_at(i)
			population_pool = population_pool - needed_worker
			add_workers(waiting_building)
			if population_pool <= 0:
				break
		else:
			i = i + 1


func population_decrease(amount: int):
	var population_pool: int = amount
	
	while not buildings.is_empty():
		var building: Building2D = buildings.pick_random()
		var current_workes: int = building.current_worker
		if current_workes > 0:
			waiting_line_buildings.push_back(building)
			population_pool = population_pool - amount
			building.rem_all_worker()
		if population_pool <= 0:
			break


func _on_TheTicker_tick():
	for single_building in buildings:
		if is_instance_of(single_building, ProductionBuilding):
			var production_building: ProductionBuilding = single_building as ProductionBuilding
			production_building.singleTick()
			var amount: int = production_building.sendProducedItems()
			storage.add_resource(production_building.getProducedItemType(), amount)
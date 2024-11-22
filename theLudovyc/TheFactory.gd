extends Node
class_name TheFactory

const uuid_util = preload('res://addons/uuid/uuid.gd')

@onready var game: Game2D = get_parent()
@onready var storage: TheStorage = $"../TheStorage"
@onready var event_bus: EventBus = $"../EventBus"


var buildings: Dictionary = {}

var workers := 0:
	set(value):
		workers = value
		event_bus.available_workers_updated.emit(game.population - workers)

var waiting_line_buildings: Array[BuildingModel] = []

func add_workers(building: Building2D) -> void:
	var uuid: String =   uuid_util.v4()
	var building_model: ProductionBuildingModel = ProductionBuildingModel.new(building.building_id, uuid)
	building.id = uuid
	add_workers_to_model(building_model)

	
func add_workers_to_model(building_model: BuildingModel):
	if (game.population - workers) > 0:
		var available_worker: int = game.population - workers
		var addedWorkers: int = building_model.add_worker(available_worker)
		workers = workers + addedWorkers
		buildings[building_model.id] = building_model
	else:
		waiting_line_buildings.append(building_model)

		
func rem_workers(building: Building2D) -> void:
	var building_model: BuildingModel = buildings.get(building.id)
	if building_model != null:
		var removed_workers: int = building_model.rem_all_worker()
		workers = workers - removed_workers;
		if not waiting_line_buildings.is_empty():
			var i := waiting_line_buildings.rfind(building_model)

			if i != -1:
				waiting_line_buildings.remove_at(i)
				return
		
		buildings.erase(building.id)



func population_increase(amount: int):
	var population_pool: int = amount

	var i := 0

	while i < waiting_line_buildings.size():
		var waiting_building: BuildingModel = waiting_line_buildings[i]
		var needed_worker: int = waiting_building.needed_worker()
		if needed_worker <= population_pool:
			waiting_line_buildings.remove_at(i)
			population_pool = population_pool - needed_worker
			add_workers_to_model(waiting_building)
			if population_pool <= 0:
				break
		else:
			i += 1


func population_decrease(amount: int):
	var population_pool: int = amount
	
	while not buildings.is_empty():
		var building: BuildingModel = buildings.values().pick_random()
		var current_workes: int = building.current_worker
		if current_workes > 0:
			waiting_line_buildings.push_back(building)
			population_pool = population_pool - amount
			building.rem_all_worker()
		if population_pool <= 0:
			break


func _on_TheTicker_tick():
	for single_building in buildings.values():
		if is_instance_of(single_building, ProductionBuildingModel):
			var production_building: ProductionBuildingModel = single_building as ProductionBuildingModel
			production_building.singleTick(storage)
			
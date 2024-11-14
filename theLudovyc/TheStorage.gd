extends Node
class_name TheStorage

var storage: Dictionary = {}

@onready var event_bus = $"../EventBus"

@onready var the_factory: TheFactory = $"../TheFactory"

@onready var the_market := $"../TheMarket"

@onready var the_ticker := $"../TheTicker"


func add_resource(resource_type: Resources.Types, amount: int) -> void:
	if sign(amount) < 0 and abs(amount) > storage[resource_type]:
		push_error(name, "Error: cannot consume " + str(amount) + " of " + str(resource_type))

		storage[resource_type] = 0
	else:
		if storage.has(resource_type):
			storage[resource_type] += amount
		else:
			storage[resource_type] = amount

	event_bus.resource_updated.emit(resource_type, storage[resource_type])

	if storage[resource_type] == 0:
		storage.erase(resource_type)


func get_resource_amount(resource_type: Resources.Types):
	if not storage.has(resource_type):
		return 0

	return storage[resource_type]


func try_to_sell_resource(resource_type: Resources.Types, amount: int) -> bool:
	if not storage.has(resource_type) or amount <= 0:
		return false

	if storage[resource_type] >= amount:
		storage[resource_type] -= amount

		event_bus.resource_updated.emit(resource_type, storage[resource_type])

		return true

	return false


func has_resources_to_construct_building(building_id: Buildings.Ids) -> bool:
	var building_cost: Array = Buildings.get_building_cost(building_id)

	if building_cost.is_empty():
		return true

	for cost in building_cost:
		if cost[1] > storage.get(cost[0], 0):
			return false

	return true


func conclude_building_construction(building_id: Buildings.Ids):
	var building_cost = Buildings.get_building_cost(building_id)

	if building_cost.is_empty():
		return

	for cost in building_cost:
		add_resource(cost[0], -cost[1])


func recover_building_construction(building_id: Buildings.Ids):
	var building_cost = Buildings.get_building_cost(building_id)

	if building_cost.is_empty():
		return

	for cost in building_cost:
		add_resource(cost[0], cost[1])
		
	
func has_enough_resources(amount: int, resource_type: Resources.Types) -> bool:
	return amount > storage.get(resource_type, 0)

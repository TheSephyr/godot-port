extends BuildingModel
class_name ProductionBuildingModel

var input_resource_amount : int = 0
var output_resource_amount : int = 0

func singleTick(storage: TheStorage):
	current_ticks = current_ticks + 1
	if current_worker > 0:
		sendProducedItems(storage)
		produce()
		collect(storage)
	
	
func collect(storage: TheStorage):
	var amount: int = 1
	if storage.has_enough_resources(amount, getNeedItemType()):
		storage.add_resource(getNeedItemType(), -amount)
		input_resource_amount = input_resource_amount + amount
	
	
func produce():
	if input_resource_amount > 0:
		input_resource_amount = input_resource_amount - 1
		output_resource_amount = output_resource_amount + 1
		
		
func sendProducedItems(storage: TheStorage):
		var output: int = output_resource_amount
		output_resource_amount = 0
		storage.add_resource(getProducedItemType(), output)
	
	
func getProducedItemType() -> Resources.Types:
	return Buildings.get_produce_resource(building_id)

func getNeedItemType() -> Resources.Types:
	return Buildings.get_produce_resource(building_id)

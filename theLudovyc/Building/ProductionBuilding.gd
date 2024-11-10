@tool
extends Building2D
class_name ProductionBuilding

var input_resource_amount : int = 0
var output_resource_amount : int = 0


func singleTick():
	current_ticks = current_ticks + 1
	produce()
	collect()
	
func collect():
	if (current_worker > 0):
		input_resource_amount = input_resource_amount + 1
	
	
func produce():
	if (current_worker > 0):
		if input_resource_amount > 0:
			input_resource_amount = input_resource_amount - 1
			output_resource_amount = output_resource_amount + 1
		
		
func sendProducedItems() -> int:
	if (current_worker > 0):
		var output: int = output_resource_amount
		output_resource_amount = 0
		return output 
	else:
		return 0
	
	
func getProducedItemType() -> Resources.Types:
	return Buildings.get_produce_resource(building_id)

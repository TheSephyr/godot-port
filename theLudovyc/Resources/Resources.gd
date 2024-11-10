extends Object
class_name Resources

enum Types { Wood, Textile, Board }
enum LevelTypes { Gathered, TransformedOnce, TransformedTwice }
enum StorageType { Building_Input, Building_Output }
enum Data {StorageType, LevelType, Icon}

const AllResources: Dictionary = {
	Types.Wood:    {
		Data.StorageType: StorageType.Building_Input,
		Data.LevelType: LevelTypes.Gathered,
		Data.Icon: preload("res://Art/Image/Gui/Icons/Resources/32/008.png")
	},
	Types.Textile: {
		Data.StorageType: StorageType.Building_Output,
		Data.LevelType:LevelTypes.TransformedTwice,
		Data.Icon: preload("res://Art/Image/Gui/Icons/Resources/32/003.png")
	},
	Types.Board: {
		Data.StorageType: StorageType.Building_Output,
		Data.LevelType:LevelTypes.TransformedOnce,
		Data.Icon: preload("res://Art/Image/Gui/Icons/Resources/32/004.png")
	},
}

static func has_rescource(resource_type: Types) -> bool:
	return AllResources.has(resource_type)

static func get_resource_icon(resource_type: Types) -> Texture2D:
	return AllResources.get(resource_type)[2]

	
static func get_rescources_level(resource_type: Types):
	
	return 0;

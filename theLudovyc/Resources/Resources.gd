extends Object
class_name Resources

enum Types { None, Wood, Textile, Board }
enum LevelTypes { Gathered, TransformedOnce, TransformedTwice }
enum Data {StorageType, LevelType, Icon}

const defaultIcon: Texture2D = preload("res://Art/Image/Gui/Icons/Resources/32/001.png")

const AllResources: Dictionary = {
	Types.Wood:    {
		Data.LevelType: LevelTypes.Gathered,
		Data.Icon: preload("res://Art/Image/Gui/Icons/Resources/32/008.png")
	},
	Types.Textile: {
		Data.LevelType:LevelTypes.TransformedTwice,
		Data.Icon: preload("res://Art/Image/Gui/Icons/Resources/32/003.png")
	},
	Types.Board: {
		Data.LevelType:LevelTypes.TransformedOnce,
		Data.Icon: preload("res://Art/Image/Gui/Icons/Resources/32/004.png")
	},
}

static func has_rescource(resource_type: Types) -> bool:
	return AllResources.has(resource_type)

static func get_resource_icon(resource_type: Types) -> Texture2D:
	if not has_rescource(resource_type):
		return defaultIcon
	return AllResources[resource_type].get(Data.Icon, defaultIcon)
	

static func get_resource_level(resource_type: Types):
	return AllResources[resource_type].get(Data.LevelType, 0)

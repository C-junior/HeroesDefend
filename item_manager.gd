# item_manager
extends Node
class_name ItemManager

var items = ItemDB
#var items: Dictionary = {
#}

func _ready() -> void:
	print("ready item manager ", items.items[1].name)

# Equip an item to the specified character in the correct slot
# item_manager.gd

func equip_item_to_character(character: BaseCharacter, item: Item):
	print("Manager equip outer", item)
	if item and character.can_equip(item):
		character.equip_item(item)
		print("Manager equipped", item.name)
	else:
		print("Item cannot be equipped by the character or is invalid!")


# Unequip item from a specific slot
func unequip_item_from_character(character: BaseCharacter, slot: String):
	character.unequip_item(slot)

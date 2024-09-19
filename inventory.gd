# inventory.gd

extends GridContainer
class_name Inventory

@onready var slots = get_children()

# Ensure that the correct item type is added to the correct slot.
func add_item(item: Item):
	for slot in slots:
		if slot.item == null and slot._item_fits_slot(item):
			slot.item = item
			print("Added item: ", item.name)
			return

func remove_item(item: Item):
	for slot in slots:
		if slot.item == item:
			slot.item = null
			return


#func equip_item_to_character(character: BaseCharacter, item: Item):	
	#if character and item:
		#character.equip_item(item)
		#

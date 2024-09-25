# inventory.gd
extends GridContainer
class_name Inventory

@onready var slots = get_children()

@onready var constant = constants

# Ensure that the correct item type is added to the correct slot.
func add_item(item: Item):
	var allowed_type_names = []
	
	for slot in slots:
		if slot.item == null:
			slot.item = item
			for allowed_type in item.allowed_types:
				allowed_type_names.append(constant.character_type_names[allowed_type])
				
				print("Added item: ", item.name)
				
				# Create a string manually
				var joined_names = ""
				for name in allowed_type_names:
					if joined_names != "":
						joined_names += ", "
					joined_names += name
				
				print("Allowed types: ", joined_names)
				
				slot.tooltip_text = "%s \n %s" % [item.name, joined_names]
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

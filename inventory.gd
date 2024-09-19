# inventory.gd
extends GridContainer
class_name Inventory

@onready var slots = get_children()
@onready var item_manager = itemmanager

func _ready() -> void:
	if item_manager == null:
		print("ItemManager node not found!")

func add_item(item: Item):
	for slot in slots:
		if slot.item == null:
			slot.item = item
			print("Added item to inventory: ", item.type, item.name)
			return

func remove_item(item: Item):
	for slot in slots:
		if slot.item == item:
			slot.item = null
			return

func equip_item_to_character(character: BaseCharacter, item: Item):
	print( "equip_item_to_character ", character, item.type)
	if character and item:
		character.equip_item(item)

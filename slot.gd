# slot.gd
extends PanelContainer
class_name Slot

# Enum for item types (weapons, armor, accessory, all)
enum SlotType { WEAPON, ARMOR, ACCESSORY, ALL }
enum SlotWeareble { WARRIOR, HEALER , ARCHER, ALL }

# Set the type of the slot (exported to set from the editor)
@export var slot_type: SlotType = SlotType.ALL
@export var slot_wear : SlotWeareble = SlotWeareble.ALL

@onready var manager = get_parent().get_parent()
@onready var texture_rect: TextureRect = $TextureRect
@onready var item_manager = itemmanager

var active_character: BaseCharacter = null

@export var item : Item = null:
	set(value):
		item = value
		if value != null:
			texture_rect.texture = value.icon
		else:
			texture_rect.texture = null

# Initialize the slot
func _ready():
	# Listen for character switching from the UI
	get_node("/root/MainGame/UI").connect("character_switched", Callable(self, "_on_character_switched"))


# Handle when the character is switched
func _on_character_switched(character: BaseCharacter):
	active_character = character
	update_slot()

func update_slot():
	if active_character != null:
		match slot_type:
			SlotType.WEAPON:
				item = active_character.equipped_items["weapon"]
				print("chegou on chracter swith w ", active_character, item)
			SlotType.ARMOR:
				item = active_character.equipped_items["armor"]
				print("chegou on chracter swith a ", active_character, item)
			SlotType.ACCESSORY:
				item = active_character.equipped_items["accessory"]
		if item != null:
			texture_rect.texture = item.icon
		else:
			texture_rect.texture = null


func get_preview():
	var preview_texture = TextureRect.new()
	preview_texture.texture = texture_rect.texture
	preview_texture.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	preview_texture.custom_minimum_size = Vector2(100, 100)

	var preview = Control.new()
	preview.add_child(preview_texture)
	preview_texture.position = -0.5 * Vector2(100, 100)
	return preview

func _can_drop_data(_pos, data):
	var source = data.get_parent().name
	var destination = get_parent().name

	if data is Slot:
		if destination == "Shop" and source == "Inventory" and not item:
			return true
		elif destination == "Inventory" and source == "Shop" and manager.currency >= data.item.price and _item_fits_slot(data.item) and not item:
			return true
		elif destination == source:
			return true
	return false

func _get_drag_data(at_position):
	set_drag_preview(get_preview())
	return self

func _drop_data(_at_position, data):
	var source = data.get_parent().name
	var destination = get_parent().name

	if destination == "Shop" and source == "Inventory":
		selling(data)
	elif destination == "Inventory" and source == "Shop":
		if _item_fits_slot(data.item):
			buying(data)
		else:
			print("Item doesn't fit in this slot")

	var temp = item
	item = data.item
	data.item = temp

# Check if the item type fits in the current slot type
func _item_fits_slot(item: Item) -> bool:
	match slot_type:
		SlotType.WEAPON:
			return item.type == "weapon"
		SlotType.ARMOR:
			return item.type == "armor"
		SlotType.ACCESSORY:
			return item.type == "accessory"
		SlotType.ALL:
			return true  # Allow any item in an ALL slot
		_:
			return false
func _item_wear_slot(item: Item) -> bool:
	match slot_wear:
		SlotWeareble.WARRIOR:
			return item.weareble == "warrior"
		SlotWeareble.HEALER:
			return item.weareble == "healer"
		SlotWeareble.ARCHER:
			return item.weareble == "archer"
		SlotWeareble.ALL:
			return true  # Allow any item in an ALL slot
		_:
			return false

func selling(data):
	if active_character == null:
		print("No character selected for selling.")
		return

	print("Sold " + data.item.name, data.item.price)
	manager.currency += data.item.price
	
	# Unequip item by calling the unequip_item function
	item_manager.unequip_item_from_character(active_character, data.item)

func buying(data):
	if active_character == null:
		print("No character selected for buying.")
		return

	print("Bought " , data.item.type ,data.item.name, data.item.price)
	manager.currency -= data.item.price
	item_manager.equip_item_to_character(active_character, data.item)

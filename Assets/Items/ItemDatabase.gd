# item_database.gd
extends Node
class_name ItemDatabase

var items: Array[Item] = []

var  healer = Constants.CharacterType.HEALER
var  fighter = Constants.CharacterType.FIGHTER
var  Valkyrie = Constants.CharacterType.VALKYRIE
var  mage = Constants.CharacterType.MAGE


func _ready():
	create_items()

func create_items():
	# Create weapons
	var iron_sword = Item.new()
	iron_sword.name = "Iron Sword"
	iron_sword.allowed_types = [fighter]
	iron_sword.type = "weapon"
	iron_sword.icon = preload("res://Assets/Items/sword.png")
	iron_sword.attack_bonus = 101
	items.append(iron_sword)

	var mystic_staff = Item.new()
	mystic_staff.name = "Mystic Staff"
	mystic_staff.type = "weapon"
	mystic_staff.icon = preload("res://Assets/Items/staff.png")
	mystic_staff.attack_bonus = 5
	mystic_staff.allowed_types = [healer, mage]  # Healers and Mages can equip staves
	items.append(mystic_staff)
	# Create armor and accessories similarly

	var wooden_bow = Item.new()
	wooden_bow.name = "Wooden Bow"
	wooden_bow.type = "weapon"
	wooden_bow.allowed_types = [Valkyrie]
	wooden_bow.price = 100
	wooden_bow.icon = preload("res://Assets/Items/axe.png")
	wooden_bow.range_bonus = 5
	wooden_bow.attack_bonus = 10
	wooden_bow.defense_bonus = 0
	wooden_bow.speed_bonus = 0
	wooden_bow.health_bonus = 0
	items.append(wooden_bow)


	# Armor
	var gold_plate = Item.new()
	gold_plate.name = "Gold Plate"
	gold_plate.type = "armor"
	gold_plate.allowed_types = [fighter]
	gold_plate.price = 100
	gold_plate.icon = preload("res://Assets/Items/shield.png")
	gold_plate.range_bonus = 0
	gold_plate.attack_bonus = 0
	gold_plate.defense_bonus = 30
	gold_plate.speed_bonus = -10
	gold_plate.health_bonus = 80
	items.append(gold_plate)

	var full_armor = Item.new()
	full_armor.name = "Full Plate Armor"
	full_armor.type = "armor"
	full_armor.allowed_types = [healer, mage, fighter,Valkyrie]
	full_armor.price = 250
	full_armor.icon = preload("res://Assets/Items/plate-icon.png")
	full_armor.range_bonus = 0
	full_armor.attack_bonus = 0
	full_armor.defense_bonus = 50
	full_armor.speed_bonus = -15
	full_armor.health_bonus = 100
	items.append(full_armor)


	var amulet = Item.new()
	amulet.name = "ring of Strength"
	amulet.type = "accessory"
	
	amulet.price = 220
	amulet.icon = preload("res://Assets/Items/ring-icon.png")
	amulet.range_bonus = 0
	amulet.attack_bonus = 5
	amulet.defense_bonus = 0
	amulet.speed_bonus = 0
	amulet.allowed_types = [healer, mage, fighter,Valkyrie]
	amulet.health_bonus = 15
	items.append(amulet)


# Function to get all available items
func get_all_items() -> Array[Item]:
	
	return items

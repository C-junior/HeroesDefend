# ui.gd
extends CanvasLayer

@onready var inventory: Inventory = %Inventory   # Shared inventory to display the active character's items

@onready var knight_button = $knight_button
@onready var cleric_button = $cleric_button

@onready var knight = get_node("/root/MainGame/PlayerCharacters/Knight")
@onready var cleric = get_node("/root/MainGame/PlayerCharacters/Cleric")

# Signal to notify which character is selected
signal character_switched(character: BaseCharacter)

# Tracks the active character
var active_character: BaseCharacter = null

func _ready():
	# Connect buttons to character switch functions
	knight_button.connect("pressed", Callable(self, "_on_knight_button_pressed"))
	cleric_button.connect("pressed", Callable(self, "_on_cleric_button_pressed"))
	
	# Initialize with Cleric as the default active character
	switch_to_character(cleric)

enum MODE {
	INVENTORY,
	SHOP
}

func open_mode(mode, items):
	%Shop.load_items(items)
	$Manager.open_mode(mode)
	
# Called when the Knight button is pressed
func _on_knight_button_pressed():
	switch_to_character(knight)

# Called when the Cleric button is pressed
func _on_cleric_button_pressed():
	switch_to_character(cleric)

# Function to switch to the selected character and update the shared inventory
func switch_to_character(character: BaseCharacter):
	active_character = character

	# Emit signal to update inventory UI for the active character
	emit_signal("character_switched", active_character)

	# Update the shared inventory with the active character's items
	update_inventory_with_character_items(character)

	print("Switched to character:", active_character.name)


func update_inventory_with_character_items(character: BaseCharacter):
	# Clear the inventory first
	for slot in inventory.get_children():
		slot.item = null
	
	# Add items that can be equipped by the active character
	for slot_name in character.equipped_items.keys():
		var item = character.equipped_items[slot_name]
		if item != null and character.can_equip(item):
			if slot_name == "weapon":
				inventory.get_children()[0].item = item
			elif slot_name == "armor":
				inventory.get_children()[1].item = item
			elif slot_name == "accessory":
				inventory.get_children()[2].item = item
	print("var slot on ui index of char ", character," and inventory 1 ", inventory.get_children()[0].item, " and inventory armor ", inventory.get_children()[1].item )

# Function to update the shared inventory (%Inventory) with the active character's equipped items
#func update_inventory_with_character_items():
	## Clear the shared inventory first
	#for slot in inventory.get_children():
		#slot.item = null
	#
	## Update the inventory slots with the active character's equipped items
	#var equipped_items = active_character.equipped_items  # Get the dictionary of equipped items
	## Loop through the equipped items and set them in the slots
	#var slot_index = 0
	#for item_type in equipped_items.keys():
		#var item = equipped_items[item_type]
		#if item != null:
			#inventory.get_children()[slot_index].item = item
		#slot_index += 1

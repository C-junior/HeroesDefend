# ui.gd
extends CanvasLayer

@onready var inventory: Inventory = %Inventory   # Shared inventory to display the active character's items

@onready var knight_button: Button = %knight_button
@onready var cleric_button: Button = %cleric_button
@onready var valkyrie_button: Button = %valkyrie_button
@onready var inventory_switch: Panel = $Inventory_switch
@onready var ativechar: Button = $Inventory_switch/ativechar

# Skill Panel
@onready var knight_buttons = $SkillPanel/SkillPopupKnight  # HBox for Knight skills
@onready var cleric_buttons = $SkillPanel/SkillPopupCleric  # HBox for Cleric skills
@onready var valkyrie_buttons = $SkillPanel/SkillPopupValkyrie  # HBox for Valkyrie skills
@onready var confirm_button = $SkillPanel/ConfirmButton  # Confirm button
@onready var skill_panel = $SkillPanel  # The whole skill panel

@onready var knight = get_node("/root/MainGame/PlayerCharacters/Knight")
@onready var cleric = get_node("/root/MainGame/PlayerCharacters/Cleric")
@onready var valkyrie = get_node("/root/MainGame/PlayerCharacters/Valkyrie")

@onready var wave_manager = get_node("/root/MainGame")  # The wave manager

var skills_selected_knight = false
var skills_selected_cleric = false
var skills_selected_valkyrie = false

# Signal to notify which character is selected
signal character_switched(character: BaseCharacter)

# Tracks the active character
var active_character: BaseCharacter = null

func _ready():
	# Listen for the wave signal to trigger skill selection
	wave_manager.connect("wave_skill_popup", Callable(self, "_show_skill_selection"))

	# Connect skill buttons for Knight
	knight_buttons.get_child(0).connect("pressed", Callable(self, "_on_knight_skill_selected").bind("KnightSkill1"))
	knight_buttons.get_child(1).connect("pressed", Callable(self, "_on_knight_skill_selected").bind("KnightSkill2"))
	knight_buttons.get_child(2).connect("pressed", Callable(self, "_on_knight_skill_selected").bind("KnightSkill3"))

	# Connect skill buttons for Cleric
	cleric_buttons.get_child(0).connect("pressed", Callable(self, "_on_cleric_skill_selected").bind("ClericSkill1"))
	cleric_buttons.get_child(1).connect("pressed", Callable(self, "_on_cleric_skill_selected").bind("ClericSkill2"))
	cleric_buttons.get_child(2).connect("pressed", Callable(self, "_on_cleric_skill_selected").bind("ClericSkill3"))

	# Connect skill buttons for Valkyrie
	valkyrie_buttons.get_child(0).connect("pressed", Callable(self, "_on_valkyrie_skill_selected").bind("ValkyrieSkill1"))
	valkyrie_buttons.get_child(1).connect("pressed", Callable(self, "_on_valkyrie_skill_selected").bind("ValkyrieSkill2"))
	valkyrie_buttons.get_child(2).connect("pressed", Callable(self, "_on_valkyrie_skill_selected").bind("ValkyrieSkill3"))

	confirm_button.connect("pressed", Callable(self, "_on_confirm_skills"))

	# Hide the skill panel initially
	skill_panel.visible = false
	# Initialize with Cleric as the default active character
	switch_to_character(knight)
	set_buttons_transparency(true) 
	

enum MODE {
	INVENTORY,
	SHOP
}

func set_buttons_transparency(transparent: bool):
	var transparency = Color(1, 1, 1, 1)  # Full opacity
	if transparent:
		transparency.a = 0  # Make fully transparent

	knight_button.modulate = transparency
	valkyrie_button.modulate = transparency
	cleric_button.modulate = transparency
	inventory_switch.modulate = transparency

func open_mode(mode, items):
	%Shop.load_items(items)
	$Manager.open_mode(mode)
	
	
# Called when the Knight button is pressed
func _on_knight_button_pressed():
	switch_to_character(knight)
	ativechar.text = "Knight"
# Called when the Cleric button is pressed
func _on_cleric_button_pressed():
	switch_to_character(cleric)
	ativechar.text = "Cleric"
	
func _on_valkyrie_button_pressed() -> void:
	switch_to_character(valkyrie)
	ativechar.text = "Valkyrie"



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

# Show skill selection once per wave (every 5th wave)
func _show_skill_selection():
	print("show skill selec out ")
	if not skill_panel.visible:  # Ensure it only opens once per wave
		print("show skill selec in")
		get_tree().paused = true  # Pause the game
		skill_panel.visible = true  # Show the skill panel
		confirm_button.visible = false  # Hide confirm button until all skills are selected

		# Reset skill selection flags
		skills_selected_knight = false
		skills_selected_cleric = false
		skills_selected_valkyrie = false

		# Enable all skill buttons initially
		_enable_skill_buttons(knight_buttons)
		_enable_skill_buttons(cleric_buttons)
		_enable_skill_buttons(valkyrie_buttons)

		# Set up skills with icons and descriptions
		_setup_skill_buttons(knight_buttons, ["Sword Mastery", "Shield Block", "Charge"], ["icon1.png", "icon2.png", "icon3.png"])
		_setup_skill_buttons(cleric_buttons, ["Healing Light", "Divine Protection", "Holy Smite"], ["icon4.png", "icon5.png", "icon6.png"])
		_setup_skill_buttons(valkyrie_buttons, ["Spear Thrust", "Winged Strike", "Valor Aura"], ["icon7.png", "icon8.png", "icon9.png"])

# Setup skill buttons with icons and descriptions
func _setup_skill_buttons(buttons_container: HBoxContainer, skill_texts: Array, icons: Array):
	for i in range(buttons_container.get_child_count()):
		var button = buttons_container.get_child(i)
		button.text = skill_texts[i]
		button.icon = load("res://Assets/Icons/" + icons[i])

# Enable skill buttons
func _enable_skill_buttons(buttons_container: HBoxContainer):
	for button in buttons_container.get_children():
		button.disabled = false

# Disable skill buttons after selection
func _disable_skill_buttons(buttons_container: HBoxContainer):
	for button in buttons_container.get_children():
		button.disabled = true

# Knight skill selected
func _on_knight_skill_selected(skill_name: String):
	knight.learn_skill(skill_name)
	skills_selected_knight = true
	_disable_skill_buttons(knight_buttons)
	_check_all_skills_selected()

# Cleric skill selected
func _on_cleric_skill_selected(skill_name: String):
	cleric.learn_skill(skill_name)
	skills_selected_cleric = true
	_disable_skill_buttons(cleric_buttons)
	_check_all_skills_selected()

# Valkyrie skill selected
func _on_valkyrie_skill_selected(skill_name: String):
	valkyrie.learn_skill(skill_name)
	skills_selected_valkyrie = true
	_disable_skill_buttons(valkyrie_buttons)
	_check_all_skills_selected()

# Check if all characters have selected their skills
func _check_all_skills_selected():
	if skills_selected_knight and skills_selected_cleric and skills_selected_valkyrie:
		confirm_button.visible = true  # Show the confirm button

# Confirm skill selections and resume the game
func _on_confirm_skills():
	get_tree().paused = false  # Unpause the game
	skill_panel.visible = false  # Hide the skill panel
	print("Skills confirmed. Resuming game.")

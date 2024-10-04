# valkyrie.gd
extends BaseCharacter

# Valkyrie-specific stats
@export var valkyrie_attack_damage: int = 70
@export var valkyrie_defense: int = 12
@export var valkyrie_move_speed: int = 85
@export var valkyrie_max_health: int = 350
@export var valkyrie_attack_cooldown: float = 1.2

@export var current_item: Item:
	set(value):
		current_item = value
		print("current item valk? ", current_item)
		if current_item != null:
			valkyrie_attack_damage += current_item.attack_bonus 

# Initialize the Valkyrie
func _ready():
	base_max_health = valkyrie_max_health
	base_attack_damage = valkyrie_attack_damage
	base_defense = valkyrie_defense
	base_move_speed = valkyrie_move_speed
	current_health = max_health
	current_item = null  # Start without any item equipped
	character_type = constants.CharacterType.FIGHTER
	health_progress_bar.max_value = max_health  # Set max value for the progress bar
	health_progress_bar.value = current_health  # Initialize progress bar value

	attack_timer.wait_time = valkyrie_attack_cooldown  # Attack timer setup
	attack_timer.start()  # Start the timer
	update_stats()
	
	add_to_group("PlayerCharacters")
	update_level_ui()

# Valkyrie-specific weapon restrictions
func can_equip(item: Item) -> bool:
	# Valkyries can equip spears and swords
	if item.name == "Spear" or item.name == "Iron Sword":
		return true
	return false

# Custom Valkyrie skill learning
func learn_skill(skill_name: String):
	print("Valkyrie learned skill:", skill_name)
	# You can add unique skill effects here based on the skill learned

func _process(delta: float):
	# Find nearest enemy to attack
	target = find_nearest_target("Enemies")
	if target:
		move_and_attack(target, delta)

# enemy.gd
extends BaseCharacter

@export var enemy_name: String = "Goblin"
@export var enemy_attack_damage: int = 18
@export var enemy_move_speed: int = 40

func _ready():
	attack_damage = enemy_attack_damage
	move_speed = enemy_move_speed
	current_health = max_health
	health_progress_bar.max_value = max_health  # Set max value for the progress bar
	health_progress_bar.value = current_health  # Initialize progress bar value

	add_to_group("Enemies")

func _process(delta: float):
	# Find nearest player character to attack
	target = find_nearest_target("PlayerCharacters")
	
	if target:
		move_and_attack(target, delta)
		
@export var xp_reward: int = 100
@export var gold_reward: int = 20

# Override the die function to reward XP and gold
func die():
	# Grant XP and gold to all player characters
	var party_manager = get_tree().root.get_node("MainGame/PlayerCharacters")
	print("die func ", party_manager.name)
	for player in party_manager.get_children():
		if player.has_method("add_xp_to_party"):
			player.add_xp_to_party(xp_reward)
			player.add_gold(gold_reward)
			

	queue_free()

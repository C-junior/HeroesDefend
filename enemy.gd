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

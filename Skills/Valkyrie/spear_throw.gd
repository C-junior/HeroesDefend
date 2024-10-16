extends Skill

@export var damage_percentage: float = 4.0  # 100% attack damage
@export var skill_range: int = 500  # Range to throw the spear
var cooldown_timer: Timer = null

# Initialize the cooldown timer
func init(character: BaseCharacter) -> void:
	cooldown_timer = Timer.new()
	cooldown_timer.one_shot = true
	cooldown_timer.wait_time = cooldown
	character.add_child(cooldown_timer)
	cooldown_timer.connect("timeout", Callable(self, "_on_cooldown_ready"))

func apply_effect(character: BaseCharacter) -> void:
	if not cooldown_timer.is_stopped():
		return  # Skill is in cooldown

	_trigger_spear_throw(character)
	cooldown_timer.start()

# Find the farthest enemy and deal damage
func _trigger_spear_throw(character: BaseCharacter) -> void:
	var enemies = character.get_tree().get_nodes_in_group("Enemies")
	var farthest_enemy: Node2D = null
	var max_distance: float = 0.0

	# Find the farthest enemy
	for enemy in enemies:
		var distance = character.global_position.distance_to(enemy.global_position)
		if distance > max_distance and distance <= skill_range:
			max_distance = distance
			farthest_enemy = enemy

	# Deal damage to the farthest enemy
	if farthest_enemy and farthest_enemy.has_method("take_damage"):
		farthest_enemy.take_damage(character.attack_damage * damage_percentage)
		print("Spear Throw hit:", farthest_enemy.name)

func _on_cooldown_ready():
	print("Spear Throw is ready again!")

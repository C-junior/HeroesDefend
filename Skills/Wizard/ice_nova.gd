# ice_nova.gd
extends Skill

@export var ice_nova_damage: int = 50  # Ice nova damage
@export var ice_nova_slow_duration: float = 3.0  # Slow effect duration
@export var ice_nova_radius: float = 250.0  # AoE radius

var cooldown_timer: Timer = null

func init(character: BaseCharacter) -> void:
	cooldown_timer = Timer.new()
	cooldown_timer.one_shot = true
	cooldown_timer.wait_time = cooldown
	character.add_child(cooldown_timer)
	cooldown_timer.connect("timeout", Callable(self, "_on_cooldown_ready"))

func apply_effect(character: BaseCharacter) -> void:
	if not cooldown_timer.is_stopped():
		return  # Skill is in cooldown
	_trigger_ice_nova(character)
	cooldown_timer.start()

# Trigger Ice Nova AoE attack
func _trigger_ice_nova(character: BaseCharacter) -> void:
	var enemies = character.get_tree().get_nodes_in_group("Enemies")
	for enemy in enemies:
		if character.global_position.distance_to(enemy.global_position) <= ice_nova_radius:
			enemy.take_damage(ice_nova_damage)
			enemy.slow(ice_nova_slow_duration)  # Apply slow effect
			print("Ice Nova hit enemy:", enemy.name)

func _on_cooldown_ready():
	print("Ice Nova is ready again!")

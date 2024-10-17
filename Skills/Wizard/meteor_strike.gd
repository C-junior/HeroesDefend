# meteor_strike.gd
extends Skill

@export var damage: int = 150  # Massive AoE damage
@export var impact_radius: float = 300.0  # Radius of the meteor impact

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
	_trigger_meteor_strike(character)
	cooldown_timer.start()

# Trigger Meteor Strike AoE damage
func _trigger_meteor_strike(character: BaseCharacter) -> void:
	var enemies = character.get_tree().get_nodes_in_group("Enemies")
	for enemy in enemies:
		var distance = character.global_position.distance_to(enemy.global_position)
		if distance <= impact_radius:
			enemy.take_damage(damage)
			print("Meteor Strike hit enemy:", enemy.name)

func _on_cooldown_ready():
	print("Meteor Strike is ready again!")

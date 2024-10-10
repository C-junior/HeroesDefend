# might_aura.gd
extends Skill

@export var debuff_amount: int = 10  # Reduce attack and defense by 10%

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

	_trigger_might_aura(character)
	cooldown_timer.start()

func _trigger_might_aura(character: BaseCharacter) -> void:
	var enemies = character.get_tree().get_nodes_in_group("Enemies")
	for enemy in enemies:
		enemy.attack_damage -= (enemy.attack_damage * debuff_amount / 100)
		enemy.defense -= (enemy.defense * debuff_amount / 100)
		print("Might Aura applied to", enemy.name)

func _on_cooldown_ready():
	print("Might Aura is ready again!")

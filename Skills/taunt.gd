# taunt.gd
extends Skill

@export var taunt_duration: float = 5.0  # Force enemies to attack the knight for 5 seconds

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

	_trigger_taunt(character)
	cooldown_timer.start()

func _trigger_taunt(character: BaseCharacter) -> void:
	var enemies = character.get_tree().get_nodes_in_group("Enemies")
	for enemy in enemies:
		if enemy.has_method("force_attack"):
			#enemy.force_attack(character, taunt_duration)
			print("Taunted enemy:", enemy.name)

func _on_cooldown_ready():
	print("Taunt is ready again!")

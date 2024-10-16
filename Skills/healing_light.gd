# healing_light.gd
extends Skill

@export var heal_percentage: float = 0.2  # 20% of max health

var cooldown_timer: Timer = null

func init(character: BaseCharacter) -> void:
	print("init healing light")
	cooldown_timer = Timer.new()
	cooldown_timer.one_shot = true
	cooldown_timer.wait_time = cooldown
	character.add_child(cooldown_timer)
	cooldown_timer.connect("timeout", Callable(self, "_on_cooldown_ready"))

func apply_effect(character: BaseCharacter) -> void:
	if not cooldown_timer.is_stopped():
		return  # Skill is in cooldown

	_trigger_healing_light(character)
	cooldown_timer.start()

func _trigger_healing_light(character: BaseCharacter) -> void:
	var ally = character.find_injured_ally()
	if ally:
		var heal_amount = ally.get_max_health() * heal_percentage
		ally.receive_heal(heal_amount)
		print("Healing Light healed ", ally.name, " for ", heal_amount)

func _on_cooldown_ready():
	print("Healing Light is ready again!")

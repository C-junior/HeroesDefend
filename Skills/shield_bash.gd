# shield_bash.gd
extends Skill

@export var stun_duration: float = 2.0  # Stun for 2 seconds
@export var damage_percentage: float = 1.0  # 100% attack damage

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

	_trigger_shield_bash(character)
	cooldown_timer.start()

func _trigger_shield_bash(character: BaseCharacter) -> void:
	var target = character.find_nearest_target("Enemies")
	if target and target.has_method("take_damage"):
		target.take_damage(character.attack_damage * damage_percentage)
		#target.stun(stun_duration)  # Assumes the enemy has a stun method
		print("Shield Bash hit and stunned:", target.name)

func _on_cooldown_ready():
	print("Shield Bash is ready again!")

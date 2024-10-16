# radiant_aura.gd
extends Skill

@export var regen_amount: int = 5  # Small regen amount per second
@export var regen_duration: float = 5.0  # Regenerates over 5 seconds

var cooldown_timer: Timer = null
var regen_timer: Timer = null  # New timer to handle regen over time
var heal_ticks: int = 0  # Track how many times healing has occurred

# Initialize cooldown and regen timers
func init(character: BaseCharacter) -> void:
	# Cooldown timer for the skill
	cooldown_timer = Timer.new()
	cooldown_timer.one_shot = true
	cooldown_timer.wait_time = cooldown
	character.add_child(cooldown_timer)
	cooldown_timer.connect("timeout", Callable(self, "_on_cooldown_ready"))

	# Regen timer to apply healing every second
	regen_timer = Timer.new()
	regen_timer.wait_time = 1.0  # Trigger every 1 second
	regen_timer.one_shot = false  # Continuous healing for the duration
	character.add_child(regen_timer)
	regen_timer.connect("timeout", Callable(self, "_apply_heal_tick").bind(character))

func apply_effect(character: BaseCharacter) -> void:
	if not cooldown_timer.is_stopped():
		return  # Skill is in cooldown

	_trigger_radiant_aura(character)
	cooldown_timer.start()

func _trigger_radiant_aura(character: BaseCharacter) -> void:
	print("Radiant Aura activated!")
	
	# Start healing over time
	heal_ticks = 0  # Reset the tick count
	regen_timer.start()  # Start the regen timer to trigger every second

# Called every second to heal allies
func _apply_heal_tick(character: BaseCharacter) -> void:
	heal_ticks += 1
	
	# Heal all allies
	var allies = character.get_tree().get_nodes_in_group("PlayerCharacters")
	for ally in allies:
		ally.receive_heal(regen_amount)
		print("Radiant Aura healed", ally.name, "for", regen_amount, "HP on tick", heal_ticks)

	# Stop healing after reaching the duration
	if heal_ticks >= regen_duration:
		regen_timer.stop()
		print("Radiant Aura healing complete.")

func _on_cooldown_ready():
	print("Radiant Aura is ready again!")

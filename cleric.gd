# cleric.gd
extends BaseCharacter

@export var heal_amount: int = 40
@export var heal_cooldown: float = 2.0

@onready var heal_timer = Timer.new()

func _ready():
	max_health = 1600
	current_health = max_health
	heal_timer.wait_time = heal_cooldown
	heal_timer.one_shot = true
	add_child(heal_timer)
	heal_timer.connect("timeout", Callable(self, "_on_heal_timeout"))
	health_progress_bar.max_value = max_health
	health_progress_bar.value = current_health
	add_to_group("PlayerCharacters")

func _process(delta: float):
	# Find nearest injured ally to heal
	var injured_ally = find_injured_ally()
	if injured_ally:
		move_and_heal(injured_ally, delta)
		
		
func find_injured_ally() -> Node2D:
	var allies = get_tree().get_nodes_in_group("PlayerCharacters")
	var injured_ally: Node2D = null
	var lowest_health: int = max_health

	for ally in allies:
		if ally.get_health() < ally.get_max_health() and ally.get_health() < lowest_health:
			injured_ally = ally
			lowest_health = ally.get_health()

	return injured_ally

func move_and_heal(target: Node2D, delta: float):
	var direction = (target.global_position - global_position).normalized()
	if global_position.distance_to(target.global_position) > attack_range:
		velocity = direction * move_speed
		move_and_slide()
		
	else:
		velocity = Vector2.ZERO
		if heal_timer.is_stopped():
			heal(target)
			

func heal(target: Node2D):
	if target.has_method("receive_heal"):
		target.receive_heal(heal_amount)
		#heal_label.text = "Healed by " + str(heal_amount)
		heal_timer.start()  # Start heal cooldown

# Called when heal timer is done
func _on_heal_timeout():
	pass

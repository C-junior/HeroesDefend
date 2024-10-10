extends BaseCharacter

@export var enemy_name: String = "Goblin"
@export var enemy_attack_damage: int = 18
@export var enemy_move_speed: int = 40
@export var goblin_max_health: int = 1000
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

var knockback_velocity: Vector2 = Vector2.ZERO  # Store the knockback force
var knockback_reduction_rate: float = 200  # Knockback reduction rate
var is_slowed: bool = false
var original_speed: int

func _ready():
	attack_damage = enemy_attack_damage
	move_speed = enemy_move_speed
	original_speed = enemy_move_speed
	current_health = goblin_max_health
	health_progress_bar.max_value = goblin_max_health  # Set max value for the progress bar
	health_progress_bar.value = current_health  # Initialize progress bar value

	add_to_group("Enemies")

func _process(delta: float):
	# Find nearest player character to attack
	target = find_nearest_target("PlayerCharacters")
	
	if target:
		move_and_attack(target, delta)
		
	# Apply knockback if there is any force left
	if knockback_velocity.length() > 0:
		# Set the velocity and call move_and_slide
		velocity = knockback_velocity
		move_and_slide()  # Call move_and_slide without arguments
		
		# Gradually reduce the knockback velocity over time (friction)
		knockback_velocity = knockback_velocity.move_toward(Vector2.ZERO, knockback_reduction_rate * delta)

# Apply knockback force to the enemy
func knockback(force: Vector2) -> void:
	knockback_velocity = force  # Apply the force as velocity
	print("Enemy knocked back with force:", force ," and ", move_speed)

# Method to slow the enemy
func slow(duration: float):
	if not is_slowed:
		is_slowed = true
		move_speed /= 2  # Halve the movement speed
		print("Enemy knocked moovee:", move_speed)
		self.sprite.modulate = Color(0, 0, 1)
		# Create and start a timer
		var timer = Timer.new()
		timer.wait_time = duration
		timer.one_shot = true
		add_child(timer)  # Add Timer as a child to the enemy
		timer.start()
		
		# Wait for the timer to finish
		await timer.timeout
		
		restore_speed()  # Restore speed after duration
		timer.queue_free()  # Free the timer after use

# Restore the original speed
func restore_speed():
	move_speed = original_speed
	print("Enemy knocked moovee rest :", move_speed)
	self.sprite.modulate = Color(1, 1, 1)
	is_slowed = false

@export var xp_reward: int = 100
@export var gold_reward: int = 20

# Override the die function to reward XP and gold
func die():
	# Grant XP and gold to all player characters
	var party_manager = get_tree().root.get_node("MainGame/PlayerCharacters")
	
	for player in party_manager.get_children():
		if player.has_method("add_xp_to_party"):
			player.add_xp_to_party(xp_reward)
			player.add_gold(gold_reward)

	queue_free()

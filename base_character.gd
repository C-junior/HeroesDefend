# base_character.gd
extends CharacterBody2D
class_name BaseCharacter

var item = ItemDB

@onready var health_label = $HP
@onready var health_progress_bar = $HealthProgressBAr
@onready var popuploc = $PopupLocation

@export var move_speed: int = 80
@export var attack_range: float = 30.0
@export var attack_damage: int = 10
@export var attack_cooldown: float = 1.5
@export var max_health: int = 100
@export var defense: int = 5

# Base stats
@export var base_move_speed: int = 80
@export var base_attack_range: float = 30.0
@export var base_attack_damage: int = 10
@export var base_attack_cooldown: float = 1.5
@export var base_max_health: int = 100
@export var base_defense: int = 5

# Equipment slots
var equipped_items: Dictionary = {
	"weapon": null,
	"armor": null,
	"accessory": null
}

var current_health: int
@export var attack_timer: Timer = Timer.new()
var target: Node2D  # The character's current target

func _ready():
	current_health = max_health
	health_progress_bar.max_value = max_health
	health_progress_bar.value = current_health
	attack_timer = Timer.new()
	attack_timer.wait_time = attack_cooldown
	attack_timer.one_shot = true
	add_child(attack_timer)
	attack_timer.connect("timeout", Callable(self, "_on_attack_timeout"))
	add_to_group("PlayerCharacters")
	update_stats()

func equip_item(item: Item):
	if item.type in equipped_items.keys():
		equipped_items[item.type] = item
	else:
		print("Item type ", item.type, " is not valid for this character.")
	update_stats()

func unequip_item(item: Item):
	if item in equipped_items.keys():
		equipped_items[item] = null
	else:
		print("Invalid item: ", item)
	update_stats()

func update_stats():
	# Reset stats to base
	attack_damage = base_attack_damage
	defense = base_defense
	move_speed = base_move_speed
	max_health = base_max_health

	# Apply equipment bonuses
	for slot in equipped_items.keys():
		var item = equipped_items[slot]
		if item:
			attack_damage += item.attack_bonus
			defense += item.defense_bonus
			move_speed += item.speed_bonus
			print("Apply equipment bonuses  update tstst", item.name)
			if slot == "armor":
				max_health += item.health_bonus
		

	current_health = min(current_health, max_health)
	update_health_label()

# Attack logic
func attack(target: Node2D):
	if target.has_method("take_damage"):
		target.take_damage(attack_damage)
		attack_timer.start()

# Damage logic
func take_damage(damage: int):
	var reduced_damage = max(damage - defense, 0)
	current_health -= reduced_damage
	popuploc.popup(-reduced_damage)  # Display damage popup
	update_health_label()
	health_progress_bar.value = current_health
	if current_health <= 0:
		die()

func update_health_label():
	health_label.text = str(current_health)

func move_and_attack(target: Node2D, delta: float):
	var direction = (target.global_position - global_position).normalized()
	if global_position.distance_to(target.global_position) > attack_range:
		velocity = direction * move_speed
		move_and_slide()
	else:
		velocity = Vector2.ZERO
		if attack_timer.is_stopped():
			attack(target)

func die():
	queue_free()

func _on_attack_timeout():
	pass

func can_equip(item: Item) -> bool:
	# Add specific checks if certain characters can't equip certain items
	return item.type in equipped_items.keys()
	
	# Find nearest target (either enemy for attack, or ally for healing)
func find_nearest_target(group_name: String) -> Node2D:
	var nearest_node: Node2D = null
	var shortest_distance = INF

	for node in get_tree().get_nodes_in_group(group_name):
		var distance = global_position.distance_to(node.global_position)
		if distance < shortest_distance:
			shortest_distance = distance
			nearest_node = node

	return nearest_node

func get_health() -> int:
	return current_health

func get_max_health() -> int:
	return max_health

func receive_heal(heal: int):
	current_health += heal
	popuploc.popup(heal)  # Display healing popup
	current_health = clamp(current_health, 0, max_health)
	update_health_label()
	health_progress_bar.value = current_health

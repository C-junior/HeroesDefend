# main_game.gd
extends Node2D

@onready var wave_manager = $WaveManager  # Timer managing wave timing
@onready var player_characters = $PlayerCharacters  # Player's character group
@onready var enemies = $Enemies  # Enemy group
@onready var wave_label = $WaveLabel  # Label to display current wave
@onready var vendor = $Vendor  # Vendor instance for shop
@onready var shop_ui = $Shop  # Shop UI

@onready var knight_def: Label = $"knight def"
@onready var knight_atk: Label = $"knight atk"
@onready var knight: CharacterBody2D = $PlayerCharacters/Knight




var current_wave = 1  # Tracks the current wave number
var max_waves = 10  # You can set the number of waves
var wave_in_progress = false

func _ready():
	# Start the first wave
	start_wave()
	knight_atk.text = str(knight.knight_attack_damage)
	knight_def.text = str(knight.knight_defense)
	

	# Connect wave manager timer to handle new waves
	wave_manager.connect("timeout", Callable(self, "start_wave"))

func start_wave():
	if wave_in_progress:
		return  # Prevent starting a new wave before finishing the previous one
	
	print("Starting wave ", current_wave)
	wave_label.text = "Wave " + str(current_wave)
	wave_in_progress = true
	spawn_enemies(current_wave)

func spawn_enemies(wave: int):
	var enemy_scene = load("res://goblin.tscn")  # Load the enemy scene
	for i in range(wave):  # Increase enemies per wave
		var enemy = enemy_scene.instantiate()
		enemies.add_child(enemy)
		enemy.position = Vector2(randf_range(500, 700), randf_range(100, 300))

func check_wave_completion():
	if enemies.get_child_count() == 0 and wave_in_progress:
		wave_in_progress = false
		if current_wave >= max_waves:
			print("All waves completed!")
			# End game or loop if needed
			wave_manager.stop()
		else:
			print("Wave cleared!")
			# Open shop after the wave is cleared
			open_shop()
			
func open_shop():
	# Pause the game and open the shop after the wave
	get_tree().paused = true
	vendor.interact()  # Trigger vendor interaction to open the shop
	

func close_shop():
	# Close shop and resume game to start the next wave
	print("fechar loja in")
	vendor.interact()
	get_tree().paused = false
	current_wave += 1
	wave_manager.start(5.0)  # Wait 5 seconds before starting the next wave

func _process(delta: float):
	check_wave_completion()
	knight_atk.text = str(knight.attack_damage)
	knight_def.text = str(knight.knight_defense)

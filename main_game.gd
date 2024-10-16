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

@onready var ui = UI  # Reference to the UI script

var current_wave = 1  # Tracks the current wave number
var max_waves = 10  # Set the maximum number of waves
var wave_in_progress = false  # Flag to indicate if a wave is in progress
var skill_popup_triggered = false  # Flag to track if the skill panel has been shown

# Emitted signal when every 5th wave is completed
signal wave_skill_popup  # Declare the signal for the skill popup

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
	skill_popup_triggered = false  # Reset the skill popup flag	
	spawn_enemies(current_wave)
	if current_wave % 2 == 0 and not skill_popup_triggered:
			emit_signal("wave_skill_popup")  # Emit the signal for skill selection
			skill_popup_triggered = true  # Set flag to prevent multiple popups
			print("Triggered skill popup for wave ", current_wave)

func spawn_enemies(wave: int):
	var enemy_scene = load("res://goblin.tscn")  # Load the enemy scene
	for i in range(wave):  # Increase enemies per wave
		var enemy = enemy_scene.instantiate()
		enemies.add_child(enemy)
		enemy.position = Vector2(randf_range(500, 700), randf_range(100, 300))

func check_wave_completion():
	# Check if all enemies have been defeated and the wave is in progress
	if enemies.get_child_count() == 0 and wave_in_progress:
		wave_in_progress = false
		print("Wave ", current_wave, " cleared!")
		
		# Check if it's a wave that should trigger the skill selection (every 5 waves)
		
		
		# End game or move to the next wave/shop
		if current_wave >= max_waves:
			print("All waves completed!")
			wave_manager.stop()
		else:
			open_shop()

func open_shop():
	# Pause the game and open the shop after the wave
	get_tree().paused = true
	vendor.interact()  # Trigger vendor interaction to open the shop
	print("Opening shop after wave ", current_wave)

func close_shop():
	# Close shop and resume game to start the next wave
	print("Closing shop and resuming game")
	vendor.interact()
	get_tree().paused = false
	current_wave += 1
	wave_manager.start(2.0)  # Start the next wave after a short delay	

func _process(delta: float):
	# Check if the wave is completed in each frame
	check_wave_completion()
	# Update the UI with knight stats
	#knight_atk.text = str(knight.attack_damage)
	#knight_def.text = str(knight.knight_defense)

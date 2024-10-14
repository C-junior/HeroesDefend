# skill_database.gd
extends Node
class_name SkillDatabase

# Initialize skills for each character type and level
var skills = {}

func _ready():
	# Knight Skills
	skills[Constants.CharacterType.FIGHTER] = {
		2: [
			_create_shield_bash(),  # Active skill with its own script
			_create_might_aura(),  # Passive skill
			_create_charge()  # Active skill
		],
		4: [
			_create_vorpal_slash(),  # Passive skill
			_create_defense_mastery(),  # Active skill
			_create_weapon_mastery()# Active skill
		],
		6: [
			_create_crescendo(),  # Passive skill
			_create_taunt(),  # Active skill
			_create_big_shield() # Active skill
		]
	}
	# Skills for the Cleric
	skills[Constants.CharacterType.HEALER] = {
		3: [
			#_create_active_skill("Healing Light", "Heal allies by 20% max health.", "heal", 20, 0, "res://Assets/Icons/icon7.png"),
			#_create_active_skill("Divine Shield", "Boost defense by 50% for 5 sec (15 sec cooldown).", "cooldown_ability", 50, 5, "res://Assets/Icons/icon8.png"),
			#_create_active_skill("Holy Smite", "Deal 100% attack_damage to a single enemy.", "attack_damage", 100, 0, "res://Assets/Icons/icon9.png")
		],
		6: [
			#_create_active_skill("Blessing", "Increase defense by 15 for 10 sec.", "cooldown_ability", 15, 10, "res://Assets/Icons/icon10.png"),
			#_create_active_skill("Radiant Burst", "Deal AoE damage for 50% attack_damage to nearby enemies (10 sec cooldown).", "cooldown_ability", 50, 10, "res://Assets/Icons/icon11.png"),
			#_create_active_skill("Prayer of Healing", "Heal all allies by 20% max health (20 sec cooldown).", "cooldown_ability", 20, 20, "res://Assets/Icons/icon12.png")
		]
	}

	# Skills for the Valkyrie
	#skills[Constants.CharacterType.VALKYRIE] = {
		#3: [
			#_create_active_skill("Spear Thrust", "Deal 80% attack_damage to enemies in front.", "attack_damage", 80, 0, "res://Assets/Icons/icon13.png"),
			#_create_active_skill("Winged Strike", "Boost move speed by 20% for 5 sec.", "cooldown_ability", 20, 5, "res://Assets/Icons/icon14.png"),
			#_create_active_skill("Valor Aura", "Increase defense of all allies by 20% for 5 sec.", "cooldown_ability", 20, 5, "res://Assets/Icons/icon15.png")
		#],
		#6: [
			#_create_active_skill("Guardian's Shield", "Absorb damage equal to 20% of max health (15 sec cooldown).", "cooldown_ability", 20, 15, "res://Assets/Icons/icon16.png"),
			#_create_active_skill("Righteous Fury", "Increase attack speed by 25% for 8 seconds (12 sec cooldown).", "cooldown_ability", 25, 8, "res://Assets/Icons/icon17.png"),
			#_create_active_skill("Avenger's Wrath", "Deal 120% attack_damage to all nearby enemies (20 sec cooldown).", "cooldown_ability", 120, 20, "res://Assets/Icons/icon18.png")
		#]
	#}

# Create Vorpal Slash skill
# Example Skill Creation Functions

func _create_vorpal_slash() -> Skill:
	var vorpal_slash = load("res://Skills/vorpal_slash.gd").new()  # Load the script directly
	vorpal_slash.name = "Vorpal Slash"
	vorpal_slash.description = "Spin and deal 80% attack damage to nearby enemies."
	vorpal_slash.cooldown = 10
	vorpal_slash.icon = load("res://Assets/Icons/icon_vorpal_slash.png")
	return vorpal_slash

func _create_weapon_mastery() -> Skill:
	var weapon_mastery = load("res://Skills/weapon_mastery.gd").new()
	weapon_mastery.name = "Weapon Mastery"
	weapon_mastery.description = "Gain +10 attack damage."
	weapon_mastery.icon = load("res://Assets/Icons/icon_weapon_mastery.png")
	return weapon_mastery

func _create_shield_bash() -> Skill:
	var shield_bash = load("res://Skills/shield_bash.gd").new()
	shield_bash.name = "Shield Bash"
	shield_bash.description = "Stun enemies for 2 seconds."
	shield_bash.cooldown = 8
	shield_bash.icon = load("res://Assets/Icons/icon_shield_bash.png")
	return shield_bash

func _create_defense_mastery() -> Skill:
	var defense_mastery = load("res://Skills/defense_mastery.gd").new()
	defense_mastery.name = "Defense Mastery"
	defense_mastery.description = "Gain +5 defense."
	defense_mastery.icon = load("res://Assets/Icons/icon_defense_mastery.png")
	return defense_mastery

func _create_charge() -> Skill:
	var charge = load("res://Skills/charge.gd").new()
	charge.name = "Charge"
	charge.description = "Knockback all enemies in your path."
	charge.cooldown = 10
	charge.icon = load("res://Assets/Icons/icon_charge.png")
	return charge

func _create_big_shield() -> Skill:
	var big_shield = load("res://Skills/big_shield.gd").new()
	big_shield.name = "Big Shield"
	big_shield.description = "Block 3 attacks for 10 seconds."
	big_shield.cooldown = 10
	big_shield.icon = load("res://Assets/Icons/icon_big_shield.png")
	return big_shield

func _create_crescendo() -> Skill:
	var crescendo = load("res://Skills/crescendo.gd").new()
	crescendo.name = "Crescendo"
	crescendo.description = "Gain +50 max health."
	crescendo.icon = load("res://Assets/Icons/icon_crescendo.png")
	return crescendo

func _create_might_aura() -> Skill:
	var might_aura = load("res://Skills/might_aura.gd").new()
	might_aura.name = "Might Aura"
	might_aura.description = "Reduce attack and defense of all nearby enemies."
	might_aura.cooldown = 15
	might_aura.icon = load("res://Assets/Icons/icon_might_aura.png")
	return might_aura

func _create_taunt() -> Skill:
	var taunt = load("res://Skills/taunt.gd").new()
	taunt.name = "Taunt"
	taunt.description = "Force all enemies to attack you for 5 seconds."
	taunt.cooldown = 8
	taunt.icon = load("res://Assets/Icons/icon_taunt.png")
	return taunt

# Fetch skills based on character type and level
func get_skills_for_level(character_type: int, level: int) -> Array:
	if character_type in skills and level in skills[character_type]:
		return skills[character_type][level]
	return []  # No skills available for this level

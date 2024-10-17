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
	6: [
		_create_holy_hands(),
		_create_healing_light(),
		_create_healing_mastery()
	],
	2: [
		_create_radiant_aura(),
		_create_mass_heal(),
		_create_divine_shield()
	],
	4: [
		_create_defense_mastery(),
		_create_crescendo(),
		_create_purifying_wave()
	]
}
	# Skills for the Valkyrie
	skills[Constants.CharacterType.VALKYRIE] = {
	2: [
		_create_spear_throw(),
		_create_valhallas_call(),  # Adding Valhalla's Call
		_create_thunder_strike()
	],
	4:[
		_create_thunder_strike(),
		_create_fenrirs_wrath(),
		_create_ragnarok()
		]
	}
	# Skills for the Wizard
	skills[Constants.CharacterType.MAGE] = {
		2: [
			_create_fireball(),
			_create_ice_nova(),
			_create_defense_mastery()
		],
		}
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
	
# skills cleric
func _create_holy_hands() -> Skill:
	var holy_hands = load("res://Skills/holy_hands.gd").new()
	holy_hands.name = "Holy Hands"
	holy_hands.description = "Give extra damage to 1 ally for their next 3 attacks."
	holy_hands.cooldown = 12  # Example cooldown
	holy_hands.icon = load("res://Assets/Icons/icon_holy_hands.png")
	return holy_hands

func _create_healing_light() -> Skill:
	var healing_light = load("res://Skills/healing_light.gd").new()
	healing_light.name = "Healing Light"
	healing_light.description = "Heal 1 ally for 20% of max health."
	healing_light.cooldown = 10
	healing_light.icon = load("res://Assets/Icons/icon_healing_light.png")
	return healing_light

func _create_healing_mastery() -> Skill:
	var healing_mastery = load("res://Skills/healing_mastery.gd").new()
	healing_mastery.name = "Healing Mastery"
	healing_mastery.description = "Increase the cleric's base healing amount by 20."
	
	healing_mastery.icon = load("res://Assets/Icons/icon_healing_mastery.png")
	return healing_mastery

func _create_mass_heal() -> Skill:
	var mass_heal = load("res://Skills/mass_heal.gd").new()
	mass_heal.name = "Mass Heal"
	mass_heal.description = "Heal all allies for 20% of their max health."
	mass_heal.cooldown = 30  # Example cooldown
	mass_heal.icon = load("res://Assets/Icons/icon_mass_heal.png")
	return mass_heal

# Create the Purifying Wave skill
func _create_purifying_wave() -> Skill:
	var purifying_wave = load("res://Skills/purifying_wave.gd").new()  # Load the script directly
	purifying_wave.name = "Purifying Wave"
	purifying_wave.description = "Heal all allies by 15% of max health and remove debuffs like poison and slow."
	purifying_wave.cooldown = 5  # 15 seconds cooldown
	purifying_wave.icon = load("res://Assets/Icons/icon_purifying_wave.png")
	return purifying_wave

func _create_radiant_aura() -> Skill:
	var radiant_aura = load("res://Skills/radiant_aura.gd").new()
	radiant_aura.name = "Radiant Aura"
	radiant_aura.description = "Regen HP of all allies for 5 seconds."
	radiant_aura.cooldown = 15  # Example cooldown
	radiant_aura.icon = load("res://Assets/Icons/icon_radiant_aura.png")
	return radiant_aura

func _create_divine_shield() -> Skill:
	var divine_shield = load("res://Skills/divine_shield.gd").new()
	divine_shield.name = "Divine Shield"
	divine_shield.description = "Make the ally with the lowest HP immune to damage for 3 seconds."
	divine_shield.cooldown = 10  # Example cooldown
	divine_shield.icon = load("res://Assets/Icons/icon_divine_shield.png")
	return divine_shield
	
	#valkyrie skills
func _create_spear_throw() -> Skill:
	var spear_throw = load("res://Skills/Valkyrie/spear_throw.gd").new()
	spear_throw.name = "Spear Throw"
	spear_throw.description = "Throw a spear at the farthest enemy."
	spear_throw.cooldown = 3
	spear_throw.icon = load("res://Assets/Icons/icon_spear_throw.png")
	return spear_throw

# Add this in your SkillDatabase.gd
func _create_valhallas_call() -> Skill:
	var valhallas_call = load("res://Skills/Valkyrie/valhallas_call.gd").new()
	valhallas_call.name = "Valhalla's Call"
	valhallas_call.description = "Reduces attack cooldown, increases movement speed, and grants lifesteal when health drops below 20%."
	valhallas_call.cooldown = 30  # 30 seconds cooldown
	valhallas_call.icon = load("res://Assets/Icons/icon_valhallas_call.png")  # Add the appropriate icon
	return valhallas_call


func _create_thunder_strike() -> Skill:
	var thunder_strike = load("res://Skills/Valkyrie/thunder_strike.gd").new()
	thunder_strike.name = "Thunder Strike"
	thunder_strike.description = "Deal lightning damage to a random enemy."
	thunder_strike.cooldown = 8
	thunder_strike.icon = load("res://Assets/Icons/icon_thunder_strike.png")
	return thunder_strike

func _create_valkyries_zeal() -> Skill:
	var zeal = load("res://Skills/Valkyrie/valkyries_zeal.gd").new()
	zeal.name = "Valkyrie's Zeal"
	zeal.description = "Increase attack speed by 20% for 5 seconds."
	zeal.cooldown = 15
	zeal.icon = load("res://Assets/Icons/icon_valkyries_zeal.png")
	return zeal
func _create_ragnarok() -> Skill:
	var ragnarok = load("res://Skills/Valkyrie/ragnarok.gd").new()
	ragnarok.name = "Ragnarök"
	ragnarok.description = "Deal massive damage to all enemies on the battlefield."
	ragnarok.cooldown = 20
	ragnarok.icon = load("res://Assets/Icons/icon_ragnarok.png")
	return ragnarok
func _create_fenrirs_wrath() -> Skill:
	var fenrirs_wrath = load("res://Skills/Valkyrie/fenrir_wrath.gd").new()
	fenrirs_wrath.name = "Fenrir's Wrath"
	fenrirs_wrath.description = "Each attack has a 25% chance to deal 120% attack damage."
	fenrirs_wrath.cooldown = 0  # Passive
	fenrirs_wrath.icon = load("res://Assets/Icons/icon_fenrirs_wrath.png")
	return fenrirs_wrath

#mage skills
# Helper functions to create the skills
func _create_fireball() -> Skill:
	var fireball = load("res://Skills/Wizard/fireball.gd").new()
	fireball.name = "Fireball"
	fireball.description = "Deal 80 damage to the nearest enemy."
	fireball.cooldown = 5
	fireball.icon = load("res://Assets/Icons/icon_fireball.png")
	return fireball

func _create_ice_nova() -> Skill:
	var ice_nova = load("res://Skills/Wizard/ice_nova.gd").new()
	ice_nova.name = "Ice Nova"
	ice_nova.description = "Deal 50 damage and slow enemies in an area."
	ice_nova.cooldown = 8
	ice_nova.icon = load("res://Assets/Icons/icon_ice_nova.png")
	return ice_nova



# Fetch skills based on character type and level
func get_skills_for_level(character_type: int, level: int) -> Array:
	if character_type in skills and level in skills[character_type]:
		return skills[character_type][level]
	return []  # No skills available for this level

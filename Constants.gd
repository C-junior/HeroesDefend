# Constants.gd
extends Node
class_name Constants


enum CharacterType {
	FIGHTER, 
	HEALER, 
	RANGED, 
	MAGE
}

var character_type_names = {
	CharacterType.HEALER: "Healer",
	CharacterType.FIGHTER: "Fighter",
	CharacterType.RANGED: "Ranged",
	CharacterType.MAGE: "Mage"
}

func _ready() -> void:
	print("Constants loaded", character_type_names)

#func nameType():
	#if CharacterType == 0:
		#return 

# You can also define other global constants or enums here if needed

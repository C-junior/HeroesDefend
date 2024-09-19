#manager.gd
extends Panel
 
enum MODE {
	INVENTORY,
	SHOP
}
 
@export var currency : int = 0:
	set(value):
		currency = value
 
		%Balance.text = str(value)
 
func _ready():
	currency = 10000
 
func _input(event):
	if event.is_action_pressed("inventory"):
		open_mode(MODE.INVENTORY)
 
 
func open_mode(mode):
	visible = not visible
 
	match mode:
		MODE.INVENTORY:
			%Shop.visible = false
			if visible:
				print("Inventory mode.")
 
		MODE.SHOP:
			%Shop.visible = true
			if visible:
				print("Shop mode.")
 

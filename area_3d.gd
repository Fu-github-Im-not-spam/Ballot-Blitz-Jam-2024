extends Area3D

@export var strings: Array[String] = []
@export var repeats_last_dialog = false
var current_string = 0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	area_entered.connect(area_entered_delegate)
	area_exited.connect(area_exited_delegate)
	pass # Replace with function body.

func area_entered_delegate(dummy):
	EventBus.playerEntered.emit(self)
func area_exited_delegate(dummy):
	EventBus.playerLeft.emit(self)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func getAndIncrementString() -> String:
	if current_string < strings.size():
		var ret = current_string
		current_string += 1
		if !repeats_last_dialog && current_string == strings.size():
			EventBus.endOfDialog.emit(self)
		return strings[ret]
	return "null"
	
func getString() -> String:
	if current_string < strings.size():
		return strings[current_string]
	return "null"

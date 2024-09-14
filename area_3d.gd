extends Area3D

@export var strings: Array[String] = []
@export var npc_name = "null"
@export var repeats_last_dialog = false
var current_string = 0
var tween = null
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	area_entered.connect(area_entered_delegate)
	area_exited.connect(area_exited_delegate)
	pass # Replace with function body.

func look_towards_area(area):
	if tween != null:
		tween.kill()
	tween = create_tween()
	tween.tween_method(
		set_owner_transform,
		owner.transform,
		owner.transform.looking_at(area.owner.position),
		0.5
	).set_ease(Tween.EASE_IN_OUT)

func set_owner_transform(new_transform):
	owner.transform = new_transform

func area_entered_delegate(_dummy):
	look_towards_area(_dummy)
	EventBus.playerEntered.emit(self)
func area_exited_delegate(_dummy):
	
	EventBus.playerLeft.emit(self)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
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

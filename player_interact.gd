extends RichTextLabel

@export var increment = PI/16
@export var factor = 4;
var cycle = 0;
var y_original = -INF
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	y_original = position.y
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if visible:
		cycle += increment
	else:
		cycle = 0
	
	position.y = y_original + sin(cycle)*factor
	pass

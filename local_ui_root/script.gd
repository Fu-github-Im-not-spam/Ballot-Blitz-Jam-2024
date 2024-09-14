extends Node3D

var owning_node = null
var ratio = 1;
var printing = false
@export_range(0.1, 1.0, 0.05) var text_speed = 1.0
@onready var rich_text_node = $SubViewport/RichTextLabel
# Called when the node enters the scene tree for the first time.

func _ready():
	owning_node = get_parent()
	reset_text(owning_node.getString())

func reset_text(string):
	rich_text_node.visible_ratio = 0
	ratio = 1.0/string.length() * text_speed
	if owning_node != null:
		rich_text_node.text = "[center]" + string + "[/center]"

func process_text():
	rich_text_node.visible_ratio = clamp(rich_text_node.visible_ratio + ratio, 0, 1);

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if printing:
		process_text()
	pass

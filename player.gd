extends CharacterBody3D


const SPEED = 5.0
const JUMP_VELOCITY = 4.5
const WIGGLE_INI = 0

@export var x_rot = -7.0
@export var increment = PI/16
@export_range(0.0005, 0.002) var factor = .002
@onready var cam = get_node("Camera")
@onready var text_node = get_node("Interact")
@onready var original_text = text_node.text
var wiggle = 0
var last_direction = Vector3(0.0,0.0,0.0)
var node_dict = {}

func _ready() -> void:
	EventBus.playerEntered.connect(enqueue_node)
	EventBus.playerLeft.connect(remove_node)
	EventBus.endOfDialog.connect(remove_node)
	cam.rotation.x = x_rot

func enqueue_node(id):
	node_dict.get_or_add(id)

func remove_node(id):
	node_dict.erase(id)

func access_dialog():
	if node_dict.size():
		var id = node_dict.keys().front()
		id.enable_local_ui()
	return ""

func _physics_process(_delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * _delta

	text_node.visible = !node_dict.is_empty()
	
	if text_node.visible:
		var npc_name = node_dict.keys().front().npc_name
		text_node.text = original_text.format({"NPC": npc_name})
	# Handle jump.
	if Input.is_action_just_pressed("ui_accept"):
		access_dialog()

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()

	if direction:
		wiggle += increment * direction.z
		last_direction = direction

		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		if !is_equal_approx(cam.rotation.x, x_rot):
			wiggle += increment * last_direction.z
		else:
			last_direction = Vector3.ZERO
			wiggle = WIGGLE_INI;
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
	
	move_and_slide()
	cam.rotation.x = x_rot + cos(wiggle) * factor

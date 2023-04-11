extends StaticBody


export(NodePath) var target_container
export(NodePath) var solution
signal button_pressed

var _solution
var targetContainer
var _level
var target_array: Array
var locked: bool = false
var targetAmount: int = 0
var currentAmount: int = 0
func _ready():
	_level = owner
	_solution = get_node(solution)
	var container = get_node(target_container)
	for target in container.get_children():
		if target.is_in_group("TARGET"):
			connect("button_pressed", target, "_on_button_pressed")
			target.connect("transform_checked", self, "_on_transform_checked")
			targetAmount += 1
			target_array.push_back(target)
		
	add_to_group("INTERACTABLE")

func interact():
	if not locked:
		emit_signal("button_pressed")
#	emit_signal("button_pressed")

func _on_transform_checked(status):
	if status:
		currentAmount += 1
	if currentAmount == targetAmount:
		print("All transforms in place")
		_solution.open()

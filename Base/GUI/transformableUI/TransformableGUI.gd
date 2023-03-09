extends PanelContainer

signal action_executed()
signal next_action_executed()
signal drawArea_block_deleted
signal selected_object_cleared

enum BlockType {TRANSLATE, ROTATE, SCALE}

var selectedObject
var blockStack: Array

onready var _translateSource = $VBoxContainer/SourceContainer/Padding/SourceRows/TranslateSource 
onready var _rotateSource = $VBoxContainer/SourceContainer/Padding/SourceRows/RotateSource
onready var _scaleSource = $VBoxContainer/SourceContainer/Padding/SourceRows/ScaleSource
onready var _drawAreaContainer = $VBoxContainer/DrawContainer/Padding/DrawColumn
onready var _drawContainer = $VBoxContainer/DrawContainer
onready var _codePanel = $VBoxContainer/DrawContainer/Padding/codePanel
onready var _timer = $Timer


func _ready():
	_resetGUI()

func _on_clearButton_pressed():
	for child in _drawAreaContainer.get_children():
		child.queue_free() # Remove all block in draw area
	blockStack.clear()

func _on_runButton_pressed():
	if blockStack:
		emit_signal("action_executed")
		execute_Action(blockStack[0])
		
func execute_Action(var block):
	blockStack.pop_front()
	match block.block_Type:
			BlockType.TRANSLATE:
				selectedObject.Instance.moveObject(Vector3(block.x_Value, block.y_Value, block.z_Value))
			BlockType.ROTATE:
				selectedObject.Instance.rotateObject(block.inputOption, float(block.inputValue))
			BlockType.SCALE:
				selectedObject.Instance.scaleObject(Vector3(block.inputValue, block.inputValue, block.inputValue))
	

func _on_TransformableGUI_visibility_changed():
	_resetGUI()

func _on_Block_Collasped():
	emit_signal("selected_object_cleared")
	selectedObject = null
	_timer.start()
	
	
func _on_Transform_Finished():
	if blockStack:
		execute_Action(blockStack[0])
		emit_signal("next_action_executed")
	else:
		for child in _drawAreaContainer.get_children():
			child.queue_free()
		# Start 1 second timer here
		_timer.start()
		
func _resetGUI():
	blockStack.clear() # Clear Stack
	# Remove all block in draw area
	for child in _drawAreaContainer.get_children():
		child.queue_free() 
	
	if selectedObject:
		if visible:
#			selectedObject._gizmo.visible = true
			configSourceBlocks()
#		else:
##			selectedObject._gizmo.visible = false
	_codePanel.hide()
	
	
func configSourceBlocks():
	if selectedObject.can_translate:
		_translateSource.show()
	else:
		_translateSource.hide()
	if selectedObject.can_rotate:
		_rotateSource.show()
	else:
		_rotateSource.hide()
	if selectedObject.can_scale:
		_scaleSource.show()
	else:
		_scaleSource.hide()
	# Pass vectors here into draw container node
	_drawContainer.set_block_limits(selectedObject.translate_axis_limit, selectedObject.rotate_axis_limit)	
			
# Push blocks into stack
func _on_DrawColumn_child_entered_tree(node):
	print(node.label)
	blockStack.push_back(node)
	
# Gets node that exits draw area
func _on_DrawColumn_child_exiting_tree(node):
	# Remove block from stack
	blockStack.erase(node)
	# Re-organise ID to match array index
	if blockStack.size() > 1:
		for block in blockStack:
			if block.id > node.id:
				block.id = block.id -1
	elif blockStack.size() == 1:
		blockStack[0].id = 0
	emit_signal("drawArea_block_deleted")
		
func _on_Timer_timeout():
	_codePanel.hide()
	hide() # Hide menu after executing all blocks
	

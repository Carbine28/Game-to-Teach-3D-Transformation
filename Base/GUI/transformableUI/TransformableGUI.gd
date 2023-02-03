extends PanelContainer

enum BlockType {
	TRANSLATE,
	ROTATE,
	SCALE
}

signal drawArea_block_deleted
onready var _drawAreaContainer = $VBoxContainer/DrawContainer/Padding/DrawColumn
var selectedObject
var blockStack: Array

func _ready():
	# Hide GUI upon loading
	visible = false

func _on_clearButton_pressed():
	for child in _drawAreaContainer.get_children():
		child.queue_free() # Remove all block in draw area
		#emit_signal("drawArea_Cleared")	
	blockStack.clear()

func _on_runButton_pressed():
	for block in blockStack:
		match block.block_Type:
			BlockType.TRANSLATE:
				selectedObject.moveObject(Vector3(block.x_Value, block.y_Value, block.z_Value))
			BlockType.ROTATE:
				pass
			BlockType.SCALE:
				pass

func _on_TransformableGUI_visibility_changed():
	if visible:
		selectedObject._gizmo.visible = not selectedObject._gizmo.visible
		
# Push blocks into stack
func _on_DrawColumn_child_entered_tree(node):
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
	
		
		
		
 

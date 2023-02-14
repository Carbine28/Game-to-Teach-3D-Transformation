extends ColorRect
class_name TransformBlock

enum BlockType {
	TRANSLATE,
	ROTATE,
	SCALE
}

export var label:String
export (BlockType) var block_Type
var dropped_on_target: bool = false

func _ready() -> void:
	add_to_group("DRAGGABLE")
	$Label.text = label
	
	
# Called when upon starting drag
func get_drag_data(_position: Vector2):
	#print("get_drag_data(): Dragging: " , label , " block, ID: ", id)
	if not dropped_on_target:
		set_drag_preview( _get_preview_control())
		return self

# Create a preview of the block being dragged
func _get_preview_control() -> Control:
	var preview = ColorRect.new()
	preview.rect_size = rect_size
	var preview_color = color
	preview_color.a = .5
	preview.color = preview_color
	preview.set_rotation(.1) # in readians
	return preview

extends Control

onready var _matrix = $NinePatchRect/MarginContainer/VBoxContainer
var row1
var row2
var row3
var object


func _ready():
	row1 = _matrix.get_node("Row")
	row2 = _matrix.get_node("Row2")
	row3 = _matrix.get_node("Row3")
	
func _process(_delta):
	draw_matrix()
	
func null_matrix():
	object = null
	
func draw_matrix():
	if object:
		row1.get_child(0).get_child(0).text = String(object.transform.basis.x.x)
		row1.get_child(1).get_child(0).text = String(object.transform.basis.x.y)
		row1.get_child(2).get_child(0).text = String(object.transform.basis.x.z)
		row1.get_child(3).get_child(0).text = String(object.transform.origin.x)
		
		row2.get_child(0).get_child(0).text = String(object.transform.basis.y.x)
		row2.get_child(1).get_child(0).text = String(object.transform.basis.y.y)
		row2.get_child(2).get_child(0).text = String(object.transform.basis.y.z)
		row2.get_child(3).get_child(0).text = String(object.transform.origin.y)
		
		row3.get_child(0).get_child(0).text = String(object.transform.basis.z.x)
		row3.get_child(1).get_child(0).text = String(object.transform.basis.z.y)
		row3.get_child(2).get_child(0).text = String(object.transform.basis.z.z)
		row3.get_child(3).get_child(0).text = String(object.transform.origin.z)
	
			
func update_matrix(var _object):
#	print(object.transform.basis)
#	print(row1.get_child(0).text)
	object = _object
	
func clear_matrix():
	object = null

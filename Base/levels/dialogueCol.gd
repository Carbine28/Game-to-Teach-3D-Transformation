extends Area

export var timeline_str: String

func _on_dialogueCol_body_entered(body):
	if body.is_in_group("Player"):
		var new_dialog = Dialogic.start(timeline_str)
		add_child(new_dialog)

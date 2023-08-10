extends InteractiveObject


signal injured_person_saved(person: InteractiveObject)


var dialogue_lines := ["You saved me!", "Thank you!"]


func interact() -> void:
	if dialogue_lines:
		$InteractLabel.text = dialogue_lines.pop_front()
	else:
		$CanvasLayer/AnimationPlayer.play("fade_full")

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "fade_full":
		injured_person_saved.emit(self)

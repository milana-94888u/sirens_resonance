extends InteractiveObject


func interact() -> void:
	if has_node("SecondSprite"):
		$ActiveSprite.texture = $SecondSprite.texture
		remove_child($SecondSprite)
	elif has_node("ActiveSprite"):
		super.stop_interacting()
		remove_child($ActiveSprite)

extends Area2D
class_name InteractiveObject


func set_active(active: bool) -> void:
	$InteractLabel.visible = active
	($ActiveSprite.material as ShaderMaterial).set_shader_parameter("enabled", active)


func interact() -> void:
	pass


func check_for_player(player: Player) -> void:
	if player.current_interact_object != null:
		return
	if player in get_overlapping_bodies():
		player.set_active_object(self)


func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		body.set_active_object(self)


func _on_body_exited(body: Node2D) -> void:
	if body is Player:
		body.remove_active_object(self)

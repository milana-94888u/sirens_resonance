extends Area2D
class_name Siren


func set_outline(enabled: bool) -> void:
	$Label.visible = enabled
	($Sprite2D.material as ShaderMaterial).set_shader_parameter("enabled", enabled)
	

func interact() -> void:
	$AudioStreamPlayer2D.play()


func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		body.set_active_object(self)


func _on_body_exited(body: Node2D) -> void:
	if body is Player:
		body.remove_active_object(self)


func check_for_player(player: Player) -> void:
	if player.current_interact_object != null:
		return
	if player in get_overlapping_bodies():
		player.set_active_object(self)

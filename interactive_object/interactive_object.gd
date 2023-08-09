extends Area2D
class_name InteractiveObject


@export var interactable := true


func _ready() -> void:
	add_to_group("interactive")


func set_active(active: bool) -> void:
	if not interactable:
		return
	$InteractLabel.visible = active
	($ActiveSprite.material as ShaderMaterial).set_shader_parameter("enabled", active)


func interact() -> void:
	pass


func stop_interacting() -> void:
	if $InteractLabel:
		$InteractLabel.visible = false
	for body in get_overlapping_bodies():
		if body is Player:
			body.remove_active_object(self)
	interactable = false


func start_interacting() -> void:
	interactable = true
	for body in get_overlapping_bodies():
		if body is Player:
			body.set_active_object(self)


func is_interactable() -> bool:
	return is_interactable()


func check_for_player(player: Player) -> void:
	if player.current_interact_object != null:
		return
	if not interactable:
		return
	if player in get_overlapping_bodies():
		player.set_active_object(self)


func _on_body_entered(body: Node2D) -> void:
	if interactable and body is Player:
		body.set_active_object(self)


func _on_body_exited(body: Node2D) -> void:
	if interactable and body is Player:
		body.remove_active_object(self)

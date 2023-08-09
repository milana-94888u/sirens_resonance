extends Area2D
class_name InteractiveObject


func set_active(active: bool) -> void:
	($Sprite2D.material as ShaderMaterial).set_shader_parameter("enabled", active)

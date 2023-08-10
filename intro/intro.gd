extends Control


var earthquake_finished = false
var broadcast_finished = false
var bag_packed = false


func check_triggers() -> void:
	if earthquake_finished and broadcast_finished and bag_packed:
		($Backpack.material as ShaderMaterial).set_shader_parameter("enabled", true)
		$Backpack.mouse_default_cursor_shape = CURSOR_POINTING_HAND
		$Backpack.disabled = false


func _ready() -> void:
	($AudioDevice.material as ShaderMaterial).set_shader_parameter("enabled", true)
	$AudioDevice.mouse_default_cursor_shape = CURSOR_POINTING_HAND
	$AudioDevice.disabled = false


func _on_audio_device_pressed() -> void:
	($AudioDevice.material as ShaderMaterial).set_shader_parameter("enabled", false)
	$AudioDevice.mouse_default_cursor_shape = mouse_default_cursor_shape
	$AudioDevice.disabled = true
	$AudioDevice.texture_normal = load("res://assets/intro_items/audio_device2.png")
	$RadioBroadcast.play()
	$Captions.show()
	
	($Backpack.material as ShaderMaterial).set_shader_parameter("enabled", true)
	$Backpack.mouse_default_cursor_shape = CURSOR_POINTING_HAND
	$Backpack.disabled = false


func _on_radio_broadcast_finished() -> void:
	$AudioDevice.texture_normal = preload("res://assets/intro_items/audio_device1.png")
	$Captions.hide()
	broadcast_finished = true
	check_triggers()


func _on_earth_quake_player_finished() -> void:
	earthquake_finished = true
	check_triggers()


func _on_backpack_pressed() -> void:
	if $Items.get_child_count():
		$Backpack/Unzip.play()
		($Backpack.material as ShaderMaterial).set_shader_parameter("enabled", false)
		$Backpack.mouse_default_cursor_shape = mouse_default_cursor_shape
		$Backpack.disabled = true
		$Backpack.texture_normal = load("res://assets/intro_items/backpack_open.png")
		
		for item in $Items.get_children():
			(item.material as ShaderMaterial).set_shader_parameter("enabled", true)
			item.mouse_default_cursor_shape = CURSOR_POINTING_HAND
			item.disabled = false
			item.pressed.connect(_on_item_pressed.bind(item))
	elif not bag_packed:
		$Backpack/Zip.play()
		($Backpack.material as ShaderMaterial).set_shader_parameter("enabled", false)
		$Backpack.mouse_default_cursor_shape = mouse_default_cursor_shape
		$Backpack.disabled = true
		$Backpack.texture_normal = load("res://assets/intro_items/backpack_сlosed.png")
		bag_packed = true
		check_triggers()
	else:
		remove_child($Backpack)
		get_tree().change_scene_to_file("res://main.tscn")


func _on_item_pressed(item: TextureButton) -> void:
	$Backpack/Put.play()
	$Items.remove_child(item)
	if $Items.get_child_count() == 0:
		($Backpack.material as ShaderMaterial).set_shader_parameter("enabled", true)
		$Backpack.mouse_default_cursor_shape = CURSOR_POINTING_HAND
		$Backpack.disabled = false

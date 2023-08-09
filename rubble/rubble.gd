extends InteractiveObject


@export var rubble_sprite := 2


var first_block_texture: Texture
var second_block_texture: Texture
var sound_texture: Texture
var base_texture: Texture


func _ready() -> void:
	if rubble_sprite == 1:
		$StaticBody2D/CollisionShape1.disabled = false
	elif rubble_sprite == 2:
		$StaticBody2D/CollisionShape2.disabled = false
	first_block_texture = load("res://assets/rubble/rubble%d_first_block.png" % rubble_sprite)
	second_block_texture = load("res://assets/rubble/rubble%d_second_block.png" % rubble_sprite)
	sound_texture = load("res://assets/rubble/rubble%d_sound.png" % rubble_sprite)
	base_texture = load("res://assets/rubble/rubble%d_base.png" % rubble_sprite)

	$ActiveSprite.texture = first_block_texture
	$SecondSprite.texture = second_block_texture
	$SoundSprite.texture = sound_texture
	$BaseSprite.texture = base_texture


func interact() -> void:
	if has_node("SecondSprite"):
		$ActiveSprite.texture = $SecondSprite.texture
		remove_child($SecondSprite)
	elif has_node("ActiveSprite"):
		stop_interacting()
		remove_child($ActiveSprite)
		remove_child($Timer)
		remove_child($ScreamPlayer)
		remove_child($SoundSprite)


func _on_timer_timeout() -> void:
	$SoundSprite.visible = true
	$ScreamPlayer.play()


func _on_scream_player_finished() -> void:
	$SoundSprite.visible = false

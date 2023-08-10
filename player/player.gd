extends CharacterBody2D
class_name Player


@export var captions = [
	"The massive earthquake occured",
	"I need to rescue people",
	"Going to clear the rubbles and notify people with sirens",
]


@export var speed := 80
@export var health := 1


var current_interact_object: InteractiveObject = null


func go_right() -> void:
	$AnimatedSprite2D.play("go_right")
	velocity = Vector2.RIGHT * speed


func go_down() -> void:
	$AnimatedSprite2D.play("go_down")
	velocity = Vector2.DOWN * speed

func go_left() -> void:
	$AnimatedSprite2D.play("go_left")
	velocity = Vector2.LEFT * speed

func go_up() -> void:
	$AnimatedSprite2D.play("go_up")
	velocity = Vector2.UP * speed


func move() -> void:
	if not $StepsPlayer.playing:
		$StepsPlayer.play()
	move_and_slide()


func stay() -> void:
	if $StepsPlayer.playing:
		$StepsPlayer.stop()
	match $AnimatedSprite2D.animation:
		"go_right":
			$AnimatedSprite2D.play("stay_right")
		"go_down":
			$AnimatedSprite2D.play("stay_down")
		"go_left":
			$AnimatedSprite2D.play("stay_left")
		"go_up":
			$AnimatedSprite2D.play("stay_up")


func _physics_process(_delta: float) -> void:
	if Input.is_action_pressed("ui_right"):
		go_right()
		move()
	elif Input.is_action_pressed("ui_down"):
		go_down()
		move()
	elif Input.is_action_pressed("ui_left"):
		go_left()
		move()
	elif Input.is_action_pressed("ui_up"):
		go_up()
		move()
	else:
		stay()
	
	if Input.is_action_just_pressed("interact"):
		if current_interact_object != null:
			current_interact_object.interact()


func set_active_object(obj: InteractiveObject) -> void:
	if current_interact_object != null and current_interact_object != obj:
		current_interact_object.set_active(false)
	current_interact_object = obj
	current_interact_object.set_active(true)


func remove_active_object(obj: InteractiveObject) -> void:
	if current_interact_object == obj:
		current_interact_object.set_active(false)
		current_interact_object = null
	get_tree().call_group("interactive", "check_for_player", self)


func _on_timer_timeout() -> void:
	if captions:
		$CanvasLayer/CaptionsLabel.visible = true
		$CanvasLayer/CaptionsLabel.text = captions.pop_front()
	else:
		$CanvasLayer/CaptionsLabel.visible = false
		$Timer.stop()

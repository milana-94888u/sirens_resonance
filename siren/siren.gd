extends InteractiveObject


signal siren_played(siren: InteractiveObject)


func interact() -> void:
	siren_played.emit(self)
	$AudioStreamPlayer2D.play()

extends Node2D


var injured_people_camp_spots: Array[Vector2i] = [
	Vector2i(36, -6),
	Vector2i(33, -6),
	Vector2i(36, -8),
	Vector2i(33, -8),
	Vector2i(46, -6),
	Vector2i(43, -6),
	Vector2i(46, -8),
	Vector2i(43, -8),
	Vector2i(45, -8),
	Vector2i(34, -5),
]


func _on_injured_person_saved(person: InteractiveObject) -> void:
	person.stop_interacting()
	person.queue_free()
	
	if injured_people_camp_spots:
		$TileMap.set_cell(5, injured_people_camp_spots.pop_front(), 4, Vector2i(6, 4))

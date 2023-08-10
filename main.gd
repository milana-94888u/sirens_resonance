extends Node2D


var player_blocked := false


var people_camp_spots: Array[Vector2i] = [
	Vector2i(33, -10),
	Vector2i(34, -10),
	Vector2i(35, -10),
	Vector2i(36, -10),
	Vector2i(37, -10),
	Vector2i(38, -10),
	Vector2i(39, -9),
	Vector2i(40, -9),
	Vector2i(41, -10),
	Vector2i(42, -10),
]


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


func _process(_delta: float) -> void:
	$CanvasLayer/VBoxContainer/SavedLabel.text = "Rescued people: %d/10" % (10 - len(injured_people_camp_spots))
	$CanvasLayer/VBoxContainer/NotifiedLabel.text = "Nofified people: %d/10" % (10 - len(people_camp_spots))
	if len(injured_people_camp_spots) == 0 and len(people_camp_spots) == 0:
		$Timer.stop()
	var seconds := int($Timer.time_left)
	$CanvasLayer/VBoxContainer/TimeLabel.text = "Remaining time %d:%d%d" % [seconds / 60, (seconds % 60) / 10, seconds % 10]
	if len(injured_people_camp_spots) == 0 and len(people_camp_spots) == 0:
		set_process(false)
		$Timer.timeout.emit()


func _on_injured_person_saved(person: InteractiveObject) -> void:
	person.stop_interacting()
	person.queue_free()
	
	if injured_people_camp_spots:
		$TileMap.set_cell(5, injured_people_camp_spots.pop_front(), 4, Vector2i(6, 4))


func check_road_tile(coords: Vector2i) -> bool:
	var result: bool = $TileMap.get_cell_source_id(1, coords) == 0
	for layer in range(2, $TileMap.get_layers_count()):
		result = result and ($TileMap.get_cell_source_id(layer, coords) == -1)
	return result


func check_building_tile(coords: Vector2i) -> bool:
	return ($TileMap.get_cell_source_id(2, coords) == 2) or ($TileMap.get_cell_source_id(3, coords) == 2)


func check_building_neighbour(coords: Vector2i) -> bool:
	if not check_road_tile(coords):
		return false
	var result := false
	for direction in [Vector2i.RIGHT, Vector2i.DOWN, Vector2i.LEFT, Vector2i.UP]:
		result = result or check_building_tile(coords + direction)
	return result


func add_people_from_buildings(
	appear_spots: Array[Vector2i], final_spots: Array[Vector2i], npc_types: Array[Vector2i]
) -> void:
	for i in len(appear_spots):
		$TileMap.set_cell(5, appear_spots[i], 4, npc_types[i])
	$Player.set_physics_process(false)
	await get_tree().create_timer(1).timeout
	$CanvasLayer/AnimationPlayer.play("fade_out")
	await $CanvasLayer/AnimationPlayer.animation_finished
	for i in len(appear_spots):
		$TileMap.set_cell(5, appear_spots[i])
	$CanvasLayer/AnimationPlayer.play("fade_in")
	await $CanvasLayer/AnimationPlayer.animation_finished
	if not player_blocked:
		$Player.set_physics_process(true)
	for i in len(appear_spots):
		$TileMap.set_cell(5, final_spots[i], 4, npc_types[i])


func try_add_people_from_buildings(valid_tiles: Array[Vector2i]) -> void:
	randomize()
	valid_tiles.shuffle()
	var appear_spots: Array[Vector2i] = []
	var final_spots: Array[Vector2i] = []
	var npc_types: Array[Vector2i] = []
	while valid_tiles:
		if not people_camp_spots:
			break
		var set_person := randi_range(1, len(valid_tiles)) == 1
		var current_position: Vector2i = valid_tiles.pop_back()
		if set_person:
			appear_spots.append(current_position)
			final_spots.append(people_camp_spots.pop_front())
			npc_types.append(Vector2i(randi_range(0, 5), 4))
	add_people_from_buildings(appear_spots, final_spots, npc_types)


func _on_siren_played(siren: InteractiveObject) -> void:
	var valid_appear_spots: Array[Vector2i] = []
	var initial_coords: Vector2i = $TileMap.local_to_map(siren.position) + Vector2i(10, -2)
	for x in range(initial_coords.x - 5, initial_coords.x + 5):
		for y in range(initial_coords.y - 5, initial_coords.y + 5):
			if check_building_neighbour(Vector2i(x, y)):
				valid_appear_spots.append(Vector2i(x, y))
	try_add_people_from_buildings(valid_appear_spots)


func _on_timer_timeout() -> void:
	player_blocked = true
	$Player.set_physics_process(false)
	$CanvasLayer/AnimationPlayer.play("fade_full")
	$Player/AnimatedSprite2D.play("stay_down")
	$Player/StepsPlayer.stop()
	$Player.position = Vector2(974, -260)
	await $CanvasLayer/AnimationPlayer.animation_finished

extends StaticBody2D
class_name ItemContainer

# items face start facing down and can be rotated by rotation in editing
@onready var current_direction: Vector2 = Vector2.DOWN.rotated(rotation)
var opened: bool = false
signal open(pos, direction)

func spawn_items(amount: int = 1) -> void:
	if not opened:
		$LidSprite.hide()
		for i in range(amount):
			var pos = $SpawnPositions.get_children().pick_random().global_position
			open.emit(pos, current_direction)
	opened = true

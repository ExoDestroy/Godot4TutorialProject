extends CharacterBody2D

var player_nearby: bool = false
var can_laser: bool = true
var alternate_gun: bool = false

var health: int = 30
var vulnerable: bool = true

signal laser(pos, direction)

func hit():
	if vulnerable:
		health -= 10
		vulnerable = false
		$Sprite2D.material.set_shader_parameter("progress", 1)
		await get_tree().create_timer(.2).timeout
		vulnerable = true
		$Sprite2D.material.set_shader_parameter("progress", 0)
	if health <= 0:
			queue_free()
	

func _process(_delta):
	if player_nearby:
		look_at(Globals.player_pos)
		if can_laser:
			var pos: Vector2 = $LaserSpawnPositions.get_child(alternate_gun).global_position
			alternate_gun = not alternate_gun
			var direction: Vector2 = (Globals.player_pos - global_position).normalized()
			laser.emit(pos, direction)
			can_laser = false
			await get_tree().create_timer(1.1).timeout
			can_laser = true

func _on_attack_area_body_entered(_body):
	player_nearby = true

func _on_attack_area_body_exited(_body):
	player_nearby = false

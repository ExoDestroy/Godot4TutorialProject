extends CharacterBody2D

var active: bool = false
var speed: int = 0
var max_speed: int = 600
var speed_multiplier: int = 1

var vulnerable: bool = true
var health: int = 50

var exploding: bool = false
var explosion_radius: int = 400

func _ready():
	$Explosion.hide()
	$Drone.show()
	speed_multiplier = 1

func _process(delta):
	if active:
		look_at(Globals.player_pos)
		var direction = (Globals.player_pos - position).normalized()
		velocity = direction * speed * speed_multiplier
		var collision = move_and_collide(velocity * delta)
		if collision:
			$AnimationPlayer.play("explosion")
			exploding = true
	if exploding:
		var targets = get_tree().get_nodes_in_group("Entity") + get_tree().get_nodes_in_group("Container")
		for target in targets:
			var in_range = target.global_position.distance_to(global_position) < explosion_radius
			if in_range and "hit" in target:
				target.hit()

func hit():
	if vulnerable:
		health -= 10
		vulnerable = false
		$Drone.material.set_shader_parameter("progress", 1)
		$HitTimer.start()
	if health <= 0:
		$AnimationPlayer.play("explosion")
		exploding = true

func stop_movement():
	speed_multiplier = 0

func _on_notice_area_body_entered(_body):
	active = true
	var tween = create_tween()
	tween.tween_property(self, "speed", max_speed, 6.0)

func _on_hit_timer_timeout():
	vulnerable = true
	$Drone.material.set_shader_parameter("progress", 0)

extends CharacterBody2D

var active: bool = false
var player_near: bool = false
var vulnerable: bool = true
var speed: int = 300

var health = 20

func _process(_delta):
	var direction: Vector2 = (Globals.player_pos - position).normalized()
	velocity = direction * speed
	if active:
		look_at(Globals.player_pos)
		move_and_slide()
	
func hit():
	if vulnerable:
		health -= 10
		vulnerable = false
		$AnimatedSprite2D.material.set_shader_parameter("progress", 1)
		$Node2D/HitParticles.emitting = true
		$Node/HitTimer.start()
		$AudioStreamPlayer2D.play()
		
	if health <= 0:
		await get_tree().create_timer(.5).timeout
		await $AudioStreamPlayer2D.finished
		queue_free()

func _on_notice_area_body_entered(_body):
	active = true
	$AnimatedSprite2D.play("walk")

func _on_notice_area_body_exited(_body):
	active = false
	$AnimatedSprite2D.stop()

func _on_attack_area_body_entered(_body):
	player_near = true
	$AnimatedSprite2D.play("attack")

func _on_attack_area_body_exited(_body):
	player_near = false
	$AnimatedSprite2D.play("walk")

func _on_animated_sprite_2d_animation_finished():
	if player_near:
		Globals.health -= 10
		$Node/AttackTimer.start()

func _on_hit_timer_timeout():
	vulnerable = true
	$AnimatedSprite2D.material.set_shader_parameter("progress", 0)


func _on_attack_timer_timeout():
	if player_near:
		$AnimatedSprite2D.play("attack")

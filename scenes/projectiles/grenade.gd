extends RigidBody2D

const speed = 750
var exploding: bool = false
var explosion_radius: int = 300

func explode():
	$AnimationPlayer.play("Explosion")
	exploding = true

func _process(_delta):
	if exploding:
		var targets = get_tree().get_nodes_in_group("Entity") + get_tree().get_nodes_in_group("Container")
		for target in targets:
			if target.global_position.distance_to(global_position) < explosion_radius:
				if "hit" in target:
					target.hit()

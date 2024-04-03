extends Area2D

@export var speed: int = 1000
# modified when spawned by level
var direction: Vector2 = Vector2.UP

func _ready():
	await get_tree().create_timer(2.0).timeout
	queue_free()

func _process(delta):
	position += direction * speed * delta

func _on_body_entered(body):
	if "hit" in body:
		body.hit()
	queue_free()

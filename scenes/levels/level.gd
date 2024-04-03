extends Node2D
class_name LevelParent

var laser_scene: PackedScene = preload("res://scenes/projectiles/laser.tscn")
var grenade_scene: PackedScene = preload("res://scenes/projectiles/grenade.tscn")
var item_scene: PackedScene = preload("res://scenes/items/item.tscn")

func _ready():
	# use a loop to automatically assign signals to any container
	for container in get_tree().get_nodes_in_group("Container"):
		container.connect("open", _on_container_opened)
	for scout in get_tree().get_nodes_in_group("Scouts"):
		scout.connect("laser", _on_scout_laser)
		
func _on_container_opened(pos, direction):
	var item = item_scene.instantiate()
	item.position = pos
	item.direction = direction
	# spawning on top of crate (staticbody) interferes with godot physics checks
	# calls at end up process once godot is done checking collision with laser
	$Items.call_deferred('add_child', item, true)
	
func create_laser(pos, direction) -> void:
	var laser = laser_scene.instantiate() as Area2D
	laser.position = pos
	laser.rotation = direction.angle() + PI / 2
	laser.direction = direction
	$Projectiles.add_child(laser, true)

func _on_player_laser(pos, direction):
	create_laser(pos, direction)

func _on_player_grenade(pos, direction):
	var grenade = grenade_scene.instantiate() as RigidBody2D
	grenade.position = pos
	grenade.linear_velocity = direction * grenade.speed
	$Projectiles.add_child(grenade, true)

func _on_scout_laser(pos, direction):
	create_laser(pos, direction)

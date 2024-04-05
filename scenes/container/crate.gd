extends ItemContainer

func hit():
	spawn_items(10)
	$AudioStreamPlayer2D.play()

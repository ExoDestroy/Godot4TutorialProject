extends ItemContainer

func hit():
	spawn_items()
	$AudioStreamPlayer2D.play()

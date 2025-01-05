extends Control

func _ready():
	$AnimationMenu.play("RESET")
	hide()


func _process(_void):
	if (Input.is_action_just_pressed("Back")) and (get_tree().paused == false) :
		$MenuSound.play()
		get_tree().paused = true
		show()
		$AnimationMenu.play("Visibility")
		
	elif (Input.is_action_just_pressed("Back")) and (get_tree().paused == true) :
		get_tree().paused = false
		hide()
		$AnimationMenu.play_backwards("Visibility")
	
	
func _on_resume_pressed():
	get_tree().paused = false
	hide()
	$AnimationMenu.play_backwards("Visibility")


func _on_retry_pressed():
	get_tree().paused = false
	hide()
	$AnimationMenu.play("Visibility")
	get_tree().reload_current_scene()


func _on_quit_pressed():
	get_tree().quit()

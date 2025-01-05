extends CanvasLayer

@onready var anim = $AnimationRectangle
@onready var Mecanics = get_node("../Stage%d" % Global.current_Stage)

func change_scene_to (scene_name) :
	anim.play("Dissolve")
	await anim.animation_finished
	Global.has_Player_finished_current_stage = false
	get_tree().change_scene_to_packed(scene_name)
	anim.play_backwards("Dissolve")
	await anim.animation_finished
	

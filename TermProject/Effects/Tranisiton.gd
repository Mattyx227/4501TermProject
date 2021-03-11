extends CanvasLayer

signal scene_changed()

onready var animation = $AnimationPlayer
onready var black = $Control/ColorRect

func change_scene(path, delay = 0.5):
	yield(get_tree().create_timer(delay), "timeout")
	animation.play("Fade")
	yield(animation, "animation_finished")
	assert(get_tree().change_scene(path) == OK)
	animation.play_backwards("Fade")
	yield(animation, "animation_finished")
	emit_signal("scene_changed")

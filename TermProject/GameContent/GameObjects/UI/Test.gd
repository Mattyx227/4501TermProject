extends NinePatchRect


func _ready():
	print(get_mouse_filter())


func _on_StrengthButton_pressed():
	print("PRESSED")


func _on_StrengthButton_mouse_entered():
	print("HI")


func _on_Text_mouse_entered():
	print("HI")

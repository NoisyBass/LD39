extends Node2D

func _ready():
	get_node("Sprite 2/AnimationPlayer").play("credits")


func _on_TextureButton_pressed():
	get_node("/root/Global").goto_scene("res://Scenes/Menu.tscn")

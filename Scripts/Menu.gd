extends Node2D

func _ready():
	pass


func _on_PlayButton_pressed():
	get_node("/root/Global").goto_scene("res://Scenes/Game.tscn")


func _on_CreditsButton_pressed():
	get_node("/root/Global").goto_scene("res://Scenes/Credits.tscn")

extends Area2D
#class_name = moeda
#@export ui = Label e depois colocar nosso label no inspetor
@export var player:= CharacterBody2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	$AnimatedSprite2D.play("default")


func _on_body_entered(_body: Node2D) -> void:
	player.pontos += 1
	if player.pontos >= 5:
		print("acabou o minigames")
	queue_free() # deleta essa merda

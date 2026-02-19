extends CharacterBody2D
var pode_morrer = false
@export var personagem = Node2D

signal resetar 

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	velocity += get_gravity() * delta
	move_and_slide()


func _on_area_2d_2_body_entered(body: Node2D) -> void:
	if body == personagem:
		if personagem.global_position.y < global_position.y - 15:
			personagem.velocity.y = personagem.JUMP_VELOCITY
			self.queue_free()
		else:
			print("else")
			resetar.emit()
			#get_tree().change_scene_to_file("res://tscn/minigames_C1/minigame_pegarcarimbo.tscn")

extends Control

@export var player: PlayerController

func _ready() -> void:
	for inimigo in get_tree().get_nodes_in_group("inimigos"):
		print(inimigo)
		if not inimigo.resetar.is_connected(_on_enemy_resetar):
			inimigo.resetar.connect(_on_enemy_resetar)

func _on_enemy_resetar() -> void:
	call_deferred("_reiniciar_cena")

func _reiniciar_cena():
	var parent = get_parent()
	var scene_path = scene_file_path
	
	queue_free()
	
	var nova_fase = load(scene_path).instantiate()
	parent.add_child(nova_fase)

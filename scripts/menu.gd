extends Control


func _on_jogar_pressed() -> void:
	print("Trocando para cena de jogar")


func _on_config_pressed() -> void:
	print("Trocando para cena de Configs")


func _on_sair_pressed() -> void:
	print("Saindo do jogo")
	get_tree().quit()

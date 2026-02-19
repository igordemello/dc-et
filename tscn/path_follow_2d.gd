extends PathFollow2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if $enemy2:
		if self.progress_ratio < 0.5 :
			$"enemy2/AnimatedSprite2D".flip_h = false
			$"enemy2/AnimatedSprite2D".play('andar')
		else:
			$"enemy2/AnimatedSprite2D".flip_h = true
			$"enemy2/AnimatedSprite2D".play('andar')
		self.progress_ratio += delta * 0.1

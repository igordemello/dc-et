extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0
var pulou_inimigo = false
var pulo_duplo = false
var pode_pulo_duplo = false
var carimbos

@onready var player: PlayerController = $"../..".player

func _physics_process(delta: float) -> void:
	if player.current_state != player.PlayerState.FOCUSING:
		return

	if not is_on_floor():
		if pulo_duplo == true:
			if Input.is_action_just_pressed("ui_accept"):
				velocity.y = JUMP_VELOCITY
				pulo_duplo = false
			
		velocity += get_gravity() * delta*1.3
		$AnimatedSprite2D.play("jump")
		if velocity.y > 0:
			$AnimatedSprite2D.play("fall")
		
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		if pode_pulo_duplo:
			pulo_duplo = true

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
		$AnimatedSprite2D.flip_h = direction < 0
		if velocity.y == 0:
			$AnimatedSprite2D.play("walk")
	elif velocity.y == 0:
		$AnimatedSprite2D.play("idle")
		velocity.x = move_toward(velocity.x, 0, SPEED)
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		#$AnimatedSprite2D.play("walk")
		#self.scale.x = -1
	
	

	move_and_slide()

#func _process(delta: float) -> void:
	#$"../CanvasLayer/Label".text = "Vida:" + str(GameController.get_instance().vidas)
	

extends StaticBody3D


@onready var seat_position: Marker3D = $SeatPosition
@onready var exit_position: Marker3D = $ExitPosition

func interact(player):
	player.sit(self)

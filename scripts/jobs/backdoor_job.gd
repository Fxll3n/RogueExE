class_name BackdoorJob extends BaseJob

var steal_rate: float = 1.0
var successful_ticks: int = 0:
	set(value):
		successful_ticks = value
		detection_chance = float(successful_ticks)/100.0
var detection_chance: float = 0.0

func tick() -> void:
	if randi_range(0, 100) <= detection_chance: 
		GameState._print_line("[color=red]Your backdoor has been found! Access to target has been revoked.[/color]")
		finish()
	else:
		successful_ticks += 1
		GameState.increase_credits(steal_rate)

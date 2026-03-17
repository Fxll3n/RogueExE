extends Node

signal history_changed(new_history: String)
signal credits_changed(new_amount: float)

var history: String = "":
	set(value):
		history = value
		history_changed.emit(history)
var credits: float = 0.0:
	set(value):
		credits = value
		credits_changed.emit(credits)
var user: String = "user"
var destination: String = "home"

func _print_line(message: String) -> void:
	history += "%s\n" % message
	history_changed.emit(history)

func _clear_history() -> void:
	history = ""

func increase_credits(amount: float) -> void:
	credits += amount

func decrease_credits(amount: float) -> void:
	credits -= amount

func set_credits(amount: float) -> void:
	credits = amount

func get_prompt() -> String:
	return "[color=green]%s@%s $[/color]\t" % [user, destination]

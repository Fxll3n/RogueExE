extends Node

func parse_command(command_string: String) -> void:
	var split_command = command_string.split(" ")
	var command: String = split_command[0]
	split_command.remove_at(0)
	var arguments: PackedStringArray = split_command
	
	print("Commands: \t%s" % command)
	print("Arguments: \t%s" % arguments)

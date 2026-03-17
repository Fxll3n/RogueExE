extends Node

var command_registry: Dictionary[StringName, BaseCommand] = {}

func _ready() -> void:
	_register_all()

func _register_all() -> void:
	_register(EchoCommand.new(), "echo")
	_register(HackCommand.new(), "hack")
	_register(ClearCommand.new(), "clear")

func _register(command: BaseCommand, call_name: StringName) -> void:
	if command_registry.has(call_name):
		GameState._print_line("{0} could not be registered. A different command is already registered under {1}".format([command, call_name]))
		return
	elif not command_registry.find_key(command) == null:
		var original = command_registry.find_key(command)
		GameState._print_line("{0} is already registered under {1}".format([command, original]))
		return
	
	command_registry[call_name] = command

func parse_raw(raw: String) -> BaseCommand:
	var tokens: PackedStringArray = raw.split(" ")
	var command_name: String = tokens[0]
	tokens.remove_at(0)
	var args: Array[String] = []
	
	for token in tokens:
		args.append(token)
	
	if not command_registry.has(command_name):
		GameState._print_line("[color=red]Could not find %s in registry. Check spelling.[/color]" % command_name)
		return null
	
	var command: BaseCommand = command_registry.get(command_name)
	
	command.args = args
	
	return command

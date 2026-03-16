extends Control

@onready var menu_bar: Label = %MenuBar
@onready var ouput_lbl: RichTextLabel = %OuputLabel
@onready var command_line: TextEdit = %CommandLine

func _ready() -> void:
	command_line.text_changed.connect(_on_command_entered)

func _on_command_entered() -> void:
	var text: String = command_line.text
	if not text.contains("\n"): return
	
	var command: String = text.split("\n")[0]
	
	CommandManager.parse_command(command)
	command_line.clear()


	

extends Control

@onready var menu_bar: Label = %MenuBar
@onready var output_lbl: RichTextLabel = %OuputLabel
@onready var command_line: TextEdit = %CommandLine

var _committed_count: int = 0
var _output_tween: Tween
var _menu_tween: Tween

func _ready() -> void:
	command_line.text_changed.connect(_on_command_entered)
	GameState.history_changed.connect(_on_history_changed)
	GameState.credits_changed.connect(_on_credits_changed)
	
	menu_bar.text = "Logged in as {0} | Credits: {1}".format([GameState.user, GameState.credits])

func _on_command_entered() -> void:
	var text: String = command_line.text
	if not text.contains("\n"): return
	
	var raw: String = text.split("\n")[0]
	
	command_line.clear()
	GameState._print_line(GameState.get_prompt() + raw)
	
	var command: BaseCommand = CommandParser.parse_raw(raw)
	if not is_instance_valid(command): return
	command.execute() 

func _on_history_changed(new_history: String) -> void:
	output_lbl.text = new_history

	var new_count: int = output_lbl.get_total_character_count()
	var added: int = new_count - _committed_count

	if added > 0:
		# Kill any in-progress tween before starting a new one
		if is_instance_valid(_output_tween):
			_output_tween.kill()

		output_lbl.visible_characters = _committed_count
		_committed_count = new_count

		_output_tween = create_tween()
		_output_tween.tween_property(
			output_lbl,
			"visible_characters",
			new_count,
			added * 0.01
		).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN_OUT)

func _on_credits_changed(amount: float) -> void:
	if is_instance_valid(_menu_tween):
		_menu_tween.kill()
		
	var new_string: String = "Logged in as {0} | Credits: {1}".format([GameState.user, amount])
	_menu_tween = create_tween()
	_menu_tween.tween_property(menu_bar, "text", new_string, 0.5)

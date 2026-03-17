class_name EchoCommand extends BaseCommand

func execute() -> RESULT:
	if args.is_empty():
		GameState._print_line("[color=red]echo: missing argument.[/color]")
		return RESULT.FAILURE
	
	if not args.front().begins_with("\""):
		if args.size() > 1:
			GameState._print_line("[color=red]Unknown arguments:\t%s. Command \"echo\" takes only one argument.[/color]" % [args.slice(1)])
			return RESULT.FAILURE
	
		GameState._print_line("[color=cyan]%s[/color]" % args.front())
		return RESULT.OK
	
	var end_index: int = -1
	for i in args.size():
		if args[i].ends_with("\""):
			end_index = i
			break
	
	if end_index == -1:
		GameState._print_line("[color=red]echo: Unclosed quote.[/color]")
		return RESULT.FAILURE
	
	# Check if there are extra arguments
	var extra_args: Array = args.slice(end_index + 1) 
	if not extra_args.is_empty():
		GameState._print_line("[color=red]Unknown arguments:\t%s. Command \"echo\" takes only one argument.[/color]" % [extra_args])
		return RESULT.FAILURE
	
	var message: String = " ".join(args.slice(0, end_index + 1))
	
	GameState._print_line("[color=cyan]%s[/color]" % message)
	return RESULT.OK

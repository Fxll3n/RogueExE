class_name ClearCommand extends BaseCommand

func execute() -> RESULT:
	GameState.history = ""
	
	return RESULT.OK

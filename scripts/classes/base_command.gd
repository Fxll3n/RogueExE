class_name BaseCommand extends RefCounted

enum RESULT { OK, FAILURE, RUNNING }

var args: Array[String] = []

func execute() -> RESULT:
	GameState._print_line("[color=green]Command Finished![/color]")
	return RESULT.OK

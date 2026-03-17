class_name HackCommand extends BaseCommand

func execute() -> RESULT:
	if args.front() == "--backdoor" or args.front() == "-b":
		var backdoor: BackdoorJob = BackdoorJob.new()
		backdoor.duration = 1.0
		
		JobManager.register_job(backdoor)
		return RESULT.OK
	else:
		GameState._print_line("[color=dim_gray][b]This would be a minigame[/b][/color]")
		return RESULT.OK

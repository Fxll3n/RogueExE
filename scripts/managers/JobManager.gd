extends Node

var current_jobs: Array[BaseJob] = []

func register_job(job: BaseJob) -> void:
	if not is_instance_valid(job): return
	if current_jobs.has(job): return
	
	var t := Timer.new()
	add_child(t)
	t.one_shot = job.one_shot
	t.autostart = true
	t.start(job.duration)
	
	current_jobs.append(job)
	t.timeout.connect(job.tick)
	job.finished.connect(_on_job_finished)

func _on_job_finished(job: BaseJob) -> void:
	current_jobs.erase(job)

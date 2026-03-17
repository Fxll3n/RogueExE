class_name BaseJob extends RefCounted

signal finished(job: BaseJob)

var duration: float = 1.0
var one_shot: bool = false

func tick() -> void:
	pass

func finish() -> void:
	finished.emit(self)

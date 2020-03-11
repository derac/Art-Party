extends Node

static func if_error(error : int, message : String) -> int:
	if error:
		write(message)
	return error

static func write(message : String) -> void:
	print(message)

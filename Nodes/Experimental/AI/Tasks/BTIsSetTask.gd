extends BTLeaf

export var reversed : bool
export var bb_entry : String

func _tick(agent : Node, blackboard : Blackboard):
	if blackboard.has_data("bb_entry"):
		var data = blackboard.get_data("agent")
		if  data == null || data == false:
			return succeed() if reversed else failed()
		else:
			return failed() if reversed else succeed()

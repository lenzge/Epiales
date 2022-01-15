class_name BTMatch
extends BTComposite

export var condition_in_bb : String

func _tick(agent: Node, blackboard: Blackboard) -> bool:
	var result
	
	if(blackboard.has_data(condition_in_bb)):
		var condition = blackboard.get_data(condition_in_bb)
		bt_child = children[condition if condition < children.size() else children.size() - 1]
		
	result = bt_child.tick(agent, blackboard)
		
	if result is GDScriptFunctionState:
		result = yield(result, "completed")
	
	return succeed() if bt_child.succeeded() else fail()

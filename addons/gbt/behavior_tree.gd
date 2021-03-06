extends Node

const State = preload("res://addons/gbt/state.gd")
const Context = preload("res://addons/gbt/context.gd")
const Error = preload("res://addons/gbt/error.gd")

func _ready():
	if get_child_count() > 1:
		var msg = str("[ERR]: Behavior trees should only have one child, but ", name, " has ", get_child_count(), ".")
		return Error.new(self, msg) 

func tick(actor, blackboard):
	var ctx = Context.new(self, actor, blackboard)
	var result = State.FAILED
	for child in get_children():
		result = child._execute(actor)

	var last_open = blackboard.get(blackboard._OPEN_NODES_KEY, self)
	var curr_open = [] + ctx.open_nodes

	# close dangling nodes
	for node in last_open:
		if not node in curr_open:
			node._close(ctx)

	# update blackboard
	blackboard.set(blackboard._OPEN_NODES_KEY, curr_open, self)
	return result

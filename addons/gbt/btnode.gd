"""
BTNode is the base class for all nodes in a BehaviorTree. 
It is intended to be extended in custom scripts assigned to 
all nodes in a BheaviorTree, primarly Leaf nodes.
"""

extends Node

const State = preload("res://addons/gbt/state.gd")

const _KEY_IS_OPEN = "is_open"

func enter(ctx):
	"""
	enter is called once when the node is entered.

	params:
		ctx: The Context instance for this tick.
	"""
	pass

func open(ctx):
	"""
	open is called once the first time a node is entered.

	params:
		ctx: The Context instance for this tick.
	"""
	pass

func tick(ctx):
	"""
	tick is called each tick of the BehaviorTree.

	params:
		ctx: The Context instance for this tick.

	returns: the State for this tick (i.e. OK, FAILED, or RUNNING)
	"""
	return State.OK

func close(ctx):
	"""
	close is called once when the node returns either State.OK or State.FAILED.

	params:
		ctx: The Context instance for this tick.
	"""
	pass

func exit(ctx):
	"""
	exit is called once when the node is exited.
	
	params:
		ctx: The Context instance for this tick.
	"""
	pass

func _execute(ctx):
	enter(ctx)
	if !ctx.blackboard.get(_KEY_IS_OPEN, ctx.tree, self):
		_open(ctx)

	var result = tick(ctx)
	if result != State.RUNNING:
		_close(ctx)

	exit(ctx)

	return result

func _open(ctx):
	ctx.open_node(self)
	ctx.blackboard.set(_KEY_IS_OPEN, true, ctx.tree, self)
	open(ctx)

func _close(ctx):
	ctx.close_node(self)
	ctx.blackboard.set(_KEY_IS_OPEN, false, ctx.tree, self)
	close(ctx)

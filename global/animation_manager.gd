extends Node

var active_nodes : Dictionary = {}

func animation_starting(node: Node) -> void:
	if active_nodes.has(node):
		active_nodes[node] = active_nodes[node] + 1
	else:
		active_nodes[node] = 1

	print("Added Node: %s> %s" % [node, active_nodes])

func animation_finished(node: Node) -> void:
	if !active_nodes.has(node):
		pass
	elif active_nodes[node] == 1:
		active_nodes.erase(node)
	else:
		active_nodes[node] = active_nodes[node] - 1
	
	#print("Removed Node: %s> %s" % [node, active_nodes])
	
	if active_nodes.size() == 0:
		#print("Emitting Events.animations_complete")
		Events.animations_complete.emit()

func animation_count(node: Node) -> int:
	if !active_nodes.has(node):
		return 0
	return active_nodes[node]

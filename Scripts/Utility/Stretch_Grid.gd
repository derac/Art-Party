extends Container

class_name Stretch_Grid

func _notification(what):
	if (what==NOTIFICATION_SORT_CHILDREN):
		# Must re-sort the children
		var children = get_children()
		print(children)
		var children_len = children.size()
		
		var child_iter = 0
		var child_size := Vector2(0, 0)
		var child_pos := Vector2(0, 0)

		
		var cols := floor(sqrt(children_len))
		if cols > 0:
			child_size.x = (rect_size.x - (20 * (cols - 1))) / cols
			
			for col in range(cols):
				child_pos.x = col * (child_size.x + 20)
				var rows = cols + floor((children_len / cols) - cols)
				if col == (cols - 1):
					rows += (children_len - cols * rows)
				child_size.y = (rect_size.y - 20 * (rows - 1)) / rows
				for row in rows:
					child_pos.y = row * (child_size.y + 20)
					children[child_iter].rect_size = child_size
					children[child_iter].set_position(child_pos)
					child_iter += 1

func set_some_setting():
	# Some setting changed, ask for children re-sort
	queue_sort()

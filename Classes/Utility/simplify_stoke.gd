# Injest the stroke format we are using in Canvas.gd
static func simplify(stroke : Array, epsilon : float) -> Array:
	var pos_hist := []
	var speed_hist := []
	for pos in stroke:
		pos_hist.append(pos["position"])
		speed_hist.append(pos["speed"])
	pos_hist = douglas_peucker(pos_hist, speed_hist, epsilon)
	var new_stroke = []
	for pos in stroke:
		if pos_hist.has(pos["position"]):
			new_stroke.append(pos)
	return new_stroke

# modified douglas peucker algorithm to find speed difference as well
static func douglas_peucker(point_list : Array, speed_list : Array, epsilon : float) -> Array:
	# Find the point with the maximum distance
	# and maximum speed difference
	var dmax := 0
	var index := 0
	var smax := 0
	var sindex := 0
	var end := point_list.size() - 1
	for i in range(1, end):
		var d = perpendicular_distance(point_list[i],
									   point_list[0],
									   point_list[end])
		if (d > dmax):
			index = i
			dmax = d
		var smaller_end = speed_list[0] if speed_list[0] < speed_list[end] else speed_list[end]
		if speed_list[i] - smaller_end > smax:
			sindex = i
			smax = speed_list[i] - smaller_end
	
	# If max distance is greater than epsilon, recursively simplify
	if dmax > epsilon:
		return (douglas_peucker(point_list.slice(0, index - 1),
								speed_list.slice(0, index - 1), epsilon) +
				douglas_peucker(point_list.slice(index, end),
								speed_list.slice(index, end),epsilon))
	elif smax > 10.0:
		return (douglas_peucker(point_list.slice(0, sindex - 1),
								speed_list.slice(0, sindex - 1), epsilon) +
				douglas_peucker(point_list.slice(sindex, end),
								speed_list.slice(sindex, end),epsilon))
	else:
		return [point_list[0], point_list[end]]

static func perpendicular_distance(p_test : Vector2, p1 : Vector2, p2 : Vector2) -> float:
	var two_times_area := abs((p2.y - p1.y) * p_test.x - (p2.x - p1.x) * 
						  p_test.y + p2.x * p1.y - p2.y * p1.x)
	var base_length := p1.distance_to(p2)
	if base_length > 0:
		return two_times_area / base_length
	else:
		return 0.0

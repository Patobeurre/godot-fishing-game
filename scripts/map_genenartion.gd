extends Node3D


@export var GRID_SIZE := 11
@export var RANDOM_WALK_ITER := 5
@export var TILE_SIZE := 20

@export var tile: PackedScene = null

enum CELL_TYPE {
	EMPTY = 0,
	OCCUPIED = 1,
	VISIBLE = 2,
	COMPLETED = 3
}

var grid: Array[Array] = []


# Called when the node enters the scene tree for the first time.
func _ready():
	_generate_grid()
	print_grid()
	#_instantiate_tiles()
	

func print_grid():
	for row in grid:
		print(row)


func _initialize_grid():
	grid.clear()
	grid.resize(GRID_SIZE)
	for x in grid.size():
		grid[x].resize(GRID_SIZE)
		grid[x].fill(CELL_TYPE.EMPTY)
	
func _generate_grid():
	_initialize_grid()
	
	var center_pos_x = GRID_SIZE/2
	var center_pos_y = center_pos_x
	grid[center_pos_x][center_pos_y] = CELL_TYPE.VISIBLE
	
	_instantiate_cell(Vector2(center_pos_x, center_pos_y))
	
	var posU = Vector2(center_pos_x - 1, center_pos_y)
	var posD = Vector2(center_pos_x + 1, center_pos_y)
	var posL = Vector2(center_pos_x, center_pos_y - 1)
	var posR = Vector2(center_pos_x, center_pos_y + 1)
	grid[posU.x][posU.y] = CELL_TYPE.OCCUPIED
	grid[posD.x][posD.y] = CELL_TYPE.OCCUPIED
	grid[posL.x][posL.y] = CELL_TYPE.OCCUPIED
	grid[posR.x][posR.y] = CELL_TYPE.OCCUPIED
	
	for i in range(RANDOM_WALK_ITER):
		posL = _random_walk(posL)
		posR = _random_walk(posR)
		posU = _random_walk(posU)
		posD = _random_walk(posD)

func _get_available_neighbours(pos: Vector2, cell_type: CELL_TYPE) -> Array :
	var neighbours = [
		Vector2(pos.x - 1, pos.y),
		Vector2(pos.x + 1, pos.y),
		Vector2(pos.x, pos.y - 1),
		Vector2(pos.x, pos.y + 1)
	]
	
	var available_neighbours = []
	for n in neighbours:
		if _is_cell_of_type(n, cell_type):
			available_neighbours.append(n)
	
	return available_neighbours

func _is_cell_of_type(pos: Vector2, cell_type: CELL_TYPE) -> bool:
	return grid[pos.x][pos.y] == cell_type

func _instantiate_tiles():
	for x in range(GRID_SIZE):
		for y in range(GRID_SIZE):
			if grid[x][y] > CELL_TYPE.EMPTY:
				var t: Node3D = tile.instantiate()
				t.coord = Vector2(x,y)
				t.position = Vector3(x*100,0,y*100)
				t.area_completed.connect(_on_cell_completed)
				add_child(t)


func _instantiate_cell(pos: Vector2):
	var t: Node3D = tile.instantiate()
	t.coord = pos
	t.position = Vector3(pos.x*TILE_SIZE,0,pos.y*TILE_SIZE)
	t.area_completed.connect(_on_cell_completed)
	add_child(t)
	grid[pos.x][pos.y] = CELL_TYPE.VISIBLE
	

func _on_cell_completed(pos: Vector2):
	grid[pos.x][pos.y] = CELL_TYPE.COMPLETED
	var neighbours = _get_available_neighbours(pos, CELL_TYPE.OCCUPIED)
	for n in neighbours:
		_instantiate_cell(n)


func _random_walk(actual_pos: Vector2) -> Vector2 :
	var is_found = false
	
	var available_neighbours = _get_available_neighbours(actual_pos, CELL_TYPE.EMPTY)
	
	if available_neighbours.is_empty():
		return actual_pos
	
	var next_pos: Vector2 = available_neighbours.pick_random()
	grid[next_pos.x][next_pos.y] = CELL_TYPE.OCCUPIED
	
	return next_pos


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

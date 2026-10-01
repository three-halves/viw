class_name PolygonVisual
extends Polygon2D

@export var outline_color: Color = Color.WHITE
@export var outline_width: float
@export var warble_amplitude: float
var outline_poly;
var base_polygon;

func overwrite_polygon(p: PackedVector2Array):
	base_polygon = p

func _ready() -> void:
	outline_poly = Polygon2D.new()
	base_polygon = polygon.duplicate()
	print(base_polygon.size())
	
	outline_poly.color = outline_color
	add_sibling.call_deferred(outline_poly)
	outline_poly.transform = transform
	outline_poly.z_index = -1
	


func _process(dt: float) -> void:
	# warble effect
	outline_poly.color = outline_color
	var new_poly = PackedVector2Array(base_polygon)
	for i in base_polygon.size():
		if randf() > 0.7: continue;
		new_poly[i] += Vector2(
			randf_range(-warble_amplitude, warble_amplitude), 
			randf_range(-warble_amplitude, warble_amplitude)
		)
	
	polygon = new_poly
		
	# create offset outline
	var expanded = Geometry2D.offset_polygon(polygon, outline_width)
	if expanded.size() > 0:
		outline_poly.polygon = expanded[0]


		

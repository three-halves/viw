class_name Player
extends CharacterBody2D

@export var speed: float
@export var fric: float
@export var wave_handler: WaveHandler
@export var bullet_instance = preload("res://resources/bullet_instance.tscn")
@export var health_bar: TextureProgressBar
@export var audio: AudioStreamPlayer2D
@export var sfx: Dictionary[String, AudioStream] = {
	"hurt": preload("res://audio/Ouch.wav"),
	"lose": preload("res://audio/Lose.wav")
}

var itime: float = 0.0
var health: int = 4

func take_damage():
	itime = 1.0
	health -= 1
	print("AAAAAA ", health)
	health_bar.value = health
	if health <= 0:
		audio.stream = sfx["lose"]
		audio.play()
		do_lose()
	else:
		audio.stream = sfx["hurt"]
		audio.play()

		
func do_lose() -> void:
	$Camera2D.reparent(get_parent())
	wave_handler.handle_lose()
	hide()
	
func _ready():
	Engine.time_scale = 1.0
	health_bar.value = health
	itime = 1.5
	
func _process(delta):
	health_bar.position = position - Vector2(128, 128)
	health_bar.tint_progress.a = itime * 2.0 + 0.2

func _physics_process(delta: float) -> void:
	if health <= 0: return
#   get input the dumb way
	if (itime > 0): 
		itime -= delta
		$PlayerVisual.outline_color.g = 0
		if sin(Time.get_ticks_msec() / 40.0) > 0:
			$PlayerVisual.color.a = 0
		else:
			$PlayerVisual.color.a = 255
	else:
		$PlayerVisual.outline_color.g = 255
		$PlayerVisual.color.a = 255
	
	var wish_dir: Vector2 = Vector2.ZERO;
	if Input.is_key_pressed(KEY_UP) || Input.is_key_pressed(KEY_W):
		wish_dir.y -= 1;
	if Input.is_key_pressed(KEY_DOWN) || Input.is_key_pressed(KEY_S):
		wish_dir.y += 1;
	if Input.is_key_pressed(KEY_LEFT) || Input.is_key_pressed(KEY_A):
		wish_dir.x -= 1;
	if Input.is_key_pressed(KEY_RIGHT) || Input.is_key_pressed(KEY_D):
		wish_dir.x += 1;
		
	wish_dir = wish_dir.normalized()
		
	#print(wish_dir)
	
	look_at(get_global_mouse_position())
		
	velocity += wish_dir * speed;
	velocity *= fric;
	move_and_slide();
	
	for i in get_slide_collision_count()-1:
		var collision = get_slide_collision(i)
		collision.get_collider()
	
func spawn_shot(shot: ShotType, damage_mult: float, level: int) -> void:
#	TODO make (bullet, size, damage) its own type instead of 3 arrays
	for i in shot.bullets.size():
		var inst: BulletInstance = bullet_instance.instantiate()
		inst.setup(shot.bullets[i], rotation + deg_to_rad(shot.angle_offsets[i]), shot.base_damages[i] * damage_mult, level)
		inst.position = position
		get_parent().add_child(inst)
		
		
		
	

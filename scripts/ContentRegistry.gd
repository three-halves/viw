# class_name ContentRegistry
extends Node

var ENEMY_REGISTRY: Dictionary[String, Enemy] = {}

var WAVE_BEHAVIOR_REGISTRY: Array[WaveBehavior]

func _ready() -> void:
	# TODO dont hardcode base content pack
	var definitions: Array[PartialContentDefinition] = [preload("res://content/base/definition.tres")]
	
	for pcd in definitions:
		for k: String in pcd.enemy_definitions:
			ENEMY_REGISTRY[k] = pcd.enemy_definitions[k]
			
		for b: WaveBehavior in pcd.wave_behavior_definitions:
			WAVE_BEHAVIOR_REGISTRY.append(b)
			
	

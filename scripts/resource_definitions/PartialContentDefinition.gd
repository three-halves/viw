## Contains all core data and metadata for a content pack
class_name PartialContentDefinition
extends Resource

## All packs should hae unique ID
@export var id: String = ""

@export var enemy_definitions: Dictionary[String, Enemy]

@export var wave_behavior_definitions: Array[WaveBehavior]

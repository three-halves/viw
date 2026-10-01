@abstract class_name WaveBehavior
extends Resource

## X value is the wave this behavior will be applied. Y value is wave the behavior will be reverted.
## -1 for Y value means never reverted
## WAVE NUMBERS START AT 1
@export var wave_range: Vector2i = Vector2i(1, -1)

@abstract func apply_behavior(handler: WaveHandler) -> void

@abstract func revert_behavior(handler: WaveHandler) -> void

extends Node

var BPM: int = 160

# TODO Refactor how beats work to make this uneeded
var SIDE_EFFECT_REGISTRY: Dictionary[String, Callable] = {
	"dash":
		func(player: Player, level: int) -> void:
			player.velocity *= 2.5 + (0.5 * level)
			if (level == 2): player.itime = 1.0 / BPM * 60
}

# Settings autoload: volume + fullscreen, persisted to user://settings.cfg.
extends Node

const PATH := "user://settings.cfg"

var volume := 0.8
var fullscreen := false


func _ready() -> void:
	var cfg := ConfigFile.new()
	if cfg.load(PATH) == OK:
		volume = cfg.get_value("audio", "volume", 0.8)
		fullscreen = cfg.get_value("video", "fullscreen", false)
	apply()


func apply() -> void:
	AudioServer.set_bus_volume_db(0, linear_to_db(clampf(volume, 0.0001, 1.0)))
	var mode := DisplayServer.WINDOW_MODE_FULLSCREEN if fullscreen \
		else DisplayServer.WINDOW_MODE_WINDOWED
	if DisplayServer.window_get_mode() != mode:
		DisplayServer.window_set_mode(mode)


func save() -> void:
	var cfg := ConfigFile.new()
	cfg.set_value("audio", "volume", volume)
	cfg.set_value("video", "fullscreen", fullscreen)
	cfg.save(PATH)

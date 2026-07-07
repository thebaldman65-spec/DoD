# Music autoload: one looping stream player that survives scene changes.
# play() is idempotent — calling it with the track already playing does nothing,
# so map music keeps flowing through party/shop screens.
extends Node

const TRACKS := {
	"menu": "res://assets/music/menu.mp3",
	"map": "res://assets/music/map.mp3",
	"battle": "res://assets/music/battle.mp3",
	"boss_intro": "res://assets/music/boss_intro.mp3",
}
const MUSIC_DB := -10.0  # under the SFX

var _player: AudioStreamPlayer
var _current := ""
var _next := ""  # queued track for intro → loop handoffs


func _ready() -> void:
	_player = AudioStreamPlayer.new()
	_player.volume_db = MUSIC_DB
	_player.finished.connect(_on_finished)
	add_child(_player)


func play(track: String, loop := true) -> void:
	if _current == track and _player.playing:
		return
	_next = ""
	_current = track
	var stream: AudioStream = load(TRACKS[track])
	stream.loop = loop
	_player.stream = stream
	_player.play()


# Plays `intro` once, then switches to `then` on loop (boss battles).
func play_intro_then(intro: String, then: String) -> void:
	play(intro, false)
	_next = then


func stop() -> void:
	_current = ""
	_next = ""
	_player.stop()


func _on_finished() -> void:
	if _next != "":
		var upcoming := _next
		_next = ""
		play(upcoming)

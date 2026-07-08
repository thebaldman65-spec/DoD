# Music autoload: one looping stream player that survives scene changes.
# play() is idempotent — calling it with the track already playing does nothing,
# so map music keeps flowing through party/shop screens. Also owns the shared
# UI click sound for menu buttons.
extends Node

# track -> [path, volume_db]
const TRACKS := {
	"menu": ["res://assets/music/menu.mp3", -10.0],
	"map": ["res://assets/music/map.mp3", -4.0],
	"battle": ["res://assets/music/battle.mp3", -10.0],
	"boss_intro": ["res://assets/music/boss_intro.mp3", -10.0],
}

var _player: AudioStreamPlayer
var _click_player: AudioStreamPlayer
var _current := ""
var _next := ""  # queued track for intro → loop handoffs


func _ready() -> void:
	_player = AudioStreamPlayer.new()
	_player.finished.connect(_on_finished)
	add_child(_player)
	_click_player = AudioStreamPlayer.new()
	_click_player.stream = load("res://assets/sfx/menu_click.wav")
	_click_player.volume_db = -10.0
	add_child(_click_player)


func play(track: String, loop := true) -> void:
	if _current == track and _player.playing:
		return
	# A handoff to this track is already queued (e.g. the boss tune finishing
	# over the node map) — let the intro play out instead of cutting it short.
	if _next == track and _player.playing:
		return
	_next = ""
	_current = track
	var stream: AudioStream = load(TRACKS[track][0])
	stream.loop = loop
	_player.stream = stream
	_player.volume_db = TRACKS[track][1]
	_player.play()


# Plays `intro` once, then switches to `then` when it ends (boss battles,
# spec-confirmation → map).
func play_intro_then(intro: String, then: String) -> void:
	play(intro, false)
	_next = then


func stop() -> void:
	_current = ""
	_next = ""
	_player.stop()


# Shared click for menu buttons.
func click() -> void:
	_click_player.play()


func _on_finished() -> void:
	if _next != "":
		var upcoming := _next
		_next = ""
		play(upcoming)

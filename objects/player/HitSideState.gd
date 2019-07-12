extends "StateBase.gd"

const Direction = preload("res://enums/Direction.gd").Direction
const State = preload("States.gd").State
const Hitbox = preload("Hitbox.gd")

var _ball
var _ball_hit
var _hitbox

func _init(player, ball).(player):
    _ball = ball

func enter():
    _ball_hit = false
    _hitbox = Hitbox.new(_player.get_position(), _player.get_side_hitbox(), _player.get_facing())

    _player.set_velocity(Vector3(0, 0, 0))
    if _player.get_facing() == Direction.LEFT:
        _player.get_animation_player().play("hit_side_left_long")
    elif _player.get_facing() == Direction.RIGHT:
        _player.get_animation_player().play("hit_side_right_long")
    else:
        assert(false)

func exit():
    pass

func get_state_transition():
    if not _player.get_animation_player().is_playing():
        return State.NEUTRAL
    return null

func process(delta):
    _render_hitbox()

func physics_process(delta):
    # TODO: There should be a better way to determine when the hitbox is active on the animation.
    if _player.get_animation_player().get_current_animation_position() < 0.1 and not _ball_hit:
        if _hitbox.intersects_ball(_ball):
            _player.fire(1000, 100, Vector3(80, 0, 50))
            _ball_hit = true

func _render_hitbox():
    var result = _hitbox.get_render_position()
    var hitbox_display = _player.get_node("HitboxDisplay")
    hitbox_display.set_global_position(result["position"])
    hitbox_display.set_size(result["size"])
# State when the player is hitting the ball.
extends State

export (NodePath) var _player_path = NodePath()
onready var _player = get_node(_player_path)

export (NodePath) var _input_handler_path = NodePath()
onready var _input_handler = get_node(_input_handler_path)

export (NodePath) var _status_path = NodePath()
onready var _status = get_node(_status_path)

export (NodePath) var _animation_player_path = NodePath()
onready var _animation_player = get_node(_animation_player_path)

const Action = preload("res://enums/Common.gd").Action
const Direction = preload("res://enums/Common.gd").Direction

var _ball_hit

func enter(message = {}):
    _ball_hit = false

    if _player.TEAM == 1:
        _animation_player.play("hit_overhead_right_long")
    elif _player.TEAM == 2:
        _animation_player.play("hit_overhead_left_long_down")

func exit():
    pass

func get_state_transition():
    if not _animation_player.is_playing():
        return "Neutral"

func process(delta):
    pass

func physics_process(delta):
    if not _ball_hit:
        var depth
        var side
        var spin = 0
        var control = 50

        if _player.TEAM == 1:
            depth = 210
        elif _player.TEAM == 2:
            depth = 570

        if _status.serving_side == Direction.LEFT:
            side = 247.5
        elif _status.serving_side == Direction.RIGHT:
            side = 112.5

        if _input_handler.is_action_pressed(Action.LEFT):
            side -= control
        elif _input_handler.is_action_pressed(Action.RIGHT):
            side += control

        if _input_handler.is_action_pressed(Action.TOP):
            spin = -100
        elif _input_handler.is_action_pressed(Action.SLICE):
            spin = 100

        var goal = Vector3(side, 0, depth)

        owner.emit_signal("serve_ball", 1200, spin, goal)
        _status.meter += 10
        _status.can_hit_ball = false
        _ball_hit = true
"""
Node storing all of the changeable values for the player.
"""
extends Node

export (NodePath) var _player_path = NodePath()
onready var _player = get_node(_player_path)

signal position_updated(position)
signal meter_updated(meter)

# Position of player on the court without transformations.
# (0, 0, 0) = top left corner of court and (360, 0, 780) = bottom right corner of court
var position : Vector3 setget set_position
var velocity : Vector3
var meter : int setget set_meter
var charge : int
var facing : int # Direction
var serving_side : int # Direction
var can_hit_ball : bool

func set_meter(value):
    meter = clamp(value, 0, 100)
    emit_signal("meter_updated", meter)

func set_position(value):
    position = value
    if _player.TEAM == 1:
        position.z = max(position.z, 410)
    elif _player.TEAM == 2:
        position.z = min(position.z, 370)
    emit_signal("position_updated", position)
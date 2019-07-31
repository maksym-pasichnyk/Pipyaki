meta:
  id: map2
  file-extension: map
  endian: be
seq:
  - id: magic
    contents: [169]
  - id: type
    contents: [2]
  - id: version
    type: u4
  - id: width
    type: u1
  - id: height
    type: u1
  - id: data_size
    type: u4
  - id: data
    type: level_data
  - id: params_count
    type: u4
  - id: track
    type: u1
  - id: difficulty
    type: u1
  - id: intro
    type: u1
types:
  level_data:
    seq:
      - id: layers
        type: layers
        size: _root.data_size
  layers:
    seq:
      - id: entries
        type: layer
        repeat: eos
  layer:
    seq:
      - id: layer
        type: u1
      - id: data
        type:
          switch-on: layer
          cases:
            0: layer_1
            1: layer_2
            2: layer_3
            3: layer_4
            4: layer_5
  layer_1:
    seq:
      - id: tiles
        size: _root.width * _root.height
  layer_2:
    seq:
      - id: tiles
        size: _root.width * _root.height
  layer_3:
    seq:
      - id: count
        type: u2
      - id: tiles
        type: wall
        repeat: expr
        repeat-expr: count
  wall:
    seq:
      - id: x
        type: u1
      - id: y
        type: u1
      - id: type
        type: u1
      - id: data
        type: wall_data
        if: type != 0xFF
  wall_data:
    seq:
      - id: type
        type: u1
      - id: subtype
        type: u1
  layer_4:
    seq:
      - id: count
        type: u4
      - id: tiles
        type: object
        repeat: expr
        repeat-expr: count
  object:
    seq:
      - id: x
        type: u2
      - id: y
        type: u2
      - id: type
        type: u1
      - id: subtype
        type: u1
  layer_5:
    seq:
      - id: count
        type: u4
      - id: tiles
        type: special
        repeat: expr
        repeat-expr: count
  special:
    seq:
      - id: type
        type: u1
      - id: x
        type: u1
      - id: y
        type: u1
      - id: data
        type:
            switch-on: type
            cases:
              0: spawn_point
              1: static_weapon
              2: trampoline
              3: pickable_item
              4: flag_blue
              5: flag_red
              6: death_zone
              7: trigger
              8: particle
  spawn_point:
    seq:
      - id: params_count
        contents: [11]
      - id: race
        type: u1
      - id: total_count
        type: u1
      - id: max_alives
        type: u1
      - id: spawn_period
        type: u1
      - id: behaviour
        type: u1
      - id: team
        type: u1
      - id: inactive
        type: u1
      - id: skill_level
        type: u1
      - id: can_kill
        type: u1
      - id: can_prosecue
        type: u1
      - id: fast_spawn
        type: u1
  static_weapon:
    seq:
      - id: params_count
        contents: [2]
      - id: type
        type: u1
      - id: spawned
        type: u1
  trampoline:
    seq:
      - id: params_count
        contents: [2]
      - id: direction
        type: u1
      - id: distance
        type: u1
  pickable_item:
    seq:
      - id: params_count
        contents: [3]
      - id: type
        type: u1
      - id: invisible
        type: u1
      - id: spawned
        type: u1
  flag_blue:
    seq:
      - id: params_count
        contents: [0]
  flag_red:
    seq:
      - id: params_count
        contents: [0]
  death_zone:
    seq:
      - id: params_count
        contents: [1]
      - id: type
        type: u1
  trigger:
    seq:
      - id: params_count
        contents: [15]
      - id: action
        type: u1
      - id: width
        type: u1
      - id: height
        type: u1
      - id: executor
        type: u1
      - id: target_x
        type: u1
      - id: target_y
        type: u1
      - id: execution_times
        type: u1
      - id: execution_delay
        type: u1
      - id: active
        type: u1
      - id: execute_at_fire
        type: u1
      - id: execute_at_use
        type: u1
      - id: activate_trigger_x
        type: u1
      - id: activate_trigger_y
        type: u1
      - id: execute_trigger
        type: u1
      - id: parameter
        type: u1
  particle:
    seq:
      - id: params_count
        contents: [5]
      - id: type
        type: u1
      - id: delta_x
        type: u1
      - id: delta_y
        type: u1
      - id: active
        type: u1
      - id: ttl
        type: u1
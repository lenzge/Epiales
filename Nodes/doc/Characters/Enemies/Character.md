# Character

**inherits:** KinematicBody2D > Character

## Description

A base for 2D Character. Can receive damage, implements basic movement, basic animation and logic components.

## Signal Descriptions

- died()

  Emits when the character died.

## Property Descriptions

### exports

- float **gravity**

  Gravitation force acting upon the Character.

- float **air_drag**

  Air drag factor counteracting to velocity.

- float **health**

  Current health status of the character.

- float **max_health**

  Maximal health the character is able to have.

### public

- StateMachine **state_machine**

  The Statemachine executing the character's logic behavior.

- DamageReceiver **hitbox**

  The box receiving hit events.

- AnimationPlayer **animation**

  The AnimationPlayer playing the character's animation.

- Vector2 **velocity**

  The current velocity the chracter is moving.

- bool **is_running**

  **true** if the player is supposed to run. Set to switch between running and walking.

- bool **is_facing_right**

  **true** if the character is facing right. Use **flip()** to flip facing direction. 
  
  **Note:** if you set this variable it's calling **set_is_facing(** bool value **)**

- bool **can_die**

  **true** if the character should switch to **Die**-state when health is smaller than zero.

### private

- Vector2 **_move_input**

  The current pending move input.


## Method Descriptions

### public

- void **move(** Vector2 value **)**
  
  Call this to set a move impluse.


- Vector2 **get_move( )**

  Returns the current move impluse.

- Vector2 **consume_move( )**

  Returns the current move impluse and resets it to zero.

- bool **set_invincible(** bool value **)**

  Sets wether the character can be hit.

- bool **set_is_facing_right(** bool value **)**

  Sets the facing direction. **true** for facing right. 

  **Note:** Rather call **flip( )** instead.

- bool **flip( )**

  Flips the character along the y axis. It's using the scale for it.

  **Note:** if you want a Node to not flip with the character you need to inverse the **scale.x** of it.

- void **apply_air_drag(** float delta **)**

  Applies air drag onto the current velocity. Using the **air_drag**-property for it. **delta** is the used delta time. 

- void **apply_air_drag_on_x(** float delta **)**

  Applies air drag onto the current velocity restricted to the x axis. Using the **air_drag**-property for it. **delta** is the used delta time. 

- void **apply_air_drag_on_y(** float delta **)**

  Applies air drag onto the current velocity restricted to the y axis. Using the **air_drag**-property for it. **delta** is the used delta time. 

- void **on_hit(** DamageEmitter emitter **)**

  Call this if the character got hit. **emitter** is the DamageEmitter the character got hit by.

### private

- void **_set_up()**

  Sets the character up.

## Node Composition

  - Character [Character]
    - Sprite [Sprite]
    - Shape [CollisionShape2D]
    - Hitbox [DamageReceiver]
      - Shape [CollisionShape2D]
    - StateMachine [StateMachine]
    - AnimationPlayer [AnimationPlayer]

  ### Hitbox

  The Collision Object the character receives damage through.

  ### StateMachine

  The StateMachine executing logic behavior of the character.

## Signal Connections

 ```mermaid
 graph LR
hitbox["Hitbox (Node) : on_hit_start()"] --> chracter["Character (Node) : on_hit()"]
```
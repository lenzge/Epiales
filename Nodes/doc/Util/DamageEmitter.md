# DamageEmitter
**Inherits**: Area2D > DamageEmitter
## Description
Emits damage to overlaping DamageReceiver objects. Contains data about dealt damage.

## Properties
### public

 - Node **emitter**
 
 A reference to the Node emitting the Damage. **Example:** A archer is a emitter of a arrow DamageEmitter object.
 
 - float **damage_amount**
 
 The dealt damage.

 - float **knockback_force** 

  The force of the commited hit.

- Vector2 **direction**

  Where the force is directed. If it is zero the direction is calculate from the center of the Area.

### private
 - bool **is_consumed**
  
  Wheter the damage is already consumed. So **hit()** and **blocked()** signals get called only once in a **_physics_process**-tick.

 - Array **collision_shapes**
  
  Array of attached **CollisionShapes2D** and **CollisionPolygon2D**

## Signals

 - **blocked(** DamageReceiver receiver **)**
  
  Emitted when the DamageEmitter got blocked by a DamageReceiver.

 - **hit(** DamageReceiver receiver **)**
  
  Emitted when the DamageEmitter has hit a DamageReceiver.

## Methods
  - **blocked(** DamageReceiver receiver **)**
  
  Call this if a DamageReceiver received the emission and blocked it.

 - **hit(** DamageReceiver receiver **)**

  Call this if a DamageReceiver received the emission and got hit.

 - **set disabled(** bool disabled **)**
  
  Set **true** to disable the emission.

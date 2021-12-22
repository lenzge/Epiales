# DamageReceiver
**Inherits:** Area2D > DamageReceiver
## Description
 Receives damage form overlaping DamageEmitter objects. Emits signals to react to hits.
## Properties
 - Node **receiver**
  
  A reference to the Node receiving the Damage. **Example:** A seperate body part (extra Node) of a boss enemy receives damage, the receiver is the boss not the body part.
## Signals
 - **on_start_hit(** DamageEmitter emitter **)**
  
  Emits when a DamageEmitter starts overlaping the DamageReceiver.
 
 - **on_stop_hit(** DamageEmitter emitter **)**
  
  Emits when a DamageEmitter stops overlaping the DamageReceiver.

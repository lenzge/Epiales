# PlayerState
**Inherits**: State > PlayerState
## Description
Every state the player can assume, inherits from **PlayerState**.

## Property Descriptions
### private
 - Player **player**

 Every state knows the player who uses it. States use its variables and methods.

 - Timer **timer**

 Can be used by every state. Stops automatically on exit. Has to be set and start manually in the enter method, if needed.

 - AnimationPlayer **animationPlayer**

 States know the animation player of the player to change animations.


## Method Descriptions
### private
 - **_ready_()**

 Set Owner as **player**. Init **timer**.

 - **enter(**_msg := {}**)**

 
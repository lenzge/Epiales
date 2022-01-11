# ChargeController
**Inherits**: Control > ChargeController
## Description
Controls the Chargepoints of the Player. 
charge_points will be increased by successful blocking. Decreased by Charged Attacks/Dashes

## Property Descriptions
### private
 - var **_charge_points**

 - var **_max_charge_points**

 - var **_progress_per_point**

 - var **progress_bar**


## Method Descriptions
### public
 - **has_charge()**

 Checks if Player can do a charged action.

### private
 - **_on_charged_action()**

 Connected to **Player.gd**. Decreases *_charge_points* by one.

 - **_on_blocked()**

 Connected to **Player.gd**. Increases *_charge_points* by one.
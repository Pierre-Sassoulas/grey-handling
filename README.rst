grey-handling
=============

This addon aims to **make decisions about your objects easier when you have to
throw them or give them away**. It helps you know what are your cheapest objects
faster.

What does it do?
----------------

- Displays the **price and maximum stack of items in tooltip**
- If your bag are full **pick the worst item** (left click to throw or give)
- If there isn't a worst item **make your two worst items glow in bag**

The two worst item are the cheapest at the moment and the cheapest once fully
stacked

Compatibility with other bags addons
------------------------------------

- **OneBag3**
- **ArkInventory** (But the orange glow is replaced with a bright yellow glow that is not removed by mouseover)

Orange glow does not work with :

- **Inventorian**
- All other bag addons that do not use the blizzard default bag interface

If the orange glow does not work, **there is an optional text explanation**.

.. image:: examples/emergency_problematic_looting_situation.jpg
   :width: 600pt

What does it do in detail?
--------------------------

For example, if you have:

* 4 leather skins worth 4*5 coppers = 20 coppers
* 1 cloth robe worth 25 coppers
* 1 cape (muddy, and only for demonists), worth 8 coppers

The muddy cape can't stack and is your cheapest item. If you activate the addon,
it pick the cape up and **you just have to left click to get rid of the cape**
(or right click to cancel the pick up).

Then if you throw away the cape, the 4 leather skins are cheaper than the robe,
but the addon know you can stack 20 of them together, so 20 stacked leather
skins are worth 100c and are more valuable than the cloth robe that can't be stacked.
**Both items will glow in orange inside your bags**, giving you the final choice.
Because you're the only one who knows how close or not you are from a vendor or
if you're going to be killing 50 more boars with leather skins.

# 13. Free camera mode

Goal: detach the camera from Ratchet and move it freely (photo mode / debug).

## Design

- Toggle by combo or checkbox (item 8).
- Freeze player input and game logic optionally; take over camera
  position/orientation (pos, target/yaw/pitch) after the game's camera update
  (hook at the end of camera update; otherwise the game overwrites it).
- Controls: left stick move, right stick look (item 1), L2/R2 down/up (item 2).
- Speed multiplier and collision off.

## Unknown

Camera object layout (matrix vs pos+target), update call site, culling
dependence on the camera (objects may vanish when far from the player).

## Approach

Find camera pos via value-scan while walking; write-probe to confirm; locate
the writer function; install a post-hook that substitutes pose when active.
Dependence: items 1, 2, 4.

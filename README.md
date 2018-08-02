# ARCore-CC
A library for ComputerCraft with Plethora that handles perspective projection for creating VR/AR applications with the overlay glasses.
<br><br>
### It sucks / is inperformant / could be improved
Please, please do improve ARCore and submit pull requests!

<br><br>
### How to use ARCore?

Download the ARCore library by executing the following in your shell:
```
wget https://raw.githubusercontent.com/Wendelstein7/ARCore-CC/master/ARCore.lua ARCore.lua
```

Now we're going to make a program, so use `edit` to create a new lua file.
First we need to make sure that we can access ARCore's functionality. We use lua's require.<br>
```
ARCore = require("ARCore")
```

Then, we ofcourse will need to start with Plethora's overlay glasses. We wrap the modules and create the canvas.
```
local modules = peripheral.wrap("back")
local canvas = modules.canvas()
```

Following, we setup some user-dependant variables and we must prepare some calculations for performance reasons.
```
local fov = 80
local ar = 1.8

local preparedCanvas = ARCore.prepare(canvas, fov, ar)
```

Now we can project some 3D point to our 3D screen! We get the rotation of the camera and define the coordinates for our point in 3D-space. <br>We pass the 3D coordinates to `ARCore.project` and it returns 2D coordinates and distance, which we use for drawing to the overlay glasses.
```
local meta = modules.getMetaOwner()
local yaw = math.rad(meta.yaw)
local pitch = math.rad(meta.pitch)

local indicator = "point"
local indicatorSize = 16

local valid, x, y, distance = ARCore.project(x, y, z, preparedCanvas, yaw, pitch, false)

canvas.addText({x - (2 * indicatorSize / distance), y - (2 * indicatorSize / distance)}, indicator, 0xFFFFFFFF, indicatorSize / distance)
```

And boom, we've projected the 3D point onto our 2D canvas. Sorry for this massively incomprehensible tutorial, see the examples to get a better understanding.
<br><br>
### NOTE: USE [PLETHORA'S BUILD-IN 3D FUNCTIONS](https://github.com/SquidDev-CC/plethora/pull/106) ONCE THEY ARE AVAILABLE INSTEAD OF ARCORE
Because ARCore ruins your performance. ARCore's purpose is to only function while Plethora lacks 3D functionality.

local _ = {}

_.name = "ARCore"
_.author = "HydroNitrogen"
_.website = "https://github.com/Wendelstein7/ARCore-CC"
_.version = 1
_.date = "2018-08-01"

local function rotate(x, y, z, yaw, pitch)
  local ysin = math.sin(yaw)
  local ycos = math.cos(yaw)
  local psin = math.sin(pitch)
  local pcos = math.cos(pitch)
  newx = ycos * x + ysin * z
  newz = -ysin * x + ycos * z
  newy = pcos * y - psin * newz
  newz = psin * y + pcos * newz
  return newx, newy, newz
end

local function toPerspective(x, y, z, scrhor, scrver, cxh, cyh)
    x = ( scrhor * x / z ) * cxh + cxh
    y = (scrver * y / z ) * cyh + cyh
    return x, y
end

local function isOnScreen(x, y, d, cx, cy)
    return ( x >= 1 and x < cx ) and ( y >= 1 and y < cy )
end

local function getDistance(x, y, z)
    return math.sqrt(x * x + y * y + z * z)
end

local function expect(func, n, arg, expected)
  if type(arg) ~= expected then return error(('%s: bad argument #%d (expected %s, got %s)'):format(func, n, expected, type(arg)), 2) end
end

function _.prepare(canvas, fov, ar)
  expect('prepare', 1, canvas, 'table'); expect('prepare', 2, fov, 'number'); expect('prepare', 3, ar, 'number');
  if fov >= 180 or fov <= 0 then error('prepare: bad argument #1 (fov must be more than 0 and less than 180)', 2) end
  local prepared = {}
  prepared.fov = math.rad(fov)
  prepared.ar = ar
  prepared.scrHor = (1 / math.tan(prepared.fov / 2)) / ar
  prepared.scrVer = (1 / math.tan(prepared.fov / 2))
  prepared.xMax, prepared.yMax = canvas.getSize()
  return prepared
end

function _.project(x, y, z, preparedCanvas, yaw, pitch, limitToScreen)
  expect('project', 1, x, 'number'); expect('project', 2, y, 'number');
  expect('project', 3, z, 'number'); expect('project', 4, preparedCanvas, 'table');
  expect('project', 5, yaw, 'number'); expect('project', 6, pitch, 'number');
  expect('project', 7, limitToScreen, 'boolean');
  local d = getDistance(x, y, z)
  x, y, z = rotate(x, y, z, yaw, pitch)
  if z < 0 then return false, 'object not in front of view' end
  x, y = toPerspective(x, y, -z, preparedCanvas.scrHor, preparedCanvas.scrVer, preparedCanvas.xMax / 2, preparedCanvas.yMax / 2)
  if limitToScreen and not isOnScreen(x, y, d, preparedCanvas.xMax, preparedCanvas.yMax) then return false, 'object not within field of view' end
  return true, x, preparedCanvas.yMax - y, d
end

return _

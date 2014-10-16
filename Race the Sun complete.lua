scriptId = 'com.thalmic.examples.racethesun'

description = [[
Race the Sun

Problems? Talk to Paul (@PBernhardt)

Controls:
 - Hold thumb to pinky to enable/disable mouse control
 - Wave in/out to click
 - Fist to center your yaw/roll, and then yaw left/right to fly left/right
 - Wave up/down to jump if you get a jump pickup
 - Fingers spread to hit escape and pause or back up in the menus
 
 Demo here: http://www.kongregate.com/games/flippfly/race-the-sun ]]

centreYaw = 0
centreRoll = 0

deltaRoll = 0

YAW_DEADZONE = .1
ROLL_DEADZONE = .2
MOUSE_CONTROL_TOGGLE_DURATION = 2000

PI = 3.1416
TWOPI = PI * 2

flyingLeft = false
flyingRight = false

togglingMouseControl = 0
mouseEnabled = true

printCount = 0

function onForegroundWindowChange(app, title)
	--myo.debug("onForegroundWindowChange: " .. app .. ", " .. title)
	local titleMatch = string.match(title, "Race The Sun") ~= nil or string.match(title, "RaceTheSun") ~= nil
	--myo.debug("Race the Sun: "  .. tostring(titleMatch))
	myo.controlMouse(titleMatch and mouseEnabled);
	return titleMatch;
end

function onPoseEdge(pose, edge)
    --myo.debug("onPoseEdge: " .. pose .. ", " .. edge)
	if (edge == "on") then
		if (pose == "fist") then
			centre()
			if (mouseEnabled) then
				toggleMouseControl()
			end
		elseif (pose == "fingersSpread") then
			escape()
		elseif (pose == "waveIn" or pose == "waveOut") then
			if (mouseEnabled) then
				leftClick()
			elseif (math.abs(deltaRoll) > ROLL_DEADZONE) then
				jump()
			end
		elseif (pose == "thumbToPinky") then
			togglingMouseControl = myo.getTimeMilliseconds()
		end
	else
		togglingMouseControl = 0
	end
end

function activeAppName()
    return "Race The Sun"
end

function centre()
	--myo.debug("Centred")
	centreYaw = myo.getYaw()
	centreRoll = myo.getRoll()
	myo.vibrate("short")
end

function onPeriodic()
	if (togglingMouseControl > 0 and myo.getTimeMilliseconds() > (togglingMouseControl + MOUSE_CONTROL_TOGGLE_DURATION)) then
		togglingMouseControl = 0
		toggleMouseControl()
	end
	
	if (centreYaw == 0) then
		return
	end
	local currentYaw = myo.getYaw()
	local currentRoll = myo.getRoll()
	local deltaYaw = calculateDeltaRadians(currentYaw, centreYaw)
	deltaRoll = calculateDeltaRadians(currentRoll, centreRoll);
	printCount = printCount + 1
	if printCount >= 200 then
		--myo.debug("deltaYaw = " .. deltaYaw .. ", centreYaw = " .. centreYaw .. ", currentYaw = " .. currentYaw)
		--myo.debug("deltaRoll = " .. deltaRoll .. " currentRoll = " .. currentRoll)
		printCount = 0
	end
	if (deltaYaw > YAW_DEADZONE) then
		flyLeft()
	elseif (deltaYaw < -YAW_DEADZONE) then
		flyRight()
	else
		flyNeutral()
	end
end

function flyLeft()
	if (flyingRight) then
		--myo.debug("Not flying right");
		myo.keyboard("right_arrow","up")
		flyingRight = false
	end
	if (not flyingLeft) then
		--myo.debug("Flying left");
		myo.keyboard("left_arrow","down")
		flyingLeft = true;
	end
end

function flyRight()
	if (flyingLeft) then
		--myo.debug("Not flying left");
		myo.keyboard("left_arrow","up")
		flyingLeft = false
	end
	if (not flyingRight) then
		--myo.debug("Flying right");
		myo.keyboard("right_arrow","down")
		flyingRight = true
	end
end

function jump()
	--myo.debug("Jump!")
	myo.keyboard("space","press")
end

function flyNeutral()
	if	(flyingLeft) then
		--myo.debug("Not flying left");
		myo.keyboard("left_arrow","up")
		flyingLeft = false
	end
	if (flyingRight) then
		--myo.debug("Not flying right");
		myo.keyboard("right_arrow","up")
		flyingRight = false
	end
end

function calculateDeltaRadians(currentYaw, centreYaw)
	local deltaYaw = currentYaw - centreYaw
	
	if (deltaYaw > PI) then
		deltaYaw = deltaYaw - TWOPI
	elseif(deltaYaw < -PI) then
		deltaYaw = deltaYaw + TWOPI
	end
	return deltaYaw
end

function toggleMouseControl()
	mouseEnabled = not mouseEnabled
	myo.vibrate("medium")
	if (mouseEnabled) then
		--myo.debug("Mouse control enabled")		
		centreYaw = 0
		flyNeutral()
	else
		--myo.debug("Mouse control disabled")
	end
	myo.controlMouse(mouseEnabled);
end

function leftClick()
	--myo.debug("Left click!")
	myo.mouse("left", "click")
end

function escape()
	--myo.debug("Escape!")
	myo.keyboard("escape","press")
end	
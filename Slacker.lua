scriptId = 'com.thalmic.examples.slacker'
description = [[
Slacker Contoller

Controls:
- Fist to take/release control, can be performed on Slacker page before music is playing, or sway.fm page
- Wave left/right to next/prev tracks
- Finger spread to play/pause

Owner: Paul

This takes advantage of the Chrome browser plugin sway.fm to control Slacker.

You need to map the keys in Sway to alt-right, alt-left, alt-down and alt-up for next, prev, play/pause, and activate Sway respectively.

This would control anything else Sway supports, but it will only activate on Slacker or the sway.fm page.

Known Issues:
- If release control accidently, it's a hassle to get it back (you have to go back to sway.fm)

]]
active = false
locked = true
appTitle = ""

ENABLED_TIMEOUT = 2200

UNLOCK_HOLD_DURATION = 400

unlocking = 0


function onForegroundWindowChange(app, title)
    myo.debug("onForegroundWindowChange: " .. app .. ", " .. title)
	local foundSlacker = string.match(title, "Slacker") ~= nil or string.match(title, "sway.fm") ~= nil
	if (foundSlacker) then
		appTitle = title
		myo.debug("Slacker controls now active")
	end
    return foundSlacker or active
end

function activeAppName()
	return appTitle
end

function onPoseEdge(pose, edge)
	myo.debug("onPoseEdge: " .. pose .. ": " .. edge)
	
	pose = conditionallySwapWave(pose)
	
	if (edge == "on") then
		if (pose == "thumbToPinky") then
			unlocking = myo.getTimeMilliseconds()
			--toggleLock()
		elseif (not locked) then
			if (pose == "waveOut") then
				onWaveOut()		
				extendUnlock()
			elseif (pose == "waveIn") then
				onWaveIn()
				extendUnlock()
			elseif (pose == "fist") then
				onFist()
				extendUnlock()
			elseif (pose == "fingersSpread") then
				onFingersSpread()			
				extendUnlock()
			end
		end
	end
end

function onPeriodic()
    local now = myo.getTimeMilliseconds()
	if (unlocking > 0 and now > unlocking + UNLOCK_HOLD_DURATION) then
		toggleLock()
		unlocking = 0
		return
	end
    if not locked then
        if (now - enabledSince) > ENABLED_TIMEOUT then
            toggleLock()
        end
    end
end

function toggleLock()
	locked = not locked
	myo.vibrate("short")
	if (not locked) then
		-- Vibrate twice on unlock
		myo.debug("Unlocked")
		myo.vibrate("short")
		enabledSince = myo.getTimeMilliseconds()
	else 
		myo.debug("Locked")
	end
end

function onWaveOut()
	myo.debug("Next")
	myo.keyboard("right_arrow","press","alt")
end

function onWaveIn()
	myo.debug("Previous")
	myo.keyboard("left_arrow","press","alt")
end


function onFist()
	active = not active		
	if (active) then
		myo.debug("Now controlling your music")
	else
		myo.debug("No longer controlling your music")
	end
	myo.vibrate("medium")
	myo.keyboard("up_arrow","press","alt")
end

function onFingersSpread()
	myo.debug("Play/Pause")
	myo.keyboard("down_arrow", "press", "alt")
end

function conditionallySwapWave(pose)
	if myo.getArm() == "left" then
        if pose == "waveIn" then
            pose = "waveOut"
        elseif pose == "waveOut" then
            pose = "waveIn"
        end
    end
    return pose
end

function extendUnlock()
    local now = myo.getTimeMilliseconds()

    enabledSince = now
end

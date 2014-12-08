scriptId = 'com.thalmic.examples.slacker'
scriptTitle = "Slacker Control"
scriptDetailsUrl = ""
description = [[
Slacker Contoller

Controls:
- Fist then raise arm to take control, fist then lower to release, can be performed on Slacker page before music is playing, or sway.fm page
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

function onForegroundWindowChange(app, title)
    -- myo.debug("onForegroundWindowChange: " .. app .. ", " .. title)
	local foundSlacker = string.match(title, "Slacker") ~= nil or string.match(title, "sway.fm") ~= nil
	if (foundSlacker) then
		appTitle = title
		myo.debug("Slacker controls now active")
	end
    return foundSlacker or active
end


function nextTrack(edge)
    if (edge == down) then
        return false
    end
	myo.debug("Next")
	myo.keyboard("right_arrow","press","alt")
end

function previousTrack(edge)
    if (edge == down) then
        return false
    end
	myo.debug("Previous")
	myo.keyboard("left_arrow","press","alt")
end

startingPitch = nil
function toggleControl(edge)
    if (edge == "down") then
        startingPitch = myo.getPitch()
    else
        local deltaPitch = myo.getPitch() - startingPitch
        myo.debug(deltaPitch)
        if (deltaPitch > .5 and not active or deltaPitch < -.5 and active) then
        	myo.vibrate("medium")
            myo.keyboard("up_arrow","press","alt")
           	active = not active		
            myo.debug("Toggling music control")
        end
    end
end

function playPause(edge)
    if (edge == down) then
        return false
    end
	myo.debug("Play/Pause")
	myo.keyboard("down_arrow", "press", "alt")
end

 STANDARD_BINDINGS = {
    fist            = toggleControl,
    fingersSpread   = playPause,
    waveOut         = nextTrack,
    wavein          = previousTrack
}

bindings = STANDARD_BINDINGS

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

function activeAppName()
    return scriptTitle
end

function onPoseEdge(pose, edge)    
    if (pose ~= "rest" and pose ~= "unknown") then
        -- hold if edge is on, timed if edge is off
        myo.unlock(edge == "off" and "timed" or "hold")
    end
    pose = conditionallySwapWave(pose)
    --myo.debug("onPoseEdge: " .. pose .. ": " .. edge)
    fn = bindings[pose]
    if fn then
        keyEdge = edge == "off" and "up" or "down"
        fn(keyEdge)
    end
end

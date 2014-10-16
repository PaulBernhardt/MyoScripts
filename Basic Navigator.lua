scriptId = 'com.thalmic.examples.myfirstscript'

locked = true
appTitle = ""

function onForegroundWindowChange(app, title)
    myo.debug("onForegroundWindowChange: " .. app .. ", " .. title)
	appTitle = title
    return true
end

function activeAppName()
	return appTitle
end

function onPoseEdge(pose, edge)
	myo.debug("onPoseEdge: " .. pose .. ": " .. edge)
	
	pose = conditionallySwapWave(pose)
	
	if (edge == "on") then
		if (pose == "thumbToPinky") then
			toggleLock()
		elseif (not locked) then
			if (pose == "waveOut") then
				onWaveOut()		
			elseif (pose == "waveIn") then
				onWaveIn()
			elseif (pose == "fist") then
				onFist()
			elseif (pose == "fingersSpread") then
				onFingersSpread()			
			end
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
	else 
		myo.debug("Locked")
	end
end

function onWaveOut()
	myo.debug("Next")
	--myo.vibrate("short")
	myo.keyboard("tab", "press")
end

function onWaveIn()
	myo.debug("Previous")
	--myo.vibrate("short")
	--myo.vibrate("short")
	myo.keyboard("tab","press","shift")
end


function onFist()
	myo.debug("Enter")	
	--myo.vibrate("medium")
	myo.keyboard("return","press")
end

function onFingersSpread()
	myo.debug("Escape")
	--myo.vibrate("long")
	myo.keyboard("escape", "press")
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

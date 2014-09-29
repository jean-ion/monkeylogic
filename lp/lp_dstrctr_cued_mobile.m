%lp_dstrctr_cued_mobile (timing script)

% Naming for TaskObjects defined in the conditions file:
start_spot = 1;
targ1 = 2;
targ2 = 4;
cue = 6;
editable( 'reward' );

% Define Time Intervals (in ms):
wait_press = 1000;
hold_time = 300;
hold_time_postcue = 400;
blank_time = 20;
wait_release = 1000;

% Define Reward Duration
reward = 300;

%Select which of the four combinations the two targets will display as
% 1-3 - neither changes, 4 - 1 changes, 5 - the other changes, 6 - both
% change
comb = randi(2);
if comb <=1
    targ1new = 2; targ2new = 4; eventmarker(132); % No Change
elseif comb == 2
    targ1new = 3; targ2new = 4; eventmarker(133); % First Change
end



%%%%%%%%% TASK %%%%%%%%

% Show Fixation Spot, Cues the Beginning of a Trial:
toggleobject(start_spot, 'eventmarker', 120) % Fixation Spot Shown


% Waits for press
pressed = eyejoytrack('acquiretouch', 1, [], wait_press); % Here '1' =button/lever index, not the target
if ~pressed
    toggleobject(start_spot, 'eventmarker', 125) % Didn't press by end of fixation cue
    trialerror(1); % Didn't press in time
    idle(200, [1, 0, 0]); % Red Error Screen
    return
end


% Turn on Targets
toggleobject([targ1 targ2], 'eventmarker', 121);

% Tests lever remains pressed
held = eyejoytrack('holdtouch', 1, [], hold_time);
if ~held,
    toggleobject([start_spot targ1 targ2], 'eventmarker', 126); %Turn off fixation spot and targets
    trialerror(2); % Released too soon
    idle(200, [1, 0, 0]); % Red Error Screen
    return
end

% Turn on Cue
toggleobject(cue,'eventmarker', 131); % Cue on

% Keep Lever Pressed while Cue is on
held = eyejoytrack('holdtouch', 1, [], hold_time_postcue);
if ~held,
    toggleobject([start_spot cue targ1 targ2], 'eventmarker', 126); % Turn off cue
    trialerror(2); % Released too early
    idle(200, [1, 0, 0]); % Red Error Screen
    return
end

% Blank Targets
toggleobject([targ1 targ2], 'eventmarker',134);
held = eyejoytrack('holdtouch', 1, [], blank_time);
if ~held,
    toggleobject([start_spot cue], 'eventmarker', 135); % Turn off cue
    trialerror(2); % Released too early
    idle(200, [1, 0, 0]); % Red Error Screen
    return
end

% Change targets or distractors (different or the same)
toggleobject([targ1new targ2new]);

% Wait for release
released = ~eyejoytrack('holdtouch', 1, [], wait_release);

if (released && (comb == 1))
    toggleobject([start_spot cue targ1new targ2new], 'eventmarker', 127); %Turn off fixation spot and targets
    trialerror(3); % Released when should not have
    idle(1500, [1, 0, 0]); % Red Error Screen
    return
end

if (~released && (comb == 2))
    toggleobject([start_spot cue targ1new targ2new], 'eventmarker', 128); %Turn off fixation spot and targets
    trialerror(4); % Did not release in time
    idle(1500, [1, 0, 0]); % Red Error Screen
    return
end

toggleobject([start_spot cue targ1new targ2new], 'eventmarker', 124); %Turn off fixation spot and targets
trialerror(0); % Correct
goodmonkey(reward); % Reward

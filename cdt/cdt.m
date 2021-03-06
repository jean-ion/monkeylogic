%cdt (timing script)

% This task requires the animal to detect a change in the stimulus and
% press the lever.

%set_iti(500);

% give names to the TaskObjects defined in the conditions file:
red = 1;
green = 2;

% define time intervals (in ms):
wait_for_press = 1000;

% TASK:

cur_targ = randi(2,1);

% show target:
toggleobject(cur_targ);
[ontarget rt] = eyejoytrack('acquirefix', cur_targ, 1, 500); % This is a hack to just leave the picture on the screen for a while before the lever press can do anything.

pressed = eyejoytrack('acquiretouch', 1, [], wait_for_press);
if (pressed && cur_targ == red) || (~pressed && cur_targ == green),
    trialerror(4); % false alarm
    toggleobject(cur_targ)
    idle(1000);
    return
end

trialerror(0); % correct
goodmonkey(50);

toggleobject(cur_targ);

idle(300);
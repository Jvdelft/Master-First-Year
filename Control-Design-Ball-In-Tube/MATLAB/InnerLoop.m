function current = InnerLoop(reference,currentOut)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
Kp_in = 2.775;
current = Kp_in*(reference-currentOut);
if (current>0)
    current = min(current,10);
else
    current = max(current,-10);
end    

end


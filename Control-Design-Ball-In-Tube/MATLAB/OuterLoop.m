function current = OuterLoop(reference,currentOut)
    
Kp = 5;
Td = 1;
N = 5;
C = tf([Td 0], [-Td/N 1]);
C = (C +1)*Kp
current = C*(reference-currentOut);
if (current>0)
    current = min(current,7);
else
    current = max(current,-7);
end    

end
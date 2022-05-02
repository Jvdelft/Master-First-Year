function current = VariableGain(Voltage)
   if((Voltage <= 4) && (Voltage >=0))
       current = Voltage*0.3333;
       %current = Voltage;
   elseif(Voltage>4)
       current = Voltage*2.5-8.55;
       %current = Voltage*0.3333;
       %current = Voltage;
   else
       current = Voltage;
   end
end
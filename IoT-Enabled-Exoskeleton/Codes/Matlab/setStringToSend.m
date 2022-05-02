function [] = setStringToSend(newStringToSend)
    assignin('base','stringToSend',newStringToSend);
    set_param('ArduinoSubsystem/String to send','String','stringToSend');
end


global key
InitKeyboard();
while 1
    pause(0.1);
    switch key
        case 'uparrow'
            %disp('Up');
            brick.MoveMotor('A', 30);
            brick.MoveMotor('C', 33);
            
        case 'downarrow'
            %disp('Down');
            brick.MoveMotor('A', -30);
            brick.MoveMotor('C', -33);
            
        case 'leftarrow'
            brick.MoveMotor('A', 50);
            brick.MoveMotor('C', -50);
            
        case 'rightarrow'
            brick.MoveMotor('C', 50);
            brick.MoveMotor('A', -50)
            
        case 0
            %disp('No Key Press');
            brick.StopMotor('AC', 'Coast');
            
        case 'w'
            %disp('Crane Up');
            brick.MoveMotorAngleRel('D', 20, 15, 'Coast');
            
        case 's'
            %disp('Crane Down');
            brick.MoveMotorAngleRel('D', 20, -15, 'Coast');
            pause(2);
            
        case 'q'
            break;
    end
end

CloseKeyboard();

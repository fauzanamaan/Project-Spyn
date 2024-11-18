brick.beep(); % Ensures connection is secure

% Constants
status = true;
ColorPortNumber = 4;
TouchPortNumber = 1;
UltrasonicPortNumber = 3;
LeftMotorPort = 'C';
RightMotorPort = 'A';
threshold = 12;

% Color Sensor Initialization - MODE
brick.SetColorMode(ColorPortNumber, 2);



% Run manual control script at the start
run('kbrdcontrol');

% Function to Check Repeated Color Detection
function check = repeatedColorDetection(brick, ColorPortNumber, targetColor)
    count = 0;
    check = false;
    while count < 2
        pause(0.5);
        colorReading = brick.ColorCode(ColorPortNumber);
        fprintf('Color Reading: %d \n', colorReading);
        if colorReading == targetColor
            check = true;
        else
            disp('Color Detected Incorrectly!');
            check = false;
            break;
        end
        count = count + 1;
    end
end

% Autonomous Mode
while status
    % Color Reading
    colorReading = brick.ColorCode(ColorPortNumber);
    fprintf('Color Reading: %d \n', colorReading);

    % Color-Based Actions
    if colorReading == 5  % Red Color Detected
        disp("Red Color Detected - Immediate Stop");
        brick.StopMotor(LeftMotorPort, 'Brake');
        brick.StopMotor(RightMotorPort, 'Brake');
        pause(2);  % Wait for 2 seconds when red is detected
        disp("Resuming Movement");
        brick.MoveMotor(LeftMotorPort, 20);  % Continue forward
        brick.MoveMotor(RightMotorPort, 20); 
        pause(3);

    % Blue Color Detected
    elseif colorReading == 2
        if repeatedColorDetection(brick, ColorPortNumber, 2)
            brick.beep();
            pause(0.1);
            brick.beep();
            disp('Blue Color Detected');
            disp('Transferring to Manual Control');
            brick.StopMotor(LeftMotorPort, 'Brake');
            brick.StopMotor(RightMotorPort, 'Brake');
            run('kbrdcontrol');
        end

    % Green Color Detected
    elseif colorReading == 3
        if repeatedColorDetection(brick, ColorPortNumber, 3)
            brick.beep();
            pause(0.1);
            brick.beep();
            pause(0.1);
            brick.beep();
            disp('Green Color Detected');
            disp('Transferring to Manual Control');
            brick.StopMotor(LeftMotorPort, 'Brake');
            brick.StopMotor(RightMotorPort, 'Brake');
            run('kbrdcontrol');
        end

    % Yellow Color Detected
    elseif colorReading == 4
        if repeatedColorDetection(brick, ColorPortNumber, 4)
            disp('Yellow Color Detected');
            disp('Transferring to Manual Control');
            brick.StopMotor(LeftMotorPort, 'Brake');
            brick.StopMotor(RightMotorPort, 'Brake');
            run('kbrdcontrol');
        end

    % Other Colors Detected
    else
        % Continue in Autonomous Mode at 45% Speed
        brick.MoveMotor(LeftMotorPort, 50);
        brick.MoveMotor(RightMotorPort, 50);
    end

    % Touch Sensor Reading
    touchReading = brick.TouchPressed(TouchPortNumber);
    fprintf('Touch Reading: %d \n', touchReading);

    % Check if Wall Touched
    if touchReading
        disp('Wall Detected!');
        brick.MoveMotor(LeftMotorPort, -50); % Reverse Left Motor
        brick.MoveMotor(RightMotorPort, -50); % Reverse Right Motor
        pause(1); % Short pause for better reversal control
        brick.StopMotor(LeftMotorPort, 'Coast');
        brick.StopMotor(RightMotorPort, 'Coast');
        
        % Read Left Side Distance
        LeftDistance = brick.UltrasonicDist(UltrasonicPortNumber);
        disp('Distance Reading');
        disp(LeftDistance);
        
        % Conditional Turning based on distance
        if LeftDistance > threshold
            disp('Turning Right');
            brick.MoveMotor(RightMotorPort, 50); % Turn Right
            brick.MoveMotor(LeftMotorPort, -50);
            pause(1);
            brick.StopMotor(RightMotorPort, 'Coast');
        else
            disp('Turning Left');
            brick.MoveMotor(LeftMotorPort, 50); % Turn Left
            brick.MoveMotor(RightMotorPort, -50);
            pause(1);
            brick.StopMotor(LeftMotorPort, 'Coast');
        end
    end
    pause(0.1);
end

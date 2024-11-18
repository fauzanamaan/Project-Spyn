% Constants for Color Sensor
ColorPortNumber = 4;  % Port where the color sensor is connected
LeftMotorPort = 'C';  % Port for the left motor
RightMotorPort = 'A'; % Port for the right motor

% Initialize the Color Sensor Mode
brick.SetColorMode(ColorPortNumber, 2);  % Setting the sensor mode to detect color codes

% Function to Check Repeated Color Detection
function check = repeatedColorDetection(brick, ColorPortNumber, targetColor)
    count = 0;
    check = false;
    % Loop to verify color detection twice for consistency
    while count < 2
        pause(0.5);  % Pause for half a second between checks
        colorReading = brick.ColorCode(ColorPortNumber);
        fprintf('Color Reading: %d \n', colorReading);
        
        % Check if the detected color matches the target color
        if colorReading == targetColor
            check = true;  % Color detected successfully
        else
            disp('Color Detected Incorrectly!');
            check = false;
            break;  % Exit the function if the color does not match
        end
        count = count + 1;  % Increment the count
    end
end

% Main Loop for Autonomous Mode
while true
    % Read the color sensor value
    colorReading = brick.ColorCode(ColorPortNumber);
    fprintf('Color Reading: %d \n', colorReading);

    % Actions Based on Detected Color
    if colorReading == 5  % Red Color Detected
        disp("Red Color Detected - Immediate Stop");
        brick.StopMotor(LeftMotorPort, 'Brake');
        brick.StopMotor(RightMotorPort, 'Brake');
        pause(2);  % Wait for 2 seconds when red is detected
        disp("Resuming Movement");
        % Resume moving forward
        brick.MoveMotor(LeftMotorPort, 20);
        brick.MoveMotor(RightMotorPort, 20);
        pause(3);

    elseif colorReading == 2  % Blue Color Detected
        % Check for repeated detection of blue color
        if repeatedColorDetection(brick, ColorPortNumber, 2)
            brick.beep();
            pause(0.1);
            brick.beep();
            disp('Blue Color Detected');
            disp('Switching to Manual Control');
            % Stop the motors and switch to manual control
            brick.StopMotor(LeftMotorPort, 'Brake');
            brick.StopMotor(RightMotorPort, 'Brake');
            run('kbrdcontrol');
        end

    elseif colorReading == 3  % Green Color Detected
        % Check for repeated detection of green color
        if repeatedColorDetection(brick, ColorPortNumber, 3)
            brick.beep();
            pause(0.1);
            brick.beep();
            pause(0.1);
            brick.beep();
            disp('Green Color Detected');
            disp('Switching to Manual Control');
            % Stop the motors and switch to manual control
            brick.StopMotor(LeftMotorPort, 'Brake');
            brick.StopMotor(RightMotorPort, 'Brake');
            run('kbrdcontrol');
        end

    elseif colorReading == 4  % Yellow Color Detected
        % Check for repeated detection of yellow color
        if repeatedColorDetection(brick, ColorPortNumber, 4)
            disp('Yellow Color Detected');
            disp('Switching to Manual Control');
            % Stop the motors and switch to manual control
            brick.StopMotor(LeftMotorPort, 'Brake');
            brick.StopMotor(RightMotorPort, 'Brake');
            run('kbrdcontrol');
        end

    else  % Other Colors Detected
        % No specific color detected, continue moving forward in autonomous mode
        disp('No significant color detected, continuing forward');
        brick.MoveMotor(LeftMotorPort, 50);
        brick.MoveMotor(RightMotorPort, 50);
    end

    % Small pause for sensor stability
    pause(0.1);
end

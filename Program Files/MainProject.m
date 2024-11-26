brick.beep(); % Ensures connection is secure

% Constants
status = true;
ColorPortNumber = 4;
TouchPortNumber = 1;
UltrasonicPortNumber = 3;
LeftMotorPort = 'C';
RightMotorPort = 'A';

% Variables
threshold = 36;      % --> Used for the implementatio of turning when a wall is detected on the front of the car
LeftMotorPower = 45;
RightMotorPower = 45;

% Color Sensor Initialization - MODE
brick.SetColorMode(ColorPortNumber, 2);


% Run manual control script at the start
run('kbrdcontrol');

% Function to Check Repeated Color Detection
function check = repeatedColorDetection(brick, ColorPortNumber, targetColor)
    count = 0;
    check = false;
    while count < 1
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
        gap = false; 

        % Immediate Stop
        disp("Red Color Detected - Immediate Stop");
        brick.StopMotor(LeftMotorPort, 'Brake');
        brick.StopMotor(RightMotorPort, 'Brake');
        pause(2); 

        % Resuming Movement
        disp("Resuming Movement");
        brick.MoveMotor(LeftMotorPort, LeftMotorPower - 10);  
        brick.MoveMotor(RightMotorPort, RightMotorPower - 10); 
        pause(3.7);

        % Checking Distances on both sides of the car
        RightDistance = brick.UltrasonicDist(UltrasonicPortNumber);
        disp('Distance Reading');
        disp(RightDistance);
        if RightDistance > 66
            % If gap is great enough, turn right!
            brick.MoveMotor(LeftMotorPort, 50);
            brick.MoveMotor(RightMotorPort, -50);
            pause(0.5);
            brick.MoveMotor(LeftMotorPort, 40);
            brick.MoveMotor(RightMotorPort, 40);
            pause(2.2);
        end



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
        % Continue in Autonomous Mode
        brick.MoveMotor(LeftMotorPort, LeftMotorPower);
        brick.MoveMotor(RightMotorPort, RightMotorPower);
    end

    % Touch Sensor Reading
    touchReading = brick.TouchPressed(TouchPortNumber);
    fprintf('Touch Reading: %d \n', touchReading);

    % Check if Wall Touched
    if touchReading
        disp('Wall Detected!');
        brick.MoveMotor(LeftMotorPort, (LeftMotorPower*(-1))); % Reverse Left Motor
        brick.MoveMotor(RightMotorPort, (RightMotorPower*(-1))); % Reverse Right Motor
        pause(0.8); % Short pause for better reversal control
        brick.StopMotor(LeftMotorPort, 'Coast');
        brick.StopMotor(RightMotorPort, 'Coast');
        
        % Read Left Side Distance
        RightDistance = brick.UltrasonicDist(UltrasonicPortNumber);
        disp('Distance Reading');
        disp(RightDistance);
        
        % Conditional Turning based on distance
        if RightDistance < threshold
            disp('Turning Left');

            brick.StopMotor(RightMotorPort, 'Brake');
            brick.StopMotor(LeftMotorPort, 'Brake');
            brick.MoveMotor(LeftMotorPort, -50);
            brick.MoveMotor(RightMotorPort, 50);
            pause(0.42);
            brick.MoveMotor(LeftMotorPort, 50);
            brick.MoveMotor(RightMotorPort, 50);
            pause(0.2);
        else
            disp('Turning Right');
            brick.StopMotor(LeftMotorPort, 'Brake');
            brick.StopMotor(RightMotorPort, 'Brake');
            brick.MoveMotor(LeftMotorPort, 50);
            brick.MoveMotor(RightMotorPort, -50);
            pause(0.42);
            brick.MoveMotor(LeftMotorPort, 50);
            brick.MoveMotor(RightMotorPort, 50);
            pause(0.2)
        end
    end

    RightDistance = brick.UltrasonicDist(UltrasonicPortNumber);
    disp('Right Distance');
    disp(RightDistance);
    if RightDistance > 100
        pause(0.75);
        brick.MoveMotor(LeftMotorPort, 50);
        brick.MoveMotor(RightMotorPort, -50);
        pause(0.42);
        brick.StopMotor(LeftMotorPort, 'Coast');
        brick.StopMotor(RightMotorPort, 'Coast');
        t = 0;
        while t < 9
            t  = t + 1;
            colorReading = brick.ColorCode(ColorPortNumber);
            fprintf('Color Reading: %d \n', colorReading);
        
            % Color-Based Actions
            if colorReading == 5  % Red Color Detected
        
                % Immediate Stop
                disp("Red Color Detected - Immediate Stop");
                brick.StopMotor(LeftMotorPort, 'Brake');
                brick.StopMotor(RightMotorPort, 'Brake');
                pause(2); 
        
                % Resuming Movement
                disp("Resuming Movement");
                brick.MoveMotor(LeftMotorPort, LeftMotorPower - 10);  
                brick.MoveMotor(RightMotorPort, RightMotorPower - 10); 
                pause(3.7);
        
                % Checking Distances on both sides of the car
                RightDistance = brick.UltrasonicDist(UltrasonicPortNumber);
                disp('Distance Reading');
                disp(RightDistance);
                if RightDistance > 66
                    % If gap is great enough, turn right!
                    brick.MoveMotor(LeftMotorPort, 50);
                    brick.MoveMotor(RightMotorPort, -50);
                    pause(0.5);
                    brick.MoveMotor(LeftMotorPort, 30);
                    brick.MoveMotor(RightMotorPort, 30);
                    pause(2.2);
                    break

                end
                break
            else
                    brick.MoveMotor(LeftMotorPort, 50);
                    brick.MoveMotor(RightMotorPort, 50);
                    pause(0.1);
            end
        end
    end

    pause(0.1);
end

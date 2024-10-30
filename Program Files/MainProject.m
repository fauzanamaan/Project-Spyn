brick.beep(); % Ensures connection is secure

% Constants (Set these when testing)
status = true;
ColorPortNumber = 4; % Define port
TouchPortNumber = 1; % Define port
UltrasonicPortNumber = 3; % Define port
LeftMotorPort = 'C'; % Define port
RightMotorPort = 'A'; % Define port
threshold = 10; % Set appropriate distance threshold for wall avoidance
BothMotorPort = RightMotorPort + LeftMotorPort; % Array for both motors

% Sensor Initialization
brick.SetColorMode(ColorPortNumber, 2); % Set to color code mode

% Run manual control script at the start
run('kbrdcontrol');

while status
    % Quick Color Reading
    colorReading = brick.ColorCode(ColorPortNumber);
    disp(['Color Reading: ', num2str(colorReading)]);

    % Touch Sensor Reading
    touchReading = brick.TouchPressed(TouchPortNumber);
    disp(['Touch Reading: ', num2str(touchReading)]);

    % Color-Based Actions
    if colorReading == 5 % Break condition
        disp("Immediate Break");
        brick.StopMotor(BothMotorPort, 'Brake'); % Use direct brake command
        pause(3); % Short pause to process the stop
        brick.MoveMotor(BothMotorPort, 20); % Resume movement
        pause(3);
        
    elseif ismember(colorReading, [2, 3, 4]) % Start manual control if specific colors detected
        disp("Color Detected, Switching to Manual Mode");
        run('kbrdcontrol'); % Manual mode script
    else
        % Continue in Autonomous Mode at 20% Speed
        brick.MoveMotor(BothMotorPort, 25);
    end

    % Check if Wall Touched
    if touchReading
        disp('Wall Detected!');
        brick.MoveMotor(BothMotorPort, -50); % Reverse
        pause(1); % Short pause for better reversal control
        brick.StopMotor(BothMotorPort, 'Coast'); % Stop both motors
        
        % Read Left Side Distance
        LeftDistance = brick.UltrasonicDist(UltrasonicPortNumber);
        disp(['Left Distance: ', num2str(LeftDistance)]);
        
        % Conditional Turning based on distance
        if LeftDistance > threshold
            disp('Turning Right');
            brick.MoveMotor(RightMotorPort, 50); % Move right motor to turn right
            pause(3.5);
            brick.StopMotor(RightMotorPort, 'Coast');
        else
            disp('Turning Left');
            brick.MoveMotor(LeftMotorPort, 50); % Move left motor to turn left
            pause(3.5);
            brick.StopMotor(LeftMotorPort, 'Coast');
        end
    end
end


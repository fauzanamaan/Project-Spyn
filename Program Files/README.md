# EV3 Autonomous Robot Project

This project utilizes an EV3 robot with autonomous and manual control features, employing various sensors and motors. The sections below guide you on how to connect and disconnect the EV3 brick, alongside detailed explanations of the color sensor, ultrasonic sensor, touch sensor, and motor functionalities.

---

## **Connecting the Brick**

1. **Enable Bluetooth on the EV3 Brick:** Ensure that the EV3 brick’s Bluetooth is enabled and discoverable.
2. **Connect from MATLAB:** Establish a connection using the following command:
   `brick = ConnectBrick('EV3');`
    * Replace 'EV3' with your specific brick's Bluetooth name if necessary.

3. **Beep Test:** To confirm the connection, you can issue a beep command:

`brick.beep();`


## Disconnecting the Brick
Graceful Disconnect: Once finished, disconnect the EV3 brick from MATLAB to avoid further communication issues.
Use the Command:
`brick.Disconnect();`


## Color Sensor
The color sensor is used to detect various colors on the track, triggering distinct actions based on the detected color. It operates in Color Mode to recognize specific colors such as red, blue, green, and yellow.

Code Setup for the Color Sensor
Port Initialization:
```
ColorPortNumber = 4;  % Define the port where the color sensor is connected
brick.SetColorMode(ColorPortNumber, 2);  % Set mode to color recognition
```

**Reading Colors:** To retrieve the color detected, use:
```
colorReading = brick.ColorCode(ColorPortNumber);
fprintf('Color Reading: %d \n', colorReading);
```

### Color Codes:
1: Black
2: Blue
3: Green
4: Yellow
5: Red


## Ultrasonic Sensor
The ultrasonic sensor measures the distance between the robot and nearby obstacles, which is essential for wall detection and collision avoidance.

Code Setup for the Ultrasonic Sensor
Port Initialization:
`UltrasonicPortNumber = 3;  % Define the port for the ultrasonic sensor`


**Reading Distance:** Retrieve the distance measurement in centimeters:
```
distanceReading = brick.UltrasonicDist(UltrasonicPortNumber);
fprintf('Distance Reading: %f cm\n', distanceReading);
```
* This value is used to decide if the robot needs to turn to avoid obstacles based on a predefined threshold.


## Touch Sensor
The touch sensor detects physical contact with obstacles, prompting the robot to reverse and turn.

Code Setup for the Touch Sensor
Port Initialization:
`TouchPortNumber = 1;  % Define the port for the touch sensor`
**Reading Touch Status:** Use this code to check if the sensor is pressed:
```
touchReading = brick.TouchPressed(TouchPortNumber);
fprintf('Touch Reading: %d \n', touchReading);
```
* 1 indicates that the sensor is pressed (contact detected), while 0 means it is not pressed.


## Motors
The motors control the robot’s movement, including driving forward, reversing, and making turns. Each motor is assigned to control either the left or right side, allowing differential steering.

Code Setup for Motors
Port Initialization:
```
LeftMotorPort = 'C';  % Define the port for the left motor
RightMotorPort = 'A';  % Define the port for the right motor
BothMotorPort = [RightMotorPort, LeftMotorPort];  % Array for both motors
```
###Movement Control:

Move Forward: To drive both motors forward:
`brick.MoveMotor(BothMotorPort, 45);  % Move at 45% power`

Stop Motors: To stop both motors with a braking command:
`brick.StopMotor(BothMotorPort, 'Brake');`

Reverse: Move both motors backward at a specific power level:
`brick.MoveMotor(BothMotorPort, -50);  % Reverse at 50% power`

Turning: Turn by activating one motor at a time.
```
% Turn Right
brick.MoveMotor(RightMotorPort, 50);  % Turn by moving only the right motor
pause(1.5);
brick.StopMotor(RightMotorPort, 'Coast');

% Turn Left
brick.MoveMotor(LeftMotorPort, 50);  % Turn by moving only the left motor
pause(1.5);
brick.StopMotor(LeftMotorPort, 'Coast');
```

##Battery Check
To ensure adequate power before operation, the brick’s battery level is verified at the start.
```
brickBattery = brick.GetBattVoltage();
if brickBattery < 40
    disp('LOW BATTERY!');
    disp('Please recharge before continuing');
else
    disp('SUFFICIENT BATTERY!');
    disp(brickBattery);
end
```


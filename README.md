# Motivation
For a final project for Digital Systems, myself and a peer challenged ourselves to leverage my processor designed in Verilog and simulated on an FPGA to do something. We chose to simulate a shooting gallery game like one you would see at Bass Pro Shops.

## Proccesor Design
This processor was a five stage pipelined processor with bypassing.
size: 32 bit
speed: 100 MHz
adder/subtractor: Carry Look-ahead Adder
multiplier: Modified Booths algorithm 
Divider: Non Restoring algorithm

## Inputs and Outputs
My processor inputs included phototransistors at each of the four targets,a joystick to aim the laser gun, and a button to fire the laser. A “Start” button input initiated a “game,” allowing control of the Servo motors and commencing a 30 second countdown. The required outputs included a display to reflect the user’s “score” , two Servo motors motors for altitude and azimuth control, and an LED at each target. 
These inputs and outputs combine to form a game in which a user presses the “Start” button, and then has 30 seconds to use a joystick and a “Fire” button to control and fire a laser to attempt to “hit” as many targets as possible. These inputs directly informed our outputs, which displayed the user’s score using seven-segment displays, activated LEDs at each target to indicate the user had not yet “hit” that target, and rotated 2 Servo motors to move the laser.




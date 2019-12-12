// File:          exomotus_h4_thigh_controller.cpp
// Date:
// Description:
// Author:
// Modifications:

// You may need to add webots include files such as
// <webots/DistanceSensor.hpp>, <webots/Motor.hpp>, etc.
// and/or to add some other includes
#include <webots/Robot.hpp>
#include <webots/Motor.hpp>

// All the webots classes are defined in the "webots" namespace
using namespace webots;

// This is the main program of your controller.
// It creates an instance of your Robot instance, launches its
// function(s) and destroys it at the end of the execution.
// Note that only one instance of Robot should be created in
// a controller program.
// The arguments of the main function can be specified by the
// "controllerArgs" field of the Robot node
int main(int argc, char **argv) {
  
  const float PI = 3.14159265358979f;

  // create the Robot instance.
  Robot *robot = new Robot();

  // get the time step of the current world.
  int timeStep = (int)robot->getBasicTimeStep();

  // You should insert a getDevice-like function in order to get the
  // instance of a device of the robot. Something like:
  //  Motor *motor = robot->getMotor("motorname");
  //  DistanceSensor *ds = robot->getDistanceSensor("dsname");
  //  ds->enable(timeStep);
  Motor *leftLegHipMotor = robot->getMotor("left_leg_hip_motor");
  Motor *rightLegHipMotor = robot->getMotor("right_leg_hip_motor");

  float time = 0;
  float leftLegHipAngle = 0;
  float rightLegHipAngle = 0;

  // Main loop:
  // - perform simulation steps until Webots is stopping the controller
  while (robot->step(timeStep) != -1) {
    // Read the sensors:
    // Enter here functions to read sensor data, like:
    //  double val = ds->getValue();

    // Process sensor data here.

    // do the algorithm
    time = time + 0.1;
    leftLegHipAngle = 50 * sin(time);
    rightLegHipAngle = 50 * sin(time + PI);

    // Enter here functions to send actuator commands, like:
    //  motor->setPosition(10.0);
    leftLegHipMotor->setPosition(leftLegHipAngle / 180 * PI);
    rightLegHipMotor->setPosition(rightLegHipAngle / 180 * PI);
    
    printf("leftLegHipAngle = %f, rightLegHipAngle = %f \n", leftLegHipAngle, rightLegHipAngle);
  };

  // Enter here exit cleanup code.

  delete robot;
  return 0;
}

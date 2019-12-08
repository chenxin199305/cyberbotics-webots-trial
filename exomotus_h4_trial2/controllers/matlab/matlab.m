% MATLAB controller for Webots
% File:          exomotus_h4_matlab_controller.m
% Date:
% Description:
% Author:
% Modifications:

% uncomment the next two lines if you want to use
% MATLAB's desktop to interact with the controller:
desktop;
keyboard;

TIME_STEP = 10;

% get and enable devices, e.g.:
%  camera = wb_robot_get_device('camera');
%  wb_camera_enable(camera, TIME_STEP);
robot = wb_supervisor_node_get_from_def('ExoMotus-H4');

left_leg_hip_motor = wb_robot_get_device('left_leg_hip_motor');
left_leg_knee_motor = wb_robot_get_device('left_leg_knee_motor');
right_leg_hip_motor = wb_robot_get_device('right_leg_hip_motor');
right_leg_knee_motor = wb_robot_get_device('right_leg_knee_motor');

period = 1;
time = 0;
time_step = TIME_STEP * 0.001;
time_buffer = [];

left_leg_hip_joint_command_position = 0;
left_leg_knee_joint_command_position = 0;
right_leg_hip_joint_command_position = 0;
right_leg_knee_joint_command_position = 0;

left_leg_hip_joint_actual_position = 0;
left_leg_knee_joint_actual_position = 0;
right_leg_hip_joint_actual_position = 0;
right_leg_knee_joint_actual_position = 0;

left_leg_hip_joint_actual_velocity = 0;
left_leg_knee_joint_actual_velocity = 0;
right_leg_hip_joint_actual_velocity = 0;
right_leg_knee_joint_actual_velocity = 0;

left_leg_hip_joint_command_position_buffer = [];
left_leg_knee_joint_command_position_buffer = [];
right_leg_hip_joint_command_position_buffer = [];
right_leg_knee_joint_command_position_buffer = [];

left_leg_hip_joint_actual_position_buffer = [];
left_leg_knee_joint_actual_position_buffer = [];
right_leg_hip_joint_actual_position_buffer = [];
right_leg_knee_joint_actual_position_buffer = [];

left_leg_hip_joint_actual_velocity_buffer = [];
left_leg_knee_joint_actual_velocity_buffer = [];
right_leg_hip_joint_actual_velocity_buffer = [];
right_leg_knee_joint_actual_velocity_buffer = [];

fig = figure();

% main loop:
% perform simulation steps of TIME_STEP milliseconds
% and leave the loop when Webots signals the termination
%
while wb_robot_step(TIME_STEP) ~= -1
    
    % read the sensors, e.g.:
    %  rgb = wb_camera_get_image(camera);
    balance = wb_supervisor_node_get_static_balance(robot);
    center_of_mass = wb_supervisor_node_get_center_of_mass(robot);
%     
%     number_of_contacts = wb_supervisor_node_get_number_of_contact_points(robot)
%     for i = 0 : 1 : number_of_contacts
%         contact_point = wb_supervisor_node_get_contact_point(node, index)
%     end

    left_leg_hip_joint_actual_position = wb_motor_get_target_position(left_leg_hip_motor);
    left_leg_knee_joint_actual_position = wb_motor_get_target_position(left_leg_knee_motor);
    right_leg_hip_joint_actual_position = wb_motor_get_target_position(right_leg_hip_motor);
    right_leg_knee_joint_actual_position = wb_motor_get_target_position(right_leg_knee_motor);
    
    left_leg_hip_joint_actual_velocity = wb_motor_get_velocity(left_leg_hip_motor);
    left_leg_knee_joint_actual_velocity = wb_motor_get_velocity(left_leg_knee_motor);
    right_leg_hip_joint_actual_velocity = wb_motor_get_velocity(right_leg_hip_motor);
    right_leg_knee_joint_actual_velocity = wb_motor_get_velocity(right_leg_knee_motor);
    
    % Process here sensor data, images, etc.
    
    %% do the algorithm
    left_leg_hip_joint_command_position = 20 * sin(time * 2 * pi / period) / 180 * pi;
    left_leg_knee_joint_command_position = 0 / 180 * pi;
    right_leg_hip_joint_command_position = 20 * sin((time * 2 * pi + pi) / period) / 180 * pi;
    right_leg_knee_joint_command_position = 0 / 180 * pi;
    
    % send actuator commands, e.g.:
    wb_motor_set_position(left_leg_hip_motor, left_leg_hip_joint_command_position);
    wb_motor_set_position(left_leg_knee_motor, left_leg_knee_joint_command_position);
    wb_motor_set_position(right_leg_hip_motor, right_leg_hip_joint_command_position);
    wb_motor_set_position(right_leg_knee_motor, right_leg_knee_joint_command_position);
    
    %% record time
    time = time + time_step;
    if time > period
        
       %% if your code plots some graphics, it needs to flushed like this:
        clf(fig);
        
        subplot(3,1,1);
        hold on;
        plot(time_buffer, left_leg_hip_joint_command_position_buffer);
        plot(time_buffer, left_leg_knee_joint_command_position_buffer);
        title('trajectory (command position)');
        hold off;
        
        subplot(3,1,2);
        hold on;
        plot(time_buffer, left_leg_hip_joint_actual_position_buffer);
        plot(time_buffer, left_leg_knee_joint_actual_position_buffer);
        title('trajectory (actual position)');
        hold off;
        
        subplot(3,1,3);
        hold on;
        plot(time_buffer, left_leg_hip_joint_actual_velocity_buffer);
        plot(time_buffer, left_leg_knee_joint_actual_velocity_buffer);
        title('trajectory (actual velocity)');
        hold off;
        
        % flush graphics
        drawnow;
        
        % clear buffer
        time = time - period;
        time_buffer = [];
        left_leg_knee_joint_time_buffer = [];
        left_leg_hip_joint_command_position_buffer = [];
        left_leg_knee_joint_command_position_buffer = [];
        right_leg_hip_joint_command_position_buffer = [];
        right_leg_knee_joint_command_position_buffer = [];
        left_leg_hip_joint_actual_position_buffer = [];
        left_leg_knee_joint_actual_position_buffer = [];
        right_leg_hip_joint_actual_position_buffer = [];
        right_leg_knee_joint_actual_position_buffer = [];
        left_leg_hip_joint_actual_velocity_buffer = [];
        left_leg_knee_joint_actual_velocity_buffer = [];
        right_leg_hip_joint_actual_velocity_buffer = [];
        right_leg_knee_joint_actual_velocity_buffer = [];
    else
        time_buffer = [time_buffer, time];
        left_leg_hip_joint_command_position_buffer = [left_leg_hip_joint_command_position_buffer, left_leg_hip_joint_command_position];
        left_leg_knee_joint_command_position_buffer = [left_leg_knee_joint_command_position_buffer, left_leg_knee_joint_command_position];
        right_leg_hip_joint_command_position_buffer = [right_leg_hip_joint_command_position_buffer, right_leg_hip_joint_command_position];
        right_leg_knee_joint_command_position_buffer = [right_leg_knee_joint_command_position_buffer, right_leg_knee_joint_command_position];
        left_leg_hip_joint_actual_position_buffer = [left_leg_hip_joint_actual_position_buffer, left_leg_hip_joint_actual_position];
        left_leg_knee_joint_actual_position_buffer = [left_leg_knee_joint_actual_position_buffer, left_leg_knee_joint_actual_position];
        right_leg_hip_joint_actual_position_buffer = [right_leg_hip_joint_actual_position_buffer, right_leg_hip_joint_actual_position];
        right_leg_knee_joint_actual_position_buffer = [right_leg_knee_joint_actual_position_buffer, right_leg_knee_joint_actual_position];
        left_leg_hip_joint_actual_velocity_buffer = [left_leg_hip_joint_actual_velocity_buffer, left_leg_hip_joint_actual_velocity];
        left_leg_knee_joint_actual_velocity_buffer = [left_leg_knee_joint_actual_velocity_buffer, left_leg_knee_joint_actual_velocity];
        right_leg_hip_joint_actual_velocity_buffer = [right_leg_hip_joint_actual_velocity_buffer, right_leg_hip_joint_actual_velocity];
        right_leg_knee_joint_actual_velocity_buffer = [right_leg_knee_joint_actual_velocity_buffer, right_leg_knee_joint_actual_velocity];
    end
    
end

% cleanup code goes here: write data to files, etc.
clear;
clc;
#!/usr/bin/env python

import rospy

import sys
import copy
import math
from math import pi
from std_msgs.msg import String, Header
from moveit_commander.conversions import pose_to_list

import numpy as np
import actionlib
import moveit_commander
import moveit_msgs.msg
import geometry_msgs.msg

from franka_msgs.msg import FrankaState
from franka_control.msg import ErrorRecoveryAction, ErrorRecoveryActionGoal

from trajectory_msgs.msg import JointTrajectoryPoint

from std_msgs.msg import(
    Int32,
)

from sensor_msgs.msg import JointState


class MoveGroup(object):
    def __init__(self):
        super(MoveGroup, self).__init__()

        #self.pubState = rospy.Publisher("/joint_states_desired", JointState, queue_size = 2)

        # First initialize `moveit_commander`_ and a `rospy`_ node:
        moveit_commander.roscpp_initialize(sys.argv)

        self.robot = moveit_commander.RobotCommander()

        self.scene = moveit_commander.PlanningSceneInterface()

        group_name = "panda_arm"

        group_gripper_name = "hand"

        self.group = moveit_commander.MoveGroupCommander(group_name)
        self.group_gripper = moveit_commander.MoveGroupCommander(
            group_gripper_name)
        self.group_robot = moveit_commander.MoveGroupCommander(
            "panda_arm_hand")

        self.end_effector_link = self.group_robot.get_end_effector_link()

        self.display_trajectory_publisher = rospy.Publisher(
            '/move_group/display_planned_path', moveit_msgs.msg.DisplayTrajectory, queue_size=20)

        print "============ Printing robot state"
        print self.robot.get_current_state()
        print ""

        print "============ Current pose"
        print self.group.get_current_pose().pose
        print ""

        self.box_name = "box"

    def go_to_joint_state(self, joint_pos):
        self.group.go(joint_pos, wait=True)

        current_joints = self.group.get_current_joint_values()
        while not all_close(joint_pos, current_joints, 0.01) and not rospy.is_shutdown():
            self.group.go(joint_pos, wait=True)
            current_joints = self.group.get_current_joint_values()

        self.group.stop()

        current_joints = self.group.get_current_joint_values()
        return all_close(joint_pos, current_joints, 0.01)

    def move_gripper(self, finger_pos):
        joint_goal = self.group_gripper.get_current_joint_values()

        print joint_goal

        joint_goal[0] = finger_pos[0]
        joint_goal[1] = finger_pos[1]

        current_joints = self.group_gripper.get_current_joint_values()
        while not all_close(joint_goal, current_joints, 0.001) and not rospy.is_shutdown():
            self.group_gripper.go(joint_goal, wait=True)
            current_joints = self.group_gripper.get_current_joint_values()

        self.group_gripper.stop()

        current_joints = self.group_gripper.get_current_joint_values()
        return all_close(joint_goal, current_joints, 0.001)

    def open_gripper(self):
        joint_goal = self.group_gripper.get_current_joint_values()

        print joint_goal

        joint_goal[0] = 0.02599644847214222
        joint_goal[1] = 0.02599644847214222

        self.group_gripper.go(joint_goal, wait=True)
        self.group_gripper.stop()

        current_joints = self.group_gripper.get_current_joint_values()
        return all_close(joint_goal, current_joints, 0.001)

    def close_gripper(self):
        joint_goal = self.group_gripper.get_current_joint_values()

        print joint_goal

        joint_goal[0] = 0  # 0.02599644847214222
        joint_goal[1] = 0  # 0.02599644847214222

        self.group_gripper.go(joint_goal, wait=True)
        self.group_gripper.stop()

        current_joints = self.group_gripper.get_current_joint_values()
        return all_close(joint_goal, current_joints, 0.05)

    def old_grasp(self, grasp_pos):
        grasps = []

        g = moveit_msgs.msg.Grasp()
        g.id = "Grasp"

        g.pre_grasp_posture.header.frame_id = "panda_link0"
        g.pre_grasp_posture.joint_names = [
            "panda_finger_joint1", "panda_finger_joint2"]

        pos = JointTrajectoryPoint()
        pos.positions.append([0.0, 0.0])

        g.pre_grasp_posture.points.append(pos)

        # set the grasp posture
        g.grasp_posture.header.frame_id = "panda_link0"
        g.grasp_posture.joint_names = [
            "panda_finger_joint1", "panda_finger_joint2"]

        pos = JointTrajectoryPoint()
        pos.positions.append([0.01, 0.01])
        pos.effort.append([0.5, 0.5])

        g.grasp_posture.points.append(pos)

        g.grasp_pose = geometry_msgs.msg.PoseStamped()
        g.grasp_pose.header.frame_id = "panda_link0"
        g.grasp_pose.pose.position.x = grasp_pos[0]
        g.grasp_pose.pose.position.y = grasp_pos[1]
        g.grasp_pose.pose.position.z = grasp_pos[2]
        g.grasp_pose.pose.orientation.x = grasp_pos[3]
        g.grasp_pose.pose.orientation.y = grasp_pos[4]
        g.grasp_pose.pose.orientation.z = grasp_pos[5]
        g.grasp_pose.pose.orientation.w = grasp_pos[6]

        # print grasp_pose
        self.group.set_pose_target(g.grasp_pose)
        self.group.go(wait=True)

        rospy.sleep(2)

        # define the pre-grasp approach
        g.pre_grasp_approach.direction.header.frame_id = "panda_link0"
        g.pre_grasp_approach.direction.vector.x = 0.0
        g.pre_grasp_approach.direction.vector.y = 0.0
        g.pre_grasp_approach.direction.vector.z = 1.0
        g.pre_grasp_approach.min_distance = 0.05
        g.pre_grasp_approach.desired_distance = 0.1

        # set the post-grasp retreat
        #g.post_grasp_retreat.direction.header.frame_id = "panda_link0"
        g.post_grasp_retreat.direction.vector.x = 0.0
        g.post_grasp_retreat.direction.vector.y = 0.0
        g.post_grasp_retreat.direction.vector.z = 1.0
        g.post_grasp_retreat.desired_distance = 0.25
        g.post_grasp_retreat.min_distance = 0.01

        g.max_contact_force = 0
        grasps.append(g)

        # print grasp_pose
        self.group.set_pose_target(g.grasp_pose)
        self.group.go(wait=True)

        rospy.sleep(2)

        self.group_robot.pick("box", g)

    def add_box(self, grasp_pos, timeout=4):
        # First, we will create a box in the planning scene at the location of the left finger:
        box_pose = geometry_msgs.msg.PoseStamped()
        box_pose.header.frame_id = "panda_link0"
        box_pose.pose.position.x = grasp_pos[0]
        box_pose.pose.position.y = grasp_pos[1]
        box_pose.pose.position.z = grasp_pos[2]
        box_pose.pose.orientation.x = grasp_pos[3]
        box_pose.pose.orientation.y = grasp_pos[4]
        box_pose.pose.orientation.z = grasp_pos[5]
        box_pose.pose.orientation.w = grasp_pos[6]
        self.scene.add_box(self.box_name, box_pose, size=(0.1, 0.1, 0.1))

        return self.wait_for_state_update(box_is_known=True, timeout=timeout)

    def wait_for_state_update(self, box_is_known=False, box_is_attached=False, timeout=4):
        # Ensuring Collision Updates Are Receieved
        # **^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
        # If the Python node dies before publishing a collision object update message, the message
        # could get lost and the box will not appear. To ensure that the updates are
        # made, we wait until we see the changes reflected in the
        # ``get_known_object_names()`` and ``get_known_object_names()`` lists.
        # For the purpose of this tutorial, we call this function after adding,
        # removing, attaching or detaching an object in the planning scene. We then wait
        # until the updates have been made or ``timeout`` seconds have passed
        start = rospy.get_time()
        seconds = rospy.get_time()
        while (seconds - start < timeout) and not rospy.is_shutdown():
            # Test if the box is in attached objects
            attached_objects = self.scene.get_attached_objects([self.box_name])
            is_attached = len(attached_objects.keys()) > 0

            # Test if the box is in the scene.
            # Note that attaching the box will remove it from known_objects
            is_known = self.box_name in self.scene.get_known_object_names()

            # Test if we are in the expected state
            if (box_is_attached == is_attached) and (box_is_known == is_known):
                return True

            # Sleep so that we give other threads time on the processor
            rospy.sleep(0.1)
            seconds = rospy.get_time()

        # If we exited the while loop without returning then we timed out
        return False

    def go_to_pose_goal(self, pos):
        pose_goal = geometry_msgs.msg.Pose()
        pose_goal.orientation.x = pos[3]
        pose_goal.orientation.y = pos[4]
        pose_goal.orientation.z = pos[5]
        pose_goal.orientation.w = pos[6]
        pose_goal.position.x = pos[0]
        pose_goal.position.y = pos[1]
        pose_goal.position.z = pos[2]
        self.group.set_pose_target(pose_goal)

        current_pose = self.group.get_current_pose().pose
        while not all_close(pose_goal, current_pose, 0.003) and not rospy.is_shutdown():
            plan = self.group.go(wait=True)
            current_pose = self.group.get_current_pose().pose

        self.group.stop()
        self.group.clear_pose_targets()

        current_pose = self.group.get_current_pose().pose
        return all_close(pose_goal, current_pose, 0.003)

    def display_trajectory(self, plan):

        display_trajectory = moveit_msgs.msg.DisplayTrajectory()
        display_trajectory.trajectory_start = self.robot.get_current_state()
        display_trajectory.trajectory.append(plan)
        # Publish
        self.display_trajectory_publisher.publish(display_trajectory)

    def plan_cartesian_path(self, pos, step):
        # BEGIN_SUB_TUTORIAL plan_cartesian_path
        ##
        # Cartesian Paths
        # ^^^^^^^^^^^^^^^
        # You can plan a Cartesian path directly by specifying a list of waypoints
        # for the end-effector to go through:
        ##
        waypoints = []
        wpose = self.group.get_current_pose().pose

        for i in range(len(pos)):
            wpose.position.x = pos[i][0]
            wpose.position.y = pos[i][1]
            wpose.position.z = pos[i][2]
            wpose.orientation.x = pos[i][3]
            wpose.orientation.y = pos[i][4]
            wpose.orientation.z = pos[i][5]
            wpose.orientation.w = pos[i][6]
            waypoints.append(copy.deepcopy(wpose))

        # We want the Cartesian path to be interpolated at a resolution of 1 cm
        # which is why we will specify 0.01 as the eef_step in Cartesian
        # translation.  We will disable the jump threshold by setting it to 0.0 disabling:
        (plan, fraction) = self.group.compute_cartesian_path(
            waypoints,   # waypoints to follow
            step,        # eef_step
            0.0)         # jump_threshold

        # Note: We are just planning, not asking move_group to actually move the robot yet:
        return plan, fraction

    def execute_plan(self, plan, wait=True):
        self.group.execute(plan, wait=True)


def all_close(goal, actual, tolerance):
    """
    Convenience method for testing if a list of values are within a tolerance of their counterparts in another list
    @param: goal       A list of floats, a Pose or a PoseStamped
    @param: actual     A list of floats, a Pose or a PoseStamped
    @param: tolerance  A float
    @returns: bool
    """
    all_equal = True
    if type(goal) is list:
        for index in range(len(goal)):
            if abs(actual[index] - goal[index]) > tolerance:
                return False

    elif type(goal) is geometry_msgs.msg.PoseStamped:
        return all_close(goal.pose, actual.pose, tolerance)

    elif type(goal) is geometry_msgs.msg.Pose:
        return all_close(pose_to_list(goal), pose_to_list(actual), tolerance)

    return True


def move_robot(x, y, z):

    angles = [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0]
    glass_grab_dist = 0.11

    angles[0] = math.atan2(
        y, x)+math.sin((0.1070+glass_grab_dist)/math.sqrt(x**2+y**2))
    x6 = x-0.107*math.sin(angles[0])
    y6 = y+0.107*math.cos(angles[0])
    r = z-0.3330
    s = math.sqrt(x6**2+y6**2)
    lalpha = math.sqrt(0.3160**2+0.0825**2)
    lbeta = math.sqrt((0.3840+0.0880)**2+0.0825**2)
    D = (r**2+s**2-lalpha**2-lbeta**2)/(2*lalpha*lbeta)
    beta = math.atan2(math.sqrt(1-D**2), D)
    gamma = math.atan((0.3840+0.0880)/0.0825)
    psi = math.atan(0.316/0.0825)
    angles[0] = math.atan2(
        y, x)+math.sin((0.1070+glass_grab_dist)/math.sqrt(x**2+y**2))

    alphaTemp = math.atan2(s, r)-math.atan2(lbeta *
                                            math.sin(beta), lalpha+lbeta*math.cos(beta))
    angles[1] = alphaTemp-math.atan2(0.0825, 0.316)  # pi/4
    angles[2] = 0

    angles[3] = -beta+psi+gamma-pi  # -pi/2
    angles[4] = -pi/2
    angles[5] = pi/2

    angles[6] = (angles[1]-angles[3]-pi+pi/4)
    print(angles)
    return angles


def main():
    rospy.init_node('move_franka')

    franka_controller = MoveGroup()

    path = [[0.6, 0.25, 0.25], [0.0, -0.5, 0.05], [-0.46, -0.5, 0.05]]

    # Control joint angles of the robot

    franka_controller.open_gripper()
    print("gripper now open")
    print(path)
    for i in range(0, len(path)):
        print(i)
        franka_controller.go_to_joint_state(
            move_robot(path[i][0], path[i][1], path[i][2]))
        print(franka_controller.group.get_current_pose().pose)
        rospy.sleep(2)

    # franka_controller.go_to_joint_state([2.5081,1.4185,0,-1.0002,-pi/2,pi/2,-0.7228])

    #angles = [0, 0, 0, -pi/2, 0, 0, 0]
    #angles[6] = (3*pi/4-angles[1]-angles[3])%(pi)
    # franka_controller.go_to_joint_state(angles)

    rospy.sleep(0.5)

    #angles = [pi/2, pi/4, 0, -pi/2, 0, -pi/2, 0]
    #angles[6] = (pi-angles[1]-angles[3]-pi/4)%(pi)
    # franka_controller.go_to_joint_state(angles)
    franka_controller.open_gripper()
    rospy.sleep(0.5)
    franka_controller.go_to_joint_state(move_robot(0.48, 0.5, 0.05))

    franka_controller.close_gripper()

    print("gripper now closed")

    rospy.sleep(2)

    franka_controller.go_to_joint_state(move_robot(0.5, 0.5, 0.5))
    rospy.sleep(0.5)


if __name__ == '__main__':
    main()

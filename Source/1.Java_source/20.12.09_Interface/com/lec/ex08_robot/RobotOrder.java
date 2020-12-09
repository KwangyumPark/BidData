package com.lec.ex08_robot;

public class RobotOrder 
{
	
	public void action(Robot robot)
	{
		if(robot instanceof DanceRobot)
		{
			DanceRobot dRobot = (DanceRobot)robot;
			dRobot.dance();
		}
		
		else if(robot instanceof SingRobot)
		{
			SingRobot sRobot = (SingRobot)robot;
			sRobot.Sing();
		}
		
		else if(robot instanceof DrawRobot)
		{
			DrawRobot dRobot = (DrawRobot)robot;
			dRobot.draw();
		}
		
	}

}

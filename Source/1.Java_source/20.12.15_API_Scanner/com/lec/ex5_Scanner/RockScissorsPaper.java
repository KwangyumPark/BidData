package com.lec.ex5_Scanner;

import java.util.Scanner;

/*
 * 20.12.15 
 * 컴퓨터와 가위,바위,보 게임을 하여 컴퓨터를 이기면 프로그램 종료
 */

public class RockScissorsPaper 
{
	
	public static void main(String[] args) 
	{
		
		int computer;
		int user;
		String input;
		
		Scanner scanner = new Scanner(System.in);
		
		do
		{
			System.out.print("컴퓨터와 가위,바위,보 게임을 시작 합니다 : ");
			
			input = scanner.nextLine().trim();
			computer = (int)(Math.random()*3);
			
			if(input.equals("가위"))
			{
				user = 0;
			}
			
			else if(input.equals("바위"))
			{
				user = 1;
			}
			
			else if(input.equals("보"))
			{
				user = 2;
			}
			
			else 
			{
				user = -1;
				
				continue;
			}
			
			if((user + 2) %3 == computer) 
			{
				printResult(user, computer);
				
				System.out.println("당신이 이겼습니다. 축하합니다.");
			}
			
			else if(user == computer) 
			{
				printResult(user, computer);
				
				System.out.println("컴류터와 비겼습니다. 게임을 다시 시작 합니다.");
			}
			
			else 
			{
				printResult(user, computer);
				
				System.out.println("당신이 졌습니다. 게임을 다시 시작 합니다.");
			}
			
		}// do
			
		while((user < 0 || user > 2) || ((user + 1) %3 == computer || user == computer));
			
		scanner.close();
			
		System.out.println("게임을 종료 합니다.");
			
			
		}// main
	

		private static void printResult(int user, int computer)
		{
			System.out.println("당신은" + ((user == 0)?"가위":((user == 1)?"바위":"보")));
			
			System.out.println("컴퓨터는 " + ((computer == 0)?"가위":((computer == 1)?"바위":"보")));
		}// pinrtResult
	
		
}// class



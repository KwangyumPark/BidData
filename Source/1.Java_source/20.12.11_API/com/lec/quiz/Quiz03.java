package com.lec.quiz;

/*
 * 20.12.11 Quiz4
 * 
 * String tel;
     while()
     {
    	 번호(031-234-5678)입력 하면 (sc.next())
		"입력한 전화번호 : 031-234-5678
	 	짝수번째 문자열  : 0 1 2 4 5 7
		문자를 꺼꾸로    : 8765-432-130
		전화번호 맨앞자리는: 031
		전화번호 뒷자리는: 5678"을 sysout
  	 	x를 입력하면 프로그램 끝
	}

	본 클래스의 객체를 생성하고 그 클래스의 풀이름 뒤부분만 출력하시오
	ex. com.lec.ex.Ex01 -> Ex01
 */

import java.util.Scanner;

public class Quiz03 
{	
	public static void main(String[] args)
	{
		Quiz03 ex = new Quiz03();
		
		String fullName = ex.getClass().getName();
		String className = fullName.substring(fullName.lastIndexOf(".")+1);
		
		System.out.println(className);
		
		Scanner sc = new Scanner(System.in);
		
		System.out.print("전화번호를 입력하세요. 예)000-000-0000 : ");
		
		while(true)
		{
			String tel = sc.next();
			
			if(tel.equalsIgnoreCase("x")) break;
			
			System.out.println("입력한 전화번호 : " + tel);
			System.out.print("짝수번째 문자열 : ");
			
			for(int i = 0; i < tel.length(); i++)
			{
				if(i%2 == 0)
				{
					System.out.print(tel.charAt(i));
				}
				else
				{
					System.out.print(" ");
				}
			} // for
			
			System.out.println();
			
			System.out.print("문자를 거꾸로 출력 : ");
			
			for(int i = tel.length() - 1; i >= 0; i--)
			{
				System.out.print(tel.charAt(i));
			}
			
			System.out.println();
			
			String pre = tel.substring(0, tel.indexOf("-"));
			String post = tel.substring(tel.lastIndexOf("-")+1);
			
			System.out.println("전화번호 앞자리 : " + pre);
			System.out.println("전화번호 뒷자리 : " + post);
			
			System.out.println();
			System.out.print("다른 전화번호를 입력 하시거나 프로그램 종료를 원하시면  'x'를 입력해 주세요 :");

		} // while
		
		
	} // main
	
} // class

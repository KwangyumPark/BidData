package com.lec.collection;

/*
  	20.12.17 HashMap을 이용한 고객 List 만들기
  	
  	N(n)”을 입력할 때까지 회원가입 정보(이름, 전화번호, 주소)를 HashMap에 받고, 
   "N(n)"을 입력할 시엔 가입한 모든 회원들의 정보를 콘솔창에 출력한다.
    (단, HashMap의 키값은 전화번호, 데이터는 회원정보로 한다.)
    
 */

import java.util.HashMap;
import java.util.Iterator;
import java.util.Scanner;

public class CustomerMain
{
	
	public static void main(String[] args) 
	{
		
		Scanner scanner = new Scanner(System.in);
		String answer, name, phone, address;
		HashMap<String, Customer> customers = new HashMap<String, Customer>();
		
		while(true)
		{
			System.out.print("회원가입을 진행하시겠습니까(Y/N)?");
			answer = scanner.nextLine().trim();
			
			if(answer.equalsIgnoreCase("n")) 
			{
				break;
			}
			
			else if(answer.equalsIgnoreCase("y")) 
			{ 
				System.out.print("가입할 회원의 이름은 ?");
				name = scanner.nextLine();
				
				System.out.print("가입할 회원의 폰번호는 ?");
				phone = scanner.nextLine();
				
				System.out.print("가입할 회원의 주소는 ?");
				address = scanner.nextLine();
				
				customers.put(phone, new Customer(name,phone,address));
			}
		}// while
		
		scanner.close();
		
		if(customers.isEmpty())
		{
			System.out.println("가입한 회원이 없습니다.");
		}
		
		else
		{
			System.out.println("가입한 회원 리스트 목록");
			
			Iterator<String> iterator = customers.keySet().iterator();
			
			while(iterator.hasNext())
			{
				String key = iterator.next();
				
				System.out.println(customers.get(key));
			}// while
			
		}//else
		
		
	}// main

}// class

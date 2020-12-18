package com.lec.customer_list;

import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.OutputStream;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.Scanner;

public class CustomerMain {
	
	public static void main(String[] args) {
		
		String name, phone, birth, address, keyIn;
		Scanner sc = new Scanner(System.in);
		Date today = new Date();
		ArrayList<Customer> customerlist = new ArrayList<Customer>();
		SimpleDateFormat sdf = new SimpleDateFormat("MM-dd");
		String todayStr = sdf.format(today);
		
		do {
			
			System.out.print("회원 가입을 하시겠습니까?(Y/N)");
			keyIn = sc.next().trim();
			
			if(keyIn.equalsIgnoreCase("n")) {
				break;
			}
			
			System.out.print("가입할 회원의 이름은? :");
			name = sc.next();
			
			System.out.print("가입할 회원의 전화 번호는? :");
			phone = sc.next();
			
			System.out.print("가입할 회원의 생일은?(MM-DD) :");
			birth = sc.next();
			
			System.out.print("가입할 회원의 주소는? :");
			sc.nextLine();
			address = sc.nextLine();
			
			if(birth.equals(todayStr)) {
				
				System.out.println(name + "\t" + "회원님의 생일을 축하합니다.");
				
			}
			
			customerlist.add(new Customer(name, phone, birth, address));
			
		}// do 
		while(true);
		
		OutputStream os = null;
		
			try {
				
				os = new FileOutputStream("src/com/lec/customer_list/CustomerList.txt",true);
				
				for(Customer customer : customerlist)
				{
					byte[] bs = customer.toString().getBytes();
					
					System.out.println(customer);
					
					os.write(bs);
				}
				
			} catch (FileNotFoundException e) {
				
				System.out.println("회원 리스트를 찾지 못했습니다." + e.getMessage());
				
			} catch (IOException e) {
				System.out.println("회원 리스트를 사용할 수 없습니다." + e.getMessage());
			} finally {
				try {
					if(os != null) os.close();
					
				} catch (Exception ignore) {
					
					System.out.println(ignore);
				}
				
			}// finally
			
		
	}// main

}// class

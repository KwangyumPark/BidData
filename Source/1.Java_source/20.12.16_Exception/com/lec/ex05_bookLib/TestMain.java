package com.lec.ex05_bookLib;

// 연체료 테스트를 위한 메인 프로그램

import java.util.Date;
import java.util.GregorianCalendar;

public class TestMain 
{
	
	public static void main(String[] args) 
	{
		BookLib book = new BookLib("890ㄱ-01", "java", "홍길동");
		BookLib book1 = new BookLib("890ㄱ-02", "hadoop", "홍하둡");
		
		try 
		{
			book.checkOut("Kim");
			book1.checkOut("Park");
			book.setCheckOutDate(new Date(new GregorianCalendar(2020, 10, 30).getTimeInMillis()));
			book.checkIn();
		} 
		
		catch (Exception e) 
		{ 
			System.out.println(e.getMessage());
		}//try
		
		System.out.println(book);
		System.out.println(book1);
		
	}//main

}

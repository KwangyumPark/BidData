package com.lec.ex09_library;

public class TestMain 
{
	
	public static void main(String[] args) 
	{
		
		Book book1 = new Book("890ㅁ","프레임","최인철");
		Book book2 = new Book("890ㅂ","정의란 무엇인가","마이클 샌댈");
		
		book1.checkIn();
		book1.checkOut("홍길동", "201209");
		book1.checkOut("김길동", "201209");
		
		book1.printState();
		book2.printState();
		
	}

}

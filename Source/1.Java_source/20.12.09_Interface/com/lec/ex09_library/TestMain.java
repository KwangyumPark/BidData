package com.lec.ex09_library;

public class TestMain 
{
	
	public static void main(String[] args) 
	{
		
		Book book1 = new Book("890��","������","����ö");
		Book book2 = new Book("890��","���Ƕ� �����ΰ�","����Ŭ ����");
		
		book1.checkIn();
		book1.checkOut("ȫ�浿", "201209");
		book1.checkOut("��浿", "201209");
		
		book1.printState();
		book2.printState();
		
	}

}

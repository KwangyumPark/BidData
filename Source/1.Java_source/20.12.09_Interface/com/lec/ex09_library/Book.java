package com.lec.ex09_library;

public class Book implements ILendable 
{
	
	private String bookNo;       // å ������ȣ
	private String bookTitle;    // å���� ex) �ڹ�
	private String writer;       // ����
	private String borrower;     // ������ (�Է�)
	private String checkOutDate; // �������� (�Է�)
	private byte state;          // �������
	
	public Book() {} // ����Ʈ ������
	
	

	public Book(String bookNo, String bookTitle, String writer) 
	{
		this.bookNo = bookNo;
		this.bookTitle = bookTitle;
		this.writer = writer;
		borrower = null; // checkOutDate = null;
		state = STATE_NOMAL;
	}


	@Override
	public void checkOut(String borrower, String checkOutDate) 
	{
		if(state != STATE_NOMAL)
		{
			System.out.println("�뿩���� ���� �Դϴ�.");
			
			return;
		}
		
		this.borrower = borrower; // �뿩ó�� ����
		state = STATE_BORRWED;
		
		System.out.println("\"" + bookTitle + "\"������ �뿩 �Ǿ����ϴ�.");

	}

	@Override
	public void checkIn() 
	{
		if(state != STATE_BORRWED)
		{
			System.out.println("�뿩���� ������ �ƴմϴ�. ������ �ֽ��ϴ�.");
			
			return;
		}
		
		borrower = null; // �ݳ�ó�� ����
		state = STATE_NOMAL;
		
		System.out.println("\"" + bookTitle + "\"������ �ݳ� �Ǿ����ϴ�.");
	}

	@Override
	public void printState() 
	{
		if(state == STATE_NOMAL)
		{
			System.out.printf("%s, %s �� - �뿩 ���� �մϴ�.\n", bookTitle, writer);
		}
		
		else if(state == STATE_BORRWED)
		{
			System.out.printf("%s, %s �� - �뿩�� �Դϴ�.\n", bookTitle, writer);
		}
		
		else
		{
			System.out.printf("%s, %s - �뿩 ���°� �Һи� �մϴ�.\n", bookTitle, writer);
		}

	}

}

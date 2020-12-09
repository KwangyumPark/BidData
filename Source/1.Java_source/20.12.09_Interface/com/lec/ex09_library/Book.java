package com.lec.ex09_library;

public class Book implements ILendable 
{
	
	private String bookNo;       // 책 고유번호
	private String bookTitle;    // 책제목 ex) 자바
	private String writer;       // 저자
	private String borrower;     // 대출자 (입력)
	private String checkOutDate; // 대출일자 (입력)
	private byte state;          // 대출상태
	
	public Book() {} // 디폴트 생성자
	
	

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
			System.out.println("대여중인 도서 입니다.");
			
			return;
		}
		
		this.borrower = borrower; // 대여처리 로직
		state = STATE_BORRWED;
		
		System.out.println("\"" + bookTitle + "\"도서가 대여 되었습니다.");

	}

	@Override
	public void checkIn() 
	{
		if(state != STATE_BORRWED)
		{
			System.out.println("대여중인 도서가 아닙니다. 착오가 있습니다.");
			
			return;
		}
		
		borrower = null; // 반납처리 로직
		state = STATE_NOMAL;
		
		System.out.println("\"" + bookTitle + "\"도서가 반납 되었습니다.");
	}

	@Override
	public void printState() 
	{
		if(state == STATE_NOMAL)
		{
			System.out.printf("%s, %s 저 - 대여 가능 합니다.\n", bookTitle, writer);
		}
		
		else if(state == STATE_BORRWED)
		{
			System.out.printf("%s, %s 저 - 대여중 입니다.\n", bookTitle, writer);
		}
		
		else
		{
			System.out.printf("%s, %s - 대여 상태가 불분명 합니다.\n", bookTitle, writer);
		}

	}

}

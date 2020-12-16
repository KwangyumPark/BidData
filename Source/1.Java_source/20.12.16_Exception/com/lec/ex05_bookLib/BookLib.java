package com.lec.ex05_bookLib;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Scanner;

public class BookLib implements ILendable
{
	
	private String bookNo;        // 책번호
	private String bookTitle;     // 책제목
	private String writer;        // 저자
	private String borrower;      // 대여자
	private Date   checkOutDate;  // 대여일
	private byte   status;        // 대출상태 - 대여중(0), 대여가능(0)
	
	public BookLib() {}
	
	public BookLib(String bookNo, String bookTitle, String writer) 
	{
		this.bookNo = bookNo;
		this.bookTitle = bookTitle;
		this.writer = writer;
		status = STATUS_NORMAL;
	}
	
	@Override
	public void checkOut(String borrower) throws Exception 
	{
		if(status != STATUS_NORMAL)
		{
			throw new Exception(bookTitle + "은 대여중 입니다.");
		}
		
		this.borrower = borrower;
		checkOutDate = new Date();
		status = STATUS_BORROWED;
		
		System.out.println("\"" + bookTitle + "\" 이(가) 대여 되었습니다.");
		System.out.println("[대여인]" + borrower);
		
		SimpleDateFormat sDate = new SimpleDateFormat("yyyy년MM월dd일(E)");
		System.out.println("[대여일]" + sDate.format(checkOutDate));
		
	}
	
	@Override
	public void checkIn() throws Exception 
	{
		if(status != STATUS_BORROWED) // 대여중이 아닌 책을 반납 하려할 때 예외처리
		{
			throw new Exception(bookTitle + "은(가) 대여중이 아닌데 반납하려고 합니다. 확인해 주세요.");
		}
		
		Date now = new Date();
		long days = now.getTime() - checkOutDate.getTime(); // 대여일로 부터 경과일 계산
		long passedDays = days / (24*60*60*1000); // 경과시간 계산
		
		if(passedDays > 14) // 14일이 지나면 연체료 발생
		{
			System.out.println("연체료료 일일 200원씩 부과 합니다.");
			
			passedDays = passedDays - 14;
			
			System.out.println("내셔야 할 연체료는 " + (passedDays * 200)+"원");
			
			Scanner sc = new Scanner(System.in);
			
			System.out.print("연체료를 내셨나요(Y/N)? ");
			
			if(!sc.next().equalsIgnoreCase("y")) 
			{
				System.out.println("연체료를 내셔야 반납처리가 됩니다");
				
				return;
			}
			
			
		  }// if
		
		this.borrower = null;
		checkOutDate = null;
		status = STATUS_NORMAL;
		
		System.out.println("\""+bookTitle+"\"이(가) 반납 되었습니다");
	     	
	}// checkIn
		
			@Override
			public String toString() 
			{
				String temp = "\""+bookTitle+"("+bookNo+")\" "+writer+"저 ";
				
				if(status == STATUS_NORMAL) 
				{
					temp += "대여가능";
				}
				
				else if(status == STATUS_BORROWED) 
				{
					SimpleDateFormat sdf = new SimpleDateFormat("yy-MM-dd E요일");
					
					temp += "대출("+sdf.format(checkOutDate)+") 중";
				}
				
				else 
				{
					temp += " 존재하지 않는 책 입니다.";
				}
				
				return temp;
			}
			
			public String getBookTitle() 
			{
				return bookTitle;
			}
			public byte getStatus() 
			{
				return status;
			}
			public void setCheckOutDate(Date checkOutDate) 
			{
				this.checkOutDate = checkOutDate;
			}
			
		

} //class

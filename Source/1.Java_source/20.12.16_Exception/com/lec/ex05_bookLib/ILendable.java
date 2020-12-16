package com.lec.ex05_bookLib;

/*
  20.12.16 인터페이스를 이용하여, 도서관 열람, 대출, 반납기능을 구현. 
     
      대출중인 도서를 대출하거나, 대출 가능한 도서를 반납하려 할 때는 강제로 예외를 발생.
    0 : 전체 대출여부 상태 열람
    1 : 대출
    2 : 반납
        그 외(문자포함) : 종료

 */

public interface ILendable 
{
	
	public byte STATUS_BORROWED = 1; // 대여중
	
	public byte STATUS_NORMAL = 0;    // 대여가능
	
	public void checkOut(String borrower) throws Exception;  // 대여시 Exception 발생
    
	public void checkIn() throws Exception; // 반납중 Exception 발생
    
}

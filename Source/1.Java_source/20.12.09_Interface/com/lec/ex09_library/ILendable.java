package com.lec.ex09_library;

/*
 * 12.09 인터페이스를 이용한 책 대여 및 반납 프로그램 작성
 */

public interface ILendable 
{
	
	public byte STATE_BORRWED = 1; // 책 대여중(대여불가)
	
	public byte STATE_NOMAL = 0; // 책 대여 가능
	
	public void checkOut(String borrower, String checkOutDate); // 책 대여
	
	public void checkIn(); // 책 반납
	
	public void printState(); // "책제목","이름","대여상태"

}

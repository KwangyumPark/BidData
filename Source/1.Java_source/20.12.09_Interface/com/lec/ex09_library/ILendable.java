package com.lec.ex09_library;

/*
 * 12.09 �������̽��� �̿��� å �뿩 �� �ݳ� ���α׷� �ۼ�
 */

public interface ILendable 
{
	
	public byte STATE_BORRWED = 1; // å �뿩��(�뿩�Ұ�)
	
	public byte STATE_NOMAL = 0; // å �뿩 ����
	
	public void checkOut(String borrower, String checkOutDate); // å �뿩
	
	public void checkIn(); // å �ݳ�
	
	public void printState(); // "å����","�̸�","�뿩����"

}

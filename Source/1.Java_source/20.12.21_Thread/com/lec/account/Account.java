package com.lec.account;

/*
 * 20.12.21 Thread의 synchronized를 이용한 입,출금 프로그램.
 */

public class Account {
	
		private int balance;
		
		public Account() {}
	
		public Account(int balance) {
		
			this.balance = balance;
		}
		
		public synchronized void deposit(int amount, String who) {
			
				System.out.println(who + "가 입금시작");
				System.out.println("입금전 잔액: " + balance);
				
				balance += amount;
				
				System.out.println(amount + "원 입금 후 잔액 :" + balance);
				System.out.println(who + "가 임금 끝");
			
		}// deposit
		
		public synchronized void withdraw(int amount, String who) {
			
				System.out.println(who + "가 출금 시작");
				System.out.println("출금전 잔액: " + balance);
				
				if(balance < amount) {
						
						System.out.println("잔액 부족으로 출금 불가.");
					
				} else {
						
						balance -= amount;
						System.out.println(amount + "원 출금 하였습니다. 남은 잔액은 :" + balance);
				}
				
				System.out.println(who + "가 출금 완료");
			
		}// withdraw
		
		public int getBalance() {
			
			return balance;
		}
		
		public void setBalance(int balance) {
			
			this.balance = balance;
		}
	
	

}// class

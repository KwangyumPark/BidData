package com.lec.account;

public class ATM_Card_TestMain {
	
	public static void main(String[] args) {
		Account account = new Account(2000);
		Runnable target = new ATM_Card(account);
		
		Thread mom = new Thread(target, "mom");
		Thread dad = new Thread(target, "dad");
		
		mom.start();
		dad.start();
	
	}// main
	

}// class

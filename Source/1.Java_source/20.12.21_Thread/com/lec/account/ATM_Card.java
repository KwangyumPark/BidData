package com.lec.account;

public class ATM_Card implements Runnable {
	
		private boolean flag = false;
		private Account obj;
		
		public ATM_Card(Account obj) {
		
				this.obj = obj;
		}
		
		public void run() {
			
			for(int i=0; i < 10; i++) {
				
					if(flag) {
					
							obj.withdraw(1000, Thread.currentThread().getName());
							flag = false;
						
					} else {
						
							obj.deposit(1000, Thread.currentThread().getName());
					
					}//if_else
			
			}//for
			
			
		}//run
		

}//main

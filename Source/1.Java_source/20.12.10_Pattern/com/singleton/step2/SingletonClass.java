package com.singleton.step2;


/*
 *  20.12.10
 *  Singleton class 하나에 객체를 한개만 생성하여 전역의 개념으로 사용하는 예제
 */

public class SingletonClass 
{
	
	private static SingletonClass INSTANCE;  // new SingletonClass() 
	
	private int i;
	
	private SingletonClass()
	{
		i = 10;
	}
	
	public static SingletonClass getInstance()
	{
		if(INSTANCE == null)
		{
			INSTANCE = new SingletonClass();
		}
		
		return INSTANCE;
	}

	public int getI() 
	{
		return i;
	}

	public void setI(int i) 
	{
		this.i = i;
	}
	
	
	
}

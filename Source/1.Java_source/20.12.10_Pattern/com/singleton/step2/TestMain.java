package com.singleton.step2;

public class TestMain 
{
	
	public static void main(String[] args)
	{
		FirstClass firstObj    = new FirstClass();
		SecondClass secondObj  = new SecondClass();
		SingletonClass singObj = SingletonClass.getInstance();
		
		System.out.println("메인 메소드에서 singObj 안의 i 값은 : ");
		System.out.println(singObj.getI());
	}

}

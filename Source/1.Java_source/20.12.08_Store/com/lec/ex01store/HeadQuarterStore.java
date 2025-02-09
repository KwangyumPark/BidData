package com.lec.ex01store;

/*
 * 12.08 연습문제 1.
 * 추상 클래스를 이용하여 3개의 가게 음식 메뉴의 가격을 각각 설정할 수 있도록 프로그램을 작성.
 */

public abstract class HeadQuarterStore 
{
	
	private String name;
	
	public HeadQuarterStore(String name) 
	{
		this.name = name;
	}
	
	public abstract void kimchi() ; // 추상(abstract) 메소드
	
	public abstract void bude();
	
	public abstract void bibib();
	
	public abstract void sunde();
	
	public abstract void gonggibab();
	
	public String getName() 
	{
		return name;
	}

}

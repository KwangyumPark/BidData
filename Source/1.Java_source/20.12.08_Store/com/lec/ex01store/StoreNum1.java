package com.lec.ex01store;

//��ġ�-4,500 �δ��-5,000 �����-6,000 ���뱹-���� �����-1,000��

public class StoreNum1 extends HeadQuarterStore
{
	public StoreNum1(String name) 
	{
		super(name);
	}
	
	@Override
	public void kimchi() 
	{
		System.out.println("��ġ� : 4,500��");
	}
	
	@Override
	public void bude() 
	{
		System.out.println("�δ�� : 5,000��");
	}
	
	@Override
	public void bibib() 
	{
		System.out.println("����� : 6,000��");
	}
	
	@Override
	public void sunde() 
	{
		System.out.println("���뱹�� �Ǹž���");
	}
	
	@Override
	public void gonggibab() 
	{
		System.out.println("�����  : 1,000��");
	}
}
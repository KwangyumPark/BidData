package com.lec.collection;

public class Customer 
{
	
	private String name;
	private String phone;
	private String address;
	
	public Customer(String name, String phone, String address) 
	{
		this.name = name;
		this.phone = phone;
		this.address = address;
	}

	@Override
	public String toString() 
	{
		return  name + "\t" + phone + "\t" + address;
	}
	
	
	
	

}

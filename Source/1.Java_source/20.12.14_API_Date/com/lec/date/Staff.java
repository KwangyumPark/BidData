package com.lec.date;

import java.text.SimpleDateFormat;
import java.util.Date;


/*
 * 20.12.14 연습문제 
 * 데이터 : 사번, 이름, 부서, 입사일
 * 생성자 : 이름, 부서, 입사일은 객체생성 당일로 작성
 */

public class Staff 
{
	
	private String name;
	private String emNum;
	private String depart;
	private Date enteredDate;
	
	public Staff(String name, String emNum, String depart) 
	{
		this.name = name;
		this.emNum = emNum;
		this.depart = depart;
		enteredDate = new Date();
	}

	@Override
	public String toString()
	{
		SimpleDateFormat date = new SimpleDateFormat("yy-MM-dd");
		String result = "[사번]" + emNum + "[이름]" + name + "[부서]" + depart + "[입사일]" + date.format(enteredDate);
		
		return result;
	}
	
	
	
	
	

}

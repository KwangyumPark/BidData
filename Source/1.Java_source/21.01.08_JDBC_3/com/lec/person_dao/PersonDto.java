/* 21.01.08 Java Oracle DB 연동
 
 JAVA GUI를 이용한 입,출력 프로그램 - Dto
 
 */

package com.lec.person_dao;

public class PersonDto {
	
	private int    rank;
	private String name;
	private String jname;
	private int kor;
	private int eng;
	private int mat;
	private int sum;
	
	public PersonDto(String name, String jname, int kor, int eng, int mat) {
		this.name = name;
		this.jname = jname;
		this.kor = kor;
		this.eng = eng;
		this.mat = mat;
	}
	
	public PersonDto(int rank, String name, String jname, int kor, int eng, int mat, int sum) {
		this.rank = rank;
		this.name = name;
		this.jname = jname;
		this.kor = kor;
		this.eng = eng;
		this.mat = mat;
		this.sum = sum;
	}
	
	@Override
	public String toString() {
		return rank + "\t" + name + "\t" + jname + "\t" + kor + "\t" + eng
				+ "\t" + mat + "\t" + sum;
	}
	public int getRank() {return rank;}
	public String getName() {return name;}
	public String getJname() {return jname;}
	public int getKor() {return kor;}
	public int getEng() {return eng;}
	public int getMat() {return mat;}
	public int getSum() {return sum;}

}

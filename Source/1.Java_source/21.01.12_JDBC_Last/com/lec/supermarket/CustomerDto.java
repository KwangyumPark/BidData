// 21.01.12 Supermarket 고객관리 프로그램(Dto)

package com.lec.supermarket;

public class CustomerDto {
	
	private int 	cId;
	private String 	cTel;
	private String 	cName;
	private int    	cPoint;
	private int    	cAmount;
	private String 	levelName;
	private int 	forLevelup;
	
	public CustomerDto(int cId, String cTel, String cName, int cPoint, int cAmount, String levelName, int forLevelup) {
		
		this.cId 		= cId;
		this.cTel 		= cTel;
		this.cName 		= cName;
		this.cPoint 	= cPoint;
		this.cAmount 	= cAmount;
		this.levelName 	= levelName;
		this.forLevelup = forLevelup;
	}
	
	@Override
	public String toString() {
		return cId+"\t"+cTel + "\t" + cName + "\t" + cPoint + "\t" + cAmount + "\t" + levelName + "\t" + forLevelup;
	}
	
	// set-get
	public void setcId(int cId) {this.cId = cId;}
	public void setcTel(String cTel) {this.cTel = cTel;}
	public void setcName(String cName) {this.cName = cName;}
	public void setcPoint(int cPoint) {this.cPoint = cPoint;}
	public void setcAmount(int cAmount) {this.cAmount = cAmount;}
	public void setLevelName(String levelName) {this.levelName = levelName;}
	public void setForLevelup(int forLevelup) {this.forLevelup = forLevelup;}
	public int getcId() {return cId;}
	public String getcTel() {return cTel;}
	public String getcName() {return cName;}
	public int getcPoint() {return cPoint;}
	public int getcAmount() {return cAmount;}
	public String getLevelName() {return levelName;}
	public int getForLevelup() {return forLevelup;}

}

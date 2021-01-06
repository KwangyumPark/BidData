// 21.01.06 MySQL Personal Table DB 접속

package com.lec.Ex01_SelectAll;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Timestamp;

public class SelectAll_MySQL {
	
	public static void main(String[] args) {
		
		String driver = "com.mysql.cj.jdbc.Driver"; // 8.0
		String url = "jdbc:mysql://localhost:3306/kimdb?serverTimezone=UTC";
		
		Connection conn = null;
		Statement  stmt = null;
		ResultSet  rs   = null;
		
		String query = "SELECT * FROM PERSONAL";
		
		try {
				Class.forName(driver); 
				conn = DriverManager.getConnection(url, "root","mysql"); 
				stmt = conn.createStatement();
				rs = stmt.executeQuery(query); 
				
				System.out.println("사번\t이름\t직책\t\t상사사번\t입사일\t\t급여\t상여\t부서번호");
				
				if(rs.next()) { 
					
					do{
							int pno      = rs.getInt("pno");
							String pname = rs.getString("pname");
							String job   = rs.getString("job");
							int manager  = rs.getInt("manager");
							Timestamp startdate = rs.getTimestamp("startdate");
							int pay      = rs.getInt("pay");
							int bonus    = rs.getInt("bonus");
							int dno      = rs.getInt("dno");
							
							if(pname!=null && pname.length() < 7) {
								System.out.printf("%d\t %s\t %s\t %d\t %TF\t %d\t %d\t %d\n",
										pno, pname, job, manager, startdate, pay, bonus, dno);
								
						}else {
								System.out.printf("%d\t %s %s\t %d\t %TF\t %d\t %d\t %d\n",
										pno, pname, job, manager, startdate, pay, bonus, dno);
						}
					} while(rs.next());
			} else {
				System.out.println("사원 정보가 없습니다.");
			}
		} catch (ClassNotFoundException e) {
				System.out.println(e.getMessage());
		} catch (SQLException e) {
				System.out.println(e.getMessage());
		} finally { // (7)
			try {
					if(rs  !=null) rs.close();
					if(stmt!=null) stmt.close();
					if(conn!=null) conn.close();
			} catch (Exception e2) {
				
			}
		} // try-catch-finally
		
		
	} // main

} // class

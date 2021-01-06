// 21.01.06 Oracle DB의 DEPT Table에 부서 번호,부서 이름,부서 위치를 Java를 통해 입력

package com.lec.Ex03_Insert;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.Scanner;

public class InsertDept_Oracle {
	
	public static void main(String[] args) {
			
			String driver = "oracle.jdbc.driver.OracleDriver";
			String url = "jdbc:oracle:thin:@localhost:1521:xe";
			Scanner scanner = new Scanner(System.in);
			
			System.out.print("입력할 부서 번호는 ?");
			int deptno = scanner.nextInt();
			
			System.out.print("입력할 부서 이름은 ?");
			String dname = scanner.next();
			
			System.out.print("입력할 부서의 위치는 ?");
			scanner.nextLine(); 
			String loc = scanner.nextLine(); 
			
			Connection conn = null;
			Statement  stmt = null;
			
			String sql = "INSERT INTO DEPT VALUES ("+deptno+",'"+dname+"','"+loc+"')";
			sql = String.format("INSERT INTO DEPT VALUES (%d,'%s','%s')", deptno, dname, loc);
			
			scanner.close();
			
			try {
					Class.forName(driver);
					conn = DriverManager.getConnection(url, "scott","tiger");
					stmt = conn.createStatement();
					int result = stmt.executeUpdate(sql); 
					
					System.out.println(result>0? "부서 입력성공":"부서 입력실패"); 
					
				} catch (ClassNotFoundException e) {
					System.out.println(e.getMessage());
			} catch (SQLException e) {
					System.out.println(e.getMessage());
			}finally { 
				try {
						if(stmt!=null) stmt.close();
						if(conn!=null) conn.close();
				} catch (Exception e) {
						System.out.println(e.getMessage());
				}
				
			} // try-catch-finally
		
	} // main

} // class

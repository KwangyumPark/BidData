// 21.01.06 Oracle DB Table에 있는  부서명을 Java를 통해 입력받아 해당 부서의 부서명, 사원 리스트 출력(사번,이름,급여,급여등급)

package com.lec.Ex02_SelectWhere;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.Scanner;

public class SelectWhereDname_Oracle {
	
	public static void main(String[] args) {
			
			String driver = "oracle.jdbc.driver.OracleDriver";
			String url = "jdbc:oracle:thin:@127.0.0.1:1521:xe";
			Scanner scanner = new Scanner(System.in);
			
			System.out.print("원하는 부서이름은 ?");
			String dname = scanner.next();
			
			Connection conn = null;
			Statement  stmt = null;
			ResultSet  rs   = null;
			
			String sql1 = String.format("SELECT * FROM DEPT WHERE DNAME='%s'", dname);
			String sql2 = String.format("SELECT e.EMPNO, ENAME, SAL, GRADE " + 
													" FROM EMP E, SALGRADE, DEPT D " + 
													" WHERE E.DEPTNO=D.DEPTNO "+
														" AND SAL BETWEEN LOSAL AND HISAL" + 
			
														" AND DNAME='%s'", dname); 
			scanner.close();
			
			try {
					Class.forName(driver);
					conn = DriverManager.getConnection(url, "scott","tiger");//(2)
					stmt = conn.createStatement(); 
					rs = stmt.executeQuery(sql1); 
					
					if(rs.next()) {
						
						System.out.println("부서번호 : " + rs.getInt("deptno"));
						System.out.println("부서이름 : " + dname);
						System.out.println("부서위치 : " + rs.getString("loc"));
						
						rs.close();
						rs = stmt.executeQuery(sql2);
						
						if(rs.next()) {
							System.out.println("사번\t이름\t급여\t급여등급");
							
							do {
								int    empno = rs.getInt("empno");
								String ename = rs.getString("ename");
								int    sal   = rs.getInt("sal");
								int    grade = rs.getInt("grade");
								System.out.println(empno+"\t"+ename+"\t"+sal+"\t"+grade);
							} while(rs.next());
							
					} else {
						System.out.println("해당 부서의 사원은 존재하지 않습니다");
					}
				} else {
						System.out.println("해당 부서이름이 존재하지 않습니다");
				}
			} catch (ClassNotFoundException e) {
					System.out.println(e.getMessage());
			} catch (SQLException e) {
					System.out.println(e.getMessage());
			} finally { 
				try {
						if(rs!=null) rs.close();
						if(stmt!=null) stmt.close();
						if(conn!=null) conn.close();
				} catch (Exception e) {
						System.out.println(e.getMessage());
				}
			} // try-catch-finally
			
	} // main
	
} // class

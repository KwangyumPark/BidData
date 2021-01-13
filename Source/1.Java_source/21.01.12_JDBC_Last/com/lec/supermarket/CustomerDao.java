// 21.01.12 Supermarket 고객관리 프로그램(Dao)

package com.lec.supermarket;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Vector;

public class CustomerDao {
	
	private String driver = "oracle.jdbc.driver.OracleDriver";
	private String url = "jdbc:oracle:thin:@localhost:1521:xe";
	public static final int SUCCESS = 1;
	public static final int FAIL    = 0;
	private static CustomerDao INSTANCE;
	
	public static CustomerDao getInstance() {
		if(INSTANCE==null) {
			INSTANCE = new CustomerDao();
		}
		return INSTANCE;
	}
	
	private CustomerDao() {
		try {
			Class.forName(driver);
		} catch (ClassNotFoundException e) {
			System.out.println(e.getMessage());
		}
	}
	
	//0. 고객등급 레벨로 검색
	public Vector<String> getLevelNames(){
		
		Vector<String> levelNames = new Vector<String>();
		levelNames.add("");
		
		Connection        conn  = null;
		PreparedStatement pstmt = null;
		ResultSet         rs   = null;
		
		String sql = "SELECT LEVELNAME FROM CUS_LEVEL";
		
		try {
				conn = DriverManager.getConnection(url, "scott", "tiger");
				pstmt = conn.prepareStatement(sql);
				rs   = pstmt.executeQuery(); 
			
			while(rs.next()) {
				levelNames.add(rs.getString("levelName"));
			}
		} catch (SQLException e) {
			System.out.println(e.getMessage());
		} finally {
			try {
					if(rs   !=null) rs.close();
					if(pstmt!=null) pstmt.close();
					if(conn !=null) conn.close();
			} catch (Exception e) {
				System.out.println(e.getMessage());
			}
		}
		return levelNames;
		
	} // getLevelNames
	
	//1. cId로 검색
	public CustomerDto cIdGetCustomer(int cId) {
		
		CustomerDto dto = null;
		Connection        conn  = null;
		PreparedStatement pstmt = null;
		ResultSet         rs   = null;
		
		String sql = "SELECT CID, CTEL, CNAME, CPOINT, CAMOUNT, LEVELNAME," + 
				"        (SELECT HIGH-CAMOUNT+1 FROM CUSTOMER WHERE CID=C.CID AND LEVELNO!=5) forLEVELUP" + 
				"    FROM CUSTOMER C, CUS_LEVEL L" + 
				"    WHERE C.LEVELNO=L.LEVELNO" + 
				"        AND cId=?";
		
		try {
				conn = DriverManager.getConnection(url, "scott", "tiger");
				pstmt = conn.prepareStatement(sql);
				pstmt.setInt(1, cId);
				rs   = pstmt.executeQuery(); 
				
				if(rs.next()) {
					//int cId = rs.getInt("cId");
					String cTel = rs.getString("cTel");
					String cName = rs.getString("cName");
					int cPoint = rs.getInt("cPoint");
					int cAmount = rs.getInt("cAmount");
					String levelName  = rs.getString("levelName");
					int forLevelup = rs.getInt("forLevelup");
					dto = new CustomerDto(cId, cTel, cName, cPoint, cAmount, levelName, forLevelup);
			}
		} catch (SQLException e) {
			System.out.println(e.getMessage());
		} finally {
			try {
					if(rs   !=null) rs.close();
					if(pstmt!=null) pstmt.close();
					if(conn !=null) conn.close();
			} catch (Exception e) {
				System.out.println(e.getMessage());
			}
		}
		return dto;
		
	} // cIdGetCustomer
	
	//2. 폰뒤4자리나 폰전체로 검색
	public ArrayList<CustomerDto> cTelGetCustomers(String cTel) {
		
		ArrayList<CustomerDto> dtos = new ArrayList<CustomerDto>();
		Connection        conn  = null;
		PreparedStatement pstmt = null;
		ResultSet         rs   = null;
		
		String sql = "SELECT CID, CTEL, CNAME, CPOINT, CAMOUNT, LEVELNAME," + 
				"        (SELECT HIGH-CAMOUNT+1 FROM CUSTOMER WHERE CID=C.CID AND LEVELNO !=5) forLEVELUP" + 
				"    FROM CUSTOMER C, CUS_LEVEL L" + 
				"    WHERE C.LEVELNO=L.LEVELNO AND CTEL LIKE '%'||?";
		
		try {
				conn = DriverManager.getConnection(url, "scott", "tiger");
				pstmt = conn.prepareStatement(sql);
				pstmt.setString(1, cTel);
				rs   = pstmt.executeQuery(); 
				while(rs.next()) {
					int cId      = rs.getInt("cId");
					cTel         = rs.getString("cTel");
					String cName = rs.getString("cName");
					int cPoint   = rs.getInt("cPoint");
					int cAmount  = rs.getInt("cAmount");
					String levelName  = rs.getString("levelName");
					int forLevelup = rs.getInt("forLevelup");
					dtos.add(new CustomerDto(cId, cTel, cName, cPoint, cAmount, levelName, forLevelup));
			}
		} catch (SQLException e) {
			System.out.println(e.getMessage());
		} finally {
			try {
					if(rs   !=null) rs.close();
					if(pstmt!=null) pstmt.close();
					if(conn !=null) conn.close();
			} catch (Exception e) {
				System.out.println(e.getMessage());
			}
		}
		return dtos;
		
	} // cTelGetCustomers
	
	//3. 고객 이름으로 검색
	public ArrayList<CustomerDto> cNameGetCustomers(String cName){
		
		ArrayList<CustomerDto> dtos = new ArrayList<CustomerDto>();
		Connection        conn  = null;
		PreparedStatement pstmt = null;
		ResultSet         rs   = null;
		
		String sql = "SELECT CID, CTEL, CNAME, CPOINT, CAMOUNT, LEVELNAME," + 
				"        (SELECT HIGH-CAMOUNT+1 FROM CUSTOMER WHERE CID=C.CID AND LEVELNO!=5) forLEVELUP" + 
				"    FROM CUSTOMER C, CUS_LEVEL L" + 
				"    WHERE C.LEVELNO=L.LEVELNO AND CNAME=?";
		
		try {
				conn = DriverManager.getConnection(url, "scott", "tiger");
				pstmt = conn.prepareStatement(sql);
				pstmt.setString(1, cName);
				rs   = pstmt.executeQuery(); 
				
				while(rs.next()) {
					int cId = rs.getInt("cId");
					String cTel = rs.getString("cTel");
					//String cName = rs.getString("cName");
					int cPoint = rs.getInt("cPoint");
					int cAmount = rs.getInt("cAmount");
					String levelName  = rs.getString("levelName");
					int forLevelup = rs.getInt("forLevelup");
					dtos.add(new CustomerDto(cId, cTel, cName, cPoint, cAmount, levelName, forLevelup));
			}
		} catch (SQLException e) {
			System.out.println(e.getMessage());
		} finally {
			try {
					if(rs   !=null) rs.close();
					if(pstmt!=null) pstmt.close();
					if(conn !=null) conn.close();
			} catch (Exception e) {
				System.out.println(e.getMessage());
			}
		}
		return dtos;
		
	} // cNameGetCustomers
	
	//4. 포인트로만 물건구매 
	public int buyWithPoint(int cAmount, int cId) {
		
		int result = FAIL;
		Connection        conn  = null;
		PreparedStatement pstmt = null;
		
		String sql = "UPDATE CUSTOMER SET cPOINT = cPOINT-? WHERE CID=?";
		
		try {
				conn = DriverManager.getConnection(url, "scott", "tiger");
				pstmt = conn.prepareStatement(sql);
				pstmt.setInt(1, cAmount);
				pstmt.setInt(2, cId);
				result  = pstmt.executeUpdate(); 
		} catch (SQLException e) {
			System.out.println(e.getMessage());
		} finally {
			try {
					if(pstmt!=null) pstmt.close();
					if(conn !=null) conn.close();
			} catch (Exception e) {
				System.out.println(e.getMessage());
			}
		}
		return result;
		
	} // buyWithPoint
	 
	//5. 구매
	public int buy(int cAmount, int cId) {
		
		int result = FAIL;
		Connection        conn  = null;
		PreparedStatement pstmt = null;
		
		String sql = "UPDATE CUSTOMER SET cPOINT = cPOINT+?*0.05," + 
				"                cAMOUNT = cAMOUNT + ?," + 
				"                LEVELNO=(SELECT L.LEVELNO " + 
				"                    FROM CUSTOMER C, CUS_LEVEL L" + 
				"                    WHERE cAMOUNT + ? BETWEEN LOW AND HIGH AND CID=?)" + 
				"            WHERE CID=?";
		
		try {
				conn = DriverManager.getConnection(url, "scott", "tiger");
				pstmt = conn.prepareStatement(sql);
				pstmt.setInt(1, cAmount);
				pstmt.setInt(2, cAmount);
				pstmt.setInt(3, cAmount);
				pstmt.setInt(4, cId);
				pstmt.setInt(5, cId);
				result  = pstmt.executeUpdate(); 
		} catch (SQLException e) {
			System.out.println(e.getMessage());
		} finally {
			try {
					if(pstmt!=null) pstmt.close();
					if(conn !=null) conn.close();
			} catch (Exception e) {
				System.out.println(e.getMessage());
			}
		}
		return result;
		
	} // buy
	
	//6. 고객 등급별 출력
	public ArrayList<CustomerDto> levelNameGetCustomers(String levelName){
		
		ArrayList<CustomerDto> dtos = new ArrayList<CustomerDto>();
		Connection        conn  = null;
		PreparedStatement pstmt = null;
		ResultSet         rs   = null;
		
		String sql = "SELECT CID, CTEL, CNAME, CPOINT, CAMOUNT, LEVELNAME," + 
				"        (SELECT HIGH-CAMOUNT+1 FROM CUSTOMER WHERE CID=C.CID AND LEVELNO!=5) forLEVELUP" + 
				"    FROM CUSTOMER C, CUS_LEVEL L" + 
				"    WHERE C.LEVELNO=L.LEVELNO AND LEVELNAME=?"+
				"    ORDER BY CAMOUNT DESC";
		
		try {
				conn = DriverManager.getConnection(url, "scott", "tiger");
				pstmt = conn.prepareStatement(sql);
				pstmt.setString(1, levelName);
				rs   = pstmt.executeQuery(); 
				
				while(rs.next()) {
					int cId = rs.getInt("cId");
					String cTel = rs.getString("cTel");
					String cName = rs.getString("cName");
					int cPoint = rs.getInt("cPoint");
					int cAmount = rs.getInt("cAmount");
					int forLevelup = rs.getInt("forLevelup");
					dtos.add(new CustomerDto(cId, cTel, cName, cPoint, cAmount, levelName, forLevelup));
			}
		} catch (SQLException e) {
			System.out.println(e.getMessage());
		} finally {
			try {
					if(rs   !=null) rs.close();
					if(pstmt!=null) pstmt.close();
					if(conn !=null) conn.close();
			} catch (Exception e) {
				System.out.println(e.getMessage());
			}
		}
		return dtos;
		
	} // levelNameGetCustomers
	
	//7.고객 List 전체 출력
	public ArrayList<CustomerDto> getCustomers(){
		
		ArrayList<CustomerDto> dtos = new ArrayList<CustomerDto>();
		Connection        conn  = null;
		PreparedStatement pstmt = null;
		ResultSet         rs   = null;
		
		String sql = "SELECT CID, CTEL, CNAME, CPOINT, CAMOUNT, LEVELNAME," + 
				"        (SELECT HIGH-CAMOUNT+1 FROM CUSTOMER WHERE CID=C.CID AND LEVELNO!=5) forLEVELUP" + 
				"    FROM CUSTOMER C, CUS_LEVEL L" + 
				"    WHERE C.LEVELNO=L.LEVELNO " +
				"    ORDER BY CAMOUNT DESC";
		
		try {
				conn = DriverManager.getConnection(url, "scott", "tiger");
				pstmt = conn.prepareStatement(sql);
				rs   = pstmt.executeQuery(); 
				
				while(rs.next()) {
					int cId = rs.getInt("cId");
					String cTel = rs.getString("cTel");
					String cName = rs.getString("cName");
					int cPoint = rs.getInt("cPoint");
					int cAmount = rs.getInt("cAmount");
					String levelName  = rs.getString("levelName");
					int forLevelup = rs.getInt("forLevelup");
					dtos.add(new CustomerDto(cId, cTel, cName, cPoint, cAmount, levelName, forLevelup));
			}
		} catch (SQLException e) {
			System.out.println(e.getMessage());
		} finally {
			try {
					if(rs   !=null) rs.close();
					if(pstmt!=null) pstmt.close();
					if(conn !=null) conn.close();
			} catch (Exception e) {
				System.out.println(e.getMessage());
			}
		}
		return dtos;
		
	} // getCustomers
	
	//8. 회원가입 
	public int insertCustomer(String cTel, String cName) {
		
		int result = FAIL;
		Connection        conn  = null;
		PreparedStatement pstmt = null;
		
		String sql = "INSERT INTO CUSTOMER (CID, CTEL, CNAME) VALUES" + 
				"    (CUSTOMER_SEQ.NEXTVAL, ?,?)";
		
		try {
				conn = DriverManager.getConnection(url, "scott", "tiger");
				pstmt = conn.prepareStatement(sql);
				pstmt.setString(1, cTel);
				pstmt.setString(2, cName);
				result  = pstmt.executeUpdate(); 
		} catch (SQLException e) {
			System.out.println(e.getMessage());
		} finally {
			try {
					if(pstmt!=null) pstmt.close();
					if(conn !=null) conn.close();
			} catch (Exception e) {
				System.out.println(e.getMessage());
			}
		}
		return result;
		
	} // insertCustomer
	
	//9. 번호수정
	public int updateCustomer(String cTel, int cId) {
		
		int result = FAIL;
		Connection        conn  = null;
		PreparedStatement pstmt = null;
		
		String sql = "UPDATE CUSTOMER SET CTEL=? WHERE CID=?";
		
		try {
				conn = DriverManager.getConnection(url, "scott", "tiger");
				pstmt = conn.prepareStatement(sql);
				pstmt.setString(1, cTel);
				pstmt.setInt(2, cId);
				result  = pstmt.executeUpdate(); 
		} catch (SQLException e) {
			System.out.println(e.getMessage());
		} finally {
			try {
					if(pstmt!=null) pstmt.close();
					if(conn !=null) conn.close();
			} catch (Exception e) {
				System.out.println(e.getMessage());
			}
		}
		return result;
		
	} // updateCustomer
	
	//10. 회원탈퇴
	public int deleteCustomer(String cId) {
		
		int result = FAIL;
		Connection        conn  = null;
		PreparedStatement pstmt = null;
		
		String sql = "DELETE FROM CUSTOMER WHERE cId=?";
		
		try {
				conn = DriverManager.getConnection(url, "scott", "tiger");
				pstmt = conn.prepareStatement(sql);
				pstmt.setString(1, cId);
				result  = pstmt.executeUpdate(); 
		} catch (SQLException e) {
			System.out.println(e.getMessage());
		} finally {
			try {
					if(pstmt!=null) pstmt.close();
					if(conn !=null) conn.close();
			} catch (Exception e) {
				System.out.println(e.getMessage());
			}
		}
		return result;
		
	} // deleteCustomer

	
} // class

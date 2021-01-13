// 21.01.12 Supermarket 고객관리 프로그램(Swing)

package com.lec.supermarket;

import java.awt.Container;
import java.awt.Dimension;
import java.awt.FlowLayout;
import java.awt.GridLayout;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.util.ArrayList;
import java.util.Vector;
import javax.swing.*;

public class SwingCustomerMng extends JFrame implements ActionListener {
	
	private Container container;
	private JPanel jpup, jpbtn;
	private JTextField txtCId, txtCTel, txtCName, txtCPoint, txtCAmount;
	private Vector<String> levelNames;
	private JComboBox<String> comLevelName;
	private JButton btnCIdSearch, btnCTelSearch, btnCNameSearch, btnBuyWithPoint;
	private JButton btnBuy, btnLevelNameOutput, btnAllOutput, btnInsert, btnCTelUpdate, btnDelete, btnExit;
	private JTextArea txtPool;
	private JScrollPane scrollPane;
	CustomerDao dao = CustomerDao.getInstance();
	
	public SwingCustomerMng(String title) {
		
		super(title);
		setDefaultCloseOperation(EXIT_ON_CLOSE);
		
		container = getContentPane();
		container.setLayout(new FlowLayout());
		
		jpup     		= new JPanel(new GridLayout(6, 3));
		jpbtn    		= new JPanel();
		
		txtCId   		= new JTextField(20);
		txtCTel  		= new JTextField(20);
		txtCName  		= new JTextField(20);
		txtCPoint 		= new JTextField(20);
		txtCAmount 		= new JTextField(20);
		levelNames 		= dao.getLevelNames();
		comLevelName 	= new JComboBox<String>(levelNames);
		
		btnCIdSearch 	= new JButton("아이디 검색");
		btnCTelSearch 	= new JButton("폰4자리(FULL) 검색");
		btnCNameSearch 	= new JButton("고객 이름 검색");
		btnBuyWithPoint = new JButton("포인트로만 구매");
		
		jpup.add(new JLabel(" 아 이 디 ",(int) CENTER_ALIGNMENT));
		jpup.add(txtCId);
		jpup.add(btnCIdSearch);
		jpup.add(new JLabel("고 객 전 화",(int) CENTER_ALIGNMENT));
		jpup.add(txtCTel);
		jpup.add(btnCTelSearch);
		jpup.add(new JLabel("고 객 이 름",(int) CENTER_ALIGNMENT));
		jpup.add(txtCName);
		jpup.add(btnCNameSearch);
		jpup.add(new JLabel("포  인  트",(int) CENTER_ALIGNMENT));
		jpup.add(txtCPoint);
		jpup.add(btnBuyWithPoint);
		jpup.add(new JLabel("구 매 금 액",(int) CENTER_ALIGNMENT));
		jpup.add(txtCAmount);
		jpup.add(new JLabel("")); // 빈 라벨 추가부분
		jpup.add(new JLabel("고 객 등 급",(int) CENTER_ALIGNMENT));
		jpup.add(comLevelName);
		
		btnBuy 				= new JButton("물품 구매");
		btnLevelNameOutput 	= new JButton("등급별출력");
		btnAllOutput 		= new JButton("전체출력");
		btnInsert 			= new JButton("회원가입");
		btnCTelUpdate 		= new JButton("번호수정");
		btnDelete 			= new JButton("회원탈퇴");
		btnExit 			= new JButton("나가기");
		
		jpbtn.add(btnBuy);
		jpbtn.add(btnLevelNameOutput);
		jpbtn.add(btnAllOutput);
		jpbtn.add(btnInsert);
		jpbtn.add(btnCTelUpdate);
		jpbtn.add(btnDelete);
		jpbtn.add(btnExit);
		
		txtPool    = new JTextArea(6, 70);
		scrollPane = new JScrollPane(txtPool);
		
		container.add(jpup);
		container.add(jpbtn);
		container.add(scrollPane);
		
		setSize(new Dimension(800, 400));setLocation(200, 200);
		setVisible(true);
		txtPool.setText("\t★ ★ ★ 고객검색 후 구매하세요 ★ ★ ★");
		
		btnCIdSearch.addActionListener(this);
		btnCTelSearch.addActionListener(this);
		btnCNameSearch.addActionListener(this);
		btnBuyWithPoint.addActionListener(this);
		btnBuy.addActionListener(this);
		btnLevelNameOutput.addActionListener(this);
		btnAllOutput.addActionListener(this);
		btnInsert.addActionListener(this);
		btnCTelUpdate.addActionListener(this);
		btnDelete.addActionListener(this);
		btnExit.addActionListener(this);
	}
	
	@Override
	public void actionPerformed(ActionEvent e) {
		
		if(e.getSource()==btnCIdSearch) { // 아이디(CId) 검색
			int CId = 0;
			
			try {
					CId = Integer.parseInt(txtCId.getText().trim());
			} catch (NumberFormatException e1) {
				txtPool.setText("유효한 고객ID를 입력하시고 아이디 검색하세요");
				return;
			}
			
			CustomerDto customer = dao.cIdGetCustomer(CId);
			
			if(customer!=null) {
				txtPool.setText("ID\t전화\t이름\t포인트\t구매누적액\t고객레벨\t레벨업을 위한 추가 구매할 금액\n");
				txtPool.append("────────────────────────────────────────────────────────\n");
				txtPool.append(customer.toString()+"\n");
				txtCTel.setText(customer.getcTel());
				txtCName.setText(customer.getcName());
				txtCPoint.setText(String.valueOf(customer.getcPoint()));
				txtCAmount.setText("");
				comLevelName.setSelectedItem(customer.getLevelName());
				
			} else {
				txtPool.setText("검색되지 않은 ID입니다");
			}
			
		} else if(e.getSource()==btnCTelSearch) { //폰4자리(FULL)검색
			
			String cTel = txtCTel.getText().trim();
			if(cTel.length()<4) {
				txtPool.setText("적어도 폰4자리 이상 입력하시고 검색하세요");
				return;
			}// if 
			
			ArrayList<CustomerDto> customers = dao.cTelGetCustomers(cTel);
			
			if(customers.size()>=1) {
				txtPool.setText("ID\t전화\t이름\t포인트\t구매누적액\t고객레벨\t레벨업을 위한 추가 구매할 금액\n");
				txtPool.append("────────────────────────────────────────────────────────\n");
				
				for(CustomerDto customer : customers) {
					txtPool.append(customer.toString()+"\n");
					//txtCId.setText(""+customer.getcId());
					txtCId.setText(String.valueOf(customer.getcId()));
					txtCTel.setText(customer.getcTel());
					txtCName.setText(customer.getcName());
					//txtCPoint.setText(""+customer.getcPoint());
					txtCPoint.setText(String.valueOf(customer.getcPoint()));
					txtCAmount.setText("");
					comLevelName.setSelectedItem(customer.getLevelName());
				}//for
			} else {
				txtPool.setText("해당 전화번호의 고객이 검색되지 않습니다. 회원가입 해 주세요");
				txtCId.setText("");
				txtCName.setText("");
				txtCPoint.setText("");
				txtCAmount.setText("");
				comLevelName.setSelectedIndex(0);
			}
			
		} else if(e.getSource()==btnCNameSearch) { // 고객이름검색
			
		} else if(e.getSource()==btnBuyWithPoint) { // 포인트로만 구매
			
			int cId = 0, cAmount = 0, cPoint = 0;
			
			try {
				cId = Integer.parseInt(txtCId.getText().trim());
				cAmount = Integer.parseInt(txtCAmount.getText().trim());
				cPoint = Integer.parseInt(txtCPoint.getText().trim());
				if(cPoint<cAmount) {
					txtPool.setText("포인트가 부족하여 포인트로 구매 불가합니다");
					return;
				}
			} catch (NumberFormatException e1) {
				txtPool.setText("유효한 고객ID와 구매금액을 입력하시고 유효한 포인트로 구매하세요");
				return;
			}
			
			int result = dao.buyWithPoint(cAmount, cId);
			
			if (result==CustomerDao.SUCCESS) {
				txtPool.setText("포인트로 구매 성공");
				txtCPoint.setText(String.valueOf(cPoint-cAmount));
				txtCAmount.setText("");
			} else {
				txtPool.setText("고객 아이디가 유효하지 않습니다");
			}
		} else if(e.getSource()==btnBuy) { // 물품구매
			
		} else if(e.getSource()==btnLevelNameOutput) { // 등급별출력
			
			txtCId.setText("");
			txtCTel.setText("");
			txtCName.setText("");
			txtCPoint.setText("");
			String levelName = comLevelName.getSelectedItem().toString();
			
			if(levelName.equals("")) {
				txtPool.setText("원하는 등급을 선택하시고 검색하세요");
				return;
			}// if - 폰4자리 이상 입력했는지
			
			ArrayList<CustomerDto> customers = dao.levelNameGetCustomers(levelName);
			
			if(customers.size()!=0) {
				txtPool.setText("ID\t전화\t이름\t포인트\t구매누적액\t고객레벨\t레벨업을 위한 추가 구매할 금액\n");
				txtPool.append("────────────────────────────────────────────────────────\n");
				for(CustomerDto customer : customers) {
					txtPool.append(customer.toString()+"\n");
				}//for
				txtPool.append("총 "+customers.size()+"명");
			} else {
				txtPool.setText("해당 레벨의 고객이 검색되지 않습니다. 회원가입 해 주세요");
			}
			
		} else if(e.getSource()==btnAllOutput) { // 전체출력
			
			txtCId.setText("");
			txtCTel.setText("");
			txtCName.setText("");
			txtCPoint.setText("");
			comLevelName.setSelectedIndex(0);
			
			ArrayList<CustomerDto> customers = dao.getCustomers();
			
			if(customers.size()!=0) {
					txtPool.setText("ID\t전화\t이름\t포인트\t구매누적액\t고객레벨\t레벨업을 위한 추가 구매할 금액\n");
					txtPool.append("────────────────────────────────────────────────────────\n");
					for(CustomerDto customer : customers) {
						txtPool.append(customer.toString()+"\n");
				}//for
					txtPool.append("총 "+customers.size()+"명");
			} else {
				txtPool.setText("고객이 검색되지 않습니다");
			}
			
		} else if(e.getSource()==btnInsert) { // 회원가입
			txtCId.setText("");
			txtCAmount.setText("");
			String cTel = txtCTel.getText().trim();
			String cName = txtCName.getText().trim();
				
			if(cTel.equals("") || cName.equals("")) {
					txtPool.setText("전화번호와 이름을 입력후 회원가입이 가능해요");
					return;
			}// if - 회원가입을 위해 전화번호와 이름 입력했는지 여부
				int result = dao.insertCustomer(cTel, cName);
				if(result==CustomerDao.SUCCESS) {
					txtPool.setText("회원가입 감사합니다. 포인트 1000점을 회원가입선물로 드립니다");
					txtCPoint.setText("1000");
					comLevelName.setSelectedIndex(1); // Normal 회원
			}

		} else if(e.getSource()==btnCTelUpdate) { // 번호수정
			
			int cId = 0; String cTel;
			
			try {
				cId = Integer.parseInt(txtCId.getText().trim());
				cTel = txtCTel.getText().trim();
				if(cTel.equals("")) {
					txtPool.setText("변경할 전화번호를 입력하셔야 번호수정이 가능합니다.");
					return;
				}
			} catch (NumberFormatException e1) {
				txtPool.setText("유효한 고객ID를 검색 후 변호변경을 하세요");
				return;
			}
			
			int result = dao.updateCustomer(cTel, cId);
			
			if(result==CustomerDao.SUCCESS) {
				txtPool.setText("아이디 : "+cId+"님의 전화번호가 수정되었습니다");
			} else {
				txtPool.setText("유효한 고객ID를 검색 후 변호변경을 하세요");
			}
			
		} else if(e.getSource()==btnDelete) { // 회원탈퇴
			
			String cId = txtCId.getText().trim();
			
			if(cId.equals("")) {
				txtPool.setText("ID가 있어야 회원탈퇴가 가능합니다");
				return;
			}
			
			int result = dao.deleteCustomer(cId);
			
			if(result==CustomerDao.SUCCESS) {
				txtPool.setText(cId+"님의 회원탈퇴가 완료되었습니다");
				txtCId.setText("");
				txtCTel.setText("");
				txtCName.setText("");
				txtCPoint.setText("");
				comLevelName.setSelectedIndex(0);
			} else {
				txtPool.setText("유효한 아이디가 아니여서 회원탈퇴가 진행되지 않았습니다");
			}
			
		} else if(e.getSource()==btnExit) { // 종료
			setVisible(false);
			dispose();
			System.exit(0);
		}
		
	} // actionPerformed
	
	
	public static void main(String[] args) {
		new SwingCustomerMng("슈퍼메켓 관리");
	}// main
	

} // class

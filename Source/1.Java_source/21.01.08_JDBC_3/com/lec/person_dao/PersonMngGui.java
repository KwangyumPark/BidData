/* 21.01.08 Java Oracle DB 연동
 
 JAVA GUI를 이용한 입,출력 프로그램 - MngGui
 
 */

package com.lec.person_dao;

import java.awt.Container;
import java.awt.Dimension;
import java.awt.FlowLayout;
import java.awt.GridLayout;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.util.ArrayList;
import java.util.Vector;

import javax.swing.ImageIcon;
import javax.swing.JButton;
import javax.swing.JComboBox;
import javax.swing.JFrame;
import javax.swing.JLabel;
import javax.swing.JPanel;
import javax.swing.JScrollPane;
import javax.swing.JTextArea;
import javax.swing.JTextField;

public class PersonMngGui extends JFrame implements ActionListener {
	
	private Container contenPane;
	private JPanel    jpup, jpbtn;
	private JTextField txtName, txtKor, txtEng, txtMat;
	private Vector<String> jnames;
	private JComboBox<String> comJob;
	private JButton btnInput, btnSearch, btnOutput, btnExit;
	private JTextArea txtPool;
	private JScrollPane scrollPane;
	private PersonDao dao = PersonDao.getInstance();
	private ArrayList<PersonDto> person;
	
	public PersonMngGui(String title) {
			
			super(title);
			setDefaultCloseOperation(EXIT_ON_CLOSE);
			contenPane = getContentPane();
			contenPane.setLayout(new FlowLayout());
			
			jpup    = new JPanel(new GridLayout(5,2));
			jpbtn   = new JPanel(new FlowLayout());
			txtName = new JTextField(20);
			jnames  = dao.jnamelist();
			comJob  = new JComboBox<String>(jnames);
			txtKor  = new JTextField(20);
			txtEng  = new JTextField(20);
			txtMat  = new JTextField(20);
			
			ImageIcon icon1 = new ImageIcon("icon/write.gif");
			btnInput = new JButton("입력", icon1);
			ImageIcon icon2 = new ImageIcon("icon/hot.gif");
			btnSearch  = new JButton("직업조회",icon2);
			btnOutput  = new JButton("전체출력");
			btnExit    = new JButton("종료");
			txtPool    = new JTextArea(10,60);
			scrollPane = new JScrollPane(txtPool);
			
			jpup.add(new JLabel("이름", (int)CENTER_ALIGNMENT));
			jpup.add(txtName);
			jpup.add(new JLabel("직업", (int)CENTER_ALIGNMENT));
			jpup.add(comJob);
			jpup.add(new JLabel("국어", (int)CENTER_ALIGNMENT));
			jpup.add(txtKor);
			jpup.add(new JLabel("영어", (int)CENTER_ALIGNMENT));
			jpup.add(txtEng);
			jpup.add(new JLabel("수학", (int)CENTER_ALIGNMENT));
			jpup.add(txtMat);
			
			jpbtn.add(btnInput);
			jpbtn.add(btnSearch);
			jpbtn.add(btnOutput);
			jpbtn.add(btnExit);
			
			contenPane.add(jpup);
			contenPane.add(jpbtn);
			contenPane.add(scrollPane);
			
			setSize(new Dimension(700, 450));
			setLocation(200, 150);
			setVisible(true);
			
			btnInput.addActionListener(this);
			btnSearch.addActionListener(this);
			btnOutput.addActionListener(this);
			btnExit.addActionListener(this);
			
		} // PersonMngGui
	
		@Override
		public void actionPerformed(ActionEvent e) {
			
			if(e.getSource()==btnInput) { //이름, 직업명, 국어수 받아와서 dao.insert 호출
				String name = txtName.getText().trim();
				String jname = comJob.getSelectedItem().toString().trim();
				String korStr = txtKor.getText().trim();
				String engStr = txtEng.getText().trim();
				String matStr = txtMat.getText().trim();
				
				if(name.equals("") || jname.equals("") || korStr.equals("") || 
						engStr.equals("") || matStr.equals("")) {
					txtPool.setText("이름, 직업, 국, 영, 수 모두 입력하셔야 입력 가능");
					return;
				}
				
				int kor = Integer.parseInt(korStr);
				int eng = Integer.parseInt(engStr);
				int mat = Integer.parseInt(matStr);
				PersonDto newPerson = new PersonDto(name, jname, kor, eng, mat);
				int result = dao.insertPerson(newPerson);
				
				if(result==PersonDao.SUCCESS) {
					txtPool.setText(name+"님 입력 성공");
					txtName.setText("");
					comJob.setSelectedIndex(0); // 콤보박스 0번째 선택
					txtKor.setText("");
					txtEng.setText("");
					txtMat.setText("");
				}//if
				
			}else if(e.getSource()==btnSearch) {//직업명으로 dao.selectJanem 호출
				String jname = comJob.getSelectedItem().toString().trim();
				if(jname.equals("")) {
					txtPool.setText("직업을 선택 후 직업조회하세요");
					return;
				}
				
				person = dao.selectJname(jname);
				txtPool.setText("등수\t이름\t직업\t국어\t영어\t수학\t총점\n");
				
				if(person.isEmpty()) {
					txtPool.setText(txtPool.getText()+"해당 직업군의 인원이 없습니다.");
				} else {
					for(PersonDto p : person) {
						txtPool.append(p.toString()+"\n");
					}
				}
			} else if(e.getSource()==btnOutput) {//dao.selectAll 호출
				person = dao.selectAll();
				txtPool.setText("등수\t이름\t직업\t국어\t영어\t수학\t총점\n");
				if(person.isEmpty()) {
					txtPool.setText(txtPool.getText()+"해당 직업군의 인원이 없습니다.");
				} else {
					for(PersonDto p : person) {
						txtPool.append(p.toString()+"\n");
					}
				}
				
			} else if(e.getSource()==btnExit) {
				setVisible(false);
				dispose();
				System.exit(0);
			}
			
		} // actionPerformed
	
	public static void main(String[] args) {
		new PersonMngGui("연예인 성적 관리");
	} // main
	
} //class

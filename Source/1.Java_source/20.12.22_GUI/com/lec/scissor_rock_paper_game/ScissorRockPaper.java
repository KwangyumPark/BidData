package com.lec.scissor_rock_paper_game;

import java.awt.BorderLayout;
import java.awt.Button;
import java.awt.Dimension;
import java.awt.FlowLayout;
import java.awt.Frame;
import java.awt.List;
import java.awt.Panel;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.awt.event.WindowAdapter;
import java.awt.event.WindowEvent;

/*
 * 20.12.22 가위,바위,보 게임을 AWT 객체를 이용하여 구현
 */

public class ScissorRockPaper extends Frame implements ActionListener {
	
		private Panel panel;
		private Button btnS, btnR, btnP, btnExit, btnRemove;
		private List list;
		
		public ScissorRockPaper (String title) {
			
				super(title);
				setLayout(new BorderLayout());
				panel = new Panel(new FlowLayout());
				
				btnS = new Button("가위");
				btnR = new Button("바위");
				btnP = new Button("보");
				btnRemove = new Button("지우기");
				btnExit = new Button("나가기");
				list = new List(5);
				
				panel.add(btnS);
				panel.add(btnR);
				panel.add(btnP);
				panel.add(btnRemove);
				
				add(panel, BorderLayout.NORTH);
				add(list, BorderLayout.CENTER);
				add(btnExit, BorderLayout.SOUTH);
				
				setSize(new Dimension(300, 200));
				setVisible(true);
				
				addWindowListener(new WindowAdapter() {
						
						@Override
						public void windowClosing(WindowEvent e) {
							setVisible(false);
							dispose();
							System.exit(0);
						}
						
				});// window
				
				btnS.addActionListener(this);
				btnR.addActionListener(this);
				btnP.addActionListener(this);
				btnRemove.addActionListener(this);
				btnExit.addActionListener(this);
			
		}// SRP

		@Override
		public void actionPerformed(ActionEvent e) {
			
				int computer = (int)(Math.random()*3); // S:가위, R:바위 , P:보
				
				if (e.getSource() == btnS) {
					
						switch (computer) {
						
						case 0:
								list.add("비겼습니다. 모두 다 가위를 냈습니다.");
						case 1:
								list.add("컴퓨터가 이겼습니다. 당신은 가위, 컴퓨터는 바위"); break;
						case 2:
								list.add("당신이 이겼습니다. 당신은 가위, 컴퓨터는 보"); break;
						}
				} else if(e.getSource()==btnR) { //바위
						
						switch (computer) {
						
						case 0:
							list.add("당신이 이겼습니다. 당신은 바위, 컴퓨터는 가위"); break;
						
						case 1:
							list.add("비겼습니다. 모두 다 가위를 냈습니다."); break;
						
						case 2:
							list.add("컴퓨터가 이겼습니다. 당신은 바위, 컴퓨터는 보");	 break;
						}
						
				} else if(e.getSource()==btnP) {//보
						
						switch (computer) {
						
						case 0:
							list.add("컴퓨터가 이겼습니다. 당신은 보, 컴퓨터는 가위");	 break;
						case 1:
							list.add("당신이 이겼습니다. 당신은 보, 컴퓨터는 바위"); break;
						case 2:
							list.add("비겼습니다.  모두 다 보를 냈습니다.");	break;
						}
						
				} else if(e.getSource()==btnExit) {//종료
						
						setVisible(false);
						dispose();
						System.exit(0);
						
				} else if(e.getSource() == btnRemove) {
						
						list.removeAll();
						
					}// if_else if
					
		
			
		}// action
		
		

}// class

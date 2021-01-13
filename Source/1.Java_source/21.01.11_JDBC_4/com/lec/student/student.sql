-- DROP
DROP TABLE STUDENT;
DROP TABLE MAJOR;
DROP SEQUENCE STUDENT_SEQ;

-- CREATE
CREATE TABLE MAJOR(
    mNO NUMBER(2),
    mNAME VARCHAR2(50),
    PRIMARY KEY(mNO));
CREATE SEQUENCE STUDENT_SEQ MAXVALUE 999 NOCACHE NOCYCLE;
CREATE TABLE STUDENT(
    sNO VARCHAR2(7),
    sNAME VARCHAR2(50),
    mNO NUMBER(2),
    SCORE NUMBER(3) DEFAULT 0 CHECK(SCORE>=0 AND SCORE<=100),
    sEXPEL NUMBER(1) DEFAULT 0 CHECK(sEXPEL=0 OR sEXPEL=1),
    PRIMARY KEY(sNO),
    FOREIGN KEY(mNO) REFERENCES MAJOR(mNO));
    
-- 학과정보 입력
INSERT INTO MAJOR VALUES (1, '빅데이터학');
INSERT INTO MAJOR VALUES (2, '경영정보학');
INSERT INTO MAJOR VALUES (3, '컴퓨터공학');
INSERT INTO MAJOR VALUES (4, '소프트웨어');
INSERT INTO MAJOR VALUES (5, '인공지능학');
SELECT * FROM MAJOR;

INSERT INTO STUDENT (sNO, sNAME, mNO, SCORE) VALUES
    (TO_CHAR(SYSDATE, 'YYYY')
    ||TRIM(TO_CHAR(STUDENT_SEQ.NEXTVAL,'000')),
    '정우성',(SELECT mNO FROM MAJOR WHERE mNAME='빅데이터학'), 90) ;
INSERT INTO STUDENT (sNO, sNAME, mNO, SCORE) VALUES
    (TO_CHAR(SYSDATE, 'YYYY')
    ||TRIM(TO_CHAR(STUDENT_SEQ.NEXTVAL,'000')),
    '박세영',(SELECT mNO FROM MAJOR WHERE mNAME='빅데이터학'), 80) ;
INSERT INTO STUDENT (sNO, sNAME, mNO, SCORE) VALUES
    (TO_CHAR(SYSDATE, 'YYYY')
    ||TRIM(TO_CHAR(STUDENT_SEQ.NEXTVAL,'000')),
    '배수지',(SELECT mNO FROM MAJOR WHERE mNAME='컴퓨터공학'), 20) ;
INSERT INTO STUDENT VALUES
    (TO_CHAR(SYSDATE, 'YYYY')
    ||TRIM(TO_CHAR(STUDENT_SEQ.NEXTVAL,'000')),
    '김제적',(SELECT mNO FROM MAJOR WHERE mNAME='컴퓨터공학'), 10, 1) ;

SELECT * FROM STUDENT;

COMMIT;


-- 스윙StudentMng에서 필요한 Query
-- 0. 첫화면에 전공이름들 콤보박스에 추가(mName) : DAO에서 public Vector<String> getMNamelist()
SELECT MNAME FROM MAJOR;

-- 1. 학번검색 (sNo, sName, mName, score) : DAO에서 public StudentSwingDto sNogetStudent(String sNo)
SELECT SNO, SNAME, MNAME, SCORE FROM STUDENT S, MAJOR M 
    WHERE S.MNO=M.MNO AND SNO='2021001';

-- 2. 이름검색 (sNo, sName, mName, score) : DAO에서 public ArrayList<StudentSwingDto> sNamegetStudent(String sName)
SELECT SNO, SNAME, MNAME, SCORE FROM STUDENT S, MAJOR M 
    WHERE S.MNO=M.MNO AND SNAME='배수지';

-- 3. 전공검색 (rank, sName(sNo포함), mName(mNo포함), score) : DAO에서 public ArrayList<StudentSwingDto> mNamegetStudent(String mName)
--- 출력 : 1 정우성(2021001) 빅데이터학(1) 90 
SELECT ROWNUM RANK, sNAME||'('||sNO||')' sName, mNAME||'('||mNO||')' mNAME, SCORE
    FROM (SELECT S.*, MNAME FROM STUDENT S, MAJOR M 
            WHERE S.mNO=m.mNO AND mNAME='빅데이터학'
            ORDER BY SCORE DESC);
ROLLBACK;

-- 4. 학생입력 : DAO에서 public int insertStudent(String sName, String mName, int score)
--              DAO에서 public int insertStudent(StudentSwingDto dto)
INSERT INTO STUDENT (sNO, sNAME, mNO, SCORE) VALUES
    (TO_CHAR(SYSDATE, 'YYYY')
    ||TRIM(TO_CHAR(STUDENT_SEQ.NEXTVAL,'000')),
    '신길동',(SELECT mNO FROM MAJOR WHERE mNAME='경영정보학'), 40);

COMMIT;

-- 5. 학생수정 : DAO에서 public int updateStudent(String sNo, String sName, String mName, int score)
--              DAO에서 public int updateStudent(StudentSwingDto dto)
SELECT * FROM STUDENT;
UPDATE STUDENT SET  sNAME='신길동', 
                    mNO=(SELECT mNO FROM MAJOR WHERE mNAME='인공지능학'),
                    SCORE = 50
                WHERE SNO='2021006';

COMMIT;

-- 6. 학생출력 (rank, sName(sNo포함), mName(mNo포함), score) : DAO에서 public ArrayList<StudentSwingDto> getStudents()
-- 출력 : 1 정우성(2021001) 빅데이터학(1) 90
SELECT ROWNUM RANK, sNAME||'('||sNO||')' sName, mNAME||'('||MNO||')' MNAME, SCORE
    FROM (SELECT S.*, MNAME FROM STUDENT S, MAJOR M 
            WHERE S.mNO=m.mNO AND sEXPEL=0
            ORDER BY SCORE DESC);

-- 7. 제적자출력  (rank, sName(sNo포함), mName(mNo포함), score) : DAO에서 public ArrayList<StudentSwingDto> getStudentsExpel()
-- 출력 : 1 김제적(2021004) 컴퓨터공학(3) 10
SELECT ROWNUM RANK, sNAME||'('||sNO||')' sName, 
        mNAME||'('||mNO||')' mNAME, SCORE
    FROM (SELECT s.*, mName FROM STUDENT S, MAJOR M 
            WHERE S.mNO=m.mNO AND sEXPEL=1
            ORDER BY SCORE DESC);

-- 8. 제적처리 : DAO에서 public int sNoExpel(String sNo)

UPDATE STUDENT SET sEXPEL = 1 WHERE SNO='2021006';

COMMIT;

SELECT * FROM STUDENT;

SELECT * FROM MAJOR;

UPDATE STUDENT SET sEXPEL = 0;
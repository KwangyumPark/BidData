-- 21.01.04 Oracle View_Inline-View_Top-N


-- [X] VIEW, INLINE VIEW, TOP-N구문

-- 1. VIEW : 가상의 테이블 (1)단순뷰, (2)복합뷰

-- (1)단순뷰
-- EMPv0이라는 VIEW 생성 또는 수정=EMP테이블 일부 필드를 갖는 가상의 테이블

CREATE OR REPLACE VIEW EMPv0   
    AS SELECT EMPNO, ENAME, JOB, DEPTNO FROM EMP;

SELECT * FROM EMPv0;

INSERT INTO EMPv0 VALUES (1111, '홍','IT',40); -- VIEW에 INSERT

SELECT * FROM EMPv0;
SELECT * FROM EMP WHERE EMPNO=1111;

UPDATE EMPv0 SET JOB='ANALYST' WHERE EMPNO=1111;
DELETE FROM EMPv0 WHERE EMPNO=1111;

-- EMPv0이라는 VIEW = EMP의 30번 부서행만
CREATE OR REPLACE VIEW EMPv0
    AS SELECT * FROM EMP WHERE DEPTNO=30;

SELECT * FROM USER_VIEWS; -- 데이터딕셔너리뷰를 확인
SELECT * FROM EMPv0;

DESC EMPv0;

INSERT INTO EMPv0 VALUES (1111,'홍',NULL, NULL, NULL, NULL, NULL,30);
SELECT * FROM EMPv0;

-- 40번 부서 입력은 가능하나 보이지 않음
INSERT INTO EMPv0 VALUES (1112,'홍',NULL, NULL, NULL, NULL, NULL,40);

SELECT * FROM EMPv0; -- 1111 (30번부서만)
SELECT * FROM EMP; -- 1111, 1112

DELETE FROM EMPv0 WHERE EMPNO<1113; -- 30번 부서만 지워짐
DELETE FROM EMP WHERE EMPNO<1113;

COMMIT;

-- EMP 테이블 30번 부서의 가상의 테이블(30번부서만 INSERT 가능)
CREATE OR REPLACE VIEW EMPv0
    AS SELECT * FROM EMP WHERE DEPTNO=30
    WITH CHECK OPTION; -- VIEW의 제한조건

SELECT * FROM EMPv0;

INSERT INTO EMPv0 VALUES (1111,'홍',NULL,NULL,NULL,NULL,NULL,30);

-- WITH CHECK OPTION제한조건 때문에 30번부서만 INSERT 가능
INSERT INTO EMPv0 VALUES (1112,'홍',NULL,NULL,NULL,NULL,NULL,40);

DELETE FROM EMPv0 WHERE EMPNO=1111;

--(2)복합뷰
CREATE OR REPLACE VIEW EMPv1
    AS SELECT EMPNO, ENAME, JOB, DNAME FROM DEPT D, EMP E
            WHERE E.DEPTNO=D.DEPTNO;

SELECT * FROM EMPv1;

INSERT INTO EMPv1 VALUES (1111,'홍','SALESMAN','RESEARCH');

-- 복합뷰 포함 DML명령어를 모두 사용할 수 없는 경우(INSERT,UPDATE,DELETE불가)
CREATE OR REPLACE VIEW EMPv2
    AS SELECT EMPNO, ENAME, DEPTNO FROM EMP
    WITH READ ONLY; -- 읽기 전용 VIEW

SELECT * FROM EMPv2;

SELECT EMPNO, ENAME, DNAME FROM EMPv2 E, DEPT D
    WHERE E.DEPTNO=D.DEPTNO;

INSERT INTO EMPv2 VALUES (1111, '홍', 40);
-- EMP(이름, 급여)
CREATE OR REPLACE VIEW EMPv3
    AS SELECT ENAME, SAL FROM EMP;

SELECT * FROM EMPv3;

INSERT INTO EMPv3 VALUES ('홍',9000); --PRIMARY KEY는 NOT NULL

SELECT * FROM EMP;

DESC EMPv3;

-- EMP(사번, 이름, 연봉=SAL*12)
-- 서브쿼리의 필드명에 특수문자가 있을 경우 1.필드에 바로 별칭
CREATE OR REPLACE VIEW EMPv3
    AS SELECT EMPNO, ENAME, SAL*12 YEARSAL FROM EMP;

-- 서브쿼리의 필드명에 특수문자가 있을 경우 2. 별칭을 따로
CREATE OR REPLACE VIEW EMPv3 (EMPNO, ENAME, YEARSAL)
    AS SELECT EMPNO, ENAME, SAL*12 FROM EMP;

SELECT * FROM EMPv3;

-- VIEW생성시 필드에 연산이 있으면 INSERT 불가
INSERT INTO EMPv3 VALUES (1115, '홍', 12000); 

-- VIEW생성시 필드에 함수를 사용한 경우 INSERT 불가
  -- EMP(사번, 이름, 반올림한 SAL)
CREATE OR REPLACE VIEW EMPv3
    AS SELECT EMPNO, ENAME, ROUND(SAL, -3) SAL FROM EMP;

SELECT * FROM EMPv3;

INSERT INTO EMPv3 VALUES (1115, '홍', 1000); -- VIEW필드에 함수포함

  -- 부서번호, 최소급여, 최대급여, 부서평균을 포함한 DEPTv1 뷰생성
CREATE OR REPLACE VIEW DEPTv1 (DEPTNO, MINSAL, MAXSAL, AVGSAL)
    AS SELECT DEPTNO, MIN(SAL), MAX(SAL), ROUND(AVG(SAL),1) 
            FROM EMP GROUP BY DEPTNO;

SELECT * FROM DEPTv1;

-- 부서번호, 부서명, 최소급여, 최대급여, 부서평균
SELECT DEPT.DEPTNO, DNAME, MINSAL, MAXSAL, ROUND(AVGSAL)
    FROM DEPTv1, DEPT
    WHERE DEPTv1.DEPTNO=DEPT.DEPTNO;

DESC DEPTv1;

INSERT INTO DEPTv1 VALUES (40, 700,9000,4000); --VIEW생성시 필드에 함수

SELECT * FROM EMP WHERE EMPNO<1115;

DELETE FROM EMP WHERE EMPNO<1115;

SELECT COUNT(*) FROM EMP;

 -- EMP(중복이 제거된 JOB, DEPTNO)
SELECT DISTINCT JOB, DEPTNO FROM EMP ORDER BY JOB; -- 서브쿼리

CREATE OR REPLACE VIEW EMPv3
    AS SELECT DISTINCT JOB, DEPTNO FROM EMP ORDER BY JOB;

SELECT * FROM EMPv3;

INSERT INTO EMPv3 VALUES ('CLEAR',10); -- DISTINCT포함한 VIEW


--- 2. INLINE VIEW : SQL문 수행하는 한줄의 명령어에서만 유용한 뷰
                   -- FROM절의 서브쿼리
-- SELECT 필드1, 필드2,  ....
-- FROM EMP E, (서브쿼리) S
-- WHRER 조건 
-- 급여가 2000을 초과하는 사원의 평균급여
SELECT AVG(SAL) FROM EMP WHERE SAL>2000;

SELECT AVG(SAL) FROM (SELECT SAL FROM EMP WHERE SAL>2000);

-- 이름, 급여, 부서번호, 해당사원의 부서평균급여(SELECT 절 서브쿼리 이용)
SELECT ENAME, SAL, DEPTNO, (SELECT AVG(SAL) 
                                FROM EMP WHERE DEPTNO=E.DEPTNO)
    FROM EMP E;

-- 이름, 급여, 부서번호, 해당사원의 부서평균급여(INLINE VIEW 이용)
SELECT ENAME, SAL, DEPTNO FROM EMP; -- (1)

SELECT DEPTNO, ROUND(AVG(SAL)) FROM EMP GROUP BY DEPTNO; -- (2)

SELECT ENAME, SAL, E.DEPTNO, S.AVGSAL
    FROM EMP E, (SELECT DEPTNO, ROUND(AVG(SAL)) AVGSAL
                    FROM EMP GROUP BY DEPTNO) S
    WHERE E.DEPTNO=S.DEPTNO;

-- 이름, 급여, 부서번호, 해당사원의부서평균(부서평균보다 많이 받는 직원만)
SELECT ENAME, SAL, E.DEPTNO, ROUND(AVGSAL)
    FROM EMP E, (SELECT DEPTNO, AVG(SAL) AVGSAL FROM EMP
                    GROUP BY DEPTNO) S
    WHERE E.DEPTNO=S.DEPTNO AND SAL>AVGSAL;


-- 3. TOP-N 구문 (TOP-1~10등, TOP 11~20등 TOP 6~10등)
-- ROWNUM : EMP테이블에서 가져온 순서. 테이블 행의 논리적인 순서
SELECT ROWNUM, ENAME, SAL FROM EMP;

SELECT ROWNUM, ENAME, SAL FROM EMP ORDER BY SAL;

SELECT ROWNUM, ENAME, SAL FROM (SELECT * FROM EMP ORDER BY SAL);

SELECT ROWNUM, ENAME, SAL FROM (SELECT * FROM EMP ORDER BY SAL)
    WHERE ROWNUM<6; -- TOP 1~5등

SELECT ROWNUM, ENAME, SAL FROM (SELECT * FROM EMP ORDER BY SAL)
    WHERE ROWNUM BETWEEN 6 AND 10; -- TOP 6~10등

--함수를 이용한 RANK 출력
SELECT RANK() OVER(ORDER BY SAL) RANK,
       DENSE_RANK() OVER (ORDER BY SAL) D_RANK,
       ROW_NUMBER() OVER (ORDER BY SAL) N_RANK,
       ENAME, SAL
    FROM EMP;

-- TOP-N 구문
SELECT ROWNUM, ENAME, SAL
    FROM (SELECT * FROM EMP ORDER BY SAL)
    WHERE ROWNUM BETWEEN 1 AND 5; -- TOP 6~10등은 불가

SELECT ROWNUM, RN, ENAME, SAL
    FROM (SELECT ROWNUM RN, ENAME, SAL 
            FROM (SELECT * FROM EMP ORDER BY SAL))
    WHERE RN BETWEEN 6 AND 10; -- TOP-N 구문

-- 이름알파벳 순서대로 6~10등까지 출력 (이름, 사번, JOB, MGR, HIREDRE)
SELECT ENAME, EMPNO, JOB, MGR, HIREDATE
    FROM (SELECT ROWNUM RN, ENAME, EMPNO, JOB, MGR, HIREDATE 
            FROM(SELECT * FROM EMP ORDER BY ENAME))
    WHERE RN BETWEEN 6 AND 10;


-- 총 연습문제 --

-- 1. 부서명과 사원명을 출력하는 용도의 뷰, DNAME_ENAME_VU 를 작성하시오
CREATE OR REPLACE VIEW DNAME_ENAME_VU
    AS SELECT DNAME, ENAME FROM EMP E, DEPT D 
        WHERE D.DEPTNO=E.DEPTNO;
SELECT * FROM DNAME_ENAME_VU;

-- 2. 사원명과 직속상관명을 출력하는 용도의 뷰,  WORKER_MANAGER_VU를 작성하시오
CREATE OR REPLACE VIEW WORKER_MANAGER_VU (WORKER, MANAGER)
    AS SELECT W.ENAME, M.ENAME FROM EMP W, EMP M 
            WHERE W.MGR=M.EMPNO;

-- 3. 부서별 급여합계 등수를 출력하시오(부서번호, 급여합계, 등수)
SELECT DEPTNO, SUM(SAL) SUMSAL 
    FROM EMP GROUP BY DEPTNO ORDER BY SUM(SAL) DESC; -- 서브쿼리
SELECT ROWNUM 등수, DEPTNO, SUMSAL FROM
    (SELECT DEPTNO, SUM(SAL) SUMSAL 
            FROM EMP GROUP BY DEPTNO ORDER BY SUM(SAL) DESC);

-- 3-1. 부서별 급여합계 등수가 2~3등인 부서번호, 급여합계, 등수를 출력하시오.
SELECT RN, DEPTNO, SUMSAL
    FROM (SELECT ROWNUM RN, DEPTNO, SUMSAL FROM
    (SELECT DEPTNO, SUM(SAL) SUMSAL 
    FROM EMP GROUP BY DEPTNO ORDER BY SUM(SAL) DESC))
    WHERE RN BETWEEN 2 AND 3;

-- 4. 사번, 사원명, 입사일을 입사일이 최신에서 오래된 사원 순으로 정렬
SELECT EMPNO, ENAME, HIREDATE FROM EMP ORDER BY HIREDATE DESC;

-- 5. 사번, 사원명, 입사일을 입사일이 최신에서 오래된 사원 5명을 출력하시오
SELECT EMPNO, ENAME, HIREDATE
    FROM (SELECT EMPNO, ENAME, HIREDATE FROM EMP 
                                        ORDER BY HIREDATE DESC)
    WHERE ROWNUM<=5;

-- 6. 사원 테이블에서 사번, 사원명, 입사일을 최신부터 오래된 순으로 6번째로 늦은 사원부터 10번째 사원까지 출력
SELECT RN, EMPNO, ENAME, HIREDATE
    FROM (SELECT ROWNUM RN, EMPNO, ENAME, HIREDATE FROM 
                (SELECT * FROM EMP ORDER BY HIREDATE DESC))
    WHERE RN BETWEEN 6 AND 10;
    

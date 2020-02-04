SET SERVEROUTPUT ON 
DECLARE    
    sum_sal  NUMBER(10,2); 
    deptno   NUMBER NOT NULL := 60;           
BEGIN 
    SELECT  SUM(salary)  -- group function 
    INTO sum_sal 
    FROM employees 
    WHERE  department_id = deptno; 
    DBMS_OUTPUT.PUT_LINE ('The sum of salary is ' || sum_sal); 
END; 
--
DECLARE
empno EMPLOYEES.EMPLOYEE_ID%TYPE := 100;
BEGIN
    MERGE INTO copy_emp c
    USING employees e
    ON (e.employee_id = c.EMPLOYEE_ID)
    WHEN MATCHED THEN
    UPDATE SET
        c.first_name = e.first_name,
        c.last_name = e.last_name,
        c.email = e.email,
        c.phone_number = e.phone_number,
        c.hire_date = e.hire_date,
        c.job_id = e.job_id,
        c.salary = e.salary,
        c.commission_pct = e.commission_pct,
        c.manager_id = e.manager_id,
        c.department_id = e.department_id
    WHEN NOT MATCHED THEN
    INSERT VALUES(e.employee_id, e.first_name, e.last_name,
                    e.email, e.phone_number, e.hire_date, e.job_id,
                    e.salary, e.commission_pct, e.manager_id, 
                    e.department_id, E.DEPARTMENT_NAME);
END;
--ROWCOUNT
VARIABLE rows_deleted VARCHAR2(30) 
DECLARE 
    empno employees.employee_id%TYPE := 176; 
BEGIN 
    DELETE FROM COPY_EMP 
    WHERE employee_id = empno; 
    :rows_deleted := (SQL%ROWCOUNT || ' row deleted.'); 
END;
PRINT rows_deleted

--1.departments 테이블에서 최대 부서 ID를 선택하여 max_deptno 변수에 저장하는
--PL/SQL 블록을 생성합니다. 최대 부서 ID를 표시합니다.
--a. 선언 섹션에서 NUMBER 유형의 max_deptno 변수를 선언합니다.
--b. BEGIN 키워드로 실행 섹션을 시작하고 departments 테이블에서 최대
--department_id를 검색하는 SELECT 문을 포함시킵니다.
--c. max_deptno를 표시하고 실행 블록을 종료합니다.
--d. 스크립트를 실행하고 lab_04_01_soln.sql로 저장합니다. 예제의 출력
--결과는 다음과 같습니다.
SELECT * FROM DEPARTMENTS;
DECLARE
    MAX_DEPTNO NUMBER;
BEGIN
    SELECT MAX(DEPARTMENT_ID)
    INTO MAX_DEPTNO
    FROM DEPARTMENTS;
    DBMS_OUTPUT.PUT_LINE(MAX_DEPTNO);
END;
/*2. 연습 1에서 생성한 PL/SQL 블록을 departments 테이블에 새 부서를 삽입하도록
수정합니다.
a. 스크립트 lab_04_01_soln.sql을 엽니다.
departments.department_name 유형의 dept_name 및 NUMBER
유형의 dept_id라는 두 개의 변수를 선언합니다. 선언 섹션에서 dept_name에
"Education"을 할당합니다.
b. 앞에서 이미 departments 테이블에서 현재 최대 부서 번호를 검색했습니다.
이 부서 번호에 10을 더하여 해당 결과를 dept_id에 할당합니다.
c. departments 테이블의 department_name, department_id 및
location_id 열에 데이터를 삽입하는 INSERT 문을 포함시킵니다.
department_name, department_id에는 dept_name, dept_id의 값을
사용하고 location_id에는 NULL을 사용합니다.
d. SQL 속성 SQL%ROWCOUNT를 사용하여 적용되는 행 수를 표시합니다.
e. select 문을 실행하여 새 부서가 삽입되었는지 확인합니다. "/"로 PL/SQL 블록을
종료하고 스크립트에 SELECT 문을 포함시킵니다.
f. 스크립트를 실행하고 lab_04_02_soln.sql로 저장합니다. 예제의 출력 결과는
다음과 같습니다.*/
SELECT * FROM DEPARTMENTS;
DECLARE
    MAX_DEPTNO NUMBER;
    DEPT_NAME DEPARTMENTS.DEPARTMENT_NAME%TYPE := 'Education';
    DEPT_ID NUMBER;
BEGIN
    SELECT MAX(DEPARTMENT_ID)
    INTO MAX_DEPTNO
    FROM DEPARTMENTS;
    DBMS_OUTPUT.PUT_LINE(MAX_DEPTNO);
    DEPT_ID := MAX_DEPTNO +10;
    
    INSERT INTO DEPARTMENTS(DEPARTMENT_NAME, DEPARTMENT_ID, LOCATION_ID)
    VALUES(DEPT_NAME, DEPT_ID, NULL);
    DBMS_OUTPUT.PUT_LINE(SQL%ROWCOUNT);
    
    
END;
/*3. 연습 문제 2에서 location_id를 널로 설정했습니다. 새 부서의 location_id를
3000으로 갱신하는 PL/SQL 블록을 생성합니다. 변수 dept_id 값을 사용하여 행을
갱신합니다.
a. BEGIN 키워드로 실행 블록을 시작합니다. 새 부서(dept_id = 280)의
location_id를 3000으로 설정하는 UPDATE 문을 포함시킵니다.
b. END 키워드로 실행 블록을 종료합니다. "/" 로 PL/SQL 블록을 종료하고 갱신한 부서가
표시되도록 SELECT 문을 포함시킵니다.
c. 추가한 부서를 삭제하도록 DELETE 문을 포함시킵니다.
d. 스크립트를 실행하고 lab_04_03_soln.sql로 저장합니다. 예제의 출력 결과는
다음과 같습니다.*/
DECLARE
    DEPT_ID NUMBER := 280;
BEGIN
    UPDATE DEPARTMENTS
    SET LOCATION_ID = 3000
    WHERE DEPARTMENT_ID = DEPT_ID;
END;
DELETE DEPARTMENTS
WHERE DEPARTMENT_ID = 280;

--4.  TEMP 에서 회장의 이름과 SALARY를 읽어 출력 시켜주는 익명 블록 작성
DECLARE
    E_NM VARCHAR2(20);
    SAL NUMBER;
BEGIN
    SELECT EMP_NAME, SALARY 
    INTO E_NM, SAL
    FROM TEMP
    WHERE LEV = '회장';
    DBMS_OUTPUT.PUT_LINE(E_NM);
    DBMS_OUTPUT.PUT_LINE(SAL);
END;
--5.  CSO001을 포함한 휘하 부서에 있는 모든 직원의 급여 합계를 출력해 주는 
--    익명 블록 작성
DECLARE
    SUM_SAL NUMBER;
BEGIN
    select SUM(SALARY)
    INTO SUM_SAL
    from TEMP A, 
        (SELECT DEPT_CODE
        FROM TDEPT
        START WITH DEPT_CODE = 'CSO001'
        CONNECT BY PRIOR DEPT_CODE = PARENT_DEPT) B
    WHERE A.DEPT_CODE = B.DEPT_CODE;
    DBMS_OUTPUT.PUT_LINE(SUM_SAL);
END;
--6.  익명 블록에서 TEMP를 모두 SELECT 해서 TEMP3를 CREATE 하는 문장을 
--    실행하고 오류확인
/*7.  PL/SQL 블록에서 WORK_YEAR VARCHAR2(04) 변수를 선언하고 
    초기 값으로 ‘2000’ 할당.
    변수를 이용하여 TCOM에서 해당 조건에 맞는 레코드 건수를 세는 쿼리 수행 후 출력
    실제 테이블 데이터와 비교해 보고 차이가 나는지 여부와 차이가 난다면 이유가 
    뭔지 확인.*/
DECLARE
    WORK_YEAR VARCHAR2(04) := '2000';
    CNT NUMBER;
BEGIN
    SELECT COUNT(*)
    INTO CNT
    FROM TCOM
    WHERE WORK_YEAR = WORK_YEAR;
    DBMS_OUTPUT.PUT_LINE(CNT);
END;
--8. 7번에서 WORK_YEAR 변수 명을 TCOM으로 바꾸고 ‘2018’로 초기화 한 후 
--   해당 변수를 WORK_YEAR와 비교하여 조건에 맞는 건수 COUNT 후 출력 및 결과 확인
DECLARE
    TCOM VARCHAR2(04) := '2018';
    CNT NUMBER;
BEGIN
    SELECT COUNT(*)
    INTO CNT
    FROM TCOM
    WHERE WORK_YEAR = TCOM;
    DBMS_OUTPUT.PUT_LINE(CNT);
END;
--9. TCOM의 2019년 자료 COMM UPDATE 
--   (자신이 부서장이면 SALARY의 0.5%, 부서장이 아니면 1%로)
SELECT * FROM TCOM;
DECLARE
BEGIN
    UPDATE TCOM C
    SET COMM = (
        SELECT SALARY * DECODE(A.EMP_ID,B.BOSS_ID,0.005,0.01)
        FROM TEMP A, TDEPT B
        WHERE A.DEPT_CODE = B.DEPT_CODE
        AND A.EMP_ID = C.EMP_ID
        )
    WHERE WORK_YEAR = 2019;
END;

/*BONUS
1. TEST10에 존재하는 LINE과 SPEC이 아닌 경우는
   TEST09에서 데이터 삭제하는 익명 블록을 작성하되 COMMIT없이,
   또한 삭제 전 RECORD 건수와 삭제 후 RECORD건수 출력하여 확인*/
SELECT * FROM TEST10;
DECLARE
    CNT NUMBER;
BEGIN
    SELECT COUNT(*) INTO CNT FROM TEST09;
    DBMS_OUTPUT.PUT_LINE(CNT);
    DELETE 
    FROM TEST09 
    WHERE (LINE, SPEC) NOT IN (SELECT LINE, SPEC
                                FROM TEST10);
    SELECT COUNT(*) INTO CNT FROM TEST09;
    DBMS_OUTPUT.PUT_LINE(CNT);
END;
COMMIT;
/*2. TCOM 2019년에 존재하지 않는 사번에 대해 TCOM에 2019년으로 신규 INSERT
   (보너스 RATE = 1, COMM은 부서장은 SALARY의 0.5% 아니면 1%로)
   COMMIT;
   
   2019년 자료 대상
   19건
   55건 */
DECLARE
    CNT NUMBER;
BEGIN
    SELECT COUNT(*) INTO CNT FROM TCOM WHERE WORK_YEAR = 2019;
    DBMS_OUTPUT.PUT_LINE(CNT);
    
    INSERT INTO TCOM
    SELECT 2019,A.EMP_ID,1, A.SALARY * DECODE(A.EMP_ID, B.BOSS_ID,0.005,0.01) COMM
    FROM TEMP A, TDEPT B
    WHERE A.DEPT_CODE = B.DEPT_CODE 
    AND A.EMP_ID NOT IN (SELECT EMP_ID FROM TCOM WHERE WORK_YEAR = 2019);
    
    SELECT COUNT(*) INTO CNT FROM TCOM WHERE WORK_YEAR = 2019;
    DBMS_OUTPUT.PUT_LINE(CNT);
END;
SELECT * FROM TDEPT;
--3.TCOM의 전체 RECORD를 대상으로 BONUS_RATE를 0으로 업데이트한
--직후의 SQL%ROWCOUNT 속성값을 변수에 할당하여 출력하고,
--SQL%NOTFOUND 인지 SQL%FOUND인지 확인하여 결과 출력 후
--블록 종료전 ROLLBACK;
DECLARE
    RC NUMBER;
BEGIN
    UPDATE TCOM
    SET BONUS_RATE = 0;
    
    RC := SQL%ROWCOUNT;
    
    IF SQL%NOTFOUND = TRUE
    THEN DBMS_OUTPUT.PUT_LINE('NOTFOUND TURE');
    ELSIF SQL%FOUND = TRUE
    THEN DBMS_OUTPUT.PUT_LINE('FOUND TURE');
    ELSE DBMS_OUTPUT.PUT_LINE('GG');
    END IF;
    ROLLBACK;
END;
--
CREATE TABLE TEMP2 AS
SELECT * FROM TEMP;

CREATE TABLE TCOM1 AS
SELECT * FROM TCOM
WHERE WORK_YEAR = 0;

CREATE TABLE EMP_LEVEL1 AS
SELECT * FROM EMP_LEVEL
WHERE LEV = '0';

SELECT * FROM TEVAL;
SELECT * FROM TCODE;
SELECT A.EMP_ID, A.EMP_NAME, B.BOSS_ID
FROM TEMP2 A, TDEPT B
WHERE A.DEPT_CODE = B.DEPT_CODE;
/*
입력받은 성명을 이용해 TEMP2를 읽어 WORK_YEAR = '2019'으로 하여 TCOM1에 해당 사번을 
INSERT (COMM은 무조건 10%) 하고 , EMP_LEVEL1에도 INSERT합니다
(최초는 FROM, TO 동일 값 이후 UPDATE는 범위확인해서 범위에 들지않는 경우만 범위확장),
마지막으로 TEVAL에 YM_EV='201901',EMP_ID,EV_CD(=KNO)
(TCODE에서 MAIN_CD = 'A002'인 4건, EV_EMP는 자신의 보스를 입력)
TEVAL 입력단계에서 BOSS를 찾기 위해 TDEPT2에 접근할때 매칭코드가 없어
부서를 찾지 못해 실패하는 경우라도 TCOM2와 EMP_LEVEL2 까지의 작업은 COMMIT 해야합니다
SAVEPOINT를 사용하는 해당 PROCEDURE를 생성하세요 => 한글로 로직흐름 먼저 정의
기능1 
- TEMP을 읽어 TCOM1에 INSERT
-성공여부 출력
기능2 
- EMP_LEVEL1 UPDATE
-대상이 없는 신규입력건은 UPDATE후 커서 속성 확인후 성공 여부 출력
-커서 속성이 NOTFOUND인 경우는 INSERT 수행
기능3
-BOSS 찾기
-INSERT 성공 실패여부 출력
-부서 정보가 없어서 실패하 경우는 기능2까지의 수행결과만 저장 성공한 경우는 기능3까지 저장*/
SELECT * FROM TCOM1;
SELECT * FROM EMP_LEVEL1;

CREATE OR REPLACE PROCEDURE QWER(P1 TEMP2.EMP_NAME%TYPE) IS
    A_ID NUMBER;
    B_ID NUMBER;
    NF VARCHAR2(20);
    L1 VARCHAR2(20);
    L2 VARCHAR2(20);
    SAL NUMBER;
    F_SAL NUMBER;
    T_SAL NUMBER;
BEGIN
    SELECT A.EMP_ID, B.EMP_ID
    INTO A_ID, B_ID
    FROM TEMP2 A, TCOM1 B 
    WHERE A.EMP_NAME = P1
    AND A.EMP_ID = B.EMP_ID(+);
    
    IF B_ID IS NULL THEN
    INSERT INTO TCOM1
    SELECT 2019, EMP_ID, 10, SALARY * 0.1
    FROM TEMP2
    WHERE EMP_NAME = P1;
    DBMS_OUTPUT.PUT_LINE('TCOM1 INSERT 완료');
    END IF;
    
    SELECT A.LEV, A.SALARY, B.LEV, B.FROM_SAL, B.TO_SAL
    INTO L1, SAL, L2, F_SAL, T_SAL
    FROM TEMP2 A, EMP_LEVEL1 B
    WHERE A.LEV = B.LEV(+)
    AND A.EMP_NAME = P1;

    IF L2 IS NULL
    THEN
        INSERT INTO EMP_LEVEL1
        SELECT LEV, SALARY, SALARY, NULL, NULL
        FROM TEMP2
        WHERE EMP_NAME = P1;
            DBMS_OUTPUT.PUT_LINE('EMP_LEVEL1 INSERT 완료');
    END IF;
    
    IF F_SAL > SAL 
    THEN
        UPDATE EMP_LEVEL1
        SET FROM_SAL = SAL
        WHERE LEV = L1;
    END IF;
    
    IF T_SAL < SAL
    THEN
        UPDATE EMP_LEVEL1
        SET TO_SAL = SAL
        WHERE LEV = L1;
    END IF;
    
    INSERT INTO TEVAL
    SELECT 201901, B.EMP_ID, B.KNO,NULL, A.BOSS_ID
    FROM TDEPT A,
        (SELECT B.EMP_ID, A.KNO, B.DEPT_CODE
        FROM TCODE A, TEMP2 B
        WHERE A.MCD = 'A002'
        AND B.EMP_NAME = P1) B
    WHERE A.DEPT_CODE = B.DEPT_CODE;
    
    SAVEPOINT SP;
END;

SELECT * FROM TCOM1;
SELECT * FROM EMP_LEVEL1;
SELECT * FROM TEVAL WHERE EMP_ID = 19960101;
SELECT * FROM TEMP2 WHERE LEV = '과장';
EXECUTE QWER('홍길동'); 
ROLLBACK TO SP;
ROLLBACK;





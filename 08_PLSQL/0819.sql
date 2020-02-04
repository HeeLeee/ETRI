CREATE TABLE retired_emps
AS
SELECT EMPLOYEE_ID EMPNO, LAST_NAME ENAME, JOB_ID JOB, MANAGER_ID MGR, HIRE_DATE HIREDATE, HIRE_DATE LEAVEDATE, SALARY SAL, COMMISSION_PCT COMM, DEPARTMENT_ID DEPTNO
FROM EMPLOYEES
WHERE ROWNUM < 1;
--
DEFINE employee_number = 124
DECLARE
emp_rec   employees%ROWTYPE;
BEGIN
SELECT * INTO emp_rec FROM employees
WHERE  employee_id = &employee_number;
INSERT INTO retired_emps(empno, ename, job, mgr,
hiredate, leavedate, sal, comm, deptno)
VALUES (emp_rec.employee_id, emp_rec.last_name,
emp_rec.job_id,emp_rec.manager_id,
emp_rec.hire_date, SYSDATE, emp_rec.salary,   
emp_rec.commission_pct, emp_rec.department_id);
END;

SELECT * FROM retired_emps;
--2차원 레코드
DECLARE
    TYPE EMP_SAL IS RECORD (EMP_ID TEMP.EMP_ID%TYPE, SALARY NUMBER);
    TYPE EMP_TAB IS RECORD(REC1 EMP_SAL, REC2 EMP_SAL);
    TAB_SAL EMP_TAB;
BEGIN
    SELECT EMP_ID, SALARY
    INTO TAB_SAL.REC1
    FROM TEMP
    WHERE ROWNUM < 2;

    SELECT EMP_ID, SALARY
    INTO TAB_SAL.REC2
    FROM TEMP
    WHERE EMP_NAME = '홍길동';
    
    DBMS_OUTPUT.PUT_LINE('EMP_ID1 : '||TAB_SAL.REC1.EMP_ID);
    DBMS_OUTPUT.PUT_LINE('SALARY1 : '||TAB_SAL.REC1.SALARY);
    DBMS_OUTPUT.PUT_LINE('EMP_ID2 : '||TAB_SAL.REC2.EMP_ID);
    DBMS_OUTPUT.PUT_LINE('SALARY2 : '||TAB_SAL.REC2.SALARY);
END;
--%ROWTYPE을 사용하여 레코드 삽입
DEFINE employee_number = 124
DECLARE
emp_rec  retired_emps%ROWTYPE;
BEGIN
SELECT employee_id, last_name, job_id, manager_id, 
hire_date, hire_date, salary, commission_pct,
department_id INTO emp_rec FROM employees
WHERE  employee_id = &employee_number;
INSERT INTO retired_emps VALUES emp_rec;
END;
/
SELECT * FROM retired_emps;

--레코드를 사용하여 테이블의 행 갱신
SET SERVEROUTPUT ON
SET VERIFY OFF
DEFINE employee_number = 124
DECLARE
emp_rec retired_emps%ROWTYPE;
BEGIN
SELECT * INTO emp_rec FROM retired_emps;
emp_rec.leavedate:=SYSDATE;
UPDATE retired_emps SET ROW = emp_rec WHERE 
empno=&employee_number; 
END;

SELECT * FROM retired_emps;
--
DECLARE 
    TYPE ename_table_type IS TABLE OF 
        employees.last_name%TYPE INDEX BY PLS_INTEGER; 
    TYPE hiredate_table_type IS TABLE OF    
        DATE INDEX BY PLS_INTEGER; 
    ename_table ename_table_type; 
    hiredate_table hiredate_table_type; 
BEGIN 
    ename_table(1) := 'CAMERON'; 
    hiredate_table(8) := SYSDATE + 7; 
    IF ename_table.EXISTS(1) THEN 
    DBMS_OUTPUT.PUT_LINE(ENAME_TABLE(1));
    END IF;
    IF HIREDATE_table.EXISTS(8) THEN 
    DBMS_OUTPUT.PUT_LINE(HIREDATE_TABLE(8));
    END IF;
END;

DECLARE
    TYPE T1_TAB IS TABLE OF T1_DATA%ROWTYPE
    INDEX BY PLS_INTEGER;
    TAB1 T1_TAB;
    CNT NUMBER := 0;
BEGIN 
    FOR I IN -4..5
    LOOP
        CNT := CNT + 1;
        TAB1(I).NO := CNT;
        DBMS_OUTPUT.PUT_LINE('INDEX: '||I);
        DBMS_OUTPUT.PUT_LINE('COUNT: '||TAB1.COUNT);
        DBMS_OUTPUT.PUT_LINE('FIRST: '||TAB1.FIRST);
        DBMS_OUTPUT.PUT_LINE('LAST: '||TAB1.LAST);
        DBMS_OUTPUT.PUT_LINE('PRIOR: '||TAB1.PRIOR(I));
        DBMS_OUTPUT.PUT_LINE('NEXT: '||TAB1.NEXT(I));
        IF I=0 THEN
            TAB1.DELETE(1);
        END IF;
    END LOOP;
    --
    FOR J IN -4..5 LOOP
        DBMS_OUTPUT.PUT_LINE(J|| ' ''S VALUES ===========START');
        IF TAB1.EXISTS(J) THEN
           DBMS_OUTPUT.PUT_LINE(J|| ' INDEX''S VALUE NO: '||TAB1(J).NO);
        ELSE
            DBMS_OUTPUT.PUT_LINE(J|| ' INDEX''S VALUE NO NOT FOUND=!!!!!');  
        END IF;
        DBMS_OUTPUT.PUT_LINE(J|| ' INDEX''S VALUE =======================END'); 
    END LOOP;
END;
--
SET SERVEROUTPUT ON 
DECLARE 
    TYPE location_type IS TABLE OF 
    locations.city%TYPE; 
    offices location_type; 
    table_count NUMBER; 
BEGIN 
    offices := location_type('Bombay', 'Tokyo','Singapore', 'Oxford'); 
    table_count := offices.count(); 
    FOR i in 1..table_count 
        LOOP DBMS_OUTPUT.PUT_LINE(offices(i)); 
    END LOOP; 
END;
--PLSQL  188페이지
/*1. 제공된 국가에 대한 정보를 출력하는 PL/SQL 블록을 작성합니다. 
    a. countries 테이블의 구조에 맞게 PL/SQL 레코드를 선언합니다.
    b. DEFINE 명령을 사용하여 countryid 변수를 정의합니다. countryid에 CA를 할당합니다. 이 값을 치환 변수를 사용하여 PL/SQL 블록에 전달합니다. 
    c. 선언 섹션에서 %ROWTYPE 속성을 사용하여 countries 유형의 country_record 변수를 선언합니다. 
    d. 실행 섹션에서 countryid를 사용하여countries 테이블의 모든 정보를 가져옵니다. 선택한 국가의 정보를 표시합니다. 다음은 출력 예입니다.*/
SELECT * FROM COUNTRIES;

DEFINE COUNTRYID = "'CA'";
DECLARE
    COUNTRY_REC COUNTRIES%ROWTYPE;
BEGIN
    SELECT * 
    INTO COUNTRY_REC
    FROM COUNTRIES
    WHERE COUNTRY_ID = &COUNTRYID;
END;
/*
2. INDEX BY 테이블과 통합하여 departments 테이블에서 일부 부서 이름을 검색하여 각 부서 이름을 화면에 출력하는 PL/SQL 블록을 생성합니다. 
    스크립트를 lab_06_02_soln.sql로 저장합니다. 
a. departments.department_name 유형의 INDEX BY 테이블 dept_table_type을 선언합니다. 
    dept_table_type 유형의 my_dept_table 변수를 선언하여 부서 이름을 임시로 저장합니다. 
b. NUMBER 유형의 두 변수loop_count 및 deptno를 선언합니다. loop_count에 10을 할당하고 deptno에 0을 할당합니다. 
c. 루프를 사용하여 10개의 부서 이름을 검색하고 INDEX BY 테이블에 이름을 저장합니다. department_id를 10에서 시작합니다. 
    루프가 반복할 때마다 deptno를 10씩 증가시킵니다. 
    다음 테이블은 department_name을 검색하고 INDEX BY 테이블에 저장할 department_id를 보여줍니다.
d. 다른 루프를 사용하여 INDEX BY 테이블에서 부서 이름을 검색한 다음 정보를 출력합니다. 
e. 스크립트를 실행하고 lab_06_02_soln.sql로 저장합니다. 출력 결과는 다음과 같습니다*/
SELECT * FROM DEPARTMENTS;
DECLARE
    TYPE dept_table_type IS TABLE OF 
    departments.department_name%TYPE
    INDEX BY PLS_INTEGER;
    my_dept_table dept_table_type;
    LOOP_COUNT NUMBER := 10;
    DEPTNO NUMBER := 0;
BEGIN
    FOR I IN 1..10 LOOP
        DEPTNO := DEPTNO + LOOP_COUNT;
        SELECT DEPARTMENT_NAME
        INTO  my_dept_table(I)
        FROM DEPARTMENTS
        WHERE DEPARTMENT_ID = DEPTNO;
    END LOOP;
    FOR J IN 1..10 LOOP
        DBMS_OUTPUT.PUT_LINE('DEPARTMENT_NAME: '|| my_dept_table(J));
    END LOOP;
END;
/*3. departments 테이블에서 각 부서 정보를 모두 검색하여 출력하도록 2번 문제에서 생성한 블록을 수정합니다. 
    INDEX BY 레코드 테이블을 사용합니다. 
a. lab_06_02_soln.sql 스크립트를 엽니다. 
b. INDEX BY 테이블은 departments.department_name 유형으로 선언된 상태입니다. 
    부서의 번호, 이름, manager_id 및 위치를 임시로 저장하도록 INDEX BY 테이블의 선언을 수정합니다. 
    %ROWTYPE 속성을 사용합니다. 
c. departments 테이블의 현재 모든 부서 정보를 검색하도록 select 문을 수정하고 INDEX BY 테이블에 저장합니다. 
d. 다른 루프를 사용하여 INDEX BY 테이블에서 부서 정보를 검색한 다음 정보를 출력합니다. 다음은 출력 예입니다.*/
DECLARE
    TYPE dept_table_type IS TABLE OF 
    departments%ROWTYPE
    INDEX BY PLS_INTEGER;
    my_dept_table dept_table_type;
    LOOP_COUNT NUMBER := 10;
    DEPTNO NUMBER := 0;
BEGIN
    FOR I IN 1..10 LOOP
        DEPTNO := DEPTNO + LOOP_COUNT;
        SELECT *
        INTO  my_dept_table(I)
        FROM DEPARTMENTS
        WHERE DEPARTMENT_ID = DEPTNO;
    END LOOP;
    FOR J IN my_dept_table.FIRST..my_dept_table.LAST LOOP
        DBMS_OUTPUT.PUT_LINE('DEPARTMENT_ID: '||my_dept_table(J).DEPARTMENT_ID||
                            ' DEPARTMENT_NAME: '||my_dept_table(J).DEPARTMENT_NAME||
                            ' MANAGER_ID: '||my_dept_table(J).MANAGER_ID||
                            ' LOCATION_ID: '||my_dept_table(J).LOCATION_ID);
    END LOOP;
END;
SELECT * FROM DEPARTMENTS;
/*4.
선언부에서 TEMP 의 EMP_ID와 SALARY 정보를 담을 수 있는 PL/SQL RECORD TYPE 선언
   선언된 타입으로 변수 선언
   TEMP 에서 EMP_ID와 SALARY를 상위 3건만 읽어오는 커서 선언
   선언된 커서를 FETCH 하며 PL/SQL RECORD 변수에 담고, 해당 변수의 값을 
   읽어 사번과 급여 각각 출력 */
DECLARE
    TYPE REC IS RECORD(EMP_ID TEMP.EMP_ID%TYPE, SALARY TEMP.SALARY%TYPE);
    EMP_REC REC;
    
    CURSOR CUR IS
    SELECT EMP_ID, SALARY
    FROM(
        SELECT EMP_ID, SALARY
        FROM TEMP
        ORDER BY SALARY DESC, EMP_ID)
    WHERE ROWNUM < 4;
BEGIN
    OPEN CUR;
    LOOP
        FETCH CUR
        INTO EMP_REC;
        EXIT WHEN CUR%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE('EMP_ID :'||EMP_REC.EMP_ID ||'SALARY :'||EMP_REC.SALARY);
    END LOOP;
END;
/*5. BOM_R_TYPE 이름으로 BOM의 ROW와 동일한 구조의 PL/SQL 레코드 TYPE 선언
   BOM_REC 변수를 BOM_R_TYPE 형식으로 선언 후 BEGIN SECTION에서
   BOM 테이블의 ROWNUM=1 인 한 건을 SELECT 하여 BOM_REC에 할당
   BOM_REC 조합 변수 내의 값들 각각 출력*/
SELECT * FROM BOM;
DECLARE
    TYPE BOM_R_TYPE IS RECORD(SPEC_CODE BOM.SPEC_CODE%TYPE,
                            ITEM_CODE BOM.ITEM_CODE%TYPE,
                            ITEM_QTY BOM.ITEM_QTY%TYPE);
    BOM_REC BOM_R_TYPE;
BEGIN
    SELECT *
    INTO BOM_REC
    FROM BOM
    WHERE ROWNUM = 1;
    DBMS_OUTPUT.PUT_LINE('SPEC_CODE :'||BOM_REC.SPEC_CODE||
                        ' ITEM_CODE :'||BOM_REC.ITEM_CODE||
                        ' ITEM_QTY :'||BOM_REC.ITEM_QTY);
END;
/*6. EMP_TYPE 이름으로 ROWNUM, EMP_ID, EMP_NAME을 수용할 PL/SQL 레코드 TYPE 선언
   EREC 변수를 EMP_TYPE 형식으로 선언 후 
   TEMP의 전체 레코드를 읽으며 해당 건 조합 변수에 차례로 저장 후, 내용 출력.*/
DECLARE
    TYPE EMP_TYPE IS RECORD(NO NUMBER, EMP_ID TEMP.EMP_ID%TYPE, EMP_NAME TEMP.EMP_NAME%TYPE);
    EREC EMP_TYPE;
    CNT NUMBER;
BEGIN
    SELECT COUNT(*)
    INTO CNT
    FROM TEMP;
    
    FOR I IN 1..CNT LOOP
        SELECT NO, A.EMP_ID, A.EMP_NAME
        INTO EREC
        FROM TEMP A, (SELECT ROWNUM NO, EMP_ID FROM TEMP) B
        WHERE  NO = I
        AND A.EMP_ID = B.EMP_ID;
        DBMS_OUTPUT.PUT_LINE('ROWNUM :'||EREC.NO||
                            ' EMP_ID :'||EREC.EMP_ID||
                            ' EMP_NAME :'||EREC.EMP_NAME);      
    END LOOP;
END;
/*7. TEMP의 %ROWTYPE 변수 선언 후 TEMP에서 부서가 CEO001인 직원 조회해 출력하기*/
DECLARE
    T TEMP%ROWTYPE;
BEGIN
    SELECT * 
    INTO T 
    FROM TEMP
    WHERE DEPT_CODE = 'CEO001';
    DBMS_OUTPUT.PUT_LINE(T.EMP_ID);
END;
/*
8. 7번 코드에 추가: 7번에 TDEPT의 %ROWTYPE 변수 추가 선언 후 7번의 결과 
   DEPT_CODE를 PARENT_DEPT로 가지는 TDEPT 자료를 조회해 해당 부서 1건만 
   읽어 부서코드, 부서명과 BOSS_ID 출력하기*/
DECLARE
    TTEMP TEMP%ROWTYPE;
    TTDEPT TDEPT%ROWTYPE;
BEGIN
    SELECT * 
    INTO TTEMP 
    FROM TEMP
    WHERE DEPT_CODE = 'CEO001';
    
    SELECT *
    INTO TTDEPT
    FROM TDEPT
    WHERE PARENT_DEPT = TTEMP.DEPT_CODE
    AND ROWNUM = 1;
    DBMS_OUTPUT.PUT_LINE('부서코드 : '||TTDEPT.DEPT_NAME||' 보스아이디 :'||TTDEPT.BOSS_ID);
END;

/*9. 8번 코드에 추가: TDEPT에서 읽어 %ROWTYPE 변수에 들어 있는 정보를 
   하나씩 컬럼과 매칭시켜 TDEPT1에 INSERT */
DECLARE
    TTEMP TEMP%ROWTYPE;
    TTDEPT TDEPT%ROWTYPE;
BEGIN    
    SELECT *
    INTO TTDEPT
    FROM TDEPT
    WHERE ROWNUM = 1;
    INSERT INTO TDEPT1
    VALUES (TTDEPT.DEPT_CODE, TTDEPT.DEPT_NAME, TTDEPT.PARENT_DEPT, TTDEPT.USE_YN, TTDEPT.AREA, TTDEPT.BOSS_ID);
END;
SELECT * FROM TDEPT1;
/* 
10. TDEPT1에서 DELETE 후 9번 INSERT 문을 %ROWTYPE 변수 통째로 INSERT*/
DECLARE
    TTEMP TEMP%ROWTYPE;
    TTDEPT TDEPT%ROWTYPE;
BEGIN    
    SELECT *
    INTO TTDEPT
    FROM TDEPT
    WHERE ROWNUM = 1;
    INSERT INTO TDEPT1
    VALUES TTDEPT;
END;
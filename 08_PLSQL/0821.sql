--for커서
SET SERVEROUTPUT ON 
DECLARE 
    CURSOR emp_cursor IS 
    SELECT employee_id, last_name 
    FROM employees 
    WHERE department_id =30; 
BEGIN 
    FOR emp_record IN emp_cursor 
    LOOP 
        DBMS_OUTPUT.PUT_LINE( emp_record.employee_id ||' ' ||emp_record.last_name);   
    END LOOP; 
END;
--%ROWCOUNT
SET SERVEROUTPUT ON 
DECLARE 
    empno employees.employee_id%TYPE; 
    ename employees.last_name%TYPE; 
    CURSOR emp_cursor IS 
    SELECT employee_id, last_name 
    FROM employees; 
BEGIN 
    OPEN emp_cursor; LOOP 
    FETCH emp_cursor INTO empno, ename; 
    EXIT WHEN emp_cursor%ROWCOUNT > 10 OR  emp_cursor%NOTFOUND; 
    DBMS_OUTPUT.PUT_LINE(TO_CHAR(empno) ||' '|| ename); 
    END LOOP; 
    CLOSE emp_cursor; 
END;
--파라미터가 포함된 커서
SET SERVEROUTPUT ON 
DECLARE 
    CURSOR   emp_cursor (deptno NUMBER) IS 
    SELECT  employee_id, last_name 
    FROM    employees
    WHERE   department_id = deptno; 
    dept_id NUMBER; 
    lname   VARCHAR2(15);
BEGIN 
    OPEN emp_cursor (10);
    FETCH EMP_CURSOR INTO DEPT_ID, LNAME;
    DBMS_OUTPUT.PUT_LINE(DEPT_ID||LNAME);
    CLOSE emp_cursor; 
END;
--FOR UPDATE
SELECT ... FROM ... FOR UPDATE [OF column_reference][NOWAIT | WAIT n]

/*1. 상위 n번째까지의 고액 급여를 판별하는 PL/SQL 블록을 생성합니다. 
    a. 사원의 급여를 저장하기 위해 lab_07_01.sql 스크립트를 실행하여 새 테이블 top_salaries를 생성합니다. 
    b. 숫자 n은 유저가 입력하는 값입니다. 여기서 n은 employees 테이블의 급여 중 상위 n번째를 나타냅니다. 
    예를 들어, 상위 다섯 개의 급여를 보려면 5를 입력합니다. 
    주: n에 대한 값을 제공하려면 DEFINE 명령을 사용하여 변수 p_num을 정의합니다. 
    치환 변수를 통해 PL/SQL 블록으로 값이 전달됩니다. 
    c. 선언 섹션에서 치환 변수 p_num을 수용할 NUMBER 유형의 num 변수와 employees.salary 유형의 sal 변수를 선언합니다. 
    사원의 급여를 내림차순으로 읽어 들이는 emp_cursor 커서를 선언합니다. 급여는 중복될 수 없습니다. 
    d. 실행 섹션에서 루프를 열고 상위 n번째까지의 급여를 패치(fetch)한 다음 top_salaries 테이블에 삽입합니다. 
    간단한 루프를 사용하여 데이터를 산출할 수 있습니다. 또한 종료 조건에 %ROWCOUNT 및 %FOUND 속성을 사용합니다. 
    e. top_salaries 테이블에 삽입한 후 SELECT 문을 사용하여 행을 출력합니다. 
    결과로 employees 테이블의 상위 5개의 급여가 출력됩니다.
    f. n이 0이거나 n이 employees 테이블의 사원 수보다 더 큰 경우와 같이 다양한 경우를 테스트해 봅니다. 
    각 테스트 전후에는 top_salaries 테이블을 비웁니다. */
CREATE TABLE top_salaries
AS
SELECT SALARY FROM EMPLOYEES;
--
DEFINE P_NUM = &N;
DECLARE
    NUM NUMBER := &P_NUM + 1;
    SAL EMPLOYEES.SALARY%TYPE;
    
    CURSOR CUR IS
    SELECT DISTINCT SALARY
    FROM EMPLOYEES
    WHERE ROWNUM <= NUM
    ORDER BY SALARY DESC;
BEGIN
    OPEN CUR;
    LOOP
        FETCH CUR INTO SAL;
        EXIT WHEN CUR%ROWCOUNT > NUM OR CUR%NOTFOUND;
        INSERT INTO top_salaries
        VALUES (SAL);
        DBMS_OUTPUT.PUT_LINE(SAL);
    END LOOP;
    CLOSE CUR;
END;

/*2. 다음을 수행하는 PL/SQL 블록을 생성합니다. 
a. DEFINE 명령을 사용하여 부서 ID를 제공하는 p_deptno 변수를 정의합니다. 
b. 선언 섹션에서 NUMBER 유형의 deptno 변수를 선언하고 p_deptno의 값을 할당합니다. 
c. deptno에 지정된 부서에 근무하는 사원의 last_name, salary 및 manager_id를 읽어 들이는emp_cursor 커서를 선언합니다.
d. 실행 섹션에서 커서 FOR 루프를 사용하여 검색된 데이터에 대해 작업할 수 있습니다. 
    사원의 급여가 5000 미만이고 관리자 ID가 101 또는 124인 경우 <<last_name>> Due for a raise 메시지를 표시합니다. 
    그렇지 않은 경우 <<last_name>> Not due for a raise 메시지를 표시합니다. 
e. 다음 경우에 대해 PL/SQL 블록을 테스트합니다.*/
DEFINE P_DEPTNO = &NO;
DECLARE
    DEPTNO NUMBER := &P_DEPTNO;
    
    CURSOR EMP_CURSOR IS
    SELECT LAST_NAME, SALARY, MANAGER_ID
    FROM EMPLOYEES
    WHERE DEPARTMENT_ID = DEPTNO;
BEGIN
    FOR EMP_REC IN EMP_CURSOR
    LOOP
        IF EMP_REC.SALARY < 5000 AND (EMP_REC.MANAGER_ID = 101 OR EMP_REC.MANAGER_ID = 124)
        THEN
            DBMS_OUTPUT.PUT_LINE('<<last_name>> Due for a raise');
        ELSE
            DBMS_OUTPUT.PUT_LINE('<<last_name>> Not due for a raise');
        END IF;
    END LOOP;
END;
/*3. 파라미터가 포함된 커서를 선언하고 사용하는 PL/SQL 블록을 작성합니다. 
    루프에서 커서를 사용하여 departments 테이블에서 department_id가 100보다 작은 부서의 부서 번호 및 부서 이름을 읽어 들입니다. 
    부서 번호를 다른 커서에 파라미터로 전달하여 employees 테이블에서 해당 부서에 근무하고 
    employee_id가 120보다 작은 사원의 성, 직위, 채용 날짜 및 급여 등의 상세 정보를 읽어 들입니다. 
    a. 선언 섹션에서 dept_cursor 커서를 선언하여 department_id가 100보다 작은 부서의 department_id 및 department_name을 검색합니다. department_id에 따라 정렬합니다. 
    b. 부서 번호를 파라미터로 사용하여 해당 부서에 근무하고 employee_id가 120 보다 작은 사원의 last_name, job_id, hire_date 및 salary를 검색하는 다른 커서 emp_cursor를 선언합니다. 
    c. 각 커서에서 검색된 값을 보유하는 변수를 선언합니다. 변수 선언 시 %TYPE 속성을 사용합니다. d. dept_cursor를 열고 간단한 루프를 사용하여 값을 선언된 변수에 패치(fetch)합니다. 
    부서 번호 및 부서 이름을 출력합니다. e. 각 부서에 대해 현재 부서 번호를 파라미터로 전달하여 emp_cursor를 엽니다 . 
    다른 루프를 시작하여 emp_cursor의 값을 변수에 패치하고 employees 테이블에서 검색된 모든 상세 정보를 출력합니다. 
    주: 각 부서의 상세 정보를 표시한 다음 한 행을 출력할 수 있습니다. 종료 조건에 적합한 속성을 사용하십시오. 
    또한 커서를 열기 전에 이미 열려 있는지 확인하십시오. f. 모든 루프 및 커서를 닫고 실행 섹션을 종료합니다. 스크립트를 실행합니다*/
DECLARE
    D_ID EMPLOYEES.DEPARTMENT_ID%TYPE;
    D_NAME EMPLOYEES.DEPARTMENT_NAME%TYPE;
    L_NAME EMPLOYEES.LAST_NAME%TYPE;
    J_ID EMPLOYEES.JOB_ID%TYPE;
    H_DATE EMPLOYEES.HIRE_DATE%TYPE;
    SAL EMPLOYEES.SALARY%TYPE;
    CURSOR DEPT_CURSOR IS
        SELECT DEPARTMENT_ID, DEPARTMENT_NAME
        FROM EMPLOYEES
        WHERE DEPARTMENT_ID < 100
        GROUP BY DEPARTMENT_ID, DEPARTMENT_NAME
        ORDER BY DEPARTMENT_ID;
    CURSOR EMP_CURSOR (DEPTNO NUMBER)IS
        SELECT LAST_NAME, JOB_ID, HIRE_DATE, SALARY
        FROM EMPLOYEES
        WHERE EMPLOYEE_ID < 120
        AND DEPARTMENT_ID = DEPTNO;
BEGIN
    OPEN DEPT_CURSOR;
    LOOP
        FETCH DEPT_CURSOR INTO D_ID, D_NAME;
        EXIT WHEN DEPT_CURSOR%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE('부서 번호 : '||D_ID||' 부서 이름 : '||D_NAME);
        OPEN EMP_CURSOR(D_ID);
        LOOP
            FETCH EMP_CURSOR INTO L_NAME, J_ID, H_DATE, SAL;
            EXIT WHEN EMP_CURSOR%NOTFOUND;
            DBMS_OUTPUT.PUT_LINE(L_NAME||'  '||J_ID||'  '||H_DATE||'  '||SAL);
        END LOOP;
        CLOSE EMP_CURSOR;
    END LOOP;
    CLOSE DEPT_CURSOR;
END;
/*3. 익명블록 선언부에서 JIT_DELIVERY_PLAN의 2019년 10월의 ITEM별 수량을 구하여 읽어들이는 
    커서를 선언하고 실행부에서 커서%ROWCOUNT, ITEM, QTY를 출력*/
DECLARE
    CURSOR CUR IS
    SELECT ITEM_CODE, ITEM_QTY
    FROM JIT_DELIVERY_PLAN
    WHERE DELIVERY_DATE LIKE '201910%';
BEGIN
    FOR JIT_REC IN CUR
    LOOP
        DBMS_OUTPUT.PUT_LINE(CUR%ROWCOUNT||JIT_REC.ITEM_CODE||JIT_REC.ITEM_QTY);
    END LOOP;
END;
/*4. 커서의 반복 사용
   TEMP에서 EMP_ID로 ORDER BY 한 커서를 선언하고, 
   커서를 OPEN하여 한 건 FETCH 하여 출력 후 CLOSE
    다시 OPEN 하여 한 건 FETCH 후 출력 후 CLOSE 하여 두 결과 비교*/
DECLARE
    E1 NUMBER;
    E2 NUMBER;
    
    CURSOR CUR IS
    SELECT EMP_ID
    FROM TEMP
    ORDER BY EMP_ID;
BEGIN
    OPEN CUR;
    FETCH CUR INTO E1;
    CLOSE CUR;
    OPEN CUR;
    FETCH CUR INTO E2;
    CLOSE CUR;
    DBMS_OUTPUT.PUT_LINE(E1||E2);
END;
 /*   
5. 선언부에 사번,성명과 자신의 보스ID, 보스 성명을 SELECT하는 커서 선언하고 
   (내가 부서장이면 상위 부서 부서장이 보스-VEMP_BOSS VIEW 사용 금지) 
   FOR LOOP 돌며 RECORD 타입 변수에 할당하여 출력 */
DECLARE
    CURSOR CUR IS
    SELECT A.EMP_ID, A.EMP_NAME, A.DEPT_CODE,
            DECODE(A.EMP_ID, B.BOSS_ID, C.BOSS_ID, B.BOSS_ID) BOSS_ID,
            D.EMP_NAME BOSS_NAME, D.DEPT_CODE BOSS_DEPT
    FROM TEMP A, TDEPT B, TDEPT C, TEMP D
    WHERE B.DEPT_CODE = A.DEPT_CODE
    AND C.DEPT_CODE = B.PARENT_DEPT
    AND D.EMP_ID = C.BOSS_ID;
BEGIN
    FOR EMP_REC IN CUR
    LOOP
        DBMS_OUTPUT.PUT_LINE(EMP_REC.EMP_ID||EMP_REC.EMP_NAME||EMP_REC.BOSS_ID||EMP_REC.BOSS_NAME);
    END LOOP;
END;
/*6. 5번을 FOR LOOP 서브쿼리로 바꿔서 동일 로직 처리  */
/*7. 
   1) 최저 임금법에 따라 TEMP2에서 2500만원이 안 되는 직원의 SALARY를 
   2500만원으로 변경하려고 합니다.
   커서를 선언해 FOR UPDATE NOWAIT를 이용 업데이트 하려는 데이터에 
   LOCK을 걸고 익명블록에서 
    작업을 수행합니다.(UPDATE 시 WHERE CURRENT OF 이용)*/
DECLARE
    CURSOR CUR IS
    SELECT *
    FROM TEMP2
    WHERE SALARY < 25000000
    FOR UPDATE NOWAIT;
BEGIN
    FOR TEMP_REC IN CUR 
    LOOP
        UPDATE TEMP2
        SET SALARY = 25000000
        WHERE CURRENT OF CUR;
    END LOOP;
END;
   /*2) 1번에서 변경된 TEMP2 반영을 위해 EMP_LEVEL2 SALARY 관련 정보 변경
   (FOR UPDATE NOWIT 커서와 WHERE CURRENT OF 이용하며, 
   업데이트 문은 연쇄서브쿼리 이용)*/
DECLARE
    CURSOR CUR IS 
        SELECT *
        FROM EMP_LEVEL1
        FOR UPDATE OF FROM_SAL, TO_SAL NOWAIT;
BEGIN
    FOR i IN CUR LOOP
        UPDATE EMP_LEVEL1
        SET FROM_SAL = (SELECT MIN(SALARY) 
                        FROM TEMP2
                        WHERE LEV = i.LEV
                        GROUP BY LEV),
            TO_SAL = (SELECT MAX(SALARY) 
                        FROM TEMP2
                        WHERE LEV = i.LEV
                        GROUP BY LEV)
        WHERE CURRENT OF CUR;
    END LOOP;
END;
/
SELECT * FROM EMP_LEVEL1;
/*   3) 1번에서 변경된 TEMP2의 내역에 따라 TCOM2 SALARY 관련 정보 변경
   (FOR UPDATE NOWIT 커서 선언 때 ROWID 포함시켜 UPDATE에 이용) */
DECLARE
    CURSOR C1 IS
    SELECT ROWID RID, EMP_ID, COMM
    FROM TCOM1
    WHERE EMP_ID IN (
        SELECT EMP_ID
        FROM TEMP A
        WHERE DEPT_CODE IN(
                SELECT DEPT_CODE
                FROM TDEPT
                START WITH DEPT_CODE = 'CSO001'
                CONNECT BY PRIOR DEPT_CODE = PARENT_DEPT)
    AND WORK_YEAR = 2019
    )
    FOR UPDATE OF COMM NOWAIT;
BEGIN
    FOR I IN C1 
    LOOP
        UPDATE TCOM1 A
        SET COMM = (SELECT SALARY * 0.01 
                    FROM TEMP B
                    WHERE A.EMP_ID = B.EMP_ID)
        WHERE ROWID = I.RID;
        --
        IF SQL%NOTFOUND THEN
            INSERT INTO TCOM1(WORK_YEAR, EMP_ID, COMM )
            VALUES(2019, I.EMP_ID, I.COMM);
        END IF;
    END LOOP;
    COMMIT;
END;
SELECT * FROM TCOM1;
/*BONUS
1. 사번, 부서코드, SALARY를 조합으로 가지는 INDEX BY 테이블형 변수 선언 카운트 할당용 넘버 변수 선언
실행부 에서 사번, 부서코드, TEMP2의 SALARY를 FOR LOOP 서브쿼리로 SELECT하되 HINT를 사용하여 EMP_ID 컬럼에 걸려있는 인덱스를 탈 수 있도록
유도하여 EMP_ID로 SORT 한 후
INDEX BY 테이블에 한 건씩 저장.
INDEX BY 테이블을 읽어 출력.*/
DECLARE
     TYPE REC IS RECORD
    TYPE T1 IS TABLE OF 
    TEMP2.EMP_ID%TYPE INDEX BY PLS_INTEGER;
    
    V1 T1;
    V2 T2;
    V3 T3;
    CNT NUMBER;
BEGIN
    FOR I IN 1..55
    LOOP
        SELECT EMP_ID, DEPT_CODE, SALARY
        INTO V1(I), V2(I), V3(I)
        FROM TEMP2
        WHERE ROWNUM = I;
        DBMS_OUTPUT.PUT_LINE(V1(I).EMP_ID);
    END LOOP;
END;
--
DECLARE
    TYPE REC IS RECORD(EID NUMBER, DC TDEPT.DEPT_CODE%TYPE, SAL NUMBER);
    TYPE TAB IS TABLE OF REC
    INDEX BY PLS_INTEGER;
    TAB1 TAB;
    C NUMBER:=0;
BEGIN
    FOR I IN (SELECT/*+ INDEX(TEMP2 TEMP2_UK)*/ EMP_ID, DEPT_CODE,SALARY
              FROM TEMP2 WHERE EMP_ID>0)
    LOOP C:=C+1;
    TAB1(C) :=I;
    DBMS_OUTPUT.PUT_LINE('EMP_ID: '|| TAB1(C).EID|| ' DEPT_CODE: '||TAB1(C).DC|| 'SALARY: '||TAB1(C).SAL);
    END LOOP;
END;
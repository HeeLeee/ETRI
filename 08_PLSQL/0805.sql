DECLARE
    V_FNAME VARCHAR2(20);
BEGIN
    SELECT FIRST_NAME
    INTO V_FNAME
    FROM EMPLOYEES
    WHERE EMPLOYEE_ID = 100;
    DBMS_OUTPUT.PUT_LINE('THE FIRST Name of the employee is: '||V_FNAME);
END;
--1. 다음 PL/SQL 블록 중 성공적으로 실행되는 블록은 무엇입니까? D

a. BEGIN
END;
b. DECLARE
amount INTEGER(10);
END;
c. DECLARE
BEGIN
END;
d. DECLARE
amount INTEGER(10);
BEGIN
DBMS_OUTPUT .PUT_LINE(amount);
END;
--2
DECLARE
    HI VARCHAR2(10);
BEGIN
    DBMS_OUTPUT.PUT_LINE('HELLO WORLD'||HI);
END;

--3. 다음에 나열된 선언을 검토하여 그 중 잘못된 선언을 판별하고 그 이유를 설명합니다.
a. DECLARE
name,dept VARCHAR2(14)
b. DECLARE
test NUMBER(5); 
c. DECLARE
MAXSALARY NUMBER(7,2) = 5000;
d. DECLARE
JOINDATE BOOLEAN := SYSDATE; 
--3.자신의 이름과 국적을 같은 줄과 다른 줄에 출력하는 간단한 익명 블록 생성 하기
DECLARE
BEGIN
    DBMS_OUTPUT.PUT_LINE('이희광');
    DBMS_OUTPUT.PUT_LINE('대한민국');
END;
--4.익명 블록에서 V$ 와 V1 이라는 변수를 선언하고, 
--  V$는 선언절에서 초기화하고, V1은 초기화 없이 BEGIN에서 두 변수 값 출력하기
DECLARE
-- V$ NUMBER DEFAULT 0;
    V$ NUMBER := 0;
    V1 NUMBER;
BEGIN 
    DBMS_OUTPUT.PUT_LINE('V$: '||V$);
    DBMS_OUTPUT.PUT_LINE('V1: '||V1);
END;
--5. TEMP 에서 자기이름의 사번을 검색해 출력하기
DECLARE
INFO NUMBER;
INFO1 VARCHAR2(20);
BEGIN
    SELECT EMP_ID, EMP_NAME
    INTO INFO, INFO1
    FROM TEMP
    WHERE EMP_NAME = '이희광';
    DBMS_OUTPUT.PUT_LINE('사번: '||INFO);
    DBMS_OUTPUT.PUT_LINE('이름: '||INFO1);
END;
--6. 5번에서 사번과, 급여를 함께 출력
DECLARE
INFO NUMBER;
INFO1 NUMBER;
BEGIN
    SELECT EMP_ID, SALARY
    INTO INFO, INFO1
    FROM TEMP
    WHERE EMP_NAME = '이희광';
    DBMS_OUTPUT.PUT_LINE('사번: '||INFO);
    DBMS_OUTPUT.PUT_LINE('급여: '||INFO1);
END;
--7. 5와 같은 방법으로 홍길동과 이순신의 사번을 출력시도
DECLARE
    INFO NUMBER;
BEGIN
    SELECT EMP_ID
    INTO INFO
    FROM TEMP
    WHERE EMP_NAME IN ('홍길동', '이순신');
    DBMS_OUTPUT.PUT_LINE('사번: '||INFO);
END;
--8. 익명 블록에서 NUMBER(10), VARCHAR2(10) , CHAR(10), DATE 타입의 변수를  
--   각각 두 개씩 8개 선언한 뒤, 한 묶음(4가지 변수 종류별 1개씩)은 
--   초기값 할당하고 나머지는 초기값 할당 없이 8개 변수 각각의 VALUE와 LENGTH 값을 출력하여 
--   자신의 예상 치와 비교해보기 
DECLARE
    V1 NUMBER(10) := 1;
    V2 NUMBER(10);
    V3 VARCHAR2(10) := 'HI';
    V4 VARCHAR2(10);
    V5 CHAR(10) := 'HELLO';
    V6 CHAR(10);
    V7 DATE := SYSDATE;
    V8 DATE;
BEGIN
    DBMS_OUTPUT.PUT_LINE('V1: '||V1);
    DBMS_OUTPUT.PUT_LINE('V1: '||LENGTH(V1));
    DBMS_OUTPUT.PUT_LINE('V2: '||V2);
    DBMS_OUTPUT.PUT_LINE('V2: '||LENGTH(V2));
    DBMS_OUTPUT.PUT_LINE('V3: '||V3);
    DBMS_OUTPUT.PUT_LINE('V3: '||LENGTH(V3));
    DBMS_OUTPUT.PUT_LINE('V4: '||V4);
    DBMS_OUTPUT.PUT_LINE('V4: '||LENGTH(V4));
    DBMS_OUTPUT.PUT_LINE('V5: '||V5);
    DBMS_OUTPUT.PUT_LINE('V5: '||LENGTH(V5));
    DBMS_OUTPUT.PUT_LINE('V6: '||V6);
    DBMS_OUTPUT.PUT_LINE('V6: '||LENGTH(V6));
    DBMS_OUTPUT.PUT_LINE('V7: '||V7);
    DBMS_OUTPUT.PUT_LINE('V7: '||LENGTH(V7));
    DBMS_OUTPUT.PUT_LINE('V8: '||V8);
    DBMS_OUTPUT.PUT_LINE('V8: '||LENGTH(V8));
END;
--
DECLARE
    LC NUMBER != 0;
BEGIN
    LOOP
        LC := LC+1;
        EXIT WHEN 1C >= 10;
    END LOOP;
END;
--9. temp에서 전체 인원의 사번,이름,salary 를 출력하는 pl/sql  block 구현
DECLARE
    PL_ID NUMBER := 0;
    EMP_ID NUMBER;
    EMP_NAME VARCHAR2(20);
    SALARY NUMBER;
BEGIN
    LOOP 
        EXIT WHEN PL_ID IS NULL;
        SELECT EMP_ID, EMP_NAME, SALARY
        INTO EMP_ID, EMP_NAME, SALARY
        FROM TEMP
        WHERE EMP_ID = (SELECT MIN(EMP_ID)
                        FROM TEMP
                        WHERE EMP_ID > PL_ID);
        DBMS_OUTPUT.PUT_LINE('사원번호: '||EMP_ID||'사원이름: '||EMP_NAME||'SAL: '||SALARY);
        PL_ID := EMP_ID;
    END LOOP;
END;
--
DECLARE
    PL_ID NUMBER := 0;
    EMP_ID NUMBER;
    EMP_NAME VARCHAR2(20);
    SALARY NUMBER;
    CNT NUMBER;
    LCNT NUMBER := 0;
BEGIN
    SELECT COUNT(*) INTO CNT FROM TEMP;
    LOOP 
        LCNT := LCNT +1;
        EXIT WHEN LCNT > CNT;
        SELECT EMP_ID, EMP_NAME, SALARY
        INTO EMP_ID, EMP_NAME, SALARY
        FROM TEMP
        WHERE EMP_ID = (SELECT MIN(EMP_ID)
                        FROM TEMP
                        WHERE EMP_ID > PL_ID);
        DBMS_OUTPUT.PUT_LINE('사원번호: '||EMP_ID||' 사원이름: '||EMP_NAME||' SAL: '||SALARY);
        PL_ID := EMP_ID;
    END LOOP;
END;
--10. N1, N2이라는 NUMBER 타입 변수를 선언하되 N2를 두 번 선언하고 N1에만 초기값을 할당해 N1 값 출력하기
DECLARE 
    N1 NUMBER := 1;
    N2 NUMBER;
    N2 NUMBER;
BEGIN
    DBMS_OUTPUT.PUT_LINE('N1: '||N1);
END;
--11. 10번에서 N2도 추가로 출력하기 실행 후 오류 확인
DECLARE 
    N1 NUMBER := 1;
    N2 NUMBER;
    N2 NUMBER;
BEGIN
    DBMS_OUTPUT.PUT_LINE('N1: '||N1);
    DBMS_OUTPUT.PUT_LINE('N2: '||N2);
END;
--12. 10번에서 N1 변수명칭을 1N으로 바꾸고 실행 후 오류 확인
DECLARE 
    N1 NUMBER := 1;
    N2 NUMBER;
    N2 NUMBER;
BEGIN
    DBMS_OUTPUT.PUT_LINE('N1: '||1N);
END;
--13. CONS1 이라는 NUMBER형 상수를 선언하고 초기 값 할당 없이 출력 후 오류내용 확인하기
--  상수이름 CONSTANT VARCHAR2(10);
DECLARE
    CONS1 CONSTANT NUMBER ;
BEGIN
    DBMS_OUTPUT.PUT_LINE('CONS: '||CONS1);
END;
--
DECLARE 
    PL_ID NUMBER;
BEGIN
    SELECT EMP_ID
    INTO PL_ID
    FROM TEMP
    WHERE EMP_ID =0;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
    DBMS_OUTPUT.PUT_LINE('찾으시는 사번이 없습니다. 확인바랍니다.');
END;
--CREATE 한것은 오브젝트 임
CREATE OR REPLACE PROCEDURE P_TEST1 AS
BEGIN
    INSERT INTO TDATE VALUES(SYSDATE);
END;
--확인
SELECT *
FROM USER_OBJECTS
WHERE OBJECT_TYPE = 'PROCEDURE'
AND OBJECT_NAME = 'P_TEST1';
--프로시저 호출-- PL/SQL BLOCK으로 이루어진 프로그램?
EXECUTE P_TEST1;
--
CREATE OR REPLACE FUNCTION F_TEST1 RETURN NUMBER IS
RES NUMBER := 0;
BEGIN
    SELECT COUNT(*)
    INTO RES
    FROM TDATE;
    
    RETURN RES;
END;
--확인
SELECT *
FROM USER_OBJECTS
WHERE OBJECT_TYPE = 'FUNCTION'
AND OBJECT_NAME = 'F_TEST1';

SELECT F_TEST1 FROM DUAL;
--BONUS
--1. 아래의 내용을 수행하는 익명블록 작성
--1). TEMP1 DATA 모두삭제
DECLARE
BEGIN 
    DELETE TEMP1;
END;
--2). TEMP에서 취미가 NULL인 정보만 읽어서 TEMP1에 INSERT...SELECT
SELECT * FROM TEMP;
DECLARE
BEGIN
    
    INSERT INTO TEMP1
    SELECT *
    FROM TEMP
    WHERE HOBBY IS NULL;
END;
--3). TEMP1에서 SALARY를 10% 인상
DECLARE
BEGIN
    UPDATE TEMP1
    SET SALARY = SALARY * 1.1;
END;

SELECT * FROM TEMP1;
--2.TEMP2 테이블이 존재하면 DROP 후 작업
--  TEMP에서 모든 데이터를 읽어 TEMP2를 CREATE 하는 익명블럭 작성 => 오류확인;
CREATE OR REPLACE TABLE TEMP2
AS
DECLARE
BEGIN
    SELECT *
    FROM TEMP;
END;
--3. TEMP1을 DROP하는 익명블럭 작성 => 오류확인
DECLARE
BEGIN
    DROP TABLE TEMP1;
END;
--4. CONG 유저에 TDEPT의 SELECT 권한을 주는 익명블럭 작성 >오류확인
--5. STUDY04에서 INPUT_PLAN의 2019년 10월 1일자 1번라인의 데이터를 읽어 11월 1일자 1번 라인으로 INSERT하고, 
--  10월 1일자 1번라인 자료 삭제하는 익명블록 작성. 익명블록 작성 후 INPUT_PLAN의 SELECT하여 수행 결과 확인 후 ROLLBACK;
DECLARE
BEGIN 
    INSERT INTO STUDY04.INPUT_PLAN
    SELECT LINE_NO, SPEC_CODE, 20191101, PLAN_SEQ
    FROM STUDY04.INPUT_PLAN
    WHERE INPUT_PLAN_DATE = 20191001 
    AND LINE_NO = 'L01';
    DELETE STUDY04.INPUT_PLAN
    WHERE INPUT_PLAN_DATE = 20191001;
END;
--6. 익명블록에서 TDATE DATA 모두 삭제하고 P_TEST1을 호출 후 COMMIT;
--  익명블럭 실행 후 결과 확인 P_TEST1;
BEGIN
    DELETE TDATE;
    P_TEST1;
END;
SELECT *
FROM USER_OBJECTS
WHERE OBJECT_TYPE = 'PROCEDURE'
AND OBJECT_NAME = 'P_TEST1';
--7. 1 에서 1 까지 더한 값은 1 입니다.
--1 에서 2 까지 더한 값은 3 입니다.
--1 에서 3 까지 더한 값은 6 입니다.
--1 에서 4 까지 더한 값은 10 입니다.
--1 에서 5 까지 더한 값은 15 입니다.
--1 에서 6 까지 더한 값은 21 입니다.
--1 에서 7 까지 더한 값은 28 입니다.
--1 에서 8 까지 더한 값은 36 입니다.
--1 에서 9 까지 더한 값은 45 입니다.
--1 에서 10 까지 더한 값은 55 입니다.
DECLARE
    CNT NUMBER := 0;
    LCNT NUMBER := 1;
BEGIN
    LOOP
        EXIT WHEN CNT >= 55;
        CNT := CNT + LCNT;
        DBMS_OUTPUT.PUT_LINE('1에서' ||LCNT||'까지 더한 값은'||CNT|| '입니다.');
        LCNT := LCNT+1;
    END LOOP;
END;
--
BEGIN
    DBMS_OUTPUT.PUT_LINE('외부블럭 START !!!!!!!!!!!!!!!!!!!!!!!');
    DECLARE 
        PL_ID NUMBER;
    BEGIN
        DBMS_OUTPUT.PUT_LINE('내부블럭 진입');
        --
        SELECT EMP_ID
        INTO PL_ID
        FROM TEMP
        WHERE EMP_ID = 0;
        EXCEPTION WHEN NO_DATA_FOUND THEN
            DBMS_OUTPUT.PUT_LINE('내부블럭 에러 CATCH !!!!!!!!!!!!!!!!!!!');
            RAISE; --에러 전달
    END;
    DBMS_OUTPUT.PUT_LINE('외부를럭 정상 실행');
    EXCEPTION WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('외부블럭으로 ERROR 전달');
END;
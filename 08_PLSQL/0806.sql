SET SERVEROUTPUT ON
DECLARE
    EVENT VARCHAR2(15);
BEGIN
    EVENT := Q'!FATHER'S DAY!';
    DBMS_OUTPUT.PUT_LINE('3RD SUNDAY IN JUNE IS :'||EVENT);
    EVENT := Q'[MOTHER'S DAY]';
    DBMS_OUTPUT.PUT_LINE('2ND SUNDAY IN MAY IS :'||EVENT);
END;

SET SERVEROUTPUT ON
DECLARE
    bf_var BINARY_FLOAT;
    bd_var BINARY_DOUBLE;
BEGIN
    bf_var := 270/35f;
    bd_var := 140d/0.35;
    DBMS_OUTPUT.PUT_LINE('bf: '||bf_var);
    DBMS_OUTPUT.PUT_LINE('bd: '||bd_var);
END;
--바인드 변수
VARIABLE result NUMBER
BEGIN
    SELECT (SALARY*12) + NVL(COMMISSION_PCT,0)
    INTO :result
    FROM EMPLOYEES
    WHERE EMPLOYEE_ID = 144;
END;
PRINT result
--
VARIABLE emp_salary NUMBER
SET AUTOPRINT ON
BEGIN
    SELECT salary 
    INTO :emp_salary
    FROM employees
    WHERE employee_id = 178;
END;
--치환변수
SET VERIFY OFF
VARIABLE emp_salary NUMBER
ACCEPT empno PROMPT 'Please enter a valid employee number: '
SET AUTOPRINT ON
DECLARE
    empno NUMBER(6) := &empno;
BEGIN
    SELECT salary
    INTO :emp_salary
    FROM employees
    WHERE employee_id = empno;
END;
--유저 변수에 DEFINE
SET VERIFY OFF
DEFINE lname = Urman
DECLARE
    fname VARCHAR2(25);
BEGIN
    SELECT first_name 
    INTO fname 
    FROM employees
    WHERE last_name='&lname';
END;
--문제
--1. 적합한 식별자와 부적합한 식별자 이름을 구분합니다. A,B,E,G,H
-- a. today
-- b. last_name
-- c. today’s_date
-- d. Number_of_days_in_February_this_year
-- e. Isleap$year
-- f. #number
-- g. NUMBER#
-- h. number1to7
--2. 다음 변수 선언 및 초기화가 적합한지 식별합니다.  A, D
-- a. number_of_copies PLS_INTEGER;
-- b. printer_name constant VARCHAR2(10);
-- c. deliver_to VARCHAR2(10):=Johnson;
-- d. by_when DATE:= SYSDATE+1;
--3. 다음 익명 블록을 검토하고 올바른 문장을 선택합니다. C
 SET SERVEROUTPUT ON
 DECLARE
  fname VARCHAR2(20);
  lname VARCHAR2(15) DEFAULT 'fernandez';
 BEGIN
  DBMS_OUTPUT.PUT_LINE( FNAME ||' '||lname);
 END;
 /
--  a. 블록이 성공적으로 실행되고 "fernandez"가 출력됩니다.
--  b. fname 변수가 초기화하지 않고 사용되었기 때문에 오류가 발생합니다.
--  c. 블록이 성공적으로 실행되고 "null fernandez"가 출력됩니다.
--  d. VARCHAR2 유형의 변수를 초기화하는 데 DEFAULT 키워드를 사용할 수 없기 때문에
--     오류가 발생합니다.
--  e. 블록에서 FNAME 변수가 선언되지 않았기 때문에 오류가 발생합니다.
--4. 익명 블록을 생성합니다. SQL Developer에서 연습 1의 2번 문제에서 생성한
--   lab_01_02_soln.sql 스크립트를 엽니다.
--  a. 이 PL/SQL 블록에 선언 섹션을 추가합니다. 선언 섹션에서 다음 변수를 선언합니다.
--    1. DATE 유형의 today 변수. today를 SYSDATE로 초기화합니다.
--    2. today 유형의 tomorrow 변수. %TYPE 속성을 사용하여 이 변수를
--       선언합니다.
--  b. 실행 섹션에서 내일 날짜를 계산하는 표현식(today 값에 1 추가)을 사용하여
--     tomorrow 변수를 초기화합니다. "Hello World"를 출력한 후 today와 tomorrow의
--     값을 출력합니다.
--  c. 이 스크립트를 실행하고 lab_02_04_soln.sql로 저장합니다.
DECLARE
    TODAY DATE := SYSDATE;
    TOMORROW TODAY%TYPE;
BEGIN
    TOMORROW := TODAY + 1;
    DBMS_OUTPUT.PUT_LINE('HELLO WORLD '||TOMORROW||TODAY);
END;
--5. lab_02_04_soln.sql 스크립트를 편집합니다.
--  a. 두 개의 바인드 변수를 생성하는 코드를 추가합니다. NUMBER 유형의 바인드 변수
--     basic_percent 및 pf_percent를 생성합니다.
--  b. PL/SQL 블록의 실행 섹션에서 basic_percent와 pf_percent에 각각 값 45와
--     12를 할당합니다.
--  c. "/"로 PL/SQL 블록을 종료하고 PRINT 명령을 사용하여 바인드 변수 값을 표시합니다.
--  d. 스크립트 파일을 실행하고 lab_02_05_soln.sql로 저장합니다. 
VARIABLE basic_percent NUMBER
VARIABLE pf_percent NUMBER
BEGIN
    :basic_percent := 45;
    :pf_percent := 12;
END;
PRINT basic_percent;
PRINT pf_percent;

--10. Pi 라는 NUMBER형 상수를 선언하고 초기 값 0 할당 후 
--    BEGIN SECTION에서 할당 값 3.14로 재 할당 후 출력하여 오류내용 확인하기
DECLARE 
    PI CONSTANT NUMBER := 0;
BEGIN
    PI := 3.14;
    DBMS_OUTPUT.PUT_LINE('PI :'||PI);
END;
--11. 리터럴 문자열 구분자를 이용하여 ‘작은 따옴표로 묶인 글’ 이라는 문자열 출력하기 
BEGIN
    DBMS_OUTPUT.PUT_LINE(Q'!'작은 따옴표로 묶인 글'!');
END;
--12. TIMESTAMP 변수 두 개를 선언하고 INTERVAL DAY TO SECOND 변수 한 선언해서 
--    SYSTIMESTAMP 와 SYSTIMESTAMP에서 1을 뺀 값을 
--    INTERVAL DAY TO SECOND 변수에 넣고 세 변수 각각 출력하기
DECLARE
    A TIMESTAMP := SYSTIMESTAMP;
    B TIMESTAMP := SYSTIMESTAMP -1;
    C INTERVAL DAY TO SECOND;
BEGIN
    C := A - B;
    DBMS_OUTPUT.PUT_LINE(A);
    DBMS_OUTPUT.PUT_LINE(B);
    DBMS_OUTPUT.PUT_LINE(C);
END;
--13. V_IS_TRUE 라는 BOOLEAN 타입의 변수를 선언하고 TRUE로 초기화한 후 
--    BEGIN SECTION 에서 CASE 문을 사용해 V_IS_TRUE 가 TRUE 인 경우 ‘참입니다’ 를 
--    출력하고 FALSE 인 경우 ‘거짓입니다’ 를 출력
DECLARE 
    V_IS_TRUE BOOLEAN := TRUE;
BEGIN
    CASE V_IS_TRUE
        WHEN TRUE THEN DBMS_OUTPUT.PUT_LINE('참입니다');
        ELSE DBMS_OUTPUT.PUT_LINE('거짓입니다');
    END CASE;
END;
--14. 13번의 BOOLEAN 변수에 3-2 > 10 이라는 값을 초기 값으로 할당하고 실행 후 
--출력 결과 확인
DECLARE 
    V_IS_TRUE BOOLEAN := 3-2 > 10;
BEGIN
    CASE V_IS_TRUE
        WHEN TRUE THEN DBMS_OUTPUT.PUT_LINE('참입니다');
        ELSE DBMS_OUTPUT.PUT_LINE('거짓입니다');
    END CASE;
END;
--15. TEMP1의 EMP_NAME을 %TYPE 변수로 선언하고, 
--    TEMP1에서 한 건을 읽어 변수에 넣는 TYPE_CHANGE 라는 PROCEDURE 생성,
CREATE OR REPLACE PROCEDURE TYPE_CHANGE 
IS E_NAME TEMP1.EMP_NAME%TYPE;
BEGIN
    SELECT EMP_NAME
    INTO E_NAME
    FROM TEMP1;
END;
--16. USER_OBJECTS 를 통해 생성된 프로시져 확인 (VALID인지 여부도 함께)
SELECT *
FROM USER_OBJECTS
WHERE OBJECT_TYPE = 'PROCEDURE';
--17. TEMP1의 EMP_NAME을 30자리로 확장
ALTER TABLE TEMP1
MODIFY EMP_NAME VARCHAR2(30);
--18.USER_OBJECTS를 통해 TYPE_CHANGE 프로시져 재 확인 (VALID인지)
SELECT *
FROM USER_OBJECTS
WHERE OBJECT_TYPE = 'PROCEDURE'
AND OBJECT_NAME = 'TYPE_CHANGE';
--19. EXECUTE TYPE_CHANGE; 로 프로시져 실행 여부 확인
EXECUTE TYPE_CHANGE;
--20. 18번 재 수행
SELECT *
FROM USER_OBJECTS
WHERE OBJECT_TYPE = 'PROCEDURE'
AND OBJECT_NAME = 'TYPE_CHANGE';
--
--1.
--IS_BOSS 라는 VARCHAR2형 바인드 변수 선언
--EMP_ID 라는 NUMBER형 바인드 변수 선언
--ENAME이라는 유저변수 값을 '홍길동'으로 정의
--익명 블록 작성
--    1) ENAME 유저변수를 이용해 ENAME과 이름이 같은 직원의 사번과
--       보스 여부('T' OR 'F')를 찾아서 각각 EMP_ID, BOSS_ID 바인드 변수에 
--       값을 할당해주는 쿼리 작성
VARIABLE IS_BOSS VARCHAR2(20)
VARIABLE EMP_ID NUMBER
DECLARE
    ENAME VARCHAR2(20) := '홍길동';
BEGIN
    SELECT A.EMP_ID, DECODE(B.BOSS_ID,NULL,'F',B.BOSS_ID)
    INTO :EMP_ID, :IS_BOSS
    FROM TEMP A, TDEPT B
    WHERE A.DEPT_CODE = B.DEPT_CODE 
    AND A.EMP_NAME = ENAME;
END;
--    2) EMP_NAME과 BOSS_ID가 같으면 IS_BOSS에 'T', 다르면 'F' 할당
--       실행 후 EMP_ID와 IS_BOSS 바인드 변수 값 PRINT;
PRINT EMP_ID;
PRINT IS_BOSS;
--2. 위의 문제에서 유저변수 대신 치환변수를 이용해 이름을 입력받아 바인드 변수에
--   값을 할당하고 프린트하는 블록 작성
VARIABLE IS_BOSS VARCHAR2(20)
VARIABLE EMP_ID NUMBER
DECLARE
    ENAME VARCHAR2(20) := &EN;
BEGIN
    SELECT A.EMP_ID, DECODE(B.BOSS_ID, A.EMP_ID,'T','F')
    INTO :EMP_ID, :IS_BOSS
    FROM TEMP A, TDEPT B
    WHERE A.DEPT_CODE = B.DEPT_CODE 
    AND A.EMP_NAME = ENAME;
END;
--3. BOM 테이블에 테스트 데이터 자동 입력
-- SPEC은 S+숫자 1자리로 S1부터 S5까지
-- ITEM은 I + 숫자 1자리로 I1부터 I7까지 존재
-- 첫번째 LOOP을 5회 돌며 S1부터 S5까지 생성
-- 두 번째 중첩 LOOP를 돌며 I1에서 I7까지 생성하며
-- S1, S2, S3인 경우 I7까지, S4, S5인 경우는 I5까지만 INSERT
-- 이때 QTY는 DBMS_RANDOM.VALUE를 이용해 1에서 3까지의 숫자 랜덤 할당 
if 조건 then
else
end if;
DECLARE
    CNT NUMBER := 1;
    CNT2 NUMBER := 1;
BEGIN
    LOOP
        EXIT WHEN CNT > 5;
        LOOP 
            IF CNT < 4 THEN
                EXIT WHEN CNT2 > 7;
                INSERT INTO BOM(SPEC_CODE, ITEM_CODE,ITEM_QTY)
                VALUES('S'||CNT,'I'||CNT2,CEIL(DBMS_RANDOM.VALUE(0,3)));
                CNT2 := CNT2 +1;
            ELSE
                EXIT WHEN CNT2 > 5;
                INSERT INTO BOM(SPEC_CODE, ITEM_CODE,ITEM_QTY)
                VALUES('S'||CNT,'I'||CNT2,CEIL(DBMS_RANDOM.VALUE(0,3)));
                CNT2 := CNT2 +1;
            END IF;
        END LOOP;
        CNT := CNT +1;
        CNT2 := 1;
    END LOOP;
END;
SELECT * FROM BOM;
TRUNCATE TABLE BOM;

--프로시져
CREATE OR REPLACE PROCEDURE(P1 NUMBER, P2 VARCHAR2(10)) P_TEST AS
BEGIN
END;
DECLARE
    PROCEDURE SUB1(P1 TEMP1.EMP_NAME%TYPE, P2 TEMP1.SALARY%TYPE) IS
    BEGIN
        UPDATE TEMP1
        SET SALARY = P2
        WHERE EMP_NAME = P1;
    END SUB1;
BEGIN
    SUB1('지문덕', 88888888);
    SUB1('강감찬', 77777777);
END;
SELECT * FROM TEMP1;
ROLLBACK;
--4. 3번의 중첩루프(내부루프)를 서브프로그램으로 변경
DECLARE
    CNT NUMBER := 1;
    CNT2 NUMBER := 1;
    PROCEDURE SUB1(P1 NUMBER, P2 NUMBER) IS
    BEGIN
        INSERT INTO BOM(SPEC_CODE, ITEM_CODE,ITEM_QTY)
                VALUES('S'||P1,'I'||P2,CEIL(DBMS_RANDOM.VALUE(0,3)));
    END SUB1;
BEGIN
    LOOP
        EXIT WHEN CNT > 5;
        IF CNT < 4 THEN
            LOOP 
                EXIT WHEN CNT2 > 7;
                SUB1(CNT,CNT2);
                CNT2 := CNT2 +1;
            END LOOP;
        ELSE
            LOOP 
                EXIT WHEN CNT2 > 5;
                SUB1(CNT,CNT2);
                CNT2 := CNT2 +1;
            END LOOP;
        END IF;
        CNT := CNT +1;
        CNT2 := 1;
    END LOOP;
END;
TRUNCATE TABLE BOM;
SELECT * FROM BOM;
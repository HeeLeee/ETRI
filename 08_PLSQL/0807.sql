BEGIN
    DBMS_OUTPUT.PUT_LINE(LOWER('WWww'));
    DBMS_OUTPUT.PUT_LINE(UPPER('WWww'));
    DBMS_OUTPUT.PUT_LINE(INITCAP('WWww'));
    DBMS_OUTPUT.PUT_LINE(LPAD('AA',4,'B'));
    DBMS_OUTPUT.PUT_LINE(LTRIM('ABC','A'));
    DBMS_OUTPUT.PUT_LINE(LTRIM('ABC','A'));
    DBMS_OUTPUT.PUT_LINE(LAST_DAY(SYSDATE));
END;
--중첩블록
DECLARE 
    outer_variable VARCHAR2(20):='GLOBAL VARIABLE'; 
BEGIN 
    DECLARE inner_variable VARCHAR2(20):='LOCAL VARIABLE'; 
    BEGIN DBMS_OUTPUT.PUT_LINE(inner_variable); 
          DBMS_OUTPUT.PUT_LINE(outer_variable); 
END; 
    DBMS_OUTPUT.PUT_LINE(outer_variable); 
END;
--변수 범위 및 가시성
DECLARE 
    father_name VARCHAR2(20):='Patrick'; 
    date_of_birth DATE:='1972-04-29'; 
BEGIN 
    DECLARE 
        child_name VARCHAR2(20):='Mike'; 
        date_of_birth DATE:='2002-01-01'; 
    BEGIN DBMS_OUTPUT.PUT_LINE('Father''s Name: '||father_name); 
        DBMS_OUTPUT.PUT_LINE('Date of Birth: '||date_of_birth); 
        DBMS_OUTPUT.PUT_LINE('Child''s Name: '||child_name); 
    END; 
    DBMS_OUTPUT.PUT_LINE('Date of Birth: '||date_of_birth); 
END;
--식별자의 명확한 지정
<<OUTER>>
DECLARE
    FATHER_NAME VARCHAR2(20) := 'PATRICK';
    DATE_OF_BIRTH DATE := '2002-12-12';
BEGIN
    DECLARE
        CHILD_NAME VARCHAR2(20) := 'MIKE';
        DATE_OF_BIRTH DATE := '1972-04-28';
    BEGIN
        DBMS_OUTPUT.PUT_LINE('FATHER''S NAME: '||FATHER_NAME);
        DBMS_OUTPUT.PUT_LINE('DATE OF BIRTH: '||OUTER.DATE_OF_BIRTH);
        DBMS_OUTPUT.PUT_LINE('CHILD''S NAME: '||CHILD_NAME);
    END;
    DBMS_OUTPUT.PUT_LINE('DATE OF BIRTH: '||DATE_OF_BIRTH);
END;

--변수 범위 결정
<<outer>> 
DECLARE 
    sal      NUMBER(7,2) := 60000; 
    comm     NUMBER(7,2) := sal * 0.20; 
    message  VARCHAR2(255) := ' eligible for commission'; 
BEGIN 
    DECLARE 
        sal NUMBER(7,2) := 50000; 
        comm  NUMBER(7,2) := 0; 
        total_comp  NUMBER(7,2) := sal + comm; 
    BEGIN 
        message := 'CLERK not'||message; 
        outer.comm := sal * 0.30;
        DBMS_OUTPUT.PUT_LINE(message);
        DBMS_OUTPUT.PUT_LINE(comm);
        DBMS_OUTPUT.PUT_LINE(outer.comm);
    END; 
    message := 'SALESMAN'||message; 
    DBMS_OUTPUT.PUT_LINE(message);
    DBMS_OUTPUT.PUT_LINE(comm);
END;
--1. PL/SQL 블록
DECLARE
 weight NUMBER(3) := 600;
 message VARCHAR2(255) := 'Product 10012';
BEGIN
 DECLARE
  weight NUMBER(3) := 1;
  message VARCHAR2(255) := 'Product 11001';
  new_locn VARCHAR2(50) := 'Europe';
 BEGIN
  weight := weight + 1;
  new_locn := 'Western ' || new_locn;
  -- (1)번
 END;
 weight := weight + 1;
 message := message || ' is in stock';
 new_locn := 'Western ' || new_locn;
  -- (2)번
END;
--1. 위에 제시된 PL/SQL 블록을 검토하여 범위 지정 규칙에 따라 다음 각 변수의 데이터 유형
--및 값을 판별합니다.
--a. 1 위치에서의 weight 값: 2
--b. 1 위치에서의 new_locn 값: Westren Europe
--c. 2 위치에서의 weight 값: 1
--d. 2 위치에서의 message 값: Product 11001
--e. 2 위치에서의 new_locn 값: 에러
--2. 
--범위 예제
DECLARE
 customer VARCHAR2(50) := 'Womansport';
 credit_rating VARCHAR2(50) := 'EXCELLENT';
BEGIN
 DECLARE
  customer NUMBER(7) := 201;
  name VARCHAR2(25) := 'Unisports';
 BEGIN
  credit_rating :='GOOD';
  …
 END;
…
END;
--2. 위에 제시된 PL/SQL 블록에서 다음 각 경우에 해당하는 값 및 데이터 유형을 판별합니다.
--a. 중첩 블록의 customer 값: 201
--b. 중첩된 블록의 name 값: Unisports
--c. 중첩 블록의 credit_rating 값: GOOD
--d. 주 블록의 customer 값: EXCELLENT
--e. 주 블록의 name 값: 에러
--f. 주 블록의 credit_rating 값: Womansport

--3. 
--a. 데이터 유형이 VARCHAR2이고 크기가 15인 fname 및 데이터 유형이 NUMBER이고
--크기가 10인 emp_sal이라는 두 변수를 선언합니다.
--b. 다음 SQL 문을 실행 섹션에 포함시킵니다.
SELECT first_name, salary
INTO fname, emp_sal FROM employees
WHERE employee_id=110;
--c. 'Hello'와 이름을 출력. 필요한 경우 날짜를 표시
--d. 적립 기금(PF)에 대한 사원의 부담금을 계산합니다. PF는 기본 급여의 12%이며 기본
--급여는 급여의 45%입니다. 계산할 때는 바인드 변수를 사용합니다. 표현식을 하나만
--사용하여 PF를 계산합니다. 사원의 급여 및 PF 부담금을 출력합니다.
VARIABLE PF NUMBER;
DECLARE
    FNAME VARCHAR2(15);
    EMP_SAL NUMBER(10);
BEGIN
    SELECT first_name, salary
    INTO FNAME, EMP_SAL
    FROM employees
    WHERE employee_id=110;
    DBMS_OUTPUT.PUT_LINE('HELLO '||FNAME);
    :PF := (EMP_SAL * 0.45) * 0.12;
    DBMS_OUTPUT.PUT_LINE('급여 :'||EMP_SAL||'PF :'||:PF);
END;
--e. 스크립트를 실행
PRINT PF;
--
--1.  첫 번째 변수는 ‘주소: 서울특별시 서초구 양재동 XXX번지’ 문자 초기 값 할당
--    두 번째 변수는 첫 번째 변수의 길이를 초기 값으로 할당
--    세 번째 변수는 ‘:’ 문자가 나타나는 위치 값 할당
--    네 번째 변수는 첫 번째 변수에서 콜론(:) 다음 문자부터 마지막 문자까지 할당
--    BEGIN SECTION에서 네 번째 변수 값 출력
DECLARE
    V1 VARCHAR2(100) := '주소: 서울시특별시 서초구 양재동 XXX번지';
    V2 NUMBER := LENGTH(V1);
    V3 NUMBER := INSTR(V1,':');
    V4 VARCHAR2(100) := SUBSTR(V1, V3+1);
BEGIN
    DBMS_OUTPUT.PUT_LINE('네 번째 변수 값: '||V4);
END;
--2.  VARCHAR2(02) 변수 두 개 선언 ‘3’으로 초기화, NUMBER 변수 2개 선언 20으로 초기화
--    문자1 변수에 숫자1과 숫자2 더해 할당하고 문자1 변수 출력
--    문자1 변수에 숫자1과 문자1 더해 할당하고 문자1 변수 출력    
--    숫자1 변수에 문자1과 문자2 더해 할당하고 숫자1 변수 출력
DECLARE 
    V1 VARCHAR2(02) := '3';
    V2 VARCHAR2(02) := '3';
    N1 NUMBER := 20;
    N2 NUMBER := 20;
BEGIN
    V1 := N1+N2;
    DBMS_OUTPUT.PUT_LINE('V1 :'||V1);
    V1 := N1+V1;
    DBMS_OUTPUT.PUT_LINE('V1 :'||V1);
    N1 := V1+V2;
    DBMS_OUTPUT.PUT_LINE('N1 :'||N1);
END;
--5.
-- 연도를 받아들이는 PL/SQL 블록을 작성하고 연도가 윤년인지 여부를 확인합니다. 예를
--들어, 입력한 연도가 1990 이면 "1990 is not a leap year"가 출력되어야 합니다.
--힌트: 윤년은 4로 정확히 나누어 떨어지며 100의 배수는 아닙니다. 그렇지만
--400의 배수는 윤년입니다.
--다음 연도로 솔루션을 테스트합니다.
--1990 Not a leap year
--2000 Leap year
--1996 Leap year
--1886 Not a leap year
--1992 Leap year
--1824 Leap year
DECLARE
    YEAR NUMBER := &YEAR;
BEGIN
    CASE  
        WHEN (MOD(YEAR,4)=0 AND MOD(YEAR,100)!=0) OR MOD(YEAR,400)=0 
        THEN DBMS_OUTPUT.PUT_LINE(YEAR||' LEAP YEAR');
        ELSE DBMS_OUTPUT.PUT_LINE(YEAR||' NOT A LEAP YEAR');
    END CASE;
END;
--6. PL_C VARCHAR2(02) 변수선언 ‘3’ 으로 초기화,  PL_N NUMBER형 변수 선언 20으로 초기화
--    실행부에서 PL_N을 TO_CHAR로 변환 후 PL_C와 IF 문으로 비교 하여 큰 값 확인 
if 조건 then
else
end if;
DECLARE
    PL_C VARCHAR2(02) := '3';
    PL_N NUMBER := 20;
BEGIN
    IF PL_C>TO_CHAR(PL_N) THEN DBMS_OUTPUT.PUT_LINE('3이 20보다 크다니 문자를 비교했군요!');
    ELSE DBMS_OUTPUT.PUT_LINE('20이 3보다 크다니 숫자를 비교했군요!');
    END IF;
END; 
--7.  1을 명시적 형변환 없이 비교하여 결과 보기(IF 문에서 두 변수의 비교순서 바꿔가며 확인)
DECLARE
    PL_C VARCHAR2(02) := '3';
    PL_N NUMBER := 20;
BEGIN
    IF PL_C>PL_N THEN DBMS_OUTPUT.PUT_LINE('3이 20보다 크다니 문자를 비교했군요!');
    ELSE DBMS_OUTPUT.PUT_LINE('3이 20보다 작다니 숫자를 비교했군요!');
    END IF;
    IF PL_N>PL_C THEN DBMS_OUTPUT.PUT_LINE('20이 3보다 크다니 숫자를 비교했군요!');
    ELSE DBMS_OUTPUT.PUT_LINE('3이 20보다 크다니 문자를 비교했군요!');
    END IF;
END;
--8.  2를 IF문에서 GREATEST에 넣어 비교 (두 변수의 순서 바꿔가며 비교) 결과 보기
DECLARE
    PL_C VARCHAR2(02) := '3';
    PL_N NUMBER := 20;
BEGIN
    IF GREATEST(PL_C, PL_N) = PL_C THEN DBMS_OUTPUT.PUT_LINE('3이 20보다 작다니 숫자를 비교했군요!');
    ELSE DBMS_OUTPUT.PUT_LINE('3이 20보다 크다니 문자를 비교했군요!');
    END IF;
    IF GREATEST(PL_N,PL_C) = PL_N THEN DBMS_OUTPUT.PUT_LINE('3이 20보다 크다니 문자를 비교했군요!');
    ELSE DBMS_OUTPUT.PUT_LINE('3이 20보다 작다니 숫자를 비교했군요!');
    END IF;
END; 
--9.  HINT이용 SALARY INDEX이용 조회하기
--  (조건에서 0보다 크다, ‘0’보다 크다, TO_CHAR(SALARY) > ‘0’ 각각 적용)
SELECT *
FROM USER_IND_COLUMNS
WHERE TABLE_NAME = 'TEMP'
AND COLUMN_NAME = 'SALARY';

DROP INDEX SALARY1;

CREATE INDEX SAL_IND ON TEMP(SALARY);
--
SELECT /*+ INDEX(TEMP SAL_IND)*/ *
FROM TEMP
WHERE SALARY > 0;
--1. 중첩 외부블록에 PL_OUT 문자 변수 선언 후 'GLOBAL 변수 '할당,
--중첩 내부 블록에 PL_IN문자 변수 선언 후 'LOCAL 변수'할당
--이후 내부 블록에서 PL_OUT과 PL_IN 각각 출력
DECLARE
    PL_OUT VARCHAR2(20) := 'GLOBAL 변수';
BEGIN
    DECLARE
        PL_IN VARCHAR2(20) := 'LOCAL 변수';
    BEGIN
        DBMS_OUTPUT.PUT_LINE(PL_OUT);
        DBMS_OUTPUT.PUT_LINE(PL_IN);
    END;
END;
--2. 1번에서 중첩내부블록에 PL_OUT 동일 이름/유형으로 재선언 후 'OUT과 이름 같은 LOCAL' 초기 값 할당 후 재실행 하여 출력 결과 확인
DECLARE
    PL_OUT VARCHAR2(100) := 'GLOBAL 변수';
BEGIN
    DECLARE
        PL_IN VARCHAR2(100) := 'LOCAL 변수';
        PL_OUT VARCHAR2(100) := 'OUT과 이름 같은 LOCAL';
    BEGIN
        DBMS_OUTPUT.PUT_LINE(PL_OUT);
        DBMS_OUTPUT.PUT_LINE(PL_IN);
    END;
END;
--3.2번에 중첩내부 블록ㅇ르 빠져나오자 마자 PL_OUT값 출력 추가 후 실행 결과 확인
DECLARE
    PL_OUT VARCHAR2(100) := 'GLOBAL 변수';
BEGIN
    DECLARE
        PL_IN VARCHAR2(100) := 'LOCAL 변수';
        PL_OUT VARCHAR2(100) := 'OUT과 이름 같은 LOCAL';
    BEGIN
        DBMS_OUTPUT.PUT_LINE(PL_OUT);
        DBMS_OUTPUT.PUT_LINE(PL_IN);
    END;
    DBMS_OUTPUT.PUT_LINE(PL_OUT);
END;
--4. 익명블록 선언부에 PL_G VARCHAR2(40) 선언 후 ;GLOBAL'로 초기화
--실행부에 한개의 중첩블록 선언 후 중첩블록 선언부에서 PL_L1 VARCHAR2(40)선언
--'LOCAL BEGIN 1ST BLOCK'으로 초기화. 중첩블록 실행부에서 GLOBAL과 자신의 LOCAL변수 출력
DECLARE
    PL_G VARCHAR2(40) := 'GLOBAL';
BEGIN
    DECLARE
        PL_LI VARCHAR2(40) := 'LOCAL BEGIN 1ST BLOCK';
    BEGIN
        DBMS_OUTPUT.PUT_LINE(PL_G);
        DBMS_OUTPUT.PUT_LINE(PL_LI);
    END;
END;
--5. 4번 실행부에 두번째 중첩 블록 만들고 선언부에 PL_L2선언 및 'LOCAL BEGIN 2ND BLOCK'으로 초기화 후 두번째 
--    중첩 블록 실행부에서 PL_G,PL_L1,PL_L2출력(오류확인 및 원인 확인)
DECLARE
    PL_G VARCHAR2(40) := 'GLOBAL';
BEGIN
    DECLARE
        PL_L1 VARCHAR2(40) := 'LOCAL BEGIN 1ST BLOCK';
    BEGIN
        DBMS_OUTPUT.PUT_LINE(PL_G);
        DBMS_OUTPUT.PUT_LINE(PL_L1);
    END;
    DECLARE 
        PL_L2 VARCHAR2(40) := 'LOCAL BEGIN 2ND BLOCK';
    BEGIN
        DBMS_OUTPUT.PUT_LINE(PL_G);
        DBMS_OUTPUT.PUT_LINE(PL_L1);  
        DBMS_OUTPUT.PUT_LINE(PL_L2); 
    END;
END;
--6. 외부 블록에 <<OUTER>>라는 라벨 지정 후 중첩 내부 블록과 외부 블록에서 동일한 이름의 변수 선언한 뒤 내부 블록에서 변수값 출력시 
--  하나는 변수 앞에 OUTER.붙여 출력하고 하나는 붙이지 않고 변수명 그대로 출력
<<OUTER>>
DECLARE
    PL_G VARCHAR2(40) := 'GLOBAL';
BEGIN
    DECLARE
        PL_G VARCHAR2(40) := 'LOCAL';
    BEGIN
        DBMS_OUTPUT.PUT_LINE(OUTER.PL_G);
        DBMS_OUTPUT.PUT_LINE(PL_G);
    END;
END;
--7. 6번에서 중첩 내부 블록 앞에 <<INNER>>라고 LABEL 지정하고 내부 블록 빠져 나오자마자 INNER.변수이름 출력하여 오류 내용 확인.
<<OUTER>>
DECLARE
    PL_G VARCHAR2(40) := 'GLOBAL';
BEGIN
    <<INNER>>
    DECLARE 
        PL_G VARCHAR2(40) := 'LOCAL';
    BEGIN
        DBMS_OUTPUT.PUT_LINE(OUTER.PL_G);
        DBMS_OUTPUT.PUT_LINE(PL_G);
    END;
    DBMS_OUTPUT.PUT_LINE(INNER.PL_G);
END;
--8. 이름을 PARAMETER로 주면 EMP_LEVEL을 찾아 해당 직급이 없으면, 해당 사원의 직급과 급여
--정보를 이용해 새로 자료를 삽입하며 (이 때 FROM_SAL과 TO_SAL은 SALARY로 동일한 값 부여),
--SALARY가 범위를 벗어나는 경우 SALARY가 범위보다 작으면 범위 하한치를 SALARY로 바꾸고
--SALARY가 범위보다 크면 범위 상한치를 SALARY로 바꾸어 주는 PROCEDURE 작성 및 생성
--(명칭: SAL_RANGE_CHANGE)
CREATE OR REPLACE PROCEDURE SAL_RANGE_CHANGE(P1 TEMP.EMP_NAME%TYPE) IS
    TLEV VARCHAR2(20);
    TLEV2 VARCHAR2(20);
    SAL NUMBER;
    TSAL NUMBER;
    FSAL NUMBER;
BEGIN
    SELECT A.LEV, A.SALARY, B.LEV, B.FROM_SAL, B.TO_SAL
    INTO TLEV, SAL, TLEV2, FSAL, TSAL
    FROM TEMP A, EMP_LEVEL B
    WHERE EMP_NAME = P1
    AND A.LEV = B.LEV(+);
     
    IF TLEV2 IS NULL
        THEN INSERT INTO EMP_LEVEL(LEV,FROM_SAL,TO_SAL)
                VALUES(TLEV,SAL,SAL);
    END IF;
    IF SAL < FSAL
        THEN UPDATE EMP_LEVEL SET FROM_SAL = SAL WHERE LEV = TLEV;
    END IF;
    IF SAL > TSAL
        THEN UPDATE EMP_LEVEL SET TO_SAL = SAL WHERE LEV = TLEV;
    END IF;
END;
--
EXECUTE SAL_RANGE_CHANGE('박승규');
ROLLBACK;
SELECT * FROM TEMP;
SELECT * FROM EMP_LEVEL;
--
INSERT INTO TEMP (EMP_ID, EMP_NAME, DEPT_CODE, EMP_TYPE, USE_YN, TEL, HOBBY, SALARY, LEV,EVAL_YN) 
VALUES (19800101,'김피디', 'AB0001', '정규','Y',12341234,'TV',0,'과장','Y');
--
--9. CREATE TABLE TDEPT2 AS SELECT * FROM TDEPT WHERE DEPT_CODE <> 'AB0001';
--10. PROCEDURE를 수행하는 제일 앞 부분에서 먼저 주어진 이름으로 사원정보에서 부서코드를 찾아 변수에 저장하고
--    TDEPT2를 조회해 해당부서 정보가 없으면 '부서 정보가 없으니 작업이 끝나면 부서 정보도 입력해주세요.'
--    라고 출력 후 나머지 로직 수행하도록 하며, 있으면 모든 로직 처리 후 마지막에 부서코드 정보와 함께
--    '성공적으로 처리되었습니다.' 출력
BEGIN
    SELECT B.DEPT_CODE
    FROM TEMP A, TDEPT B
    WHERE A.EMP_NAME = P1
    AND B.DEPT_CODE = A.DEPT_CODE;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
    DBMS_OUTPUT.PUT_LINE(P1||'직원의 부서정보가 없으니 작업이 끝나면 부서 정보도 입력해주세요.');
END;
--프로시저 마지막에
IF PL_DEPT IS NOT NULL THEN
    DBMS_OUTPUT.PUT_LINE(PL_DEPT||'부서의 정보가 정상적으로 존재하여 성공적으로 처리되었습니다.');
END IF
--11. 김피티 SALARY 를 1111111으로 UPDATE 후 프로시저 실행
--12. 위의 PROCEDURE에서 중첩 BLOCK 제거하고 실행 했을 때의 결과와 비교
--    - 중첩 블록을 제거해도 EMP_LEVEL에 DATA가 INSERT, UPDATE 되는지
--13. 중첩 BLOCK의 EXCEPTION만 제거하고 결과 비교
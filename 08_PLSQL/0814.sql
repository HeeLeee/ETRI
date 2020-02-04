CREATE TABLE JIT_CHECK AS
SELECT * FROM JIT_DELIVERY_PLAN
WHERE DELIVERY_DATE = '20000000';

SELECT * FROM JIT_CHECK;
TRUNCATE TABLE JIT_CHECK;
UPDATE JIT_DELIVERY_PLAN
SET ITEM_QTY = ITEM_QTY-1
WHERE DELIVERY_DATE = '20191001'
AND DELIVERY_SEQ = 5;

SELECT COUNT(*) FROM JIT_DELIVERY_PLAN;

SELECT A.SPEC_CODE, A.LINE_NO, A.INPUT_PLAN_DATE, ITEM_CODE, ITEM_QTY, CEIL(PLAN_SEQ/2)
FROM INPUT_PLAN A, BOM B
WHERE A.SPEC_CODE = B.SPEC_CODE;
/*
날짜를 parameter로 받아서 해당 날짜의 jit_delivery_plan table
정보가 제대로 입력 되어 있는지 확인하여 실제 수치와 다르다면 
어느 일자, 어느 라인, 어느 jit 순번, 어느 item에서 얼마만큼의 수량이 차이가 나는지
확인하여 jit_check table의 해당 날짜 데이터에 차이나는 부분을 
insert 해주는 procedure (p_jit_plan_check)*/
EXECUTE P_JIT_PLAN_CHECK(20191001);
CREATE OR REPLACE PROCEDURE P_JIT_PLAN_CHECK(P1 JIT_DELIVERY_PLAN.DELIVERY_DATE%TYPE)
AS
    L1  JIT_DELIVERY_PLAN.LINE_NO%TYPE;
    L2  JIT_DELIVERY_PLAN.LINE_NO%TYPE;
    D1  JIT_DELIVERY_PLAN.DELIVERY_DATE%TYPE;
    D2  JIT_DELIVERY_PLAN.DELIVERY_DATE%TYPE;
    I1  JIT_DELIVERY_PLAN.ITEM_CODE%TYPE;
    I2  JIT_DELIVERY_PLAN.ITEM_CODE%TYPE;
    S1  JIT_DELIVERY_PLAN.DELIVERY_SEQ%TYPE;
    S2  JIT_DELIVERY_PLAN.DELIVERY_SEQ%TYPE;
    Q1  JIT_DELIVERY_PLAN.ITEM_QTY%TYPE;
    Q2  JIT_DELIVERY_PLAN.ITEM_QTY%TYPE;
    CURSOR CUR1 IS
    SELECT A.LINE_NO LINE_NO, 
            A.INPUT_PLAN_DATE INPUT_PLAN_DATE, 
            ITEM_CODE, 
            SUM(ITEM_QTY) ITEM_QTY, CEIL(PLAN_SEQ/2) PLAN_SEQ
    FROM INPUT_PLAN A, BOM B
    WHERE A.SPEC_CODE = B.SPEC_CODE
    AND A.INPUT_PLAN_DATE = P1
    GROUP BY A.LINE_NO, A.INPUT_PLAN_DATE, ITEM_CODE, CEIL(PLAN_SEQ/2);
BEGIN
    OPEN CUR1;
    LOOP    
        FETCH CUR1
        INTO L1, D1, I1, Q1, S1;
        SELECT DELIVERY_DATE, LINE_NO, DELIVERY_SEQ, ITEM_CODE, ITEM_QTY
        INTO D2, L2, S2, I2, Q2
        FROM JIT_DELIVERY_PLAN
        WHERE DELIVERY_DATE = D1
        AND LINE_NO = L1
        AND DELIVERY_SEQ = S1
        AND ITEM_CODE = I1
        AND DELIVERY_DATE = P1;
        EXIT WHEN CUR1%NOTFOUND;
        IF L1=L2 AND D1=D2 AND I1=I2 AND S1=S2 AND Q1!=Q2
        THEN
            INSERT INTO JIT_CHECK
            VALUES(D1,L1,S1,I1,Q1-Q2,NULL);
        END IF;
    END LOOP;
    CLOSE CUR1;
END;

SELECT * FROM TEMP;
/*과제1. 최고연봉 금액과 그 당사자들 출력하기 (LOOP 연습용)
  1-1. 최고급여 금액과 급여를 받는 직원 이름을 저장할 변수 선언 
  1-2. 최초 직원과 SALARY 가져와 두 최고 변수에  각각 할당
  1-3. 다음 직원을 차례로 FETCH해 이제 까지의 최고SALARY보다 이 번 SALARY가 많으면 최고 SALARY 변수에 이번 SALARY 할당
        또한 이번 SALARY의 주인공도 최고당사자 변수에 할당 
        (만약 SALARY가 기존 MAX SALARY와 같으면 당사자 변수 값 뒤에 컴마(,)붙여 이번 직원ID APPEND)
  1-4. 두 변수 출력 */
DECLARE
    E_SAL NUMBER;
    E_EMP VARCHAR2(200);
    M_SAL NUMBER;
    M_EMP VARCHAR2(200);
    CURSOR CUR IS
    SELECT EMP_NAME, SALARY
    FROM (SELECT ROWNUM A, EMP_NAME, SALARY
                FROM TEMP)
    WHERE A > 1 ;
BEGIN
    SELECT EMP_NAME, SALARY
    INTO M_EMP, M_SAL
    FROM TEMP
    WHERE ROWNUM = 1;
    OPEN CUR;
    LOOP
        FETCH CUR INTO E_EMP, E_SAL;
        EXIT WHEN CUR%NOTFOUND;
        IF M_SAL < E_SAL THEN
            M_SAL := E_SAL;
            M_EMP := E_EMP;
        ELSIF M_SAL = E_SAL THEN
            M_SAL := E_SAL;
            M_EMP := M_EMP||','||E_EMP;
        END IF;
    END LOOP;
    DBMS_OUTPUT.PUT_LINE(M_EMP||' '||M_SAL);
    CLOSE CUR;
END;

--2. FOR LOOP 100회 돌며 1에서 100 까지 100LINE 출력하기
BEGIN
    FOR I IN 1..100
    LOOP
        DBMS_OUTPUT.PUT_LINE(I);
    END LOOP;
END;
--3. WHILE LOOP 3회 돌며 루프카운터 출력
DECLARE
    CNT NUMBER :=1 ;
BEGIN
    WHILE CNT < 4
    LOOP
        DBMS_OUTPUT.PUT_LINE(CNT);
        CNT := CNT+1;
    END LOOP;
END;
/*4. While Loop을 이용해 Power 함수와 동일한 기능을 하는 
   SQUARE1 함수 만들기 (함수 내에서 2번째
  인자로 음수 값이 들어오는 경우 SQRT 함수를 사용할 수 있으나 
  양수 값이 들어오는 경우 POWER 함수나
  지수 계산 연산자인 ** 사용 불가하며 WHILE LOOP으로 해결 할 것)*/
CREATE OR REPLACE FUNCTION SQUARE1(P1 NUMBER, P2 NUMBER)
 RETURN NUMBER
IS
    CNT NUMBER := 0;
    NUM NUMBER := 1;
BEGIN
    IF P2 >= 0
    THEN
        WHILE CNT < P2 
        LOOP
            NUM := NUM * P1;
            CNT := CNT + 1;
        END LOOP;
    ELSIF P2 < 0
    THEN
        NUM := SQRT(P1);
    END IF;
    RETURN NUM;
END;
SELECT SQUARE1(2,4) FROM DUAL;
--5. 루프카운터, 합계용 NUMBER 변수를 각각 선언하고 0 으로 초기화한 후 
--   기본 LOOP를 20회 실행시켜
--   카운터를 1씩 증가 시키며 루프카운터 값과 루프카운터의 현재까지의 누적 값을 출력
DECLARE
    CNT NUMBER := 0;
    SNUM NUMBER := 0;
BEGIN
    LOOP
    EXIT WHEN CNT >19;
        CNT := CNT + 1;
        SNUM := SNUM + CNT;
        DBMS_OUTPUT.PUT_LINE(CNT);
    END LOOP;
    DBMS_OUTPUT.PUT_LINE(SNUM);
END;
--6. 5번 문제를 WHIE LOOP으로 바꾸기
DECLARE
    CNT NUMBER := 0;
    SNUM NUMBER := 0;
BEGIN
    WHILE CNT < 20
    LOOP
        CNT := CNT + 1;
        SNUM := SNUM + CNT;
        DBMS_OUTPUT.PUT_LINE(CNT);
    END LOOP;
    DBMS_OUTPUT.PUT_LINE(SNUM);
END;
--7. 6번 문제를 FOR LOOP 으로 바꾸기
DECLARE
    CNT NUMBER := 0;
    SNUM NUMBER := 0;
BEGIN
    FOR I IN 1..20
    LOOP
        CNT := I;
        SNUM := SNUM + CNT;
        DBMS_OUTPUT.PUT_LINE(CNT);
    END LOOP;
    DBMS_OUTPUT.PUT_LINE(SNUM);
END;
--보너스 스터디공사가서해랑
--BONUS1. INPUT_PLAN 동일한 IN_SEQ 테이블 생성(모든 컬럼 NULL 허용, PK없음)

--BONUS2. 현재 10월 1일자 투입 계획과 동일한 값을 입력하기 위한 익명 블록 작성 중첩루프로 해결
BEGIN
    FOR i IN 1..3 LOOP
        FOR j IN 1..10 LOOP
                INSERT INTO IN_SEQ(INPUT_PLAN_DATE, LINE_NO, PLAN_SEQ, SPEC_CODE)
                VALUES('20191001', 'L0'||i, j, 'S0'||CEIL(j/2));
        END LOOP;
    END LOOP;
END;
--BONUS3. PL_DATE VARCHAR2(08)을 선언하고 초기값으로 '20191102' 할당
-- FOR LOOP를 5회 돌며 루프카운터를 이용해 DELIVERY_SEQ에
-- PLAN_DATE와 DELIVERY_SEQ 컬럼 값 입력
-- 테이블에서 입력 여부와 데이터 구조 확인하고 삭제 후 COMMIT;



--BONUS4. 위 코드를 그대로 이용해 5회 짜리
-- FOR LOOP 외곽에 추가하고 INSERT문에서는 새로 추가된
-- FOR 문의 루프카운터를 이용해 LINE과 SPEC컬럼 추가 입력.
-- 입력내용 및 구조 확인하고 데이터 삭제 후 COMMIT

--BONUS5. 위 INSERT문에서 점차 앞에 SPEC은 S LINE은 L문자를 앞에 붙이고
-- LPAD 적용해 S01, L01 형식으로 수정 후 데이터 확인 및 삭제


--BONUS6. 위 코드를 그대로 이용해 외곽을 5회짜리 FOR LOOP으로 감싸고
-- END LOOP 바로 위에서 PL_DATE 날짜 1일 증가
SELECT '20191102' + I - 1 IDATE,
       'L'||LPAD(J,2,'0') LINE,
       'S'||LPAD(J,2,'0') SPEC,
       K IN_SEQ
FROM (SELECT NO I FROM T1_DATA WHERE ROWNUM <= 5) A,
     (SELECT NO J FROM T1_DATA WHERE ROWNUM <= 5) B,
     (SELECT NO K FROM T1_DATA WHERE ROWNUM <= 5) C;

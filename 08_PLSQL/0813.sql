DECLARE 
    myage number:=31; 
BEGIN 
    IF myage < 11 
    THEN 
        DBMS_OUTPUT.PUT_LINE(' I am a child ');  
    END IF; 
END; 
--null일 경우 else로 이동함
DECLARE 
    myage number; 
BEGIN 
    IF myage < 11 
    THEN 
        DBMS_OUTPUT.PUT_LINE(' I am a child ');  
    ELSE 
        DBMS_OUTPUT.PUT_LINE(' I am not a child '); 
    END IF; 
END;
--case
DECLARE 
    grade CHAR(1) := UPPER('&grade'); 
    appraisal VARCHAR2(20); 
BEGIN  
    appraisal := 
        CASE grade 
            WHEN 'A' THEN 'Excellent' 
            WHEN 'B' THEN 'Very Good' 
            WHEN 'C' THEN 'Good' 
            ELSE 'No such grade' 
        END; 
DBMS_OUTPUT.PUT_LINE ('Grade: '|| grade || ' Appraisal ' || appraisal); 
END;
--LOOP
DECLARE 
    countryid    locations.country_id%TYPE := 'CA'; 
    loc_id       locations.location_id%TYPE; 
    counter NUMBER(2) := 1; 
    new_city     locations.city%TYPE := 'Montreal'; 
BEGIN 
    SELECT MAX(location_id) 
    INTO loc_id 
    FROM locations 
    WHERE country_id = countryid; 
    LOOP 
        INSERT INTO locations(location_id, city, country_id)   
        VALUES((loc_id + counter), new_city, countryid); 
        counter := counter + 1; 
        EXIT WHEN counter > 3; 
    END LOOP; 
END; 
--WHILE
DECLARE 
    countryid    locations.country_id%TYPE := 'CA'; 
    loc_id       locations.location_id%TYPE; 
    counter NUMBER(2) := 1; 
    new_city     locations.city%TYPE := 'Montreal'; 
BEGIN 
    SELECT MAX(location_id) 
    INTO loc_id 
    FROM locations 
    WHERE country_id = countryid; 
    WHILE COUNTER <= 3 LOOP
        INSERT INTO locations(location_id, city, country_id)   
        VALUES((loc_id + counter), new_city, countryid); 
        counter := counter + 1; 
    END LOOP; 
END;
--FOR
DECLARE 
    countryid    locations.country_id%TYPE := 'CA'; 
    loc_id       locations.location_id%TYPE; 
    new_city     locations.city%TYPE := 'Montreal'; 
BEGIN 
    SELECT MAX(location_id) 
    INTO loc_id 
    FROM locations 
    WHERE country_id = countryid; 
    FOR I IN 1..3 LOOP
        INSERT INTO locations(location_id, city, country_id)   
        VALUES((loc_id + I), new_city, countryid);   
        END LOOP; 
END;
--STUDY04
--JIT_DELIVERY_PLAN 테이블에 필요한 정보를
--모두 PARAMETER로 받아 한 건씩 데이터를 갱신 또는 삽입하는
--PROCEDURE P_JITCHANGE_BYROW
SELECT * FROM STUDY04.JIT_DELIVERY_PLAN;
--1.JIT_CHANGE_BYROW 프로시져를 생성하되 인풋 인자는 투입일자. JIT순번, 라인, ITEM, 수량일
CREATE OR REPLACE PROCEDURE P_JITCHANGE_BYROW(YM , JITNUM, LINE, ITEM, QTY)
AS

--2. 인풋인자를 모두 컬럼과 동일형 변수를 선언하여 각각 할당
--3. BEGIN에서 인풋인자의 QTY를 이용하여 JIT_DELIVERY_PLAN의 QTY를 업데이트 하되
--대상은 PK가 INPUT인자로 받은 조건과 같은 레코드
--4. SQL%NOTFOUND 이용대상이 없으면 동일 값 INSERT 수행
CREATE OR REPLACE PROCEDURE P_JITCHANGE_BYROW(DINPUT JIT_DELIVERY_PLAN.DELIVERY_DATE%TYPE,
                                                JITNUM NUMBER, 
                                                LINE JIT_DELIVERY_PLAN.LINE_NO%TYPE, 
                                                ITEM JIT_DELIVERY_PLAN.ITEM_CODE%TYPE, 
                                                QTY NUMBER)
AS
BEGIN
    UPDATE JIT_DELIVERY_PLAN
    SET ITEM_QTY = ITEM_QTY + QTY
    WHERE DELIVERY_DATE = DINPUT
    AND DELIVERY_SEQ = JITNUM
    AND ITEM_CODE = ITEM
    AND LINE_NO = LINE;
    
    IF SQL%NOTFOUND 
    THEN
        INSERT INTO JIT_DELIVERY_PLAN
        VALUES(DINPUT, LINE, JITNUM,ITEM, QTY, NULL);
    END IF;
END;
--명시적 CURSOR  <-> 암시적커서 SQL%FOUND ....
DECLARE
    VEMP NUMBER;
    VNM TEMP.EMP_NAME%TYPE;
    VSAL NUMBER;
    CURSOR CUR1 IS
    SELECT EMP_ID, EMP_NAME, SALARY
    FROM TEMP;
BEGIN
    OPEN CUR1;
    LOOP
        FETCH CUR1
        INTO VEMP, VNM, VSAL;
        EXIT WHEN CUR1%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE('ID:'||VEMP||' NAME: '||VNM||' SALARY: '||VSAL);
    END LOOP;
    CLOSE CUR1;
END;
--
/*1.  V_SECONDS 라는 VARCHAR2 변수를 정의하고 해당 변수에 
    SYSDATE의 초에 해당하는 숫자
    2자리 할당 후 BEGIN SECTION에서 if문을 이용해 해당 변수가 
    10보다 작거나 같으면 10초전 
    11과 20사이면 20초전  …. 
    51과 60 사이면 60초전 이라는 내용을 출력하는 익명 블록작성( IF문 이용)*/
DECLARE
    V_SECONDS VARCHAR2(2) := TO_CHAR(SYSDATE,'SS');
BEGIN
    IF V_SECONDS <= 10  
    THEN
        DBMS_OUTPUT.PUT_LINE('10초전');
    ELSIF V_SECONDS <= 20 AND V_SECONDS > 10
    THEN
        DBMS_OUTPUT.PUT_LINE('20초전');
    ELSIF V_SECONDS <= 30 AND V_SECONDS > 20
    THEN
        DBMS_OUTPUT.PUT_LINE('30초전');
    ELSIF V_SECONDS <= 40 AND V_SECONDS > 30
    THEN
        DBMS_OUTPUT.PUT_LINE('40초전');
    ELSIF V_SECONDS <= 50 AND V_SECONDS > 40
    THEN
        DBMS_OUTPUT.PUT_LINE('50초전');
    ELSIF V_SECONDS <= 60 AND V_SECONDS > 50
    THEN
        DBMS_OUTPUT.PUT_LINE('60초전');
    END IF;
END;
--2. 1번 문제를 CASE 문으로 구현;
DECLARE
    V_SECONDS VARCHAR2(2) := TO_CHAR(SYSDATE,'SS');
BEGIN
    CASE    
    WHEN V_SECONDS <= 10 THEN
        DBMS_OUTPUT.PUT_LINE('10초전');
    WHEN V_SECONDS <= 20 AND V_SECONDS > 10
    THEN
        DBMS_OUTPUT.PUT_LINE('20초전');
    WHEN V_SECONDS <= 30 AND V_SECONDS > 20
    THEN
        DBMS_OUTPUT.PUT_LINE('30초전');
    WHEN V_SECONDS <= 40 AND V_SECONDS > 30
    THEN
        DBMS_OUTPUT.PUT_LINE('40초전');
    WHEN V_SECONDS <= 50 AND V_SECONDS > 40
    THEN
        DBMS_OUTPUT.PUT_LINE('50초전');
    WHEN V_SECONDS <= 60 AND V_SECONDS > 50
    THEN
        DBMS_OUTPUT.PUT_LINE('60초전');
    END CASE;
END;
/*3. TEMP를 커서로 읽어 해당 직원의 SALARY와 직원과 동일 직급의
   SALARY평균을 구해 두 금액의 차이와 차이금액이 마이너스인지 플러스인지를 
   각각 변수에 할당.
   할당된 변수 값을 이용해 IF문을 통해 다음 로직 구현
   평균과의 GAP이 1천500만원보다 크고 많이 받는 상태면 ‘꽤많이 받네!’ 
   적게 받는 상태면 ‘재능기부네!‘
   GAP이 1천500만원보다 작거나 같으면서 많이 받으면 '좀 받네!‘ 
   적게 받으면 '아쉽게 받네‘ 평균과 같으면
   '딱 평균이네!‘ 를 결과 출력 익명 블록 작성*/
DECLARE
    ENM TEMP.EMP_NAME%TYPE;
    SAL NUMBER;
    ASAL NUMBER;
    CURSOR TCUR IS
    SELECT A.EMP_NAME, SALARY, SAL_AVG
    FROM TEMP A,
        (SELECT LEV, ROUND(AVG(SALARY)) SAL_AVG
        FROM TEMP
        GROUP BY LEV)B
    WHERE A.LEV = B.LEV;
BEGIN
    OPEN TCUR;
    LOOP
        FETCH TCUR
        INTO ENM, SAL, ASAL;
        IF (SAL - ASAL) > 15000000 AND SAL > ASAL
        THEN
            DBMS_OUTPUT.PUT_LINE(ENM|| ' 꽤많이 받네!');
        ELSIF (SAL - ASAL) > 15000000 AND SAL < ASAL
        THEN
            DBMS_OUTPUT.PUT_LINE(ENM||' 재능 기부네');    
        ELSIF (SAL - ASAL) <= 15000000 AND SAL > ASAL
        THEN
            DBMS_OUTPUT.PUT_LINE(ENM||' 좀 받네!'); 
        ELSIF (SAL - ASAL) <= 15000000 AND SAL < ASAL
        THEN
            DBMS_OUTPUT.PUT_LINE(ENM||' 아쉽게 받네');
        ELSIF SAL = ASAL
        THEN
            DBMS_OUTPUT.PUT_LINE(ENM||' 딱 평균이네!');
        END IF;
        EXIT WHEN TCUR%NOTFOUND;
    END LOOP;
END;

--정답
DECLARE
    VNM TEMP.EMP_NAME%TYPE;
    VSAL NUMBER;
    VLEV TEMP.LEV%TYPE;
    VGAP NUMBER;
    VSIGN NUMBER;
    PAVG NUMBER;
    VMSG VARCHAR2(200);
    CURSOR C1 IS
    SELECT EMP_NAME, SALARY, LEV
    FROM TEMP;
BEGIN
    OPEN C1;
    LOOP
        FETCH C1 INTO VNM, VSAL, VLEV;
        EXIT WHEN C1%NOTFOUND;
        SELECT AVG(SALARY)
        INTO PAVG
        FROM TEMP
        WHERE LEV = VLEV;
        VGAP := ABS(VSAL-PAVG);
        VSIGN := SIGN(VSAL-PAVG);
        
        IF VGAP > 15000000 THEN
            IF VSIGN = 1 THEN
                VMSG := '꽤 많이 받네!';
            ELSE
                VMSG := '재능기부네!';
            END IF;
        ELSE
            IF VSIGN = 1 THEN
                VMSG := '좀 받네!';
            ELSIF VSIGN =-1 THEN
                VMSG := '아쉽게 받네!';
            ELSE
                VMSG := '딱 평균이네!';
            END IF;
        END IF;
        DBMS_OUTPUT.PUT_LINE(VNM||' '||VMSG);
    END LOOP;
END;
/*4. 2 의 문제에서 출력 값을 CASE식을 이용해 변수에 직접 할당하고 
   DBMS_OUTPUT 출력 문장을 한번만 사용하도록 변경 */
DECLARE
    V_SECONDS VARCHAR2(2) := TO_CHAR(SYSDATE,'SS');
    V1 VARCHAR2(20);
BEGIN
    CASE    
    WHEN V_SECONDS <= 10 THEN
        V1 := '10초전';
    WHEN V_SECONDS <= 20 AND V_SECONDS > 10
    THEN
        V1 := '20초전';
    WHEN V_SECONDS <= 30 AND V_SECONDS > 20
    THEN
        V1 := '30초전';
    WHEN V_SECONDS <= 40 AND V_SECONDS > 30
    THEN
        V1 := '40초전';
    WHEN V_SECONDS <= 50 AND V_SECONDS > 40
    THEN
        V1 := '50초전';
    WHEN V_SECONDS <= 60 AND V_SECONDS > 50
    THEN
        V1 := '60초전';
    END CASE;
    DBMS_OUTPUT.PUT_LINE(V1);
END;
/*5. NUMBER 변수를 선언하고 초기화 없이 BEGIN SECTION에서 
   IF 문을 통해 변수가 10보다 큰 지를 물어
   TRUE 이면 ’10보다 큰 값’ 을 출력하고 
   10보다 작거나 같으면  ‘10보다 작거나 같은 값’ 출력 
   ELSE 면 ‘그럼 무슨 값? ’ 출력*/
DECLARE
    N NUMBER;
BEGIN
    IF N >10
    THEN
        DBMS_OUTPUT.PUT_LINE('10보다 큰 값');
    ELSIF N <= 10
        DBMS_OUTPUT.PUT_LINE('10보다 작거나 같은 값');
    ELSE
        DBMS_OUTPUT.PUT_LINE('그럼 무슨 값?');
    END IF;
END;
/*6. PL_A 와 PL_B 라는 두 NUMBER 변수를 초기화 없이 선언하고, 
   IF문에서 PL_A = PL_B 인지 물어 같으면 ' 둘은 같은 값 ‘  출력하고, 
  IF 문을 끝내고 바로 ' IF 문은 이미 지나옴 ! ‘ 을 출력하여 IF 문을 타는지
 통과하는지 확인. */

DECLARE
    PL_A NUMBER;
    PL_B NUMBER;
BEGIN
    IF PL_A = PL_B 
    THEN
        DBMS_OUTPUT.PUT_LINE('둘은 같은 값');
    END IF;
    DBMS_OUTPUT.PUT_LINE('IF문은 이미 지나옴!');
END;
/*7. TRUE 와 FALSE의 두 경우가 AND와 OR로 묶일 수 있는
   각각의 경우의 수를 따져 IF문으로 어느 경우에 TRUE 되는지 확인  */
DECLARE
    A NUMBER := 1;
    B NUMBER := 2;
BEGIN
    IF A = 1 AND B = 2
    THEN 
      DBMS_OUTPUT.PUT_LINE('TRUE');
    ELSIF A = 1 OR B = 2
    THEN 
      DBMS_OUTPUT.PUT_LINE('TRUE');
    ELSIF A = 1 AND B != 2
    THEN 
      DBMS_OUTPUT.PUT_LINE('FALSE');
    ELSIF A = 1 OR B != 2
    THEN 
      DBMS_OUTPUT.PUT_LINE('TRUE');
    ELSIF A != 1 OR B != 2
    THEN 
      DBMS_OUTPUT.PUT_LINE('FALSE');
    END IF;
END;
/*8. 사전조건
   EMP_LEVEL1, TCOM1, TEVAL의 201902 자료를 모두 삭제하고 COMMIT;
   TEMP의 전체 사원을 커서로 읽어 CHANGE_BY_EMP에 이름을 매개변수로 주어
   호출해 전체 사원에 대한 정보를 EMP_LEVEL1, TCOM1, TEVAL에 입력하는
   익명 블럭 생성*/
DESC TEMP;
DECLARE
    ENM TEMP.EMP_NAME%TYPE;
    CURSOR TCUR IS
    SELECT EMP_NAME
    FROM TEMP;
BEGIN
    OPEN TCUR;
    LOOP
        FETCH TCUR
        INTO ENM;
        EXIT WHEN TCUR%NOTFOUND;
        CHANGE_BY_EMP(ENM);
    END LOOP;
    CLOSE TCUR;
END;
SELECT * FROM TEVAL;
DELETE TEVAL;
COMMIT;

--보너스
--투입계획을 커서로 읽어 한건 씩 FETCH하며 BOM을 찾아
--JIT_PLAN에 넘거야 할 정보를 조합하여 한 건 씩
--JIT_CHANGE_BYROW를 호출하는 프로그램
DECLARE
    LINE INPUT_PLAN.LINE_NO%TYPE;
    SPEC INPUT_PLAN.SPEC_CODE%TYPE;
    INDATE INPUT_PLAN.INPUT_PLAN_DATE%TYPE;
    PSEQ INPUT_PLAN.PLAN_SEQ%TYPE;
    ITEM BOM.ITEM_CODE%TYPE;
    IQTY BOM.ITEM_QTY%TYPE;
    
    CURSOR ICUR IS
    SELECT A.SPEC_CODE, A.LINE_NO, A.INPUT_PLAN_DATE, ITEM_CODE, ITEM_QTY, CEIL(PLAN_SEQ/2)
    FROM INPUT_PLAN A, BOM B
    WHERE A.SPEC_CODE = B.SPEC_CODE;
BEGIN
    OPEN ICUR;
    LOOP
        FETCH ICUR
        INTO SPEC, LINE, INDATE, ITEM, IQTY, PSEQ;
        EXIT WHEN ICUR%NOTFOUND;
        P_JITCHANGE_BYROW(INDATE, PSEQ, LINE, ITEM, IQTY);
    END LOOP;
    CLOSE ICUR;
END;
SELECT COUNT(*) FROM JIT_DELIVERY_PLAN;
--보너스
--투입계획을 커서로 읽어 한건 씩 FETCH하며 BOM을 찾아
--JIT_PLAN에 넘거야 할 정보를 조합하여 한 건 씩
--JIT_CHANGE_BYROW를 호출하는 프로그램
DECLARE
    LINE INPUT_PLAN.LINE_NO%TYPE;
    SPEC INPUT_PLAN.SPEC_CODE%TYPE;
    INDATE INPUT_PLAN.INPUT_PLAN_DATE%TYPE;
    PSEQ INPUT_PLAN.PLAN_SEQ%TYPE;
    ITEM BOM.ITEM_CODE%TYPE;
    IQTY BOM.ITEM_QTY%TYPE;
    
    CURSOR ICUR IS
    SELECT A.SPEC_CODE, A.LINE_NO, A.INPUT_PLAN_DATE, ITEM_CODE, ITEM_QTY, CEIL(PLAN_SEQ/2)
    FROM INPUT_PLAN A, BOM B
    WHERE A.SPEC_CODE = B.SPEC_CODE;
BEGIN
    OPEN ICUR;
    LOOP
        FETCH ICUR
        INTO SPEC, LINE, INDATE, ITEM, IQTY, PSEQ;
        EXIT WHEN ICUR%NOTFOUND;
        P_JITCHANGE_BYROW(INDATE, PSEQ, LINE, ITEM, IQTY);
    END LOOP;
    CLOSE ICUR;
END;
SELECT COUNT(*) FROM JIT_DELIVERY_PLAN;
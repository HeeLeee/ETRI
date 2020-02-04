create or replace package var as
    i number := 0;
    s varchar2(20) := 'A';
end;

declare
begin
    dbms_output.put_line(var.i);
    dbms_output.put_line(var.s);
end;


declare
begin
    var.i := 1;  --바뀐값으로 출력된다.
    var.s := 'B';
    dbms_output.put_line(var.i);
    dbms_output.put_line(var.s);
end;

rollback; --롤백해도 1,B가 나온다.

create or replace package var as
 i number := 0;
 s varchar2(20) := 'A';
    cursor c1 is
    select * from temp;
end; --커서를 만들어.

-- 1. cursor가 블록을 벗어나도 open 이 유지되는지
-- 2. 트랜잭션을 마감해도 유지되는지
-- 3. 다른 세션에서도 유지되는지
declare
begin
    open var.c1;
    if var.c1%isopen then
        var.s := 'open';
    else
        var.s := 'close';
    end if;
    dbms_output.put_line(var.s);
end;
-- 1. cursor가 블록을 벗어나도 open 이 유지되는지 : YES
--2.트랜잭션을 마감해도 유지되는지 : YES
--3.다른 세션에서도 유지되는지 : NO
declare
begin
    if var.c1%isopen then
        var.s := 'open';
    else
        var.s := 'close';
    end if;
    dbms_output.put_line(var.s);
    close var.c1;
END;
--
CREATE OR REPLACE PROCEDURE PR1(P1 OUT NUMBER, P2 IN OUT NUMBER) IS
BEGIN
    P1 := P2;
    P2 := P2*2;
END;

DECLARE
    V NUMBER;
    P NUMBER;
BEGIN
    P := 100;
    PR1(V,P);
    DBMS_OUTPUT.PUT_LINE(V);
    DBMS_OUTPUT.PUT_LINE(P);
END;
--1. 간단한 프로시져와 파라미터 받는 프로시저
--    1.1 TEST04 테이블에 YMD:20181201 US_AMOUNT:3000을 입력/저장하는 P_TEST1 PROCEDURE 작성
create or replace PROCEDURE P_TEST1 as
begin 
    insert into test04 values('20181201', 300);
end; 

execute P_TEST1;
--    1.2 일자와 금액을 PARAMETER로 받아 TEST04에 INSERT하는 P_TEST02 PROCEDURE 작성
CREATE OR REPLACE PROCEDURE P_TEST02(PYMD OUT NUMBER, PUS IN OUT NUMBER) IS
BEGIN
INSERT INTO TEST04 VALUES(PYMD, PUS);
END;

--2. TID VARCHAR2(10) PK, MESEQ NUMBER 두 컬럼을 가진 TESQ 테이블 생성 후 TID:KEY1 MSEQ:0 INSERT
CREATE TABLE TSEQ(
    TID VARCHAR2(10),
    MSEQ NUMBER);

ALTER TABLE TSEQ ADD CONSTRAINT TESQ_PK2 PRIMARY KEY(TID);

INSERT INTO TSEQ VALUES('KEY1', 0);
--    2.1 TID를 IN PARAMETER로 받아 TSEQ에서 해당 TID의 현재 MSEQ를 1증가시키고 증가된 값을 OUT
--    PARAMETER로 넘겨주는 P_TEST3 PROCEDURE 작성*/  
CREATE OR REPLACE PROCEDURE P_TEST3(pTID IN VARCHAR2, pMSEQ OUT NUMBER) IS
BEGIN
    UPDATE TSEQ 
    SET MSEQ = MSEQ+1;
    
    SELECT MSEQ 
    INTO pMSEQ
    FROM TSEQ
    WHERE TID = pTID;
END;
DECLARE
    V VARCHAR2(08);
    N NUMBER;
BEGIN
    V := 'KEY1';
    P_TEST3(V, N);
    DBMS_OUTPUT.PUT_LINE(N);
END;

SELECT * FROM TSEQ;
--3. TEST0 테이블 생성 : KEY1 NUMBER PRIMARY KEY, REMARK VARCHAR2(200)
CREATE TABLE TEST0(
    KEY1 NUMBER PRIMARY KEY,
    REMARK VARCHAR2(200)
);
--  3.1 문자열을 PARAMETER 로 받아 TEST0 테이블에 INSERT하는
--      P_TEST4 PROCEDURE를 만들되 PK값을 P_TEST3 PROCEDURE를 통해 받아올 것
CREATE OR REPLACE PROCEDURE P_TEST4(P1 VARCHAR2) IS
    N NUMBER;
BEGIN
    P_TEST3('KEY1',N);
    INSERT INTO TEST0
    VALUES(P1,N);
END;

--  3.2 TEMP의 EMP_NAME을 FOR LOOP SUBQUERY CURSOR로 읽어서 LOOP 돌며
--      P_TEST4에 EMP_NAME을 PARAMETER로 주고 호출하는 P_TEST5 프로시져 생성
CREATE OR REPLACE PROCEDURE P_TEST5 IS
BEGIN
  FOR I IN (SELECT EMP_NAME FROM TEMP) LOOP
    P_TEST4(I.EMP_NAME);
  END LOOP;
END;
/
EXEC P_TEST4();
--1.function에서의 update
--    1.1 무조건 1을 리턴하는 f_test1 이름의 function 작성 후 dual을 이용 함수 사용 select 
        --select f_test1 from dual;
CREATE OR REPLACE FUNC
--    1.2 f_test1에 test04테이블에 (20181203, 2000)을  insert하는 문장 추가 후 재 실행 해 오류 확인
--2. sub program 등록
--    2.1 실습예제1의 2.1 p_test3 procedure 수정하여 select 문을 서브프로그램 함수로 등록하고
--    mseq의 값을 select하는 문장에서 서브 프로그램 함수 호출하도록 바꾸고 컴파일
--3. sub program 이용
--    3.1 p_test5 재실행 후 tseq select 하여 수정된 p_test3이 잘 실행되는지 확인하고 rollback
--    3.2 select get_mseq from dual;
--    문을 실행하여 프로시저 내의 서브 프로그램을 pl_sql block 밖에서 호출할 수 있는지 확인

CREATE TABLE TEMP10 AS
SELECT * FROM TEMP
WHERE ROWNUM < 1;

CREATE OR REPLACE TRIGGER TEMP10_UPDATE
    AFTER UPDATE ON TEMP10 FOR EACH ROW
BEGIN
--1. 부서나 직급이 변경될 수 있다
    IF  (:OLD.DEPT_CODE <> :NEW.DEPT_CODE) OR
        (:OLD.LEV <> :NEW.LEV)  THEN
            UPD(-1, :OLD.DEPT_CODE, :OLD.LEV);
    --OLD값의 부서/직급에서 1 차감 : UPDATE만
            UPD(1, :NEW.DEPT_CODE, :NEW.LEV);
    --NEW값의 부서/직급에 1을 더함 : UPDATE 후 INSERT
            IF SQL%NOTFOUND THEN
                INS(:NEW.DEPT_CODE, :NEW.LEV);
            END IF;
    END IF;
--2. USE_YN변경
    IF :OLD.USE_YN = 'Y' THEN
        IF :NEW.USE_YN <> 'Y' THEN
            UPD(-1, :OLD.DEPT_CODE, :OLD.LEV);
        -- 'Y' => 다른 값 : OLD의 부서/직급에서 1 차감
        END IF;
    ELSE
        IF :NEW.USE_YN = 'Y' THEN
            UPD(1, :NEW.DEPT_CODE, :NEW.LEV);
            IF SQL%NOTFOUND THEN
                INS(:NEW.DEPT_CODE, :NEW.LEV);
            END IF;
        -- 다른 값 => 'Y' : NEW의 부서/직급에 1을 더함
        END IF;
    END IF;
END;

UPDATE TEMP10
SET USE_YN = 'Y';
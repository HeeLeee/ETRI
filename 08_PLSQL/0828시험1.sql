/*1.
  명시적 커서와 암시적 커서의 속성을 이용하는 익명블록을 작성하고
  실행 결과를 보이시오.*/
DECLARE 
    E1 NUMBER;
    
    CURSOR CUR1 IS
    SELECT EMP_ID 
    FROM TEMP;
BEGIN
    OPEN CUR1;
    LOOP
        FETCH CUR1 INTO E1;
        EXIT WHEN  CUR1%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE(E1);
    END LOOP;
    CLOSE CUR1;
END;
/*2. 
  tcom의 2019년 자료의 comm을 temp salary의 2%로 조정하고자 합니다.
  이때 다른 프로그램이나 세션이 작업 중 또 다른 수정을 할 수 없게 하고자 합니다.
  위의 요구를 만족하는 익명 블록을 작성하시오*/
DECLARE
     W1 NUMBER;
     E1 NUMBER;
     S1 NUMBER;
     C1 NUMBER;
    
    CURSOR CUR IS
    SELECT A.WORK_YEAR, A.EMP_ID, B.SALARY, A.COMM
    FROM TCOM A, TEMP B
    WHERE A.EMP_ID = B.EMP_ID
    AND A.WORK_YEAR = 2019
    FOR UPDATE;
BEGIN
    OPEN CUR;
    LOOP
        FETCH CUR INTO W1, E1, S1, C1;
        EXIT WHEN CUR%NOTFOUND;
        UPDATE TCOM
        SET COMM = E1 * 0.02
        WHERE EMP_ID = E1;
    END LOOP;
    CLOSE CUR;
END;

SELECT * FROM TEMP;
/*3.
  사번을 매개변수로 주면
  해당 사번을 이용해 temp의 해당 row 정보를 읽어 한 건을 
  record형 변수로 리턴하는 함수를 작성하고
  해당 함수를 호출해 출력해주는 익명 블록을 작성하여 실행 결과를 보이시오.*/
CREATE OR REPLACE FUNCTION F1(P1 NUMBER) RETURN TEMP%ROWTYPE IS
    REC TEMP%ROWTYPE;
    
BEGIN
    SELECT *
    INTO REC
    FROM TEMP
    WHERE EMP_ID = P1;
    
    RETURN REC;
END;

DECLARE
    A TEMP%ROWTYPE;
BEGIN
    A := F1(19970101);
    DBMS_OUTPUT.PUT_LINE(A.EMP_ID ||A.EMP_NAME|| A.DEPT_CODE);
END;
/*4. 
  부서별 소속인원 명단을 뽑기위해
  tdept 를 읽는 커서와  temp를 읽는 커서를 선언하고 이를 이용해
  각 부서명과 부서에 속한 사원의 성명을 출력하는 익명 블록을 작성하시오.
  이때 temp를 읽는 커서는 tdept의 부서코드를 매개변수로 받아 해당 부서의 성명을 읽어야 함*/
DECLARE
    CURSOR CUR1 IS
    SELECT *
    FROM TEMP;
    
    CURSOR CUR2 IS
    SELECT *
    FROM TDEPT;
BEGIN
    FOR I IN CUR2 LOOP
        FOR J IN CUR1 LOOP
            IF J.DEPT_CODE = I.DEPT_CODE THEN
                DBMS_OUTPUT.PUT_LINE('부서명 :'||I.DEPT_NAME||'사원명 :'||J.EMP_NAME);
            END IF;
        END LOOP;
    END LOOP;
END;
/*5. 
  숫자 한 개를 매개변수로 주면 
  t1_data에서 최고 값을 찾아 첫번째 매개변수의 숫자 값을 insert한 후
  최종 insert된 값을 출력하는 프로시져 p_t1_in procedure작성하고
  실행 결과를 보이시오.
  이때 매개 변수로 입력된 숫자가 1보다 작거나 자연수가 아닌 경우는 적절한 에러를 정의하고
  정의된 에러를 발생시켜 exception으로 유도해 트랩한 후 
  '자연수가 아니거나 0이므로 작업을 수행할 수 없습니다.' 라는 메세지 뿌리고 종료.
  5번 문제  추가 설명 : (예: 현재 20000 이 최고 값인데 3을 매개변수로 주면 20001,20002,20003 세 개의 
  새로운 NO 값이 생겨야 함) */
CREATE OR REPLACE PROCEDURE P_T1_IN(P1 NUMBER) IS
    MX NUMBER;
    ER EXCEPTION;
BEGIN
    SELECT MAX(NO)
    INTO MX
    FROM T1_DATA;
    
    IF P1<1 OR MOD(P1,1) != P1 THEN
        RAISE ER;
    END IF;
    
    FOR I IN 1..P1 LOOP
        INSERT INTO T1_DATA(NO)
        VALUES (MX+I);
    END LOOP;

EXCEPTION 
    WHEN ER THEN
    DBMS_OUTPUT.PUT_LINE('자연수가 아니거나 0이므로 작업을 수행할 수 없습니다.');
END;

/*6.
  temp의 자료를 사번순으로 커서로 읽어 한 건씩 fetch하며(어는 loop를 사용해도 ok)
  tcom1의 2019년도 자기 사번에 해당하는 comm을 select해서
  temp 커서의 salary/12 값에 더해 당월의 지급 급여로 하는 정보를 출력
  (사원, 지급급여)
  이때 select 한 결과가 없어도 전체 사원의 급여가 모두 출력 되어야 합니다.
  comm select 시에는 그룹함수 사용을 금지하며 이중블록으로 처리해야 합니다.*/
DECLARE
    CURSOR CUR IS
        SELECT * 
        FROM TEMP
        ORDER BY EMP_ID;

    EID NUMBER;
    COM NUMBER;
BEGIN
    FOR I IN CUR LOOP
    BEGIN
            SELECT EMP_ID, COMM
            INTO EID, COM
            FROM TCOM1
            WHERE WORK_YEAR = 2019
            AND I.EMP_ID = EMP_ID;
            IF I.EMP_ID = EID  THEN
                DBMS_OUTPUT.PUT_LINE('사원 :'||I.EMP_ID||'지급급여 :'||ROUND((COM + (I.SALARY/12))));
            ELSE
                DBMS_OUTPUT.PUT_LINE('사원 :'||I.EMP_ID||'지급급여 :'||I.SALARY);
            END IF;
            EXCEPTION
            WHEN no_data_found THEN
                DBMS_OUTPUT.PUT_LINE('에러');  
    END;
    END LOOP;
END;

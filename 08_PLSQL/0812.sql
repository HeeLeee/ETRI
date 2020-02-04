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

CREATE OR REPLACE PROCEDURE CHANGE_BY_EMP(pENAME TEMP.EMP_NAME%TYPE) AS
    vEMP NUMBER;
    vSAL NUMBER;
    vLEV TEMP1.LEV%TYPE;
    vDCD TEMP1.DEPT_CODE%TYPE;
    vDCD1   TEMP1.DEPT_CODE%TYPE;
    vBOSS   NUMBER;
    vTAG    NUMBER :=0;
BEGIN
-- 기능1
    SELECT EMP_ID, SALARY, LEV, DEPT_CODE
    INTO vEMP, vSAL, vLEV, vDCD
    FROM TEMP2
    WHERE EMP_NAME = pENAME;
--TCOM1에 INSERT
/*
WORK_YEAR   NOT NULL    VARCHAR2(4)
EMP_ID      NOT NULL    NUMBER
BONUS_RATE              NUMBER
COMM                    NUMBER
*/
    INSERT INTO TCOM1(WORK_YEAR, EMP_ID, BONUS_RATE, COMM)
    SELECT '2019', vEMP, 1, vSAL*0.1
    FROM TEMP2
    WHERE EMP_NAME = pENAME;
    --
    DBMS_OUTPUT.PUT_LINE('INSERT INTO TCOM1 COMPLETE!');
-- 기능2 EMP_LEVEL1 UPDATE
    --대상이 없는 신규입력건은 UPDATE 후 커서속성 확인
    UPDATE EMP_LEVEL1
    SET FROM_SAL    = LEAST(vSAL, FROM_SAL),
        TO_SAL      = GREATEST(vSAL, TO_SAL)
    WHERE   LEV = vLEV;
--성공 여부 출력
    DBMS_OUTPUT.PUT_LINE('UPDATE EMP_LEVEL1 COMPLETE!');
    -- 커서 속성이 NOT FOUND인 경우는 INSERT 수행
    IF SQL%NOTFOUND THEN
        INSERT INTO EMP_LEVEL1 (LEV, FROM_SAL, TO_SAL)
        VALUES (vLEV, vSAL, vSAL);
        DBMS_OUTPUT.PUT_LINE('INSERT INTO EMP_LEVEL1 COMPLETE!');
    END IF;
    
-- 기능3
    BEGIN
        SELECT A.DEPT_CODE, DECODE(vEMP, A.BOSS_ID, B.BOSS_ID, A.BOSS_ID)
        INTO vDCD1, vBOSS
        FROM TDEPT2 A, TDEPT B
        WHERE A.DEPT_CODE = vDCD
        AND A.PARENT_DEPT = B.DEPT_CODE;
-- 정상
        INSERT INTO TEVAL(YM_EV, EMP_ID, EV_CD, EV_EMP)
        SELECT '201902', vEMP, KNO, vBOSS
        FROM    TCODE
        WHERE   MCD = 'A002';
        DBMS_OUTPUT.PUT_LINE('TEVAL INSERT');
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('보스찾기 실패');
    END;
    COMMIT;
END;    
-- 확인
SELECT * FROM TCOM1;
SELECT * FROM EMP_LEVEL1;
SELECT * FROM TEVAL
WHERE YM_EV = '201902';
BEGIN
    CHANGE_BY_EMP('지문덕');
END;
ROLLBACK;
TRUNCATE TABLE TCOM1;
TRUNCATE TABLE EMP_LEVEL1;
TRUNCATE TABLE TEVAL;

/*과제1. 앞 실습예제를 4개 모듈로 나눕니다.
   - 각 모듈에 필요한 변수는 중첩 모듈에서 별도 정의하고 최상위 블록 
     GLOBAL 변수는 중첩 블록 내부에서 사용하지 않습니다.
     (글로벌 변수를 사용하고 싶으면 반드시 로컬 변수에 할당 후 사용)
   - 모듈1 : MAIN BLOCK => TEMP에서 SELECT => 중첩 블록으로 넣지 않습니다.
   - 모듈2 : TCOM1에 INSERT
   - 모듈3 : EMP_LEVEL1 UPDATE OR INSERT
   - 모듈4 : TEVAL INSERT
   - 2,3번 모듈은 수행 중 에러가 발생하면 외부로 에러를 전달합니다.
   - 4번 모듈은 에러가 발생하면 에러대신 태그 값을 변경하여 변경실패 정보를 전달합니다*/
CREATE OR REPLACE PROCEDURE CHANGE_BY_EMP(P1 TEMP2.EMP_NAME%TYPE) AS
    vEMP TEMP1.EMP_ID%TYPE;
    vSAL TEMP1.SALARY%TYPE;
    vLEV TEMP1.LEV%TYPE;
    vDCD TEMP1.DEPT_CODE%TYPE;
    vDCD1 TDEPT2.DEPT_CODE%TYPE;
    vBOSS TDEPT2.BOSS_ID%TYPE;
    vTAG NUMBER := 0;
BEGIN
    SELECT EMP_ID, SALARY, LEV, DEPT_CODE
    INTO vEMP, vSAL, vLEV, vDCD
    FROM TEMP1
    WHERE EMP_NAME = P1;
    --기능1
    ---TCOM1에 INSERT
    DECLARE
        lEMP NUMBER := vEMP;
        lSAL NUMBER := vSAL;
    BEGIN
        INSERT INTO TCOM1(WORK_YEAR, EMP_ID, BONUS_RATE, COMM)
        VALUES('2019', lEMP, 1, lSAL*0.1);
        DBMS_OUTPUT.PUT_LINE('INSERT INTO TCOM1 COMPLETE!');
    END;
    --기능2
    DECLARE
        lSAL NUMBER := vSAL;
        lLEV TEMP1.LEV%TYPE := vLEV;
    BEGIN
        UPDATE EMP_LEVEL1
        SET FROM_SAL = LEAST(lSAL, FROM_SAL),
            TO_SAL = GREATEST(lSAL, TO_SAL)
        WHERE LEV = lLEV;
        DBMS_OUTPUT.PUT_LINE('UPDATE EMP_LEVEL1 COMPLETE!');
        IF SQL%NOTFOUND THEN
            INSERT INTO EMP_LEVEL1(LEV, FROM_SAL, TO_SAL)
            VALUES(lLEV, lSAL, lSAL);
            DBMS_OUTPUT.PUT_LINE('INSERT INTO EMP_LEVEL1 COMPLETE!');
        END IF;
    END;
    --기능3
    DECLARE
        lEMP TEMP1.EMP_ID%TYPE :=vEMP;
        lDCD1 TDEPT2.DEPT_CODE%TYPE := vDCD1;
        lBOSS TDEPT2.BOSS_ID%TYPE := vBOSS;
        lDCD TEMP1.DEPT_CODE%TYPE := vDCD;
    BEGIN
        SELECT A.DEPT_CODE, DECODE(lEMP, A.BOSS_ID, B.BOSS_ID, A.BOSS_ID) BOSS
        INTO lDCD1, lBOSS
        FROM TDEPT A, TDEPT B
        WHERE A.DEPT_CODE = lDCD
        AND A.PARENT_DEPT = B.DEPT_CODE;
        INSERT INTO TEVAL(YM_EV, EMP_ID, EV_CD, EV_EMP)
        SELECT '201902', lEMP, KNO, lBOSS
        FROM TCODE
        WHERE MCD = 'A002';
        DBMS_OUTPUT.PUT_LINE('TEVAL INSERT');
    EXCEPTION
        WHEN NO_DATA_FOUND THEN 
        DBMS_OUTPUT.PUT_LINE('보스 찾기 실패');
    END;
    EXCEPTION 
        WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('---외부 블럭으로 에러 전달---'); 
        RAISE;
    COMMIT;
END;
/*2. TCOM1에 INSERT 하는 모듈은 CHANGE_BY_EMP 내부에서만 사용될 것으로 판단되고
   EMP_LEVEL1 과 TEVAL의 DATA 변경 모듈은 타 프로그램에서도 자주 호출될 것으로
   판단됩니다.
   따라서 1번 기능은 서브 프로그램으로 정의할 예정이며,
   2,3번 기능은 별도의 프로시져로 정의하여 CHANGE_BY_EMP에서 호출할 예정입니다.
   위의 조건을 만족할 수 있도록 프로그램을 나누어 정의 하고 
   지금의 기능이 똑같이 작동되도록 수정합니다.*/
DECLARE
    vEMP TEMP2.EMP_ID%TYPE;
    vSAL TEMP2.SALARY%TYPE;
    ENAME TEMP2.EMP_NAME%TYPE := &NAME;
    
    PROCEDURE SUB(P1 TEMP2.EMP_NAME%TYPE) IS
    BEGIN
    INSERT INTO TCOM1(WORK_YEAR, EMP_ID, BONUS_RATE, COMM)
    VALUES('2019', vEMP, 1, vSAL*0.1);
    DBMS_OUTPUT.PUT_LINE('INSERT INTO TCOM1 COMPLETE!');
    END SUB;
BEGIN
    SELECT EMP_ID, SALARY
    INTO vEMP, vSAL
    FROM TEMP2
    WHERE EMP_NAME = ENAME;
    SUB(ENAME);
    CHANGE_BY_EMP1(ENAME);
END;

CREATE OR REPLACE PROCEDURE CHANGE_BY_EMP(P1 TEMP2.EMP_NAME%TYPE) AS
BEGIN
    CHANGE_BY_EMP2(P1);
    CHANGE_BY_EMP3(P1);
END;
EXECUTE CHANGE_BY_EMP('김단비');
--기능2
CREATE OR REPLACE PROCEDURE CHANGE_BY_EMP2(P1 TEMP2.EMP_NAME%TYPE) AS
    vSAL TEMP2.SALARY%TYPE;
    vLEV TEMP2.LEV%TYPE;
BEGIN
    SELECT SALARY, LEV
    INTO vSAL, vLEV
    FROM TEMP2
    WHERE EMP_NAME = P1;
    
    UPDATE EMP_LEVEL1
    SET FROM_SAL = LEAST(vSAL, FROM_SAL),
        TO_SAL = GREATEST(vSAL, TO_SAL)
    WHERE LEV = vLEV;
    DBMS_OUTPUT.PUT_LINE('UPDATE EMP_LEVEL1 COMPLETE!');
    IF SQL%NOTFOUND THEN
        INSERT INTO EMP_LEVEL1(LEV, FROM_SAL, TO_SAL)
        VALUES(vLEV, vSAL, vSAL);
        DBMS_OUTPUT.PUT_LINE('INSERT INTO EMP_LEVEL1 COMPLETE!');
    END IF;
END;

CREATE OR REPLACE PROCEDURE CHANGE_BY_EMP3(P1 TEMP2.EMP_NAME%TYPE) AS
    vEMP TEMP2.EMP_ID%TYPE;
    vDCD1 TDEPT2.DEPT_CODE%TYPE;
    vBOSS TDEPT2.BOSS_ID%TYPE;
    vDCD TEMP2.DEPT_CODE%TYPE;
BEGIN
    SELECT EMP_ID, DEPT_CODE
    INTO vEMP, vDCD
    FROM TEMP2
    WHERE EMP_NAME = P1;
    
    SELECT A.DEPT_CODE, DECODE(vEMP, A.BOSS_ID, B.BOSS_ID, A.BOSS_ID) BOSS
    INTO vDCD1, vBOSS
    FROM TDEPT A, TDEPT B
    WHERE A.DEPT_CODE = vDCD
    AND A.PARENT_DEPT = B.DEPT_CODE;
    INSERT INTO TEVAL(YM_EV, EMP_ID, EV_CD, EV_EMP)
    SELECT '201902', vEMP, KNO, vBOSS
    FROM TCODE
    WHERE MCD = 'A002';
    DBMS_OUTPUT.PUT_LINE('TEVAL INSERT');
EXCEPTION
    WHEN NO_DATA_FOUND THEN 
    DBMS_OUTPUT.PUT_LINE('보스 찾기 실패');
    COMMIT;
END;
--보너스
--1. 인사팀에서 다음과 같은 요청을 했습니다.
--  3개월의 해외 봉사활동을 위해 직원 1명을 파견해야 합니다.
--  직원들의 동의를 얻어 다음과 같은 조건으로 선발하기로 했습니다.
--  나이가 어릭수록, 연봉이 적을수록, 직급이 높을수록(부장,차장,과장,대리,사원만) 적합하며
--  정규직 만을 대상으로 선발합니다.
--  어느 조건에 가중치를 등수 없어 나이, 연봉, 직급 각항목에 순위를 매겨 순위 합이 가장 낮은
--  5명을 선발하기로 했으며, 이 5명을 대상으로 랜덤 뽑기로 한 명을 선발 할 예정입니다.
-- VALUE는 동일 순위이며 예를 들어 두명이 동일 순위 1위는 다음 순위는 3위입니다.
-- 해당 프로그램 작성해 선발자 사번, 성명, 총 점수, 나이, 급여, 직급, 선발순위를 출력하세요
--  1에서 5까지 랜덤값 생성은 다음 함수를 이용: DBMS_RANDOM.
SELECT *
FROM(
    SELECT EMP_ID, EMP_NAME, SUM_RK,
            AGE, SALARY, LEV,
            RANK() OVER (ORDER BY SUM_RK) AS RK
    FROM
        (SELECT EMP_ID, EMP_NAME,
                FLOOR((SYSDATE - BIRTH_DATE)/365)-1 AGE,
                RANK() OVER (ORDER BY FLOOR((SYSDATE - BIRTH_DATE)/365) -1) AS AGE_RK,
                SALARY,
                RANK() OVER (ORDER BY SALARY) AS SAL_RK,
                LEV,
                RANK() OVER (ORDER BY DECODE(LEV,'부장',1,'차장',2,'과장',3,'대리',4,'사원',5)) AS LEV_RK,
                (RANK() OVER (ORDER BY FLOOR((SYSDATE - BIRTH_DATE)/365) -1)+
                RANK() OVER (ORDER BY SALARY)+
                RANK() OVER (ORDER BY DECODE(LEV,'부장',1,'차장',2,'과장',3,'대리',4,'사원',5))) AS SUM_RK    
        FROM TEMP
        WHERE LEV IN ('부장','차장','과장','대리','사원')
        ORDER BY SUM_RK)
    WHERE ROWNUM <=5
    ORDER BY CEIL(DBMS_RANDOM.VALUE(0,5)))
WHERE ROWNUM = 1;


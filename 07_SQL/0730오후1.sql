--8. 부서별로 부서원을 나열하고 모금금액을 알아내기위해 부서코드,부서명,사번,성명, 모금금액을 구하는 쿼리를 작성하고자합니다.
--   각 부서별로 10만원을 모금하기 위해 개인이 부담해야하는 금액이 모금금액입니다.
--   (예 : 부서원이 5명이면 각 2만원씩 4명이면 2만5천원씩 모금금액이 정해집니다)  (소숫점 아래는 올림처리)
SELECT B.DEPT_CODE, A.DEPT_NAME, EMP_ID, EMP_NAME, B.CO 
FROM TDEPT A,
    (
    SELECT DEPT_CODE, CEIL(100000/COUNT(*)) CO
    FROM TEMP 
    GROUP BY DEPT_CODE) B,
    TEMP C
WHERE A.DEPT_CODE = B.DEPT_CODE
AND A.DEPT_CODE = C.DEPT_CODE;

--9. TEMP에서 LEV가 '수습'인 직원 정보의 사번,성명, 급여, 취미, 부서코드, 전화번호를 보여주는 VIEW를 만들어 
--   STUDY04 유저에게 제공할 예정입니다.
--   이때 사번,성명, 급여는 READ ONLY로 UPDATE를 허용하지 않을 예정이며 HOBBY, DEPT_CODE, TEL
--   세 컬럼은 업데이트를 허용할 예정입니다.
--   VIEW만을 이용해 위 조건을 만족 시키려 할 때 필요한 VIEW들 만들기.
CREATE OR REPLACE VIEW VIEW9
AS
SELECT EMP_ID, EMP_NAME, SALARY
FROM TEMP
WHERE LEV = '수습'
WITH READ ONLY;

CREATE OR REPLACE VIEW VIEW10
AS
SELECT EMP_ID,  HOBBY, DEPT_CODE ,TEL
FROM TEMP
WHERE LEV = '수습';

CREATE OR REPLACE VIEW VIEW11
AS
SELECT A.EMP_ID, A.EMP_NAME, A.SALARY, B.HOBBY, B.DEPT_CODE, B.TEL
FROM VIEW9 A, VIEW10 B
WHERE A.EMP_ID = B.EMP_ID;
--10. TEMP의 컬럼들에 적절한 COMMENT를 붙이는 문장과 COMMENT를 붙인 결과를 DICTIONARY에서 조회하는 문장을 작성
COMMENT ON COLUMN TEMP.EMP_ID IS '사원 아이디';
COMMENT ON COLUMN TEMP.EMP_NAME IS '사원 이름';
SELECT *
FROM ALL_COL_COMMENTS
WHERE TABLE_NAME = 'TEMP';
--11. SEQ10  이라는 시퀀스를 생성하되 1에서 시작해 증분은 1씩 최대 1000까지 증가하다 다시 1로 순환 채번 되도록 생성하며 
--    메모리에 CACHE 하지 않게 합니다.
CREATE SEQUENCE SEQ10
        INCREMENT BY 1
        START WITH 1
        MAXVALUE 1000
        NOCACHE
        CYCLE;
--12. SPEC, ITEM, QTY 를 컬럼으로 가지는 BOM 테이블이 있습니다.
--    T1_DATA를 이용해 BOM에 우측과 같은 데이터를 자동으로 입력하고자 합니다. 
--    (QTY 는  CEIL(DBMS_RANDOM.VALUE(0,3)) 을 이용해 랜덤값을 넣었습니다)
--    해당 쿼리를 작성하세요  
SELECT 'S'||A.NO SPEC, 
        'I0'||B.NO ITEM,
        CEIL(DBMS_RANDOM.VALUE(0,3))
FROM T1_DATA A, T1_DATA B
WHERE A.NO <6 AND B.NO<6;
--13. 테이블명, 시노님, 퍼블릭시노님 간의 명칭 경합이 벌어질 때 먼저 사용되는 순서로 
--  기술하고 직접 확인 할 수 있도록 구현 하시오.
--답
--테이블명 > 시노님 > 퍼블릭시노님
CREATE SYNONYM TEMP1
FOR TDEPT;
CREATE PUBLIC SYNONYM TEMP1
FOR TEVAL;
SELECT * FROM TEMP1;
--시노님 > 퍼블릭시노님
CREATE SYNONYM TEMP200
FOR TDEPT;
CREATE PUBLIC SYNONYM TEMP200
FOR TEVAL;
SELECT * FROM TEMP200;
--14. DAED LOCK 발생하는 경우를 한 가지 예를 들어 설명하고 구현합니다.
--한곳에서 수정중인 테이블(COMMIT하지 않음)을 다른 곳에서 수정하려할때 트랜잭션이 종료되지 않아 DAED LOCK이 발생
UPDATE TEMP1
SET EMP_NAME = '이희과앙'
WHERE EMP_NAME = '이희광';
--ADMIN(DBA권한)
UPDATE TEMP1
SET EMP_NAME = '이희과앙'
WHERE EMP_NAME = '이희광'; --이때 DAED LOCK이 발생
--15. 소속된 부서의 평균 봉급보다 많은 봉급을 받는 직원의 이름, 급여, 부서코드 
SELECT A.EMP_NAME, A.SALARY, A.DEPT_CODE
FROM TEMP A,
    (SELECT DEPT_CODE, AVG(SALARY) AVG_SAL
    FROM TEMP
    GROUP BY DEPT_CODE) B
WHERE A.DEPT_CODE = B.DEPT_CODE
AND A.SALARY>B.AVG_SAL;

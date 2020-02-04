--1. TDEPT의 부서코드와 상위부서코드 정보를 이용해 CEO001에서 시작해 TOP-DOWN 방식의 계층 검색을 수행하되
--   결과가 부서명으로 정렬되도록 쿼리 구성
SELECT LPAD(DEPT_CODE, LENGTH(DEPT_CODE) + (LEVEL)-1, '*'), DEPT_NAME
FROM TDEPT
START WITH DEPT_CODE = 'CEO001'
CONNECT BY PRIOR DEPT_CODE = PARENT_DEPT;
--2. TEMP1의 전화번호 15자리에서 스페이스(‘ ‘)와 대시바(‘-’)를 제거하고 우측정렬 시켜 
--앞의 빈자리를 모두 별문자(‘*’) 로 채우는 ONE 업데이트 문장 작성 및 실행 후 
--COMMIT (NULL인 자료도 모두 별문자(‘*’) 로 채워져야 함) 
UPDATE TEMP1 A
SET A.TEL =
            (SELECT LPAD( NVL(REPLACE(REPLACE(TEL,'-',''),' ',''),'*'),15,'*' )
            FROM TEMP1 
            WHERE A.EMP_ID = EMP_ID);

SELECT EMP_ID, TEL FROM TEMP1;
--3. TEMP 에서 취미가 독서나 여행이 아닌 직원(입력 안된 직원 포함) 수 세는 QUERY 54-7 = 47
SELECT COUNT(*)
FROM TEMP
WHERE (HOBBY != '독서' AND HOBBY != '여행')
OR HOBBY IS NULL;
--4. 
--   4.1 TEMP의 EMP_ID 컬럼을 제외한 모든 컬럼에 걸린 인덱스를 조회하는 쿼리 작성
SELECT INDEX_NAME, TABLE_NAME, COLUMN_NAME
FROM USER_IND_COLUMNS A
WHERE A.TABLE_NAME = 'TEMP'
AND COLUMN_NAME != 'EMP_ID';
--   4.2 위의 쿼리 결과를 참고하여 EMP_ID를 제외한 컬럼에 걸린 모든 인덱스를 DROP 하는 문장을 결과로 반환하는 쿼리작성
SELECT 'DROP INDEX ' || C.INDEX_NAME ||';'
FROM   USER_INDEXES I, USER_IND_COLUMNS C
WHERE   C.INDEX_NAME = I.INDEX_NAME
AND      C.TABLE_NAME = 'TEMP'
AND      C.COLUMN_NAME <> 'EMP_ID';  
--   4.3 4.2의 결과를 실행 시켜 관련 인덱스를 DROP;
DROP INDEX UK_EMP_NAME;
DROP INDEX TEMP_SAL_IDX;
--   4.4 SALARY 컬럼에 SALARY1 이라는 이름의 INDEX 만들고 생성된 인덱스의 테이블과 컬럼 확인하는 쿼리 작성
CREATE INDEX SALARY1
ON TEMP(SALARY);

SELECT INDEX_NAME, TABLE_NAME, COLUMN_NAME
FROM USER_IND_COLUMNS
WHERE TABLE_NAME = 'TEMP'
AND COLUMN_NAME = 'SALARY';
--   4.5 생성된 인덱스를 이용하여 SALARY 내림차순으로 사번과 검색 쿼리 작성
SELECT /*+INDEX(TEMP, SALARY1)*/EMP_NAME, SALARY
FROM TEMP
ORDER BY SALARY;
--5. TEMP에서 박문수보다 급여를 적게받는 직원 검색하여 사번,성명,급여,박문수급여 
--    함께 보여주기(단, ANALYTIC  FUNCTION 사용 금지)
SELECT A.EMP_ID, A.EMP_NAME, A.SALARY, B.SALARY
FROM TEMP A, (SELECT SALARY FROM TEMP WHERE EMP_NAME = '박문수') B
WHERE A.SALARY < B.SALARY;
--6. TEMP 와 EMP_LEVEL 을 이용해 EMP_LEVEL의 과장 직급의 연봉 상한/하한 범위 내에 
-- 드는 모든 직원의 사번,성명,직급,SALARY, 연봉 하한,연봉 상한 읽어 오기
SELECT * FROM EMP_LEVEL;

SELECT A.EMP_ID, A.EMP_NAME, A.LEV, A.SALARY, B.FROM_SAL, B.TO_SAL 
FROM TEMP A, EMP_LEVEL B, 
        (SELECT FROM_SAL, TO_SAL, LEV FROM EMP_LEVEL WHERE LEV = '과장') C
WHERE A.LEV = B.LEV(+)
AND A.SALARY BETWEEN C.FROM_SAL AND C.TO_SAL;
--7. 16번에서 125번 까지 번호에 해당되는 ASCII 코드 값의 문자들을 1줄에 5개씩 컴마(,) 구분자로 보여주기
SELECT LISTAGG(BB, ',') within group (order by AA)
FROM(
SELECT A.NO AA, CHR(B.NO) BB
FROM T1_DATA A, T1_DATA B 
WHERE A.NO = B.NO AND B.NO BETWEEN 16 AND 125)
GROUP BY  CEIL(AA/5);

--2번째방법
select 
max(decode(g, 0, c))||','|| 
max(decode(g, 1, c))||','||  
max(decode(g, 2, c))||','||  
max(decode(g, 3, c))||','||  
max(decode(g, 4, c)) 
from
(
    select no, chr(no) c, mod(rownum - 1, 5) as g, ceil(rownum / 5) as gr
    from t1_data 
    where no between 16 and 125
)
group by gr;
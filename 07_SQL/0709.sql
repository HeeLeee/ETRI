--과장 직급을 가질만한 나이에 포함되는 사람이 누군지 현재 직급에 관계없이 읽어오기(사번,성명,나이,현재직급 만 보여 주세요)
SELECT T.EMP_ID, T.EMP_NAME, 
        (SYSDATE-T.BIRTH_DATE)/365 AGE, 
        T.LEV
FROM TEMP T, EMP_LEVEL L
WHERE T.BIRTH_DATE BETWEEN ADD_MONTHS(SYSDATE,-1*L.TO_AGE*12) 
AND ADD_MONTHS(SYSDATE,-1*L.FROM_AGE*12)
AND L.LEV = '과장';
--
UPDATE TDEPT
    SET BOSS_ID = DECODE(DEPT_CODE, 'AA0001', 19970101, 'BA0001', 19930331)
    WHERE DEPT_CODE IN ('AA0001', 'BA0001');
--
SELECT B.EMP_ID, A.NO||'월' MONTH, DECODE(MOD(A.NO,2),1,B.SAL01,B.SAL02) SALARY
FROM T1_DATA A, T2_DATA B
WHERE A.NO <= 12
ORDER BY 1, A.NO;

SELECT EMP_ID, 
        NO||'월' MONTH, 
        DECODE(NO,1,SAL01,
                    2,SAL02,
                    3,SAL03,
                    4,SAL04,
                    5,SAL05,
                    6,SAL06,
                    7,SAL07,
                    8,SAL08,
                    9,SAL09,
                    10,SAL10,
                    11,SAL11,
                    12,SAL12
                ) SALARY
FROM T1_DATA , T2_DATA 
WHERE NO <= 12
ORDER BY 1, NO;
--서브쿼리 사용예
SELECT LAST_NAME
FROM EMPLOYEES
WHERE SALARY > (SELECT SALARY
                FROM EMPLOYEES
                WHERE LAST_NAME = 'Kochhar');
--비교연산자와 쓸때는 단일행 서브쿼리를 사용해야한다
SELECT LAST_NAME, DEPARTMENT_ID, SALARY
FROM EMPLOYEES
WHERE DEPARTMENT_ID = (SELECT DEPARTMENT_ID
                        FROM EMPLOYEES
                        WHERE EMPLOYEE_ID = 101)
AND SALARY > (SELECT SALARY
                FROM EMPLOYEES
                WHERE EMPLOYEE_ID = 141);
--
SELECT LAST_NAME, SALARY
FROM EMPLOYEES
WHERE SALARY = (SELECT MAX(SALARY)
                FROM EMPLOYEES);
--
SELECT DEPARTMENT_ID, MIN(SALARY)
FROM EMPLOYEES
GROUP BY DEPARTMENT_ID
HAVING MIN(SALARY) > (SELECT MIN(SALARY)
                        FROM EMPLOYEES
                        WHERE DEPARTMENT_ID = 60);
--IN 같다
SELECT LAST_NAME, SALARY
FROM EMPLOYEES
WHERE SALARY IN (SELECT MAX(SALARY)
                FROM EMPLOYEES
                GROUP BY DEPARTMENT_ID);
--ANY--<ANY 최대값보다 작다 >ANY최소값보다크다
SELECT LAST_NAME, JOB_ID,SALARY
FROM EMPLOYEES
WHERE SALARY < ANY (SELECT SALARY
                    FROM EMPLOYEES
                    WHERE JOB_ID='IT_PROG')
AND JOB_ID <> 'IT_PROG';
--서브쿼리 결과값아 NULL인 경우
SELECT FIRST_NAME, DEPARTMENT_ID
FROM EMPLOYEES
WHERE DEPARTMENT_ID = (SELECT DEPARTMENT_ID
                        FROM EMPLOYEES
                        WHERE FIRST_NAME = 'Kimberely');
--치환변수 &
SELECT LAST_NAME, SALARY
FROM EMPLOYEES
WHERE SALARY = &SAL;

SELECT LAST_NAME, SALARY
FROM EMPLOYEES
WHERE SALARY = '&NAME';

SELECT LAST_NAME, SALARY, &COL
FROM EMPLOYEES
WHERE &CONDITION
ORDER BY &ORDER;
--&&
SELECT LAST_NAME, SALARY, &&COL
FROM EMPLOYEES
ORDER BY &COL;
--DEFINE
DEFINE V_EMPID = 200
SELECT LAST_NAME, SALARY
FROM EMPLOYEES
WHERE EMPLOYEE_ID = &V_EMPID;

--1. SALARY 가 강감찬보다 많은 직원의 이름,SALARY 가져오기
SELECT EMP_NAME, SALARY
FROM TEMP
WHERE SALARY > (SELECT SALARY
                FROM TEMP
                WHERE EMP_NAME = '강감찬');
--2. 부서가 김길동과 같고 SALARY가 강감찬보다 많은 사번,성명,부서코드,SALARY 가져오기
SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY
FROM TEMP
WHERE DEPT_CODE = (SELECT DEPT_CODE
                FROM TEMP
                WHERE EMP_NAME = '김길동')
AND SALARY > (SELECT SALARY
                FROM TEMP
                WHERE EMP_NAME = '강감찬');
--3. 가장 월급을 많이 받는 사람의 이름, SALARY 검색 (서브쿼리)
SELECT EMP_NAME, SALARY
FROM TEMP 
WHERE SALARY  >=ALL (SELECT SALARY
                    FROM TEMP);
--4. 부서별 최저월급을 출력하되 BC0001부서의 최저월급보다는 큰 값만 가져오기
SELECT DEPT_CODE, MIN(SALARY)
FROM TEMP
GROUP BY DEPT_CODE
HAVING MIN(SALARY) > (SELECT MIN(SALARY)
                FROM TEMP
                WHERE DEPT_CODE = 'BC0001')
ORDER BY 1;
--5. 각 부서 최저 SALARY와 SALARY가 같은 직원 정보 검색
SELECT *
FROM TEMP
WHERE SALARY IN (SELECT MIN(SALARY)
                FROM TEMP
                GROUP BY DEPT_CODE);
--6. 직급이 차장인 사람들 중 누구든 어느 한 사람보다는 급여를 많이 받는 사원 정보 가져오기 
SELECT *
FROM TEMP
WHERE SALARY >ANY (SELECT SALARY
                    FROM TEMP
                    WHERE LEV = '차장');

--7. 직급이 사원인 어느 누구보다 급여를 많이 받는 사원 정보 가져오기 
SELECT *
FROM TEMP
WHERE SALARY >ALL (SELECT SALARY
                    FROM TEMP
                    WHERE LEV = '사원');
--8. 19950303 직원의 취미와 취미가 같은 사원 정보 가져오기
SELECT *
FROM TEMP
WHERE NVL(HOBBY,0) = (SELECT NVL(HOBBY,0)
                    FROM TEMP
                    WHERE EMP_ID = '19950303');
--9. &SAL 이라는 치환변수를 입력받아 변수값과 SALARY가 같은 사원 검색 쿼리 작성 후 
--   (변수 값에 50000000, ‘50000000’, ‘5천만원’ 을 넣어 각각 실행해보기 
SELECT *
FROM TEMP
WHERE SALARY = &SAL;
--10. 9번 치환변수를 앞뒤로 작은 따옴표 붙여 재실행
--   (변수 값에 50000000, ‘50000000’ 을 넣어 각각 재실행)
SELECT *
FROM TEMP
WHERE SALARY = '&SAL';
--11. HOBBY를 &HOBBY를 통해 입력받아  HOBBY와 입력값이 같은 정보 검색 쿼리 작성 후
--   (변수 값에 등산, ‘등산’ 을 넣어 각각 재실행)
SELECT *
FROM TEMP
WHERE HOBBY = &HOBBY;
--12. 11번 치환변수를 앞뒤로 작은 따옴표 붙여 재실행
--   (변수 값에 등산, ‘등산’ 을 넣어 각각 재실행)
SELECT *
FROM TEMP
WHERE HOBBY = '&HOBBY';
--13. 자기 직급의 평균 연봉보다 급여가 적은 직원정보 가져오기 
SELECT A.EMP_NAME, A.SALARY, A.LEV
FROM TEMP A
WHERE SALARY < (SELECT AVG(SALARY)
                    FROM TEMP B
                    WHERE B.LEV = A.LEV);
--14. 인천에 근무하는 직원 가져오기 (서브쿼리 이용) 
SELECT *
FROM  TEMP
WHERE DEPT_CODE IN (SELECT DEPT_CODE
                    FROM TDEPT
                    WHERE AREA = '인천');
--보너스
--1.TCOM에 연봉 외에 COMMISSION을 받는 직원의 사번이 보관되어 있다.
--  이 정보를 SUB QUERY SELECT 하여 부서 명칭별로 COMMISIOIN을 받는 인원수를 세는 문장 만들기
--1번 4개만 나오게
SELECT B.DEPT_NAME, COUNT(*)
FROM TEMP A, TDEPT B
WHERE A.DEPT_CODE = B.DEPT_CODE 
AND EMP_ID IN (SELECT EMP_ID
                 FROM TCOM 
                 WHERE WORK_YEAR = '2019')
GROUP BY B.DEPT_NAME;
--2번 다나오게
SELECT B.DEPT_NAME, COUNT(A.EMP_ID)
FROM
    (SELECT B.DEPT_CODE, EMP_ID
    FROM TEMP A, TDEPT B
    WHERE A.DEPT_CODE = B.DEPT_CODE 
    AND EMP_ID IN (SELECT EMP_ID
                     FROM TCOM 
                     WHERE WORK_YEAR = '2019')) A,
    TDEPT B
WHERE B.DEPT_CODE = A.DEPT_CODE(+)
GROUP BY B.DEPT_NAME;
--2.치환변수로 숫자를 한 번만 입력받아 입력값, 입력값 +1, 입력값 * 10을 구하는 쿼리
SELECT &&VAR, &VAR*10, &VAR+10
FROM DUAL;
--3. 입력되는 PARAMETER 값에 따라 GROUP BY를 하고 싶은 경우 QUERY작성
--조건1: 입력되는 GROUPING 단위는 두 개 까지 가능함(예 취미별 부서명별)
--     하나만 들어올 수 있음(예. 직급별)
--조건 2: 집계 자료는 그룹별 SALARY 평균, 해당인원수, 그룹별 SALARY 총합
--조건 3: 입력 가능한 GROUP 단위는 다음과 같음
--
SELECT &IN, AVG(A.SALARY), SUM(A.SALARY), COUNT(A.&IN)
FROM TEMP A, TDEPT B
WHERE A.DEPT_CODE = B.DEPT_CODE AND &IN = A.LEV OR &IN = B.DEPT_CODE OR &IN = B.DEPT_NAME OR &IN = A.HOBBY
GROUP BY &IN;
--
SELECT DECODE(&IN1,'부서코드', A.DEPT_CODE,
                   '부서명', B.DEPT_NAME,
                   '취미', A.HOBBY,
                   '직급', A.LEV,
                   '채용형태', A.EMP_TYPE) GR1,
       DECODE(&IN2,'부서코드', A.DEPT_CODE,
                   '부서명', B.DEPT_NAME,
                   '취미', A.HOBBY,
                   '직급', A.LEV,
                   '채용형태', A.EMP_TYPE) GR2,        
       AVG(SALARY) 평균,
       COUNT(EMP_ID) 해당인원수,
       SUM(SALARY) 합
FROM   TEMP A, TDEPT B
WHERE  A.DEPT_CODE = B.DEPT_CODE
GROUP BY DECODE(&IN1, '부서코드', A.DEPT_CODE,
                      '부서명', B.DEPT_NAME,
                      '취미', A.HOBBY,
                      '직급', A.LEV,
                      '채용형태', A.EMP_TYPE),
         DECODE(&IN2, '부서코드', A.DEPT_CODE,
                      '부서명', B.DEPT_NAME,
                      '취미', A.HOBBY,
                      '직급', A.LEV,
                      '채용형태', A.EMP_TYPE);
SELECT * FROM TEMP
WHERE HOBBY = '낚시';
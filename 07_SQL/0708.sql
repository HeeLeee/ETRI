SELECT EMP_ID, EMP_NAME, DEPT_CODE
FROM TEMP
WHERE EMP_ID = 19970101;

SELECT DEPT_CODE, DEPT_NAME
FROM TDEPT
ORDER BY 1;
--NON-EQUIJOIN
SELECT TEMP.EMP_ID, TEMP.EMP_NAME, TEMP.DEPT_CODE,
        TDEPT.DEPT_CODE, TDEPT.DEPT_NAME
FROM TEMP, TDEPT
WHERE EMP_ID = 19970101    
AND TEMP.DEPT_CODE < TDEPT.DEPT_CODE;
--OUTERJOIN
SELECT TEMP.EMP_ID, TDEPT.BOSS_ID
FROM TEMP, TDEPT
WHERE TEMP.EMP_ID = TDEPT.BOSS_ID(+)
ORDER BY 1;
--SELFJOIN
SELECT A.EMP_ID, A.EMP_NAME, B.EMP_ID, B.EMP_NAME
FROM TEMP A, TEMP B
WHERE A.EMP_ID = B.EMP_ID;
--EQUIJOIN
SELECT EMPLOYEES.EMPLOYEE_ID,EMPLOYEES.LAST_NAME, EMPLOYEES.DEPARTMENT_ID,
        DEPARTMENTS.DEPARTMENT_ID, DEPARTMENTS.DEPARTMENT_NAME
FROM EMPLOYEES, DEPARTMENTS
WHERE EMPLOYEES.DEPARTMENT_ID = DEPARTMENTS.DEPARTMENT_ID;
--EQUIJOIN 3���̻��� ���̺� ����
SELECT E.EMPLOYEE_ID, E.LAST_NAME, E.DEPARTMENT_ID,
       D.DEPARTMENT_ID, D.DEPARTMENT_NAME, L.LOCATION_ID
FROM   EMPLOYEES E, DEPARTMENTS D, LOCATIONS L
WHERE  E.DEPARTMENT_ID = D.DEPARTMENT_ID
AND    D.LOCATION_ID = L.LOCATION_ID;
--EQUIJOIN�� AND�� �߰�
SELECT E.EMPLOYEE_ID, E.LAST_NAME, E.DEPARTMENT_ID,
       D.DEPARTMENT_ID, D.DEPARTMENT_NAME
FROM   EMPLOYEES E, DEPARTMENTS D
WHERE  E.DEPARTMENT_ID = D.DEPARTMENT_ID
AND    LAST_NAME = 'King';
--NON-EQUIJOIN
SELECT E.LAST_NAME, E.SALARY, J.GRADE_LEVEL
FROM EMPLOYEES E, JOB_GRADES J
WHERE E.SALARY BETWEEN J.LOWEST_SAL AND J.HIGHEST_SAL;
--OUTERJOIN
SELECT E.EMPLOYEE_ID, E.LAST_NAME, E.DEPARTMENT_ID,
       D.DEPARTMENT_ID, D.DEPARTMENT_NAME
FROM   EMPLOYEES E, DEPARTMENTS D
WHERE  E.DEPARTMENT_ID = D.DEPARTMENT_ID(+);
--��� ������ � �μ��� �ٹ��ϴ� �� �˻��ϵ� ������ �������� ���� �μ��� ���
SELECT E.EMPLOYEE_ID, E.LAST_NAME, E.DEPARTMENT_ID,
       D.DEPARTMENT_ID, D.DEPARTMENT_NAME
FROM   EMPLOYEES E, DEPARTMENTS D
WHERE  E.DEPARTMENT_ID(+) = D.DEPARTMENT_ID;
--SELFJOIN
SELECT E.LAST_NAME,M.LAST_NAME
FROM EMPLOYEES E, EMPLOYEES M
WHERE E.MANAGER_ID = M.MANAGER_ID;
--CROSSJOIN �� ���̺��� ���� ������ ����
SELECT LAST_NAME, DEPARTMENT_NAME
FROM EMPLOYEES
CROSS JOIN DEPARTMENTS;

SELECT COUNT(*)
FROM EMPLOYEES
CROSS JOIN DEPARTMENTS;
--NATURAL JOIN
SELECT LAST_NAME, DEPARTMENT_NAME
FROM EMPLOYEES
NATURAL JOIN DEPARTMENTS;
--USING
SELECT LAST_NAME, DEPARTMENT_NAME
FROM EMPLOYEES JOIN DEPARTMENTS
USING (DEPARTMENT_ID);
--ON�� ���
SELECT E.LAST_NAME, D.DEPARTMENT_NAME
FROM EMPLOYEES E JOIN DEPARTMENTS D
ON (E.DEPARTMENT_ID = D.DEPARTMENT_ID);

SELECT EMPLOYEE_ID, DEPARTMENT_NAME, CITY
FROM EMPLOYEES E
JOIN DEPARTMENTS D
ON (E.DEPARTMENT_ID = D.DEPARTMENT_ID)
JOIN LOCATIONS I
ON (D.LOCATION_ID = I.LOCATION_ID);

SELECT E.LAST_NAME, E.DEPARTMENT_ID, D.DEPARTMENT_NAME
FROM EMPLOYEES E
LEFT OUTER JOIN DEPARTMENTS D
ON (E.DEPARTMENT_ID = D.DEPARTMENT_ID);

SELECT E.LAST_NAME, E.DEPARTMENT_ID, D.DEPARTMENT_NAME
FROM EMPLOYEES E
LEFT OUTER JOIN DEPARTMENTS D
ON (E.DEPARTMENT_ID = D.DEPARTMENT_ID);

SELECT E.LAST_NAME, E.DEPARTMENT_ID, D.DEPARTMENT_NAME
FROM EMPLOYEES E, DEPARTMENTS D
WHERE E.DEPARTMENT_ID(+) = D.DEPARTMENT_ID;
--������ ����Ƴ� ����Ŭǥ�����δ� �Ұ�
SELECT E.LAST_NAME, E.DEPARTMENT_ID, D.DEPARTMENT_NAME
FROM EMPLOYEES E
FULL OUTER JOIN DEPARTMENTS D
ON (E.DEPARTMENT_ID = D.DEPARTMENT_ID);

--�ǽ� 10000��¥�� �׽�Ʈ ������ �����
SELECT * FROM TEMP;
SELECT * FROM USER_TABLES;
SELECT * FROM TEST17;

CREATE TABLE T1_DATA
AS
SELECT ROWNUM NO
FROM TEMP, USER_TABLES, TEST17
WHERE ROWNUM < 10001;

SELECT COUNT(*) FROM T1_DATA; 
--������ �����
CREATE TABLE TCOM(
        WORK_YEAR VARCHAR2(04) NOT NULL,
        EMP_ID NUMBER NOT NULL,
        BONUS_RATE NUMBER,
        COMM NUMBER,
        CONSTRAINT COM_PK PRIMARY KEY (WORK_YEAR,EMP_ID)
);

INSERT INTO TCOM
SELECT '2018', EMP_ID, 1, SALARY*0.01
FROM TEMP
WHERE DEPT_CODE LIKE 'C%';

SELECT * FROM TCOM;

--����
--1. TEMP�� TDEPT �� �μ��ڵ�� �����Ͽ� ���,����,�μ��ڵ�,�μ��� ��������
--��, SALARY�� 9õ���� ���� ū ������ ���ؼ�
SELECT A.EMP_ID, A.EMP_NAME, A.DEPT_CODE, B.DEPT_NAME
FROM TEMP A, TDEPT B
WHERE A.DEPT_CODE = B.DEPT_CODE AND A.SALARY > 90000000;

--2.2019�⿡ Ŀ�̼��� �޴� ������ ���,����,�μ��ڵ�,�μ���, Ŀ�̼� ��������
SELECT A.EMP_ID, A.EMP_NAME, A.DEPT_CODE, B.DEPT_NAME, C.COMM
FROM TEMP A, TDEPT B, TCOM C
WHERE A.DEPT_CODE = B.DEPT_CODE AND A.EMP_ID = C.EMP_ID AND C.WORK_YEAR = 2019;

--3. TEMP���� �ڹ�������  �޿��� ���Թ޴� ���� �˻�
SELECT A.EMP_ID, A.EMP_NAME, A.SALARY
FROM TEMP A, TEMP B
WHERE A.SALARY < B.SALARY AND B.EMP_NAME = '�ڹ���';

SELECT EMP_NAME, EMP_ID, SALARY 
FROM TEMP
WHERE EMP_NAME = '�ڹ���';

--4. EMP_LEVEL ���� �޿� �������� ���ϰ� TEMP ��� �� �ڱ� ������ 
--   ������ ���� �޿��� ���� ���� �������� 
SELECT T.EMP_ID, T.EMP_NAME, T.SALARY, T.LEV
FROM EMP_LEVEL L, TEMP T
WHERE  T.LEV = L.LEV AND T.SALARY < (L.FROM_SAL + L.TO_SAL)/2;

SELECT * FROM EMP_LEVEL;
SELECT * FROM TEMP;
--5. TEMP ,TCOM�� EMP_ID�� �����Ͽ� ��� ������ ��������,  TEMP�� �����ϴ� �ڷ� ���� ��� 
SELECT *
FROM TEMP T, TCOM C
WHERE T.EMP_ID = C.EMP_ID(+) AND C.WORK_YEAR(+) = 2019;
--6. EMP_ID ���� �ڽź��� SALARY�� ���� �ο� COUNT
SELECT A.EMP_ID, COUNT(B.EMP_ID)
FROM TEMP A, TEMP B
WHERE A.SALARY < B.SALARY(+)
GROUP BY A.EMP_ID
ORDER BY 2;
--7. TEMP �� TDEPT CARTESIAN PRODUCT ����
SELECT COUNT(*)
FROM TEMP A, TDEPT B;
SELECT * FROM TEMP;
SELECT * FROM TDEPT;
--8. TEMP �� TDEPT NATURAL JOIN
SELECT EMP_NAME, DEPT_NAME
FROM TEMP
NATURAL JOIN TDEPT;
--9. TEMP �� TDEPT USING�� ��� NATURAL JOIN
SELECT EMP_NAME, DEPT_NAME
FROM TEMP JOIN TDEPT
USING(DEPT_CODE);
--10. NATURAL JOIN ON �� ����Ͽ� ���,�μ�,EMP_LEV ���� ����
SELECT A.EMP_ID, B.DEPT_NAME, A.LEV
FROM TEMP A JOIN TDEPT B
ON A.DEPT_CODE = B.DEPT_CODE;
--11. ���, ����, TEMP.�μ��ڵ�, TDEPT.�μ��ڵ� , �μ����� �������� LEFT OUTER JOIN ����
SELECT A.EMP_ID, A.EMP_NAME, A.DEPT_CODE, B.DEPT_CODE, B.DEPT_NAME
FROM TEMP A
LEFT OUTER JOIN TDEPT B
ON A.DEPT_CODE = B.DEPT_CODE;
--12. 11���� FROM���� ���� ���̺��� outer JOIN���� ���� ���̺��� �ٲ㼭 ����
SELECT A.EMP_ID, A.EMP_NAME, A.DEPT_CODE, B.DEPT_CODE, B.DEPT_NAME
FROM TEMP A, TDEPT B
WHERE A.DEPT_CODE = B.DEPT_CODE;
--13. ���, ����, TEMP.�μ��ڵ�, TDEPT.�μ��ڵ� , �μ����� �������� RIGHT OUTER JOIN ����
SELECT A.EMP_ID, A.EMP_NAME, A.DEPT_CODE, B.DEPT_CODE, B.DEPT_NAME
FROM TDEPT B
RIGHT OUTER JOIN TEMP A
ON A.DEPT_CODE = B.DEPT_CODE;
--���ʽ� ����
--1.��� ,����, TEMP.�μ��ڵ�, TDEPT.�μ��ڵ�, �μ����� �������� FULL OUTER JOIN ����
SELECT A.EMP_ID, A.EMP_NAME, A.DEPT_CODE, B.DEPT_CODE, B.DEPT_NAME
FROM TEMP A
FULL OUTER JOIN TDEPT B
ON A.DEPT_CODE = B.DEPT_CODE;

--2.1������ ����� 2019�� �����ϴ� ������ �˻�
SELECT A.EMP_ID, A.EMP_NAME, A.DEPT_CODE, B.DEPT_CODE, B.DEPT_NAME
FROM TEMP A
FULL OUTER JOIN TDEPT B
ON A.DEPT_CODE = B.DEPT_CODE AND A.EMP_ID BETWEEN 20190000 AND 20199999;
--3.������̺��� SALARY�� Ȧ,¦�� �� 1:2�� ������ ������ �����ϴµ� Ŀ�̼� ���̺��� Ŀ�̼��� ��ϵ� �����
--  �ش� Ŀ�̼��� �ſ� �޿��� ���� �����ϰ��� �մϴ�. ������ ���̺��� ����� ���� �� ��ŭ�� ROW�� �����ϰ�
--  1������ 12������ ���� �ݾ��� �÷����� ������ �� �ֵ��� �ϼ���.(T2_DATA���� : EMP_ID, SAL01, SAL02,....,SAL12)
--  ��, SALARY�� ���� �޿��� �Ҽ��� �Ʒ��� �� ������ �ø� ó�� �մϴ�.
CREATE TABLE T2_DATA
AS
SELECT T.EMP_ID, T.EMP_NAME, 
        CEIL(T.SALARY/18+NVL(C.COMM,0)) SAL01, CEIL(T.SALARY/9+NVL(C.COMM,0)) SAL02,
        CEIL(T.SALARY/18+NVL(C.COMM,0)) SAL03, CEIL(T.SALARY/9+NVL(C.COMM,0)) SAL04,
        CEIL(T.SALARY/18+NVL(C.COMM,0)) SAL05, CEIL(T.SALARY/9+NVL(C.COMM,0)) SAL06,
        CEIL(T.SALARY/18+NVL(C.COMM,0)) SAL07, CEIL(T.SALARY/9+NVL(C.COMM,0)) SAL08,
        CEIL(T.SALARY/18+NVL(C.COMM,0)) SAL09, CEIL(T.SALARY/9+NVL(C.COMM,0)) SAL10,
        CEIL(T.SALARY/18+NVL(C.COMM,0)) SAL11, CEIL(T.SALARY/9+NVL(C.COMM,0)) SAL12
FROM TEMP T, TCOM C
WHERE T.EMP_ID = C.EMP_ID(+) AND C.WORK_YEAR(+) = '2019';
--���� ������ �������� ���̿� ���ԵǴ� ����� ������ ���� ���޿� ������� �о����(���,����,����,�������� �� ���� �ּ���)
SELECT T.EMP_ID, T.EMP_NAME, 
        (SYSDATE-T.BIRTH_DATE)/365 AGE, 
        T.LEV
FROM TEMP T, EMP_LEVEL L
WHERE T.BIRTH_DATE BETWEEN ADD_MONTHS(SYSDATE,-1*L.TO_AGE*12) 
AND ADD_MONTHS(SYSDATE,-1*L.FROM_AGE*12)
AND L.LEV = '����';
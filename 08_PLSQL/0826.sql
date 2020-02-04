SET SERVEROUTPUT ON
DECLARE
lname VARCHAR2(15);
BEGIN
SELECT last_name INTO lname FROM employees WHERE     
first_name='John'; 
DBMS_OUTPUT.PUT_LINE ('John''s last name is : ' ||lname);
END;
--예외의 예제
SET SERVEROUTPUT ON
DECLARE
lname VARCHAR2(15);
BEGIN
SELECT last_name INTO lname FROM employees WHERE     
first_name='John'; 
DBMS_OUTPUT.PUT_LINE ('John''s last name is : ' ||lname);
EXCEPTION
WHEN TOO_MANY_ROWS THEN
DBMS_OUTPUT.PUT_LINE (' Your select statement retrieved multiple rows. Consider using a cursor.');
END;
--정의 되지않은 에러 
SET SERVEROUTPUT ON
DECLARE
insert_excep EXCEPTION;
PRAGMA EXCEPTION_INIT   (insert_excep, -01400);
BEGIN
INSERT INTO departments (department_id, department_name) VALUES (280, NULL);
EXCEPTION
WHEN insert_excep THEN
DBMS_OUTPUT.PUT_LINE('INSERT OPERATION FAILED');
DBMS_OUTPUT.PUT_LINE(SQLERRM);
END;
--유저 정의예외 트랩
ACCEPT deptno PROMPT 'Please enter the department number:' 
ACCEPT name   PROMPT 'Please enter the department name:' 
DECLARE 
    invalid_department EXCEPTION; 
    name VARCHAR2(20):='&name'; 
    deptno NUMBER :=&deptno; 
BEGIN 
    UPDATE  departments 
    SET     department_name = name
    WHERE   department_id = deptno; 
    IF SQL%NOTFOUND 
    THEN 
        RAISE invalid_department; 
    END IF;
    COMMIT; 
    EXCEPTION WHEN invalid_department  
    THEN 
        DBMS_OUTPUT.PUT_LINE('No such department id.');
END; 
/
create table messages ( m_user varchar2(100), m_date date, m_code number, m_cont varchar2(200), constraint message_pk primary key(m_user, m_date));

--과제1
/* 이 연습의 목적은 미리 정의된 예외에 대한 사용법을 제공하는 것입니다. 제공된 급여
값을 가진 사원의 이름을 선택하는 PL/SQL 블록을 작성합니다.
a. messages 테이블의 모든 레코드를 삭제합니다. DEFINE 명령을 사용하여 sal
변수를 정의하고 6000으로 초기화합니다. 
b. 선언 섹션에서 employees.last_name 유형의 ename 변수와
employees.salary 유형의 emp_sal 변수를 선언합니다. 대체 변수의
값을 emp_sal에 전달합니다.
c. 실행 섹션에서 급여가 emp_sal의 값과 동일한 사원의 이름을 검색합니다.
주: 명시적 커서를 사용하지 마십시오. 입력된 급여가 행을 하나만 반환하는
경우 messages 테이블에 사원 이름 및 급여를 삽입하십시오.
d. 입력된 급여가 행을 반환하지 않으면 적합한 예외 처리기로 예외를 처리하고
messages 테이블에 "No employee with a salary of <salary>" 메시지를 삽입합니다.
e. 입력된 급여가 둘 이상의 행을 반환하면 적합한 예외 처리기로 예외를 처리하고
messages 테이블에 "More than one employee with a salary of <salary>" 메시지를
삽입합니다.
f. 기타 예외의 경우 적합한 예외 처리기로 처리하고 messages 테이블에 "Some other
error occurred" 메시지를 삽입합니다.
g. messages 테이블의 행을 표시하여 PL/SQL 블록이 성공적으로 실행되었는지
확인합니다. 다음은 출력 예입니다. */
DEFINE SAL = 6000
DECLARE
    ENAME EMPLOYEES.LAST_NAME%TYPE;
    EMP_SAL EMPLOYEES.SALARY%TYPE := &SAL;
BEGIN
    SELECT LAST_NAME
    INTO ENAME
    FROM EMPLOYEES
    WHERE SALARY = EMP_SAL;
    
    INSERT INTO MESSAGES(M_USER)
    VALUES (ENAME);
EXCEPTION
    WHEN TOO_MANY_ROWS THEN
    insert into messages(m_user, m_date, m_cont)
    select sys_context('USERENV', 'IP_ADDRESS'), sysdate, 'name:' || ename||',salary :'|| emp_sal
    from dual;
    WHEN NO_DATA_FOUND THEN
    insert into messages(m_user, m_date, m_coNt)
    select sys_context('USERENV', 'IP_ADDRESS'), sysdate, 'name:' || ename||',salary :'|| emp_sal
    from dual;
    WHEN OTHERS THEN
    insert into messages(m_user, m_date, m_cont)
    select sys_context('USERENV', 'IP_ADDRESS'), sysdate, 'name:' || ename||',salary :'|| emp_sal
    from dual;
END;

SELECT * FROM MESSAGES;
--과제2
/*2. 이 연습의 목적은 표준 Oracle 서버 오류를 사용하여 예외를 선언하는 방법을 제공하는 것입니다. 
Oracle 서버 오류 ORA-02292(무결성 제약 조건 위반 ? 하위 레코드 발견)를 사용합니다. 
a. 선언 섹션에서 childrecord_exists 예외를 선언합니다. 선언된 예외를 표준 Oracle 서버 오류 ?02292와 연결합니다. 
b. 실행 섹션에서 "Deleting department 40...."을 출력합니다. department_id가 40인 부서를 삭제하는 DELETE 문을 포함시킵니다. 
c. childrecord_exists 예외를 처리하고 적절한 메시지를 출력하는 예외 섹션을 포함시킵니다. 다음은 출력 예입니다.*/
DECLARE
    childrecord_exists  EXCEPTION;
    PRAGMA EXCEPTION_INIT
    (childrecord_exists, -02292);
BEGIN
    DBMS_OUTPUT.PUT_LINE('Deleting department 40....');
    
    DELETE DEPARTMENTS
    WHERE DEPARTMENT_ID = 40;
EXCEPTION 
    WHEN childrecord_exists THEN
    DBMS_OUTPUT.PUT_LINE('에러');
END;
/
SELECT * FROM DEPARTMENTS;
--3. 익명블록에서 EMP_ID를 할당할 변수 선언하고 실행부에서 HOBBY가 등산인 사번 조회하여 
--   변수에 할당 후 결과 출력하는 실행문 작성하고 실행하여 실행 오류 확인.
declare
    empid temp.emp_id%type;

begin
    select emp_id
    into empid
    from temp
    where hobby = '등산';

    dbms_output.put_line('사번: '||empid);
end;
/
--4. EXCEPTION에서 TOO_MANY_ROWS EXCEPTION을 정의하고 
--   ‘조회 결과 1행보다 많은 ROW가 검색되어 실행을 중지합니다.’ 라는 메시지 출력
declare
    empid temp.emp_id%type;
begin
    select emp_id
    into empid
    from temp
    where hobby = '등산';

    dbms_output.put_line('사번: '||empid);
exception
    when too_many_rows then
        dbms_output.put_line('조회 결과 1행보다 많은 ROW가 검색되어 실행을 중지합니다.');  
end;
/
--5. TEMP에서 존재하지 않는 사번 SELECT 해 NO_DATA_FOUND 에러 발생시키고 
--   EXCEPTION 처리하기 
declare
    empid temp.emp_id%type;
begin
    select emp_id
    into empid
    from temp
    where EMP_ID = 1;

    dbms_output.put_line('사번: '||empid);
exception
    when NO_DATA_FOUND then
        dbms_output.put_line('낫파운드');  
end;
/
--6. ZERO_DIVIDE 에러 발생시키고 EXCEPTION 처리하기 
DECLARE
    N NUMBER;
BEGIN
    N := 10/0;
EXCEPTION
    WHEN ZERO_DIVIDE THEN
    DBMS_OUTPUT.PUT_LINE('ZERO_DIVIDE 에러');    
END;
--
CREATE TABLE ELOG(
    EMP_ID NUMBER,
    LEV VARCHAR2(08),
    FLAG VARCHAR2(01),
    SAL_FLAG VARCHAR2(01),
    AGE_FLAG VARCHAR2(01),
    ECODE NUMBER,
    ERRM VARCHAR2(1000)
    );
--7. 모든 에러발생 상황을 오라클 원 메시지 이용하여 사용자에게 오류로 인지시키기 
DECLARE
    E1 ELOG.EMP_ID%TYPE;
BEGIN
    SELECT EMP_ID 
    INTO E1
    FROM ELOG;
EXCEPTION
WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE(SQLERRM); 
END;
/*8. TEMP를 커서로 읽어내 한 건씩 FETCH하며 ELOG에 INSERT
   EMP_LEVEL을 SELECT 해보고 해당 직급이 존재하면 ELAG 에 1,
   SALARY가 범위안에 들면 1, 아니면 0,
   AGE가 범위 안에 들면 1 아니면 0, 
   직급이 존재하지 않으면 NO_DATA_FOUND EXCEPTION으로 떨어뜨려서
   FLAG 0, ECODE 에 SQLCODE, ERRM에 SQLERRM INSERT
  (중간에 오류 발생해도 끝까지 진행되어야 함)*/
SELECT * FROM ELOG;
declare
    emplev emp_level%rowtype;
    v_lev VARCHAR2(8);
    v_sal number := 0;
    v_age number := 0;  
    v_ecode elog.ecode%type;
    v_errm elog.errm%type;
    cursor c1 is
    select *
    from temp;
begin
    for i in c1 loop
        begin
            select *
            into emplev
            from emp_level
            where lev = i.lev;        
            if i.salary between emplev.from_sal and emplev.to_sal then
                v_sal := 1;
            end if;
            if 2019-to_char(i.birth_date,'yyyy')+1 between emplev.from_age and emplev.to_age then
                v_age :=1;
            end if;
            insert into elog(emp_id, lev, flag, sal_flag,age_flag)
            values (i.emp_id, i.lev, 1, v_sal, v_age);                 
        exception
            when no_data_found then
                v_ecode := sqlcode;
                v_errm := sqlerrm;
                insert into elog(emp_id, lev, flag, sal_flag, age_flag, ecode, errm)
                values(i.emp_id, i.lev, 0, 0,0, v_ecode, v_errm );
        end;   
    end loop;
end;
/*9. 선언부에 사용자 예외를 정의하고 실행부 시작하자 마자 사용자 정의 
   EXCEPTION 발생시키기
   EXCEPTION에서 사용자 정의 EXCEPTION을 받아 ‘관리자가 정의한 예외입니다.’ 
   메시지 출력*/
DECLARE
    T1 NUMBER;
    UE EXCEPTION;
BEGIN
    UPDATE  departments 
    SET     department_name = 11 
    WHERE   department_id = -1; 
    IF SQL%NOTFOUND THEN
        RAISE UE;
    END IF;
EXCEPTION WHEN UE THEN
    DBMS_OUTPUT.PUT_LINE('관리자가 정의한 예외입니다.');
END;
/*10. 9번의 RAISE 문을 NO_DATA_FOUND 로 대체하고 EXCEPTION에서 
    NO_DATA_FOUND로 받은 후
   '관리자가 발생시킨 NO DATA FOUND 예외 입니다. ‘ 출력  */
DECLARE
    U_EXCEPTION EXCEPTION;
BEGIN
    RAISE NO_DATA_FOUND;
EXCEPTION
    WHEN U_EXCEPTION THEN
    DBMS_OUTPUT.PUT_LINE('관리자가 정의한 예외입니다.');
    WHEN NO_DATA_FOUND
    THEN DBMS_OUTPUT.PUT_LINE('관리자가 정의한 예외입니다.');
END;
/*11. 유저 정의 EXCEPTION을 선언하고 FOR LOOP에서 TEMP 자료를 모두 
    SELECT 해서 한 건씩 해당 레벨의 
   EMP_LEVEL을 UPDATE(직원의 나이가 FROM_AGE보다 작으면 
   FROM_AGE을 직원 나이로 변경)하는데,
   만약 해당 직급이 존재하지 않으면 유저 정의 에러를 발생 시켜 
   사용자가 다음 메시지를 에러 창으로 볼 수
   있도록 유도 LEV || ‘자료가 EMP_LEVEL에 없습니다. 먼저 자료를 등록하고 재 실행 하세요’*/
DECLARE
    USER_EXCEP EXCEPTION;
    L TEMP.LEV%TYPE;
    CURSOR CUR IS
    SELECT *
    FROM TEMP;
BEGIN
    FOR I IN CUR LOOP 
        UPDATE EMP_LEVEL
        SET FROM_AGE = CEIL((SYSDATE-I.BIRTH_DATE)/365)
        WHERE LEV = I.LEV
        AND FROM_AGE > CEIL((SYSDATE-I.BIRTH_DATE)/365);
        L := I.LEV;
        IF SQL%NOTFOUND THEN
            RAISE USER_EXCEP;
        END IF;
    END LOOP;
EXCEPTION
    WHEN USER_EXCEP THEN
    DBMS_OUTPUT.PUT_LINE(L||' 자료가 EMP_LEVEL에 없습니다. 먼저 자료를 등록하고 재 실행 하세요');
END;
/
--BONUS
--1. BEGIN에서 사전 선언없이 사용자 에러 발생시키고 바로 다음 문장 타는지 메세지 출력하고
--   EXCEPTION에서 OTHERS로 받아서 메세지 출력하여 어느 메세지가 나오는지 확인
BEGIN
    DELETE TEMP2
    WHERE EMP_ID = 1;
    RAISE_APPLICATION_ERROR(-20202, 'This is not a valid manager');
    DBMS_OUTPUT.PUT_LINE('실행블락');
EXCEPTION WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('여기는 EXCEPTION블락');
END;
--2. 1의 EXCEPTION에서 SQLCODE와 SQLERRM 출력
BEGIN
    DELETE TEMP2
    WHERE EMP_ID = 1;
    RAISE_APPLICATION_ERROR(-20202, 'This is not a valid manager');
    DBMS_OUTPUT.PUT_LINE('실행블락');
EXCEPTION WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('여기는 EXCEPTION블락 '||SQLCODE||SQLERRM);
END;
--3. 2번의 -20001에러를 MY_ERROR라는 이름으로 PRAGMA를 이용 초기화하고
--   EXCEPTION에서 MY_ERROR로 받아 SQLCODE와 SQLERRM 출력
DECLARE
    MY_ERROR EXCEPTION;
    PRAGMA EXCEPTION_INIT (MY_ERROR, -20001);
BEGIN
    DELETE TEMP2
    WHERE EMP_ID = 1;
    RAISE MY_ERROR;
EXCEPTION WHEN MY_ERROR THEN
    DBMS_OUTPUT.PUT_LINE(SQLCODE||SQLERRM);
END;
--4. TEST04에 20181201일자로 NULL INSERT하는 BLOCK 작성
BEGIN
    INSERT INTO TEST04
    VALUES(20181201,NULL);
END;
SELECT * FROM TEST04;
--5. 위의 예제에서 나오는 에러번호를 처리할 수 있는 PRAGMA EXCEPTION_INIT을 정의하고 예외 처리하여
--   친절한 안내 메세지 출력
DECLARE
    MY_ERROR EXCEPTION;
    PRAGMA EXCEPTION_INIT (MY_ERROR, -01400);
BEGIN
    INSERT INTO TEST04
    VALUES(20181201,NULL);
    RAISE_APPLICATION_ERROR(-01400,'cannot insert NULL into (%s)');
EXCEPTION WHEN MY_ERROR THEN
    DBMS_OUTPUT.PUT_LINE('SQLCODE: '||SQLCODE||'SQLERRM: '||SQLERRM);
END;
--- sql
select last_name
from employees
where employee_id = 100;

--- PL/SQL 
set SERVEROUTPUT ON
DECLARE 
    v_ename employees.last_name%TYPE;
BEGIN
    select last_name
    into v_ename
    from employees
    where employee_id = 100;
    
    DBMS_OUTPUT.PUT_LINE(v_ename);
END;
/
--PL/SQL
 DECLARE
 --선언부 변수등을 선언하는 영역
BEGIN
 --실행부 기능을 수행하는 영역
EXCEPTION
-- 예외처리 PL/SQL 실행할때 발생하는 예외처리
END;
/ 
-- 블럭이 끝날 떄 / 를붙이는데 해당 블럭을 컴파일 하고 즉각 실행하는 명령어

-- 변수 선언
SET SERVEROUTPUT ON

DECLARE
    v_str VARCHAR2(100 char); -- 글자수로 100글자 바이트 기준으로 할꺼면 byte
    v_num CONSTANT NUMBER(3,1) := 10; --CONSTANT 상수라는 뜻, MAX 99.9
    v_count NUMBER(2,0) NOT NULL DEFAULT 5;
    v_sum NUMBER(4,0) := (v_num+v_count);
BEGIN
    v_str := 'Hello';
    --v_count := 10;
    --v_sum :=  v_num + 1234;
    -- 출력하는 용도의 프로시저
    DBMS_OUTPUT.PUT_LINE('v_str : '||v_str);
    DBMS_OUTPUT.PUT_LINE('v_num : '||v_num);
    DBMS_OUTPUT.PUT_LINE('v_count : '||v_count);
    DBMS_OUTPUT.PUT_LINE('v_sum : '||v_sum);
END;
/


DECLARE
    v_comm employees.commission_pct%TYPE;
    v_new_comm v_comm%TYPE := 1;
BEGIN
    DBMS_OUTPUT.PUT_LINE(v_comm);
END;
/ 

-- 디코드 함수와 그룹함수 -> a무조건ㅇsql문과 함ㄲ

DECLARE
    v_today DATE := SYSDATE;
    v_after_day DATE;
    v_msg VARCHAR2(100);
BEGIN
    v_after_day := ADD_MONTHS(v_today,3);
    v_msg := TO_CHAR(v_after_day,'yyyy"년" mm"월" dd"일"');
    DBMS_OUTPUT.PUT_LINE(v_msg);
END;
/

--PL/SQL 의 셀렉트문

DECLARE
    v_ename VARCHAR2(100);
BEGIN
    SELECT last_name
    into v_ename
    FROM employees
    where department_id = &부서번호;
    -- 부서번호 10: 데이터가 1개라 정상적 실행 
    -- 부서번호 50: 데이터가 2개 이상이라 오류 발생 TOO MANY ROWS ORA-01422: exact fetch returns more than requested number of rows
    -- 부서번호 0: 데이터가 없음 NO DATA FOUND
    DBMS_OUTPUT.PUT_LINE('사원이름 : ' ||v_ename);
END;
/

DECLARE
    v_eid employees.employee_id%TYPE;
    v_ename VARCHAR2(100);
BEGIN
    SELECT employee_id,last_name
    into v_eid,v_ename
    -- select > into not enough values
    -- select < into too many values
    -- v_ename,into v_eid  character to number conversion error
    FROM employees
    where employee_id = 100;
    DBMS_OUTPUT.PUT_LINE('사원번호 : ' ||v_eid || ', 사원이름 : ' ||v_ename);
END;
/
-- 사원번호를 입력 할 경우 해당 사원의 이름과 입사일자 출력하는 plsql을 작성하시오
DECLARE
    v_ename VARCHAR2(100);
    v_date DATE;
BEGIN
    SELECT last_name,hire_date
    into v_ename,v_date
    FROM employees
    where employee_id = &사원번호;
    DBMS_OUTPUT.PUT_LINE('사원이름 : ' ||v_ename||'입사일자 : ' ||v_date );
END;
/

DECLARE
BEGIN
END;
/

/*
1.
사원번호를 입력(치환변수사용&)할 경우
사원번호, 사원이름, 부서이름  
을 출력하는 PL/SQL을 작성하시오.
*/
DECLARE
    v_eid employees.employee_id%TYPE;
    v_ename employees.last_name%TYPE;
    v_dname departments.department_name%TYPE;
BEGIN
    select e.employee_id, e.last_name, d.department_name
    into v_eid,v_ename,v_dname
    from employees e join departments d on e.department_id = d.department_id
    where e.employee_id = &사원번호;
    DBMS_OUTPUT.PUT_LINE('사원번호 : ' ||v_eid||' 사원이름 : ' ||v_ename||' 부서이름 : ' ||v_dname );
END;
/

/*
2.
사원번호를 입력(치환변수사용&)할 경우 
사원이름, 
급여, 
연봉->(급여*12+(nvl(급여,0)*nvl(커미션퍼센트,0)*12))
을 출력하는  PL/SQL을 작성하시오.
*/
DECLARE
    v_ename employees.last_name%TYPE;
    v_salary employees.salary%TYPE;
    v_salary12 number;
BEGIN
    select last_name, salary, (salary*12+(nvl(salary,0)*nvl(commission_pct,0)*12))
    into v_ename,v_salary,v_salary12
    from employees
    where employee_id = &사원번호;
    DBMS_OUTPUT.PUT_LINE('사원이름 : ' ||v_ename||' 급여 : ' ||v_salary ||' 연봉 : ' ||v_salary12);
END;
/

/* 
	추가문제 
1번) JOIN 대신 두개의 SELECT문을 활용
2번) 연봉을 SELECT문 에서 연산하지 않고 분리해서 계산
	
*/
DECLARE
    v_eid employees.employee_id%TYPE;
    v_ename employees.last_name%TYPE;
    v_did employees.department_id%TYPE;
    v_dname departments.department_name%TYPE;
BEGIN
    select employee_id,last_name,department_id
    into v_eid,v_ename,v_did
    from employees
    where employee_id = &사원번호;
    
    select department_name
    into v_dname
    from departments
    where department_id = v_did;
    
    DBMS_OUTPUT.PUT_LINE('사원번호 : ' ||v_eid||' 사원이름 : ' ||v_ename||' 부서이름 : ' ||v_dname );
END;
/
select e.employee_id,e.last_name,(select d.department_name from departments d where d.department_id = e.department_id) as department_name
from employees e
where e.employee_id = &사원번호;
    
DECLARE
    v_ename employees.last_name%TYPE;
    v_salary employees.salary%TYPE;
    v_com employees.commission_pct%TYPE;
    v_salary12 number;
BEGIN
    select last_name,salary,commission_pct
    into v_ename,v_salary,v_com
    from employees
    where employee_id = &사원번호;
    v_salary12 := (v_salary*12+(nvl(v_salary,0)*nvl(v_com,0)*12));
    DBMS_OUTPUT.PUT_LINE('사원이름 : ' ||v_ename||' 급여 : ' ||v_salary ||' 연봉 : ' ||v_salary12);
END;
/

DECLARE
    v_deptno departments.department_id%TYPE;
    v_comm employees.commission_pct%TYPE := .1;
BEGIN
    select department_id
    into v_deptno
    from employees
    where employee_id = &사원번호;
    
    insert into employees(employee_id,last_name,email,hire_date,job_id,department_id)
    values(1000,'Hong','hkd@google.com',sysdate,'IT_PROG',v_deptno);
    
    UPDATE employees 
    SET salary = (nvl(salary,0)+10000)*v_comm
    where employee_id = 1000;
END;
/

select *
from employees
where employee_id in (200,1000);


BEGIN
    Delete from employees
    where employee_id = 1000;
    
    DBMS_OUTPUT.PUT_LINE(sql%ROWCOUNT || '건이 삭제되었습니다');
END;
/

SET SERVEROUTPUT ON
-- DBMS_OUTPUT.PUT_LINE 프로시저 사용 출력하는 코드
-- 조건문 : if, case 등
-- 1) 기본 IF문 : 해당 조건식이 True 인 경우만
IF 조건문 THEN
    조건식이 true 인경우 실행코드
END IF;
-- 예시
BEGIN
  DELETE FROM employee
  WHERE department_id = &부서번호;
  
  IF SQL%ROWCOUNT = 0 THEN
    -- 삭제되지 않았을 경우
    DBMS_OUTPUT.PUT_LINE('해당 부서에 속한 사원이 존재하지 않습니다');
  END IF;
END;
/

drop table employee;
create table employee
as
    select *
    from employees;

-- 2) IF ~ ELSE 문 : 해당 조건식이 true 인경우와 false인 경우 동시 처리
IF 조건문 THEN
    조건식이 true 인경우 실행코드
ELSE
    위의 모든 조건식 false인 경우 실행코드
END IF;
-- 예시
BEGIN
    DELETE FROM employee
    WHERE employee_id = &사원번호;
      
    IF SQL%ROWCOUNT = 0 THEN
        DBMS_OUTPUT.PUT_LINE('해당 부서에 속한 사원이 존재하지 않습니다.');
    ELSE
        DBMS_OUTPUT.PUT_LINE('정상적으로 삭제되었습니다.');
    END IF;
END;
/
-- 3) IF ~ ELSIF ~ ELSE 문 : 여러 경우에 대한 처리 (다중 조건문)
IF 조건문 THEN
    조건식이 true 인경우 실행코드
ELSIF 추가 조건식 1 THEN
    추가 조건식 1 이 true 인 경우 실행코드
ELSIF 추가 조건식 2 THEN
    추가 조건식 2 이 true 인 경우 실행코드
ELSE
    위의 모든 조건식 false인 경우 실행코드
END IF;

DECLARE
    v_score NUMBER(2,0) := &정수;
    v_grade CHAR(1);
BEGIN
    IF v_score >= 90 THEN  --  99 >= v_score >= 90
        v_grade := 'A';
    ELSIF v_score >= 80 THEN --  89 >= v_score >= 80
        v_grade := 'B';
    ELSIF v_score >= 70 THEN --  79 >= v_score >= 70
        v_grade := 'C';
    ELSIF v_score >= 60 THEN --  69 >= v_score >= 60
        v_grade := 'D';
    ELSE
        v_grade := 'E'; --  59 >= v_score >= -99
    END IF;
    
    DBMS_OUTPUT.PUT_LINE(v_grade||'학점');
END;
/


/*
3.
사원번호를 입력(치환변수사용&)할 경우
입사일이 2005년 이후(2005년 포함)이면 'New employee' 출력
      2005년 이전이면 'Career employee' 출력
단, DBMS_OUTPUT.PUT_LINE ~ 은 한번만 사용

입력 사원번호 -> 입사일로 변환 => select문

SELECT 입사일
FROM employees
WHERE 사원번호
입사일이 2005년 이후(2005년 포함) / 2005년 이전 구분 => 조건문

IF 입사일자 >= 2005년 THEN
    'New employee' 출력
ELSE 
    'Career employee' 출력
END IF;

*/

DECLARE
    v_hiredate employees.hire_date%TYPE;
    v_msg VARCHAR2(100);
BEGIN
    select hire_date
    into v_hiredate
    from employees
    where employee_id = &사원번호;

--  IF TO_CHAR(v_hiredate,'yyyy') >= '2005' 
    IF v_hiredate >= '05/01/01' THEN  
        v_msg := 'New employee';
    ELSE
        v_msg := 'Career employee';
    END IF;
    DBMS_OUTPUT.PUT_LINE(v_msg);
END;
/

/*
4.
create table test01(empid, ename, hiredate)
as
  select employee_id, last_name, hire_date
  from   employees
  where  employee_id = 0;

create table test02(empid, ename, hiredate)
as
  select employee_id, last_name, hire_date
  from   employees
  where  employee_id = 0;

사원번호를 입력(치환변수사용&)할 경우
사원들 중 2005년 이후(2005년 포함)에 입사한 사원의 사원번호, 
사원이름, 입사일을 test01 테이블에 입력하고, 2005년 이전에 
입사한 사원의 사원번호,사원이름,입사일을 test02 테이블에 입력하시오.
*/
create table test01(empid, ename, hiredate)
as
  select employee_id, last_name, hire_date
  from   employees
  where  employee_id = 0;

create table test02(empid, ename, hiredate)
as
  select employee_id, last_name, hire_date
  from   employees
  where  employee_id = 0;
  
DECLARE
    v_empid NUMBER := &사원번호;
    v_hiredate DATE;
    v_last_name VARCHAR2(100);
BEGIN
    select last_name, hire_date
    into v_last_name, v_hiredate
    from employees
    where employee_id = v_empid;


    IF v_hiredate >= '15/01/01' THEN  
        insert into test01(empid, ename, hiredate)
        values(v_empid,v_last_name,v_hiredate);
    ELSE
        insert into test02(empid, ename, hiredate)
        values(v_empid,v_last_name,v_hiredate);
    END IF;
END;
/
/*
5.
급여가  5000이하이면 20% 인상된 급여
급여가 10000이하이면 15% 인상된 급여
급여가 15000이하이면 10% 인상된 급여
급여가 15001이상이면 급여 인상없음

사원번호를 입력(치환변수)하면 사원이름, 급여, 인상된 급여가 출력되도록 PL/SQL 블록을 생성하시오.
*/
DECLARE
    v_last_name VARCHAR2(100);
    v_salary NUMBER;
    v_raised_salary NUMBER;
    v_new NUMBER;
BEGIN
    SELECT last_name, salary
    INTO v_last_name, v_salary
    FROM employees
    WHERE employee_id = &사원번호;

    IF v_salary <= 5000 THEN  
        v_raised_salary := 20;
    ELSIF v_salary <= 10000 THEN  
        v_raised_salary := 15;
    ELSIF v_salary <= 15000 THEN  
        v_raised_salary := 10;
    ELSE v_raised_salary := 0;
        
    END IF;
    v_new := v_salary+(v_salary*v_raised_salary/100);
    DBMS_OUTPUT.PUT_LINE('이름'||v_last_name||'급여'||v_salary||'인상된급여'||v_new);
END;
/

BEGIN 
    LOOP
        DBMS_OUTPUT.PUT_LINE('hi');
    END LOOP;
END;
/

-- 1) 기본 LOOP문 : 무조건 반복한다를 전재로 사용
-- 필수 문법 => 무한 루프
LOOP
    --반복할 코드
END LOOP; 
-- 사용 문법 : EXIT문을 포함

LOOP
    --반복할 코드
    EXIT WHEN 루프문을 종료할 조건
END LOOP; 

-- 예시 1
BEGIN 
    LOOP
        DBMS_OUTPUT.PUT_LINE('hi');
        EXIT;
    END LOOP;
END;
/

-- 예시 5
DECLARE
    v_count NUMBER(1) := 0; --반복한 횟수
BEGIN 
    LOOP
        DBMS_OUTPUT.PUT_LINE('hi');
        
        --EXIT WHEN에 사용하는 변수가 변경된느 코드가 반드시 필요!
        v_count := v_count + 1;
        EXIT WHEN v_count >= 5;
    END LOOP;
END;
/


DECLARE
    v_count NUMBER := 1;
    v_sum NUMBER := 0;
BEGIN 
    LOOP
        v_sum := v_count + v_sum;
        v_count := v_count + 1;
        EXIT WHEN v_count > 10;
    END LOOP;
    DBMS_OUTPUT.PUT_LINE('합 : '||v_sum);
END;
/


/*

6. 다음과 같이 출력되도록 하시오.
*         
**        
***       
****     
*****    

*/

DECLARE
    v_count NUMBER := 1;
    v_star VARCHAR(100) := '*';
BEGIN 
    LOOP
        DBMS_OUTPUT.PUT_LINE(v_star);
        v_star := v_star || '*';
        v_count := v_count + 1;
        EXIT WHEN v_count > 5;
    END LOOP;
END;
/
-- length 활용시 v_count 필요 없음


/*
7. 치환변수(&)를 사용하면 숫자를 입력하면 
해당 구구단이 출력되도록 하시오.
예) 2 입력시 아래와 같이 출력
2 * 1 = 2
2 * 2 = 4
...
*/

DECLARE
    v_count NUMBER := 1;
    v_num NUMBER := &단;
BEGIN 
    LOOP
        DBMS_OUTPUT.PUT_LINE(v_num||' X '||v_count||' = '||v_num*v_count);
        v_count := v_count + 1;
        EXIT WHEN v_count > 9;
    END LOOP;
END;
/

/*
8. 구구단 2~9단까지 출력되도록 하시오.
*/
DECLARE
    v_count NUMBER;
    v_num NUMBER := 2;
BEGIN 
    LOOP
        v_count := 1;
        DBMS_OUTPUT.PUT_LINE('==================='||v_num||'단'||'===================');
        LOOP
            DBMS_OUTPUT.PUT_LINE(v_num||'X'||v_count||'='||v_num*v_count);
            v_count := v_count + 1;
            EXIT WHEN v_count > 9;
        END LOOP;
        v_num := v_num + 1;
        EXIT WHEN v_num > 6220;
    END LOOP;
END;
/

-- 2) WHILE LOOP : 조건식이 true 인 동안 반복
-- 문법

WHILE 조건식 LOOP
    반복코드
END LOOP;

DECLARE
    v_count NUMBER(1,0) := 0;
BEGIN
    WHILE v_count < 5 LOOP 
        DBMS_OUTPUT.PUT_LINE('Hello !!');
        v_count := v_count + 1;
    END LOOP;
END;
/
-- 기본 LOOP문과 WHILE LOOP문의 연관성
-- 1) 정 반대의 조건을 가진다. 종료 조건 vs 반복 조건
-- 2)WHILE LOOP문은 아예 실행되자 않는 경우가 있다

-- 1 DECLARE 선언 x
-- 2 read only
-- 3 for loop 가 가지는 정수 범위의 숫자를 가짐
FOR 임시변수 in [REVERSE] 최소값..최대값 LOOP
    statement1;
    statement2;
    ***
END LOOP;
/
--3) FOR LOOP문 : 횟수를 기준으로 반복
-- 문법

BEGIN
    FOR idx in 111..115 LOOP 
        DBMS_OUTPUT.PUT_LINE(idx||' : Hello !!');
    END LOOP;
END;
/

--주의사항 1) 임시 변수는 수정 불가

BEGIN
    FOR idx in 1..5 LOOP 
        idx := 123;
    END LOOP;
END;
/

--주의사항 2) 최소값 보다 항상 최소값이 같거나 커야한다.

BEGIN
    FOR idx in 10..1 LOOP 
        DBMS_OUTPUT.PUT_LINE(idx);
    END LOOP;
END;
/

-- 역순으로 값을 가지고 올때
BEGIN
    FOR idx in REVERSE 1..10 LOOP 
        DBMS_OUTPUT.PUT_LINE(idx);
    END LOOP;
END;
/

DECLARE
    v_sum number := 0;
BEGIN
    FOR idx in 1..10 LOOP 
        v_sum := v_sum + idx;
    END LOOP;
    DBMS_OUTPUT.PUT_LINE(v_sum);
END;
/

DECLARE
    v_star varchar2(100) := '*';
BEGIN
    FOR idx in 1..5 LOOP 
        DBMS_OUTPUT.PUT_LINE(v_star);
        v_star := v_star || '*';
    END LOOP;
END;
/

BEGIN
    FOR idx in 1..5 LOOP 
        FOR idx2 in 1..idx LOOP 
            DBMS_OUTPUT.PUT('*');
        END LOOP;
        DBMS_OUTPUT.PUT_LINE('');
    END LOOP;
END;
/

DECLARE
    v_num number := &숫자;
BEGIN
    FOR idx in 1..9 LOOP
        DBMS_OUTPUT.PUT_LINE(v_num||' x '|| idx ||' = '||idx *v_num);
    END LOOP;
END;
/

BEGIN
    FOR idx in 2..9 LOOP
        FOR idx2 in 1..9 LOOP
            DBMS_OUTPUT.PUT_LINE(idx||' x '|| idx2 ||' = '||idx * idx2);
        END LOOP;
    END LOOP;
END;
/

BEGIN
    FOR idx in 1..9 LOOP
        FOR dan in 2..9 LOOP
            DBMS_OUTPUT.PUT(dan ||' x '|| idx  ||' = '||idx * dan||'  ');
        END LOOP;
        DBMS_OUTPUT.PUT_LINE(' ');
    END LOOP;
END;
/

/*
9. 구구단 1~9단까지 출력되도록 하시오.
   (단, 홀수단 출력)
*/
BEGIN
    FOR dan in 1..9 LOOP
        IF MOD(dan,2) = 1 THEN  
        DBMS_OUTPUT.PUT_LINE(dan || '단');
            FOR idx in 1..9 LOOP
                DBMS_OUTPUT.PUT_LINE(dan ||' x '|| idx  ||' = '||idx * dan||'  ');
            END LOOP;
        END IF;
    END LOOP;
END;
/


BEGIN
    FOR dan in 1..9 LOOP
        continue when mod(dan,2) = 1;
        DBMS_OUTPUT.PUT_LINE(dan || '단');
            FOR idx in 1..9 LOOP
                DBMS_OUTPUT.PUT_LINE(dan ||' x '|| idx  ||' = '||idx * dan||'  ');
            END LOOP;
    END LOOP;
END;
/

DECLARE 
    -- 1) RECORD 정의
    TYPE 레코더 타입 이름 IS RECORD
        (필드명1 데이터타입,
         필드명2 데이터타입 NOT NULL DEFAULT 초기값,
         필드명3 데이터타입 := 초기값,
         ...);
    -- 2) 변수 선언
    변수명 레코드 타입 이름;
BEGIN
    -- 실제사용
END;
/

-- 예시
DECLARE 
    -- 회원 정보(아이디,이름,가입일자)를 의미하는 RECORD
    TYPE user_record_type IS RECORD
        (user_id number(6,0),
         user_name varchar2(100) := '익명',
         join_date date NOT NULL DEFAULT SYSDATE);
    -- 2) 변수 선언
    first_user user_record_type;
    new_user user_record_type;
BEGIN
    DBMS_OUTPUT.PUT_LINE(first_user.user_id);
    DBMS_OUTPUT.PUT_LINE(first_user.user_name);
    DBMS_OUTPUT.PUT_LINE(first_user.join_date);
END;
/

--특정 사원의 사원번호,이름,급여를 출력하세요

DECLARE 
    TYPE emp_record_type IS RECORD
    (
        empno number(6,0),
        ename employees.last_name%TYPE Not null := 'Hong',
        sal employees.salary%TYPE := 0
    );
    v_emp_info emp_record_type;
    v_emp_record emp_record_type;
BEGIN
    select employee_id, last_name, salary
    -- 무조건 record 타입 변수 하나만 사용
    into v_emp_info
    from employees
    where employee_id = 100;
    DBMS_OUTPUT.PUT(v_emp_info.empno||' ');
    DBMS_OUTPUT.PUT(v_emp_info.ename||' ');
    DBMS_OUTPUT.PUT_LINE(v_emp_info.sal);
    
    select employee_id, last_name, salary
    -- 무조건 record 타입 변수 하나만 사용
    into v_emp_record
    from employees
    where employee_id = 200;
    DBMS_OUTPUT.PUT(v_emp_record.empno||' ');
    DBMS_OUTPUT.PUT(v_emp_record.ename||' ');
    DBMS_OUTPUT.PUT_LINE(v_emp_record.sal);
END;
/
-- %rowtype
--1) 필드명은 참조하는 테이블의 컬럼명과 동을
--2) Select 할때 반드시 해당 테이블의 모든 컬럼을 선언
DECLARE 
    --1) record 정의 => 생략
    --2) 변수선언
    v_emp_info employees%ROWTYPE;
BEGIN
    select *
    into v_emp_info
    from employees
    where employee_id = 100;
    
    DBMS_OUTPUT.PUT(v_emp_info.employee_id||' ');
    DBMS_OUTPUT.PUT(v_emp_info.last_name||' ');
    DBMS_OUTPUT.PUT_LINE(v_emp_info.salary);
END;
/

-- 명시적 커서 : 다중행 select 문을 사용
select employee_id, last_name, hire_date
from employees
where department_id = &부서번호;

DECLARE
    -- 커서 정의 => 실행 x
    CURSOR emp_cursor IS
        select employee_id, last_name, hire_date
        from employees
        where department_id = &부서번호;
    
    -- 값을 담을 변수 선언
    v_eid employees.employee_id%TYPE;
    v_ename employees.last_name%TYPE;
    v_hdate employees.hire_date%TYPE;
  --부서번호 : 10 값이 하나  정상실행        명시적 커서로 실행시 =>
  --부서번호 : 50 값이 여러개 TOO_MANY_ROW  명시적 커서로 실행시 =>
  --부서번호 : 0  값이 없음  NO_DATA_FOUND 명시적 커서로 실행시 =>
BEGIN
    -- 커서 실행
    OPEN emp_cursor;
    LOOP
        -- 데이터 확인 및 반환 => 1건의 데이터
        fetch emp_cursor into v_eid, v_ename, v_hdate;
            --FETCH를 기반으로 가져온 데이터가 새로운 데이터가 아닌 경우
        EXIT WHEN emp_cursor%NOTFOUND;
        dbms_output.put(emp_cursor%ROWCOUNT);  
        dbms_output.put_line(v_eid|| v_ename||v_hdate);
   
    END LOOP;
    -- 커서 종료
    dbms_output.put_line('루프종료'||emp_cursor%ROWCOUNT);
    close emp_cursor;
END;
/

DECLARE
    -- 1 커서정의
    cursor 커서명 is 
        커서가 실행할 select문;
BEGIN
    -- 2 커서실행
    open 커서명
    LOOP
        -- 3 데이터 확인 및 반환
        fetch 커서명 into 값을 담을 변수들;
        EXIT WHEN 커서명%NOTFOUND;
        --새로운 데이터가 있는 경우 진행할 작업
        -- 커서명%ROWCOUNT : 현재 몇번째 행을 가지고 있는지, 유동값
    END LOOP
    -- 커서명%ROWCOUNT : 커서가 가진 총 행수
    -- 4 커서 종료
    close 커서명
END;
/


-- 특정 없무를 수행하는 사원의 정보를 출력하세요.
-- 출력할 사원의 정보는 사원번호 사원이름 입사일자 입니다
-- 단 해당 업무를 수행하는 사원이 없는경우
-- '해당 사원이 없습니다.'라고 출력합니다


DECLARE
    CURSOR emp_cursor IS 
        SELECT employee_id, last_name, hire_date
        FROM employees
        WHERE job_id LIKE UPPER('%&업무%');
    v_eid employees.employee_id%TYPE;
    v_ename employees.last_name%TYPE;
    v_hdate employees.hire_date%TYPE;
BEGIN
    OPEN emp_cursor;
    LOOP
        FETCH emp_cursor INTO v_eid,v_ename,v_hdate;
        EXIT WHEN emp_cursor%NOTFOUND;
        dbms_output.put_line(v_eid||' '|| v_ename||' '||v_hdate);
    END LOOP;
    IF emp_cursor%ROWCOUNT = 0 THEN
        dbms_output.put_line('해당 사원이 없습니다.');
    END IF;
    CLOSE emp_cursor;
END;
/


/*
1.
사원(employees) 테이블에서
사원의 사원번호, 사원이름, 입사연도를 
다음 기준에 맞게 각각 test01, test02에 입력하시오.

입사년도가 2005년(포함) 이전 입사한 사원은 test01 테이블에 입력
입사년도가 2005년 이후 입사한 사원은 test02 테이블에 입력
*/

DECLARE
    CURSOR emp_cursor IS 
        SELECT employee_id, last_name, hire_date
        FROM employees;
    v_eid employees.employee_id%TYPE;
    v_ename employees.last_name%TYPE;
    v_hdate employees.hire_date%TYPE;
BEGIN
    OPEN emp_cursor;
    LOOP
        FETCH emp_cursor INTO v_eid,v_ename,v_hdate;
        EXIT WHEN emp_cursor%NOTFOUND;
        IF TO_CHAR(v_hdate,'YYYY') >= '2015' THEN  
            insert into test01(empid, ename, hiredate)
            values(v_eid,v_ename,v_hdate);
        ELSE
            insert into test02(empid, ename, hiredate)
            values(v_eid,v_ename,v_hdate);
        END IF;
    END LOOP;
    CLOSE emp_cursor;
END;
/

/*
2.
부서번호를 입력할 경우(&치환변수 사용)
해당하는 부서의 사원이름, 입사일자, 부서명을 출력하시오.
*/



DECLARE
    CURSOR emp_cursor IS 
        SELECT e.last_name, e.hire_date, (select d.department_name from departments d where d.department_id = e.department_id)
        FROM employees e
        WHERE e.department_id = &부서번호;
    v_ename employees.last_name%TYPE;
    v_hdate employees.hire_date%TYPE;
    v_dname departments.department_name%TYPE;
BEGIN
    OPEN emp_cursor;
    LOOP
        FETCH emp_cursor INTO v_ename,v_hdate,v_dname;
        EXIT WHEN emp_cursor%NOTFOUND;
        dbms_output.put_line(v_ename||' '||v_hdate||' '||v_dname);
    END LOOP;
    
    IF emp_cursor%ROWCOUNT = 0 THEN
        dbms_output.put_line('해당 부서에는 사람이 없거나 부서 번호가 잘못됨.');
    END IF;
    
    CLOSE emp_cursor;
END;
/

/*
3.
부서번호를 입력(&사용)할 경우 
사원이름, 급여, 연봉->(급여*12+(급여*nvl(커미션퍼센트,0)*12))
을 출력하는  PL/SQL을 작성하시오.
*/

DECLARE
    CURSOR emp_cursor IS 
        SELECT last_name, salary, commission_pct
        FROM employees 
        WHERE department_id = &부서번호;
    v_ename employees.last_name%TYPE;
    v_sal employees.salary%TYPE;
    v_com employees.commission_pct%TYPE;
BEGIN
    OPEN emp_cursor;
    LOOP
        FETCH emp_cursor INTO v_ename,v_sal,v_com;
        EXIT WHEN emp_cursor%NOTFOUND;
        dbms_output.put_line(v_ename||' '||v_sal||' '||(v_sal*12+(v_sal*nvl(v_com,0)*12)));
    END LOOP;

    
    CLOSE emp_cursor;
END;
/


DECLARE
    CURSOR emp_cursor IS 
        SELECT employee_id empid, last_name ename, hire_date
        FROM employees;
    v_emp_info emp_cursor%ROWTYPE;
BEGIN
    OPEN emp_cursor;
    LOOP
        FETCH emp_cursor INTO v_emp_info;
        EXIT WHEN emp_cursor%NOTFOUND;
        IF TO_CHAR(v_emp_info.hire_date,'YYYY') >= '2015' THEN  
            insert into test01(empid, ename, hiredate)
            values (v_emp_info.empid,v_emp_info.ename,v_emp_info.hire_date);
        ELSE
            insert into test02
            values v_emp_info;
        END IF;
    END LOOP;
    CLOSE emp_cursor;
END;
/

create view emp_view
as
    select employee_id,last_name,job_id
    from employees;

select *
from emp_view;

DECLARE
    cursor emp_cursor is
        select employee_id,last_name,job_id
        from employees;
        
    v_emp_rec emp_cursor%rowtype;
begin
    open emp_cursor;
    
    loop 
        FETCH emp_cursor into v_emp_rec;
        exit when emp_cursor%notfound;
        
        dbms_output.put(v_emp_rec.employee_id);
        dbms_output.put(v_emp_rec.last_name);
        dbms_output.put_line(v_emp_rec.job_id);
    end loop;
    
    CLOSE emp_cursor;
end;
/


--커서 for loop 명시적 커서 단축 방법

select employee_id,last_name,job_id
from employees
where department_id = &부서번호;

set serveroutput on;

DECLARE
    cursor emp_cursor is
        select employee_id,last_name,hire_date
        from employees
        where department_id = &부서번호;
        
begin
    -- 명령어 사용 vs 커서 for loop
    for emp_rec in emp_cursor loop --암묵적으로 open과 fetch를 실행
        --emp_rec에 데이터가 반드시 존재할 경우 사용 없으면 실행안됨
        dbms_output.put(emp_cursor%rowcount||' : ');
        dbms_output.put_line(emp_rec.employee_id);
    end loop; --명목족으로 close실행\ 
    
    -- invalid cursor close 된 커서에 접근
    dbms_output.put_line('근무하는 총 사원수' || emp_cursor%rowcount);
end;
/

-- 사용방법 정리

declare
    cursor 커서명 is
        커서가 실행할 select문
begin
    --2 커서실행
    --3 데이터 확인 및 반환
    for 임시변수(레코드타입 )in 커서명 loop
        -- 데이터가 존재하는 경우에만 실행
        -- => 커서 for loop는 반드시 데이터가 있는 경우만
        -- 명시적 커서의 속성에 접근가능
    end loop; --4 커서 종료
end;
/


/*
1.
사원(employees) 테이블에서
사원의 사원번호, 사원이름, 입사연도를 
다음 기준에 맞게 각각 test01, test02에 입력하시오.

입사년도가 2005년(포함) 이전 입사한 사원은 test01 테이블에 입력
입사년도가 2005년 이후 입사한 사원은 test02 테이블에 입력
*/

declare
    cursor emp_cursor is
        select employee_id,last_name,hire_date
        from employees;
begin
    for emp_rec in emp_cursor loop
        IF TO_CHAR(emp_rec.hire_date,'YYYY') >= '2015' THEN  
            insert into test01(empid, ename, hiredate)
            values (emp_rec.employee_id,emp_rec.last_name,emp_rec.hire_date);
        ELSE
            insert into test02
            values emp_rec;
        END IF;
    end loop; 
end;
/



/*
2.
부서번호를 입력할 경우(&치환변수 사용)
해당하는 부서의 사원이름, 입사일자, 부서명을 출력하시오.
*/

declare
    cursor emp_cursor is
        select e.last_name,e.hire_date,d.DEPARTMENT_name
        from employees e join departments d on e.DEPARTMENT_ID = d.DEPARTMENT_ID
        where e.DEPARTMENT_ID = &부서번호;
begin
    --커서 안 select 절에 별칭을 쓰는 경우 임시변수의 필드명은 반드시 별칭으로 사용
    for emp_rec in emp_cursor loop
        dbms_output.put_line(emp_rec.last_name||emp_rec.hire_date||emp_rec.DEPARTMENT_name);
    end loop; 
end;
/

/*
3.
부서번호를 입력(&사용)할 경우 
사원이름, 급여, 연봉->(급여*12+(급여*nvl(커미션퍼센트,0)*12))
을 출력하는  PL/SQL을 작성하시오.
*/

declare
    cursor emp_cursor is
        select last_name,salary,commission_pct
        from employees
        where DEPARTMENT_ID = &부서번호;
begin
    for emp_rec in emp_cursor loop
        dbms_output.put_line(emp_rec.last_name||'님의 급여는 : '||emp_rec.salary||'$ 이며 연봉은 : '||(emp_rec.salary*12+(emp_rec.salary*nvl(emp_rec.commission_pct,0)*12))||'$ 입니다');
    end loop; 
end;
/

declare
    cursor emp_cursor is
        select last_name,salary, (salary*12+salary*nvl(commission_pct,0)*12) as sal
        from employees
        where DEPARTMENT_ID = &부서번호;
begin
    for emp_rec in emp_cursor loop
        dbms_output.put_line(emp_rec.last_name||'님의 급여는 : '||emp_rec.salary||'$ 이며 연봉은 : '||emp_rec.sal);
    end loop; 
end;
/

--예외처리
--문법

declare
 --변수 커서 레코드등 타입 선언부
 
begin 
 --실행
exception
 --예외처리
    when 예외이름 1 then
        예외가 발생했을때 실행할 코드;
    when 예외이름 2 or 예외이름 3 then
        예외가 발생했을때 실행할 코드;
    when others then
        위에 선언 되지 않은 예외가 발생한 경우 실행할 코드;
end;
/

-- 1) 예외유형 : 이름있음
declare 
    v_ename employees.last_name%type;
begin
    select last_name
    into v_ename
    from employees
    where department_id = &부서번호;
    
    dbms_output.put_line(v_ename);
    --부서번호 0 ORA-01403
    --부서번호 10 정살
    --부서번호 50 ORA-01422: exact fetch returns more than requested number of rows
    
EXCEPTION
	WHEN NO_DATA_FOUND THEN
        dbms_output.put_line('데이터가 없습니다');
    WHEN TOO_MANY_ROWS THEN
        dbms_output.put_line('데이터가 너무 많습니다');
    WHEN OTHERS THEN
        dbms_output.put_line('기타 예외 발생');
end;
/

-- 2) 예외유형 : 정의되있지만 이름이 없음
DECLARE
    --2-1 예외이름 선언
    e_emps_remeaining EXCEPTION;
    --2-2 예외 이름과 에러코드 연결
    PRAGMA EXCEPTION_INIT(e_emps_remeaining,-02292);
BEGIN 
    DELETE FROM departments
    WHERE department_id = &부서번호;
EXCEPTION
    WHEN e_emps_remeaining THEN
        dbms_output.put_line('참조 데이터가 있습니다.');
    WHEN OTHERS THEN
        dbms_output.put_line('기타 예외 발생');
END;
/

--사용자 정의 예외사항 vs 조건문
-- 해당 경우 더이상 코드가 진행되면 안될때 예외처리

--3 예외유형
DECLARE
    --3-1 예외 이름 선언
    e_dept_del_fail EXCEPTION;
BEGIN 
    DELETE FROM departments
    WHERE department_id = &부서번호;
    
    IF SQL%ROWCOUNT = 0 THEN
        RAISE e_dept_del_fail;
    END IF;
    dbms_output.put_line('정상적으로 삭제됨');
EXCEPTION -- 예외는 스탑
    WHEN e_dept_del_fail THEN
        dbms_output.put_line('해당 부서는 존재하지 않습니다');
    WHEN OTHERS THEN
        dbms_output.put_line('기타 예외 발생');  
END;
/

BEGIN 
    DELETE FROM departments
    WHERE department_id = &부서번호;
    
    IF SQL%ROWCOUNT = 0 THEN
        dbms_output.put_line('해당 부서는 존재하지 않습니다');
    END IF;
    dbms_output.put_line('정상적으로 삭제됨');
END;
/

-- procedure : 독립된 기능을 구현하는 pl/sql 의 객체중 하나
create or replace procedure test_pro_01
(p_msg in VARCHAR2)
is 
-- declare절이 생략됨
    -- 선언부 : 변수, 커서, 예외
    v_msg VARCHAR2(1000) := 'Hello! ';
begin
    DBMS_OUTPUT.PUT_LINE(v_msg || p_msg);
exception
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('데이터가 존재 하지 않습니다');
end;
/

--실행 
--declare
--    v_result varchar2(1000);
begin 
    -- v_result := test_pro_01('PL/SQL');
    -- 프로시저를 호출 할 때 왼쪽에 변수가 있으면 no function with name 'TEST_PRO_01' exists in this scope 에러가 뜸
    test_pro_01('PL/SQL');
end;
/

execute test_pro_01('PL/SQL');

-- IN 모드 : 호출환경 -> 프로시저
drop procedure raise_salary;
create procedure raise_salary
(p_eid in employees.employee_id%type)
is

begin 
    -- IN 모두 : 상수로 인식
--    p_eid := NVL(p_eid, 100);
    
    update employees
    set salary = salary * 1.1
    where employee_id = p_eid;
end;
/

declare
    v_first number := 100;
    v_second constant number := 149;
begin 
    raise_salary(100);
    raise_salary(v_first+10);
    raise_salary(v_first);
    raise_salary(v_second);
end;
/

select employee_id,salary
from employees
where employee_id in(100,110,149);

-- oup 모드 : 프로시저 -> 호출환경
create or replace procedure test_p_out
(
p_num in number,
p_out out number
)
is

begin
    DBMS_OUTPUT.PUT_LINE('in: ' ||p_num);
    DBMS_OUTPUT.PUT_LINE('out: ' ||p_out);
end;
/
    
declare
    v_result number := 1234;
begin
    -- 매개 변수로 전달되는 값이 있어도 무조건 아웃을 null이다
    DBMS_OUTPUT.PUT_LINE('1 result : ' ||v_result);
    test_p_out(1000,v_result);
    DBMS_OUTPUT.PUT_LINE('2 result : ' ||v_result);
end;   
/

create or replace procedure plus
(p_x in number, p_y in number, p_result out number)
is
begin 
    p_result := (p_x + p_y);
end;
/

declare
    v_total number;
begin 
    plus(10,25,v_total);
    DBMS_OUTPUT.PUT_LINE(v_total);
end;
/

-- inout모드 : 호출환경 <-> 프로시저
-- '01012341234' => '010-1234-1234'
create or replace procedure format_phone
(p_phone_no in out varchar2)
is

begin
    dbms_output.put_line('before : '||p_phone_no);
    p_phone_no := substr(p_phone_no,1,3)|| '-' ||substr(p_phone_no,4,4)|| '-' || substr(p_phone_no,8);
end;
/

declare
    v_no varchar2(100) := '01037496468';
begin 
    format_phone(v_no);
    DBMS_OUTPUT.PUT_LINE('after : '||v_no);
end;
/


/*
1.
주민등록번호를 입력하면 
다음과 같이 출력되도록 yedam_ju 프로시저를 작성하시오.

EXECUTE yedam_ju('9501011667777');
950101-1******
EXECUTE yedam_ju('1511013689977');
151101-3******
*/
create or replace procedure yedam_ju
(uno in varchar2)
is
begin 
    DBMS_OUTPUT.PUT_LINE(substr(uno,1,6)||'-'||substr(uno,7,1)||'******');
end;
/


EXECUTE yedam_ju('9501011667777');
EXECUTE yedam_ju('1511013689977');

BEGIN
  yedam_ju('9501011667777');
  yedam_ju('1511013689977');
END;
/
/*
2.
사원번호를 입력할 경우
삭제하는 TEST_PRO 프로시저를 생성하시오.
단, 해당사원이 없는 경우 "해당사원이 없습니다." 출력
예) EXECUTE TEST_PRO(176);
*/

create or replace procedure TEST_PRO
(eno in number)
is
    e_emps_remeaining EXCEPTION;
    PRAGMA EXCEPTION_INIT(e_emps_remeaining,-02292);
begin 
    delete from employees
    where employee_id = eno;
    IF SQL%ROWCOUNT = 0 THEN
        dbms_output.put_line('해당사원이 없습니다');
    ELSE
        dbms_output.put_line('삭제됨');
    END IF;
EXCEPTION
    WHEN e_emps_remeaining THEN
        dbms_output.put_line('참조 데이터가 있습니다.');
    WHEN OTHERS THEN
        dbms_output.put_line('기타 예외 발생');    
end;
/

EXECUTE TEST_PRO(&사원번호);

rollback;


/*
3.
다음과 같이 PL/SQL 블록을 실행할 경우 
사원번호를 입력할 경우 사원의 이름(last_name)의 첫번째 글자를 제외하고는
'*'가 출력되도록 yedam_emp 프로시저를 생성하시오.

실행) EXECUTE yedam_emp(176);
실행결과) TAYLOR -> T*****  <- 이름 크기만큼 별표(*) 출력
*/

create or replace procedure yedam_emp
(eno in number)
is
    v_name varchar2(100);
    v_star varchar2(100);
begin 
    select last_name
    into v_name
    from employees
    where employee_id = eno;

    for idx in 1..length(v_name)-1 LOOP
        v_star := v_star || '*';
    END LOOP;

    dbms_output.put_line(replace(v_name,substr(v_name,2),v_star));
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        dbms_output.put_line('해당사원이 없습니다');
end;
/

EXECUTE yedam_emp(&사원번호);

    
/*
4.
부서번호를 입력할 경우 
해당부서에 근무하는 사원의 사원번호, 사원이름(last_name), 연차를 출력하는 get_emp 프로시저를 생성하시오. 
(cursor 사용해야 함)
단, 사원이 없을 경우 "해당 부서에는 사원이 없습니다."라고 출력(exception 사용)
실행) EXECUTE get_emp(30);
*/

create or replace procedure get_emp
(dno in number)
is
CURSOR emp_cursor IS
    select employee_id, last_name, to_char(sysdate,'yy')-to_char(hire_date,'yy') as workyear
    from employees
    where department_id = dno;
    
    v_eid employees.employee_id%TYPE;
    v_ename employees.last_name%TYPE;
    v_workyear varchar2(100);
    e_dept_del_fail EXCEPTION;
BEGIN

    OPEN emp_cursor;
    LOOP
        FETCH emp_cursor INTO v_eid,v_ename,v_workyear;
        IF emp_cursor%ROWCOUNT = 0 then
            RAISE e_dept_del_fail;
        END IF;
        EXIT WHEN emp_cursor%NOTFOUND;
        dbms_output.put_line(v_eid||' '||v_ename||' '||v_workyear||'년 차'); 
    END LOOP;
    CLOSE emp_cursor;
    
exception
    WHEN e_dept_del_fail THEN
        DBMS_OUTPUT.PUT_LINE('해당 부서에는 사원이 없습니다.');
end;
/

EXECUTE get_emp(&부서번호);


/*
5.
직원들의 사번, 급여 증가치만 입력하면 Employees테이블에 쉽게 사원의 급여를 갱신할 수 있는 y_update 프로시저를 작성하세요. 
만약 입력한 사원이 없는 경우에는 ‘No search employee!!’라는 메시지를 출력하세요.(예외처리)
실행) EXECUTE y_update(200, 10);
*/

create or replace procedure y_update
(eno in number,sal in number)
is
    e_dept_del_fail EXCEPTION;
BEGIN
    UPDATE employees 
    SET salary = salary + sal
    where employee_id = eno;
    IF SQL%ROWCOUNT = 0 then
        RAISE e_dept_del_fail;
    END IF;
exception
    WHEN e_dept_del_fail THEN
        DBMS_OUTPUT.PUT_LINE('No search employee!!');
end;
/

EXECUTE y_update(&사원번호,&증가할급여);



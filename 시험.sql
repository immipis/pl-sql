set SERVEROUTPUT ON

--2 
DECLARE 
    v_dname departments.department_name%TYPE;
    v_jid employees.job_id%TYPE;
    v_sal employees.salary%TYPE;
    v_com employees.commission_pct%TYPE;
BEGIN
    select department_name,job_id,nvl(salary,0),nvl(commission_pct,0)
    into v_dname,v_jid,v_sal,v_com
    from employees e join departments d on e.department_id = d.department_id
    where employee_id = &사원번호;
    
    DBMS_OUTPUT.PUT_LINE(v_dname||','||v_jid||','||v_sal||','||(v_sal+(v_sal*v_com))*12);
END;
/

--3
DECLARE
    v_hidate number;
BEGIN
    select to_char(hire_date,'YYYY')
    into v_hidate
    from employees
    where employee_id = &사원번호;
    
    if v_hidate > 2015 then
        DBMS_OUTPUT.PUT_LINE('New employee');
    else
        DBMS_OUTPUT.PUT_LINE('Career employye');
    end if;
END;
/

--4
BEGIN
    FOR idx in 1..9 LOOP 
        continue when mod(idx,2) = 0;
        FOR idx2 in 1..9 LOOP 
            DBMS_OUTPUT.PUT_LINE(idx||'x'||idx2||'='||idx * idx2);
        END LOOP;
    END LOOP;
END;
/

--5
declare
    cursor emp_cursor is
        select employee_id,last_name,salary
        from employees
        where department_id = &부서번호;
    v_eid employees.employee_id%TYPE;
    v_ename employees.last_name%TYPE;
    v_sal employees.salary%TYPE;
begin
    OPEN emp_cursor;
    LOOP
        fetch emp_cursor into v_eid, v_ename, v_sal;
        EXIT WHEN emp_cursor%NOTFOUND;
        dbms_output.put_line(v_eid|| v_ename||v_sal);
    END LOOP;
    close emp_cursor;
end;
/

--6
create or replace procedure new_pro
(v_eid in number,v_upsal in number)
is 
    no_data EXCEPTION;
begin
    update employees
    set salary = salary+(salary*(v_upsal/100))
    where employee_id = v_eid;
    IF SQL%ROWCOUNT = 0 then
        RAISE no_data;
    END IF;
exception
    WHEN no_data THEN
        DBMS_OUTPUT.PUT_LINE('No search employee!!');
end;
/

EXECUTE new_pro(&사번,&증가치);

--7
create or replace procedure new_pro2
(uno in varchar2)
is
    v_a number;
    v_s varchar(100);
BEGIN
    if substr(uno,7,1) = '1' then
        v_s := '남';
        v_a := trunc(months_between(sysdate,19||substr(uno,1,6))/12);
    elsif substr(uno,7,1) = '3' then
        v_s := '남';
        v_a := trunc(months_between(sysdate,20||substr(uno,1,6))/12);
    elsif substr(uno,7,1) = '2' then
        v_s := '여';
        v_a := trunc(months_between(sysdate,19||substr(uno,1,6))/12);
    elsif substr(uno,7,1) = '4' then
        v_s := '여';
        v_a := trunc(months_between(sysdate,20||substr(uno,1,6))/12);
    else    
        v_s := '여';
    end if;
    DBMS_OUTPUT.PUT_LINE('만 '||v_a||'세, '||v_s||'성');
end;
/

EXECUTE new_pro2('0211023234567');
EXECUTE new_pro2('9507152856951');

--8
create or replace function new_fuc
(v_eid employees.employee_id%type)
return varchar2
is
    hire_year number;
begin
    select trunc(months_between(sysdate,hire_date)/12)
    into hire_year
    FROM employees
    where employee_id = v_eid;

    return hire_year||'년차';
end;    
/
EXECUTE DBMS_OUTPUT.PUT_LINE(new_fuc(&사원번호));

--9
create or replace function new_fuc2
(v_dname departments.department_name%type)
return varchar2
is
    v_mname varchar2(100);
begin
    select e.last_name
    into v_mname
    from employees e 
    where employee_id = (select d.manager_id from departments d where department_name = v_dname);
    
    return v_mname;
end;    
/
EXECUTE DBMS_OUTPUT.PUT_LINE(new_fuc2('Sales'));

--10
select name, text
from user_source
where type in ('PROCEDURE','FUNCTION','PACKAGE','PACKAGE BODY');

--11
DECLARE 
    v_star varchar2(100) := '*';
BEGIN
    for idx in 1..9 LOOP
        dbms_output.put_line(LPAD(v_star, 10, '-'));
        v_star := v_star || '*';
    END LOOP;
END;
/

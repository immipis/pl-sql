-- 1
SELECT *
FROM   employees
WHERE  UPPER(job_id) = 'ST_CLERK'
AND    hire_date < TO_DATE('2002/01/01','YYYY/MM/DD');

-- AND    TO_CHAR(hire_date, 'YYYY') < '2002';








-- 2
SELECT   last_name, job_id, salary, commission_pct
FROM     employees;
WHERE    commission_pct IS NOT NULL
ORDER BY salary DESC;








-- 3
SELECT 'The salary of ' || last_name 
       || 'after a 10% raise is'
       || ROUND(salary*1.10)
       AS "New salary"
FROM   employees
WHERE  commission_pct IS NULL;


-- 4

-- 근무한 기간 중 년
SELECT TRUNC(MONTHS_BETWEEN(SYSDATE, hire_date) / 12)
FROM   employees;

-- 근무한 기간 중 년을 제외한 달
SELECT TRUNC(MOD(MONTHS_BETWEEN(SYSDATE, hire_date), 12))
FROM   employees;


SELECT last_name, 
       TRUNC(MONTHS_BETWEEN(sysdate, hire_date)/12) years,
       TRUNC(MOD(MONTHS_BETWEEN(sysdate, hire_date), 12)) MONTHS
FROM   employees;






-- 5
-- 1) LIKE 연산자
SELECT last_name
FROM   employees
WHERE  UPPER(last_name) LIKE 'J%'
OR     UPPER(last_name) LIKE 'K%'
OR     UPPER(last_name) LIKE 'L%'
OR     UPPER(last_name) LIKE 'M%';

-- 2) IN 연산자
SELECT last_name
FROM   employees
WHERE  UPPER(SUBSTR(last_name, 1, 1)) IN ('J','K','L','M');







-- 6
-- 1) NVL2 함수
SELECT last_name, salary, NVL2(commission_pct, 'Yes', 'No')
FROM   employees;

-- 2) CASE 문
SELECT last_name, salary,
       CASE 
         WHEN commission_pct is null
             THEN 'No'
         ELSE 'Yes'
       END AS commission
FROM   employees;

-- 3) DECODE 함수
SELECT last_name, salary,
       DECODE(commission_pct, NULL, 'No',
                                    'Yes') commission
FROM   employees;









-- 7 
SELECT d.department_name, d.location_id, e.last_name,
       e.salary, e.job_id
FROM   employees e JOIN departments d
       ON (e.department_id = d.department_id)
WHERE  d.loction_id = 1800;







-- 8
-- 1) LIKE 연산자
SELECT COUNT(*)
FROM   employees
WHERE  LOWER(last_name) LIKE '%n';

-- 2) SUBSTR 함수
SELECT COUNT(*)
FROM   employees
WHERE  LOWER(SUBSTR(last_name,-1)) = 'n';













-- 9 표준 SQL 조인
SELECT d.department_name, d.location_id, COUNT(e.employee_id)
FROM   departments d LEFT OUTER JOIN employees e 
                      ON(e.department_id = d.department_id)
GROUP BY d.department_name, d.location_id;









-- 10
SELECT DISTINCT job_id
FROM   employees
WHERE  department_id IN (10, 20);











-- 11
-- 1) 표준 SQL 조인
SELECT   e.job_id, count(e.job_id) AS frequency
FROM     employees e JOIN departments d
               ON(e.department_id = d.department_id)
WHERE    LOWER(d.department_name) 
                        IN ('administration', 'executive')
GROUP BY e.job_id
ORDER BY 2 DESC;

-- 2) 서브쿼리
SELECT   job_id, count(job_id) AS frequency
FROM     employees
WHERE    department_id  IN
        (SELECT department_id
         FROM   departments
         WHERE  LOWER(department_name) IN ('administration', 'executive')
GROUP BY job_id
ORDER BY 2 DESC;
















-- 12
SELECT last_name, hire_date
FROM   employees
WHERE  TO_CHAR(hire_date, 'DD') < '16';

-- DATE TYPE ) TO_CHAR(), TO_DATE() 차이점
TO_CHAR(SYSDATE -> 'YYYY"년" MM"월" DD"일" ')
        YY/MM/DD    
TO_DATE('1999-01-31', 'YYYY-MM-DD')












-- 13
SELECT 	last_name, salary, 
        TRUNC(salary, -3)/1000 thousands
FROM    employees;













-- 14
-- 1) 표준 SQL 조인
SELECT w.last_name, m.last_name manager, m.salary, 
       j.grade_level gra
FROM e mployees w JOIN employees m
                    ON (w.manager_id = m.employee_id)
                  JOIN job_grades j 
                    ON (m.salary BETWEEN j.lowest_sal AND j.highest_sal)
WHERE m.salary > 15000;

-- 2) 서브쿼리
SELECT e.last_name, m.last_name MANAGER, m.salary, 
       j.grade_level GRADE
FROM   employees e JOIN employees m
             ON(e.manager_id = m.employee_id)
                   JOIN job_grades j
             ON(m.salary BETWEEN j.lowest_sal AND j.highest_sal)
AND    m.salary > 15000;













-- 15
SELECT   department_id, MIN(salary)
FROM     employees
GROUP BY department_id
HAVING   AVG(salary) = (select   max(avg(salary))
                        from     employees
                        group by department_id);
                        
                        
                        
                        DECLARE
    v_empid NUMBER := &사원번호;
    v_salary2 NUMBER;
BEGIN
    select last_name, salary
    into v_last_name, v_salary
    from employees
    where employee_id = v_empid;


    IF v_salary <= 5000 THEN  
        v_salary2 : v_salary*1.2
    ELSIF v_salary <= 10000 THEN  
        v_salary2 := v_salary*1.15
    ELSIF v_salary <= 15000 THEN  
        v_salary2 := v_salary*1.1
    ELSE;
        
    DBMS_OUTPUT.PUT_LINE('이름'||v_last_name||'급여'||v_salary||'인상된급여'||v_salary2);
    END IF;
END;
/

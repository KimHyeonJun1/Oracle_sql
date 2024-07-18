--부서명
select  last_name||' '||first_name as name, e.* 
from employees e 
where employee_id = 178;

select  last_name||' '||first_name as name, e.*
from    employees e, departments d 
where   employee_id = 178
and e.department_id = d.department_id(+);


select  last_name||' '||first_name as name, e.*
from    employees e  LEFT OUTER JOIN departments d
on      e.department_id = d.department_id
where   employee_id = 178;

select  last_name||' '||first_name as name, e.*
from    departments d right OUTER JOIN  employees e
on      e.department_id = d.department_id
where   employee_id = 178;

-- 업무 제목 추가
select  last_name||' '||first_name as name, department_name, job_title, e.*
from    departments d right OUTER JOIN  employees e on e.department_id = d.department_id 
INNER JOIN jobs j ON j.job_id = e.job_id
where   employee_id = 178;


select  last_name||' '||first_name as name, department_name, e.*
from    departments d right OUTER JOIN  employees e
on      e.department_id = d.department_id
where   employee_id = 178;

select *
from    departments


--고객관리
create table customer (
id      number CONSTRAINT customer_id_pk primary key,
name    varchar2(50) not null,
gender  varchar2(3) default '남' not null,
phone   varchar2(13),
email   varchar2(50)
);

insert into customer (id, name)
values (1, '홍길동');

--customer 테이블의 pk인 id컬럼에 적용할 시퀀스
create sequence seq_customer
start with 2 increment by 1 nocache;


--시퀀스 적용
insert into customer(id, name)
values (seq_customer.nextval, '박문수');

-- customer 테이블의 pk인 id컬럼에 시퀀스 자동적용할 트리거
-- old, new 
create or replace trigger trg_customer
   before insert on customer --시점
   for each row
begin
    select seq_customer.nextval into :new.id from dual;
    end;
/


insert into customer(name)
values('심청');

commit;

select * from customer;










회원 테이블 생성
create table custom_01 (
p_id     varchar2(10) constraint custom_id_pk primary key,
p_pw     varchar2(10),
c_name   varchar2(20),
c_email  varchar2(20),
c_tel    varchar2(14)
);

/*
 회원정보 샘플 데이터
회원ID 비번 회원명 email 연락처
aaa 1234 김회원 aaa@korea.com 010-1111-1111
bbb 1234 이회원 bbb@korea.com 010-1111-1112
ddd 1234 오회원 ddd@korea.com 010-1111-1114
eee 1234 최회원 eee@korea.com 010-1111-1115
fff 1234 조회원 fff@korea.com 010-1111-1116
*/
insert into custom_01
values ( 'aaa', '1234', '김회원', 'aaa@korea.com', '010-1111-1111'  );

insert into custom_01
values ( 'bbb', '1234', '이회원', 'bbb@korea.com', '010-1111-1112'  );

insert into custom_01
values ( 'ddd', '1234', '오회원', 'ddd@korea.com', '010-1111-1114'  );

insert into custom_01
values ( 'eee', '1234', '최회원', 'eee@korea.com', '010-1111-1115'  );

insert into custom_01
values ( 'fff', '1234', '조회원', 'fff@korea.com', '010-1111-1116'  );
commit;

select * from custom_01;

commit;



create table product_code (
code       varchar2(4) constraint product_code_pk primary key,
maker      varchar2(50) not null,
reg_date   date default sysdate
);

desc product_code;
insert into product_code (code, maker)
values ('A100', '삼성전자');
insert into product_code (code, maker)
values ('B100', 'LG전자');

commit;

select * from product_code;

update product_code set reg_date = '2019-10-31';
commit;

select distinct department_id, nvl(department_name, '소속없음') AS department_name
from employees e left outer join departments d using(department_id)
order by department_name;

//내가 한것
select e.last_name||' '||e.first_name as name, m.last_name||' '||m.first_name as manager_name, j.job_title, d.department_name, e.* 
from employees e, departments d, jobs j, employees m
where e.department_id = d.department_id
and e.job_id = j.job_id
and e.manager_id = m.employee_id
and e.employee_id = 101;

//오라클 조인
select e.*, department_name, job_title, m.last_name||' '||m.first_name as manager_name, city
from employees e, departments d, jobs j, employees m, locations l
where e.employee_id = 178
and e.department_id = d.department_id(+)
and j.job_id = e.job_id
and e.manager_id = m.employee_id(+)
and d.location_id = l.location_id(+);

//안시 조인
select city, region_name, country_name, department_name, job_title,  m.last_name||' '||m.first_name as manager_name, city, country_name
from employees e left outer join departments d on e.department_id = d.department_id
inner join jobs j on j.job_id = e.job_id
left outer join employees m on e.manager_id = m.employee_id
left outer join locations l on d.location_id = l.location_id
left outer join countries c on c.country_id = l.country_id
left outer join regions r on r.region_id = c.region_id
where e.employee_id = 201;


select *
from employees
where employee_id = 101;

alter trigger update_job_history disable;

desc employees;

select t.table_name, t.constraint_name, column_name, constraint_type
from user_constraints t left outer join user_cons_columns c 
on t.constraint_name = c.constraint_name
where t.table_name in ('EMPLOYEES', 'DEPARTMENTS', 'JOB_HISTORY')
order by 1;

alter table job_history drop constraint jhist_emp_fk;


select * from departments;

alter table employees drop constraint emp_manager_fk;
alter table employees add constraint emp_manager_fk foreign key(manager_id)
                                                    references employees(employee_id) on delete set null;

alter table departments drop constraint dept_mgr_fk;
alter table departments add constraint dept_mgr_fk 
                        foreign key(manager_id)  references employees(employee_id) on delete set null;
                                                    
-- 관리자인 102번                                                    
select employee_id from employees where manager_id = 102;
-- 103번의 관리자는 102번 = 102번이 관리하고 있는 사원 103번
select employee_id, manager_id from employees where employee_id = 103;                                                     

select count(*) from employees where manager_id = 120;

select * from departments;

select employees_seq.nextval from dual; //209

create or replace trigger trg_employees
    before insert on employees
    for each row
begin
    select employees_seq.nextval into :new.employee_id from dual;
end;
/

select * from employees;

-- 회원관리
create table member(
name    varchar2(50) not null,
userid  varchar2(50) constraint member_userid_pk primary key, 
userpw  varchar2(300) not null, 
gender  varchar2(3) default '남' not null, 
email   varchar2(50) not null, 
profile     varchar2(300), /*프로필이미지*/
birth       date, 
phone       varchar2(13), 
post        varchar2(5),
address1    varchar2(300), 
address2    varchar2(100),
social      varchar2(1) /* 소셜: N/K(네이버/카카오)*/
);

-- 소셜로그인에 따른 제약조건변경
alter table member modify(userpw null, email null);

--소셜로그인에 따른 소셜종류 관리 컬럼 추가
alter table member add( social   varchar2(1) );

update member set email ='6389301@naver.com';
commit;

select * from member; 
--where userid= 'hong' and userpw= '1234';





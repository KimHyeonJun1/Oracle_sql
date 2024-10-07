-- 공지글관리
create table notice (
id          number constraint notice_id_pk primary key, /* PK */
title       varchar2(300) not null, /* 제목 */
content     varchar2(4000) not null, /* 내용 */
writer      varchar2(50) constraint notice_writer_fk
                            references member(userid) on delete set null, /* 글쓴이: 회원의 아이디 */
writedate   date default sysdate, /* 작성일자 */
readcnt     number default 0, /* 조회수 */
filepath    varchar2(300), /* 첨부파일경로 */
filename    varchar2(300), /* 첨부파일명 */
rid         number, /* 원글 */
root        number, /* 최초원글id */
step        number default 0, /* 순서 */
indent      number default 0,  /* 들여쓰기 */
constraint notice_rid_fk foreign key(rid) references notice(id) on delete cascade
);

alter table notice add (
rid         number, /* 원글 */
root        number, /* 최초원글id */
step        number default 0, /* 순서 */
indent      number default 0,  /* 들여쓰기 */
constraint notice_rid_fk foreign key(rid) references notice(id) on delete cascade
);

select id, rid, root, step, indent from notice order by id desc;

update notice set root = id;
commit;

create sequence seq_notice start with 1 increment by 1 nocache;

insert into notice (id, title, content, writer)
values (seq_notice.nextval, '테스트 공지글', '첫번째 테스트 공지글 입니다.', 'admin' );
commit;

insert into notice (title, content, writer)
values ('두번째 테스트 공지글', '두번째 테스트 공지글 입니다.', 'manager' );

insert into notice (title, content, writer)
values ('두번째 테스트 공지글', '두번째 테스트 공지글 입니다.', 'manager' );


create or replace trigger trg_notice
    before insert on notice
    for each row
begin
    select seq_notice.nextval into :new.id from dual;
    
    -- 원글인 경우만 root에 id와 같은 값 (currval) 넣기
    if :new.root is null then
        select seq_notice.currval into :new.root from dual;
    else
    -- 답글인 경우 순서를 위한 step 변경
        update notice set step = step + 1
        where root = :new.root and step >= :new.step;
    end if;
end;
/

select id, filename, filepath from notice order by id desc;

select name, userid from member;


select * from
(select row_number() over(order by id) no, name, n.*
from notice n left outer join member m on m.userid = n.writer) n
where no    between 375 and 384
order by no desc;

insert into notice ( title, content, writer)
select title, content, writer from notice;

commit;

//새로운 테이블 로그인정보 저장하기 위한
create table remember(
    username varchar(64) not null, /*userid*/
    series varchar(64) constraint remember_pk primary key, /* 식별자*/
    token varchar(64) not null, /*쿠키에 사용할 토큰*/
    last_used timestamp not null /*최종 사용일시*/
);

select * from remember;

delete from remember where username ='admin'

drop table board;
//방명록을 관리할 테이블

create table board (
id          number constraint board_id_pk primary key,
title       varchar2(300) not null,
content     varchar2(4000) not null,
writer      varchar2(50) not null constraint board_wrtier_fk references member(userid) on delete cascade,
writedate date default sysdate not null,
readcnt     number default 0
);

create sequence seq_board start with 1 increment by 1 nocache;

create or replace trigger trg_board 
    before insert on board
    for each row
begin
    select seq_board.nextval into :new.id from dual;
end;
/

insert into board(id, title, content, writer)
values (seq_board.nextval, '테스트 방명록글1', '방명록글 테스트', 'test123');
insert into board(title, content, writer)
values ('테스트 방명록글2', '방명록글 테스트', 'test123');

commit;
select * from board;

--방명록 첨부파일 관리할 테이블 만들기
create table board_file (
id              number constraint board_file_id_pk primary key,
filename        varchar2(300) not null,
filepath        varchar2(300) not null,
board_id        number not null constraint board_file_fk references board(id) on delete cascade
);

create sequence seq_board_file start with 1 increment by 1 nocache;

create or replace trigger trg_board_file
    before insert on board_file
    for each row
begin
    select seq_board_file.nextval into :new.id from dual;
end;
/

insert into board (title, content, writer)
select title, content, writer from board;

commit;

select *
from	(select row_number() over(order by id) no, name, b.*
		from board b inner join member on writer = userid ) 
--where no between #{beginList} and #{endList}		
order by id desc;

select * from board where id = 387;

select name, b.*, f.id file_id, filename, filepath 
from board b inner join member m on writer = userid
left outer join board_file f on b.id = f.board_id
where b.id = 390;

select * from board_file;


select * from board;

select userid from member;


create or replace function fn_boardFileCount( b_id number )
return number is
 cnt    number;
begin
    select count(*) into cnt from board_file where board_id = b_id;
return cnt;
end;
/

commit;

select fn_boardFileCount(393) from dual;

-- 방명록 댓글관리
create table board_comment (
id            number constraint board_comment_id_pk primary key,
content       varchar2(4000) not null,
writer        varchar2(50) constraint board_comment_writer_fk 
                           references member(userid) on delete cascade,
writedate     date default sysdate,
board_id      number constraint board_comment_id_fk 
                            references board(id) on delete cascade,
notify        number default 0 /*0:미확인, 1:확인*/                            
);

create sequence seq_board_comment start with 1 increment by 1 nocache;

create or replace trigger trg_board_comment
    before insert on board_comment
    for each row
begin
    select seq_board_comment.nextval into :new.id from dual;
end;
/


commit;


alter table board_comment add (notify        number default 0);

desc board_comment;
select id, board_id, notify from board_comment;

--댓글 누가썻는지 조회
select writer from board
where id in (select board_id from board_comment);

select userid, name from member;

--댓글 여러개로 만들기
insert into board_comment (content,writer,board_id)
select content,writer,board_id from board_comment;
commit;

select userid, name from member;

--부서별 사원수 조회
select department_id, count(employee_id) count, nvl(department_name, '소속없음') department_name
from employees e left outer join departments d using(department_id)
group by department_id, department_name;


--년도별 채용인원수 조회
--2020년 10명
--2021년 5명
select to_char(hire_date, 'yyyy') unit, count(employee_id) count
from employees
group by to_char(hire_date, 'yyyy')
order by unit
;

select to_char(hire_date, 'mm') unit, count(employee_id) count
from employees
group by to_char(hire_date, 'mm')
order by unit;


--부서원수 상위3위까지의 부서
--dense_rank 써서 1,2,333,6이아니라 1,2,333,4,5이런식으로 표현
select rank, department_id, '(TOP' || rank || ')' || department_name department_name
from (select dense_rank() over(order by count(*) desc ) rank, department_id
        from employees
        group by department_id) e left outer join departments d using(department_id)
where rank <=3 
;

--상위3위까지의 부서의 월별 채용인원수 
select to_char(hire_date, 'mm') unit, count(*) count
from employees
group by to_char(hire_date, 'mm');

select department_name, to_char(hire_date, 'mm') unit
from employees e inner join
        (select rank, department_id, '(TOP' || rank || ')' || department_name department_name
        from (select dense_rank() over(order by count(*) desc ) rank, department_id
                from employees
                group by department_id) e left outer join departments d using(department_id)
        where rank <=3 ) r using(department_id)
order by 1, 2       
;

--상위3위까지의 부서의 월별 채용인원수 가로행으로

select department_name, extract(month from hire_date) unit
from employees e inner join
        (select rank, department_id, '(TOP' || rank || ')' || department_name department_name
        from (select dense_rank() over(order by count(*) desc ) rank, department_id
                from employees
                group by department_id) e left outer join departments d using(department_id)
        where rank <=3 ) r using(department_id)
order by 1, 2       
;

select *
from (select department_name, extract(month from hire_date) unit
        from employees e inner join
                (select rank, nvl(e.department_id, 0) department_id, '(TOP' || rank || ')' || nvl(department_name, '소속 없음') department_name
                from (select dense_rank() over(order by count(*) desc ) rank, department_id
                        from employees
                        group by department_id) e left outer join departments d on nvl(e.department_id, 0)=d.department_id
                where rank <=3 ) r on nvl(e.department_id, 0)=r.department_id)
pivot( count(unit) for unit in (1,2,3,4,5,6,7,8,9,10,11,12) )
order by department_name
;


--년도별
select *
from (select department_name, extract(year from hire_date) unit
        from employees e inner join
                (select rank, nvl(e.department_id, 0) department_id, '(TOP' || rank || ')' || nvl(department_name, '소속 없음') department_name
                from (select dense_rank() over(order by count(*) desc ) rank, department_id
                        from employees
                        group by department_id) e left outer join departments d on nvl(e.department_id, 0)=d.department_id
                where rank <=3 ) r on nvl(e.department_id, 0)=r.department_id)
pivot( count(unit) for unit in (2002,2003,2004,2005,2006,2007,2008,2024) )
order by department_name
;



--세로행을 가로행으로 : pivot
--가로행을 세로행으로 : unpivot

--각 사원의 부서코드 조회
select nvl(department_id, 0) department_id from employees
order by 1;

select *
from (select nvl(department_id, 0) department_id from employees)
pivot( count(department_id) for department_id in(0,10,20,30,40,50,60,70,80,90,100,110) )
;

--각 부서별 사원수 조회
select nvl(department_id, 0) department_id, count(employee_id) count
from employees
group by department_id
order by 1;

--pivot하기(가로행으로 만들기)
select *
from (select nvl(department_id, 0) department_id, count(employee_id) count
        from employees
        group by department_id)
pivot (sum (count) for department_id in (0,10,20,30,40,50,60,70,80,90,100,110) )        
;        

--사월들의 입사월 조회
select to_char(hire_date, 'mm'), extract(month from hire_date) mm from employees
order by 1;
--pivot하기(가로행으로 만들기)
select * 
from (select to_char(hire_date, 'mm') mm from employees)
pivot(count(mm) for mm in ('01','02','03','04','05','06','07','08','09','10','11','12'))
;
select *
from ( select extract(month from hire_date) mm from employees)
pivot (count(mm) for mm in ('01','02','03','04','05','06','07','08','09','10','11','12'));

--입사월별 사원수 조회
select to_char(hire_date, 'mm'), count(employee_id) from employees
group by to_char(hire_date, 'mm')
;

--pivot하기
select *
from (select to_char(hire_date, 'mm') mm , count(employee_id) count from employees
        group by to_char(hire_date, 'mm'))
pivot(sum (count) for mm in ('01','02','03','04','05','06','07','08','09','10','11','12') )
;
        
        
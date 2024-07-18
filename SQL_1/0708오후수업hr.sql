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













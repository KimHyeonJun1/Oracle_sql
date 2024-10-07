create table faq (
id      number constraint faq_id_pk primary key,
question        varchar2(300) not null,
answer          varchar2(4000) not null,
writedate       date default sysdate
);

select * from faq;

SELECT * FROM faq ORDER BY id;

drop table faq;

insert into faq(id, question, answer)
values ('1', 'faq1', 'faq 테스트');

commit;

insert into faq( id, question, answer)
values (seq_faq.nextval, 'faq3', 'faq 테스트3');

create sequence seq_faq start with 1 increment by 1 nocache;

create or replace trigger trg_faq 
    before insert on faq
    for each row
begin
    select seq_faq.nextval into :new.id from dual;
end;
/
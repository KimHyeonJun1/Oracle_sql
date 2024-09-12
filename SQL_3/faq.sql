create table faq (
id      number constraint faq_id_pk primary key,
question        varchar2(300) not null,
answer          varchar2(4000) not null,
writedate       date default sysdate
);

select * from faq;

drop table faq;
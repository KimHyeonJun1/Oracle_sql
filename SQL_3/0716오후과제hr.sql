CREATE TABLE board (
        numb NUMBER(5) CONSTRAINT  numb_pk PRIMARY KEY,
        name VARCHAR2(10) CONSTRAINT name_nn NULL,
        nalja DATE DEFAULT SYSDATE,
        email VARCHAR2(50) CONSTRAINT email_nn  NULL,
        subject VARCHAR2(50) CONSTRAINT subject_nn  NULL,
        content VARCHAR2(100) CONSTRAINT content_nn  NULL,
        check_num NUMBER(5),
        password VARCHAR2(10) CONSTRAINT password_nn  NULL    
);

delete from board where numb = 1;

rollback;

select numb from board;

delete from board
where name = '김현준';

select * 
from board 

commit;

INSERT INTO board 
VALUES (1, '한라산', '2024-03-15', 'admin@gmail.com', '산악회 행사 안내', '2024년 4월 1일 한라산 등반 일정 공지합니다', 4, 1234);
INSERT INTO board 
VALUES (2, '지리산', '2024-03-16', 'admin@gmail.com', '직원 야유회 일정', '신입 직원 환영회 개최 안내', 3, 1234);
INSERT INTO board 
VALUES (3, '월출산', '2024-03-17', 'admin@gmail.com', '연말정산 제출', '2023년 연말정산 정부서류 제출 기한 안내', 3, 1234);
INSERT INTO board 
VALUES (4, '무등산', '2024-03-18', 'admin@gmail.com', '휴일 근무자 편성', '2024년 4월 휴일근무자 편성 안내', 4, 1234);


CREATE SEQUENCE seq_num
  START WITH 5  -- 시작 값
  INCREMENT BY 1  -- 증가 값
  MINVALUE 1  -- 최소 값
  MAXVALUE 99999999;  -- 최대 값



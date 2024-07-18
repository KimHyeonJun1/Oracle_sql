-- 부록. 데이터 모델링

-- I. 정의
-- 데이터 + 모델링 ==> 데이터를 저장하는 공간(=테이블)의 설계 과정
-- 요구사항 분석 ==> 처리 과정  vs  실수 + 데이터 삽입 ==> 갈아 엎는?
-- ※ 데이터 모델링은 조직의 정보 수집과 관리 시스템을 정의하는 시각적 표현 또는 청사진을 생성하는 프로세스입니다.

-- II. 도구
-- 1.SQL Modeler vs SQL Developer : Developer 에 탑재되어 있음.  [보기 > Data Modeler > 브라우저 > 디자인 > 우클릭, 새 디자인]
-- 2.draw.io : 요구사항 확인 --> 분석한 결과 --> 시각화 하는 도구, 다양한 다이어그램을 직접 그려볼 수 있는 UI를 제공(무료)
-- 3.eraser.io : AI 설계(diagramGPT) - 문자열로 설계 요구사항을 입력하면, 다이어그램 + SQL 문장 제공 (무료, 총 다이어그램 5개까지)
-- 4.erd cloud : 온라인, 구글계정 회원가입, 무료사용 ==> 저장 & 검색 | 
-- 5.erdMaster : Eclipse 확장기능 ==> 버전이 오래되었으나, 대학교 전공수업등에서 활용 ==> 궁금하면 써보세요! (무료,오픈소스)
-- 그밖에 여러 유료/무료/클라우드 도구 + 요즘에는 AI로 클라우드 서비스에서 직접 모델링을 제공 (=supabase vs firebase : NoSQL)


-- 모델링 예시) 도서회원 관리 프로그램
-- erdcloud.com : https://www.erdcloud.com/d/9mGtqMrBNgy4TDmjw
-- 주제영역 : 공공 도서관의 도서와 회원에 대한 관리 프로그램 (모든 업무가 아닌 핵심 엄무!)
-- 메인 엔터티 : 도서(책), 회원
-- 액션 엔터티 : 대출정보 (엔터티간의 관계에 따라서 생성되는 엔터티)
-- 모델링 과정 : 개념 모델링 -> 논리 모델링 -> 물리 모델링  vs (실제로는 개념+논리 모델링 -> 물리 모델링)
-- 식별자 : 오라클 예약어(a.k.a 자료형) 사용시 오류 발생!!
CREATE TABLE book (
    isbn VARCHAR2(18) CONSTRAINT book_isbn_pk PRIMARY KEY,
    title VARCHAR2(100) CONSTRAINT book_title_nn NOT NULL,
    sub_title VARCHAR2(80),
    author VARCHAR2(30) CONSTRAINT book_author_nn NOT NULL,
    publisher VARCHAR2(50) CONSTRAINT book_publisher_nn NOT NULL,
    price NUMBER(8) CONSTRAINT book_price_nn NOT NULL,
    pub_date DATE DEFAULT SYSDATE,
    status CHAR(1) DEFAULT '1'
);

CREATE TABLE citizen (
    id VARCHAR2(50) CONSTRAINT citizen_id_pk PRIMARY KEY,
    name VARCHAR2(50) CONSTRAINT citizen_name_nn NOT NULL,
    phone VARCHAR2(11) CONSTRAINT citizen_phone_nn NOT NULL,
    address VARCHAR2(100) CONSTRAINT citizen_address_nn NOT NULL,
    email VARCHAR2(100),
    created_at DATE DEFAULT sysdate
);
-- 식별 관계, 관계를 맺는 테이블의 외래키를 PK로 지정할때
CREATE TABLE checkout (
    isbn VARCHAR2(18) CONSTRAINT book_pk REFERENCES book(isbn),
    id VARCHAR2(50) CONSTRAINT citizen_pk REFERENCES citizen(id),
    in_date DATE DEFAULT sysdate,
    out_date DATE,
    CONSTRAINT checkout_pk PRIMARY KEY (isbn, id)
);

-- 비식별 관계, 인위적인 대출일련번호 사용시
CREATE TABLE checkout2 (
    no VARCHAR2(20) CONSTRAINT checkout2_no_pk PRIMARY KEY,    
    isbn VARCHAR2(18) CONSTRAINT book_isbn_fk REFERENCES book(isbn),
    id VARCHAR2(50) CONSTRAINT citizen_id_fk REFERENCES citizen(id),
    in_date DATE DEFAULT sysdate,
    out_date DATE
);


--온라인 상품 만개 관리 시스템(가칭)

--items 테이블
CREATE TABLE items (
    item_no NUMBER(4) CONSTRAINT items_no_pk PRIMARY KEY,
    item_title VARCHAR2(100) CONSTRAINT items_title_nn NOT NULL,
    item_price NUMBER(8) CONSTRAINT items_price_nn NOT NULL,
    item_recepit DATE DEFAULT SYSDATE
);

--items 샘플데이터
INSERT INTO items 
VALUES (1, '참이슬', 1650, '24/07/08');
INSERT INTO items 
VALUES (2, '처음처럼', 1700, '24/07/01');
INSERT INTO items 
VALUES (3, '청하', 2000, '24/07/09');
INSERT INTO items 
VALUES (4, '잎새주', 1600, '24/07/04');

select * from items;

CREATE TABLE users (
    id VARCHAR2(50) CONSTRAINT users_id_pk PRIMARY KEY,
    name VARCHAR2(30) CONSTRAINT users_name_nn NOT NULL,
    address VARCHAR2(120) CONSTRAINT clients_address_NN NOT NULL,
    email VARCHAR2(100),
    phone VARCHAR2(11)
);

INSERT INTO users
VALUES ('users1', 'users1', '광주 서구', 'users1@naver.com', '01012345678');
INSERT INTO users
VALUES ('users2', 'users2', '광주 북구', 'users2@naver.com', '01098765432');



CREATE TABLE salese (
    sales_no NUMBER(4) CONSTRAINT salese_no_pk PRIMARY KEY,
    shipping_date DATE DEFAULT SYSDATE,
    sales_count NUMBER(4) DEFAULT 1,
    client_no NUMBER(4) CONSTRAINT sale_item_fk REFERENCES items(item_no),
    user_id VARCHAR2(50) CONSTRAINT sale_user_fk REFERENCES users(id)
    
);

INSERT INTO salese
VALUES (1, SYSDATE, 10, 2, 'users1');

INSERT INTO salese
VALUES (2, SYSDATE, 10, 3, 'users1');

INSERT INTO salese
VALUES (3, SYSDATE, 10, 1, 'users2');

select * from salese;

select * from items;

select * from users;







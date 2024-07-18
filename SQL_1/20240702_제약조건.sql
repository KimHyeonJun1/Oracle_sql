-- 14장. 제약조건
-- 테이블에 데이터를 저장할때, 데이터 무결성(정확성, 일관성 보장)을 지키기 위한 원칙
-- ※ 제약 조건에 부합하지 않는 데이터를 저장할 수 없다.
-- ※ 제약 조건 지정 방식에 따라 데이터 수정, 삭제 가능 여부도 영향을 받음.
-- ※ 제약조건은 (1)컬럼 레벨   (2)테이블 레벨 에서 정의하거나, 테이블 생성후 ALTER 명령으로 제약조건을 추가/수정/삭제 할수 있다.


-- 1) NOT NULL : 지정한 열에 NULL 허용하지 않음, NULL 제외한 중복값은 허용
--    └ 회원 정보중, 회원 이름에 NULL 허용하지 않음

-- 2) UNIQUE : 지정한 열에 유일한 값(=중복x), NULL은 허용
--    └ 사원 정보중, 사원의 번호는 중복되지 않도록 입력

-- 3) PRIMARY KEY : 지정한 열에 유일한 값이면서 NULL 허용하지 않음. PK는 테이블에 하나만 지정 가능
--    └ 사번, 주민번호, 학번은 유일하고 NULL은 허용되지 않아야 함

-- 4) FOREIGN KEY : 다른 테이블의 열을 참조하면서 존재하는 값만 입력 허용
--    └ 사원 데이터 입력시, 사원의 부서가 존재하는 부서여야 데이터가 입력 허용
--    식별/비식별 관계 : 두 테이블이 관계를 맺을 때, 연관된 테이블의 PK가 식별자로 사용되면 식별, 아니라면(일반속성) 비식별 관계

-- 5) CHECK : 설정한 조건식을 만족하는 데이터만 입력 허용
--    └ 사원 정보 입력시 급여가 최저급여 이상 입력되도록 허용
-- ==============================================================================================
-- ※ 제약 조건은 데이터 정의어(DDL)에서 활용합니다
-- ==============================================================================================
/* 
< ACID 원칙 >

- 원자성(Atomicity) : 트랜잭션은 분해가 불가능한 최소의 단위인 하나의 원자처럼 동작한다는 의미 (all or noting)
- 일관성(Consistency) : 트랜잭션 작업이 종료된 후에도 일관성 있는 데이터 베이스 상태를 유지해야한다.
- 고립성(Isolation) : 하나의 트랜잭션이 완료될 때까지는 현재 실행 중인 트랜잭션의 중간 수행결과를 다른 트랜잭션에서 보거나 참조 할 수 없다
- 지속성(Durability) :  트랜잭션 완료 후 통지를 사용자가 받는 시점에서 그 조작이 영구적이 되어 그 결과를 잃지 않는 것을 나타낸다

< 데이터 무결성 >
- 영역 무결성(domain integrity) : 열에 저장된 값의 적정 여부, 자료형, 형식, NULL 여부등 정해놓은 범위를 만족하는 데이터임을 규정
- 개체 무결성(entity integrity) : 테이블의 데이터를 유일하게 식별하는 기본키를 반드시 갖고 있으며 NULL일수 없고 중복일수 없는 규정
- 참조 무결성(referential integrity) : 참조 테이블의 외래키 값은 참조하는 테이블의 기본키로 존재하며 NULL은 가능
*/

-- =============================================================================
-- p.362 빈 값을 허용하지 않는 NOT NULL
-- =============================================================================
-- 특정 열에 데이터의 중복 여부와 상관없이 NULL 저장을 허용하지 않는 제약조건
-- ※ 특정 열에 값이 반드시 존재해야하는 경우에 지정

-- TABLE_NOTNULL 이라는 테이블을 생성하면서 NOT NULL 지정하기
--1) 테이블 생성
CREATE TABLE members (
    login_id VARCHAR2(20) NOT NULL, -- I.제약조건 정의 : 컬럼 레벨에서
    login_pw VARCHAR2(20) NOT NULL,
    tel VARCHAR2(20)
    -- II.제약조건 정의 : 테이블 레벨
);

-- III. 제약조건 정의 : 객체 생성 이후
--ALTER TABLE memebrs
--ADD CONSTRAINTS 컬럼 제약조건

--2) 데이터 입력 : NULL 허용 x
INSERT INTO members 
VALUES ('guest1', 'password1', '062-362-7797');

INSERT INTO members 
VALUES ('', 'password2', '062-362-7798');

INSERT INTO members 
VALUES ('guest2', null, '062-362-7798');
--ORA-01400: NULL을 ("HANUL"."MEMBERS"."LOGIN_ID") 안에 삽입할 수 없습니다

--2) 데이터 입력 : 중복값 허용 o
INSERT INTO members 
VALUES ('guest1', 'password1', '062-362-7798');

SELECT *
FROM    members;

--3) 데이터 변경 : NULL 허용 x
UPDATE members
SET login_id = ''
WHERE   tel = '062-362-7798';

UPDATE members
SET login_pw = NULL
WHERE   tel = '062-362-7798';
-- ORA-01407: NULL로 ("HANUL"."MEMBERS"."LOGIN_ID")을 업데이트할 수 없습니다.
-- ORA-01407: NULL로 ("HANUL"."MEMBERS"."LOGIN_PW")을 업데이트할 수 없습니다



-- 사용자 테이블의 제약조건 확인
SELECT  owner, constraint_name, constraint_type, table_name
FROM    user_constraints;

DESC emp_temp2;

-- =============================================================================
-- 제약조건 종류      (제약조건 작명시 약어: Suffix / 접미어: 단어의 뒤에 오는 단어)
-- C : CHECK, NOT NULL ---> CK, NN
-- U : UNIQUE          ---> UK
-- P : PRIMARY KEY     ---> PK
-- R : FOREIGN KEY     ---> FK
-- (Relation: 관계 --> 수직관계, 종속관계, 부모-자식 관계)
-- ※ SYS_C00XXXXX 등의 이름 : 시스템이 자동으로 제약조건의 이름을 네이밍
-- 만약, 개발자가 제약조건을 작명한다면? ex.login_id_nn : login_id 컬럼은 NOT NULL
-- =============================================================================

-- p.365 제약조건 이름 정하기
CREATE TABLE clients (
    login_id VARCHAR2(20) CONSTRAINT members_id_nn NOT NULL, -- 제약조건 : SYS_C00XXXX 으로 자동으로 지정
    login_pw VARCHAR2(20) CONSTRAINT members_pw_nn NOT NULL,  -- II.제약조건 정의 : 테이블 레벨
    tel VARCHAR2(20)    
);

SELECT owner, constraint_name, constraint_type, table_name
FROM    user_constraints
WHERE table_name = 'CLIENTS';



-- =============================================================================
-- p.370 중복되지 않는 값 UNIQUE
-- =============================================================================
-- 유니크 vs 레어 : Unique(유니크)는 '유일무이한' 정도의 의미를 지니고 있어서, 유니크 쪽이 Rare(레어)보다 훨씬 더 희귀함을
-- 강조
-- ※ 컬럼에 저장할 데이터 중복을 허용하지 않고자 할 때 사용함. (NULL은 허용)
-- ※ 일반적으로 NOT NULL + UNIQUE ==> PRIMARY KEY : 중복 허용 x, NULL 허용 x

-- 실습14-14. 제약조건 테이블 생성
CREATE TABLE TABLE_UNIQUE (
    login_id VARCHAR2(20) UNIQUE, -- 컬럼 레벨에서 제약조건 지정
    login_pw VARCHAR2(20) NOT NULL, -- UNIQUE: 중복 허용x, NULL 허용   vs  NOT NULL : 중복 허용o, NULL 허용 x
    tel VARCHAR2(20)
);
--Table TABLE_UNIQUE이(가) 생성되었습니다.

INSERT INTO table_unique 
VALUES ('guest1','password1','062-362-7797');
--1 행 이(가) 삽입되었습니다.

INSERT INTO table_unique 
VALUES ('guest1','password1','062-362-7797');
-- ORA-00001: 무결성 제약 조건(HANUL.SYS_C008394)에 위배됩니다

SELECT *
FROM    user_constraints
WHERE   table_name = 'TABLE_UNIQUE';

INSERT INTO table_unique 
VALUES ('','password2','062-362-7798');
-- 1 행 이(가) 삽입되었습니다.

SELECT *
FROM    table_unique;

INSERT INTO table_unique 
VALUES (NULL,'password3','062-362-7795');

-- 1 행 이(가) 삽입되었습니다

INSERT INTO table_unique 
VALUES ('guest1','password1','062-362-7795');

-- ORA-00001: 무결성 제약 조건(HANUL.SYS_C008394)에 위배됩니다

-- 입력 확인 : 중복 허용 x
-- 수정 확인 : 기존 데이터와 변경할 데이터가 중복되면 ==> 제약조건 위배

UPDATE  table_unique
SET     login_id = 'guest1'
WHERE   login_pw = 'password2';
-- ORA-00001: 무결성 제약 조건(HANUL.SYS_C008394)에 위배됩니다


-- p.374 이미 생성한 테이블에 제약 조건 추가(지정)
-- 실습 14-23. table_unique의 TEL 컬럼에 UNIQUE 제약조건 추가
-- ※ 기존 데이터가 이미 중복이 발생한 상태라면?
ALTER TABLE table_unique
MODIFY (TEL UNIQUE);

-- ORA-02299: 제약 (HANUL.SYS_C008395)을 사용 가능하게 할 수 없음 - 중복 키가 있습니다
SELECT *
FROM    table_unique;

TRUNCATE TABLE table_unique; -- 테이블의 데이터를 모두 삭제

-- 다시 제약조건: UNIQUE 추가
ALTER TABLE table_unique
MODIFY (TEL UNIQUE);

INSERT INTO table_unique
VALUES ('guest1','password1','062-1234-5678');

INSERT INTO table_unique
VALUES ('guest1','password2','062-1234-5672');
--ORA-00001: 무결성 제약 조건(HANUL.SYS_C008394)에 위배됩니다

INSERT INTO table_unique
VALUES ('guest2','password2','062-1234-5678');
--ORA-00001: 무결성 제약 조건(HANUL.SYS_C008396)에 위배됩니다

-- p.375 제약조건 이름 직접 지정하기 : 이미 생성된 테이블 
CREATE TABLE TABLE_UNIQUE2   (
    login_id VARCHAR2(20) CONSTRAINT TBL_UNIQ_ID_UK UNIQUE, -- 컬럼 레벨에서 제약조건 지정
    login_pw VARCHAR2(20) NOT NULL, -- UNIQUE: 중복 허용x, NULL 허용   vs  NOT NULL : 중복 허용o, NULL 허용 x
    tel VARCHAR2(20)
);

SELECT  constraint_name, constraint_type
FROM   user_constraints
WHERE   table_name = 'TABLE_UNIQUE2';

INSERT INTO table_unique2
VALUES ('guest1','password1','tel1');

INSERT INTO table_unique2
VALUES ('guest1','password1','tel1');

-- p.376 제약 조건 삭제
-- 관례상, 테이블이름_컬럼이름_제약조건약어 ==> TBL_ID_UK..다양하게!
ALTER TABLE table_unique2
DROP CONSTRAINT TBL_UNIQ_ID_UK;
-- Table TABLE_UNIQUE2이(가) 변경되었습니다.


-- =============================================================================
-- p.377 PRIMARY KEY : 유일하게 하나의 값만 존재 (중복 허용 x, NULL 허용 x)
-- PRIMARY KEY = NOT NULL + UNIQUE ==> 사원번호, 주민등록번호, 제품ID, ...자동차 번호
-- ※ 테이블 각 행(Row ==> Data)
-- (1) 테이블에는 PK를 하나가 반드시 존재해야 함
-- (2) PK가 지정된 컬럼은 자동으로 인덱스가 생성됨
-- PK : 유일한 식별자 <--- 후보키(Candidate Key), 인조키(인위적으로 조합된), 슈퍼키


-- 1) 테이블 생성 하면서 PK 정의 - 임의로 정의 or 작명
CREATE TABLE table_pk (
    login_id VARCHAR2(20) PRIMARY KEY,
    login_pw VARCHAR2(20) NOT NULL,
    tel VARCHAR2(20)
);

SELECT *
FROM    user_constraints
WHERE table_name = 'TABLE_PK';


INSERT INTO table_pk
VALUES ('guest1','password1','tel1');

INSERT INTO table_pk
VALUES ('guest1','password1','tel1');
-- ORA-00001: 무결성 제약 조건(HANUL.SYS_C008400)에 위배됩니다

INSERT INTO table_pk
VALUES (NULL,'password1','tel1');
-- ORA-01400: NULL을 ("HANUL"."TABLE_PK"."LOGIN_ID") 안에 삽입할 수 없습니다

-- 2) 이미 생성된 테이블에 PK 추가
-- SYS_C008400 : 시스템이 자동으로 제약조건명을 작명 ==> 일련번호 형태로..
-- 개발자/DBA 생성 ==> 테이블명_컬럼명_제약조건약어 형태로!!

-- 이미 생성된 테이블의 제약조건명 변경
ALTER TABLE table_pk
RENAME CONSTRAINT SYS_C008400 TO pktbl_id_pk;
--ADD CONSTRAINT 컬럼 제약조건명
--DROP CONSTRAINT 제약조건명

-- ALTER TABL MODIFY 컬럼 제약조건 : 이미 생성된 테이블에 PK를 추가(수정)
-- ORA-02260: 테이블에는 하나의 기본 키만 가질 수 있습니다.


-- 3) 테이블의 제약조건을 수정/ 삭제
ALTER TABLE table_pk
DROP CONSTRAINT PKTBL_ID_PK;
-- Table TABLE_PK이(가) 변경되었습니다.

SELECT constraint_name, constraint_type, owner
FROM    user_constraints
WHERE   table_name = 'TABLE_PK';

-- SYS_C008399	C	HANUL

INSERT INTO  table_pk
VALUES ('guest1', 'password1', 'tel1');

SELECT *
FROM    table_pk;

ALTER TABLE table_pk
MODIFY login_id CONSTRAINT pktbl_id_pk PRIMARY KEY;

-- ORA-02437: (HANUL.PKTBL_ID_PK)을 검증할 수 없습니다 ==> 이미 중복된 데이터 존재

TRUNCATE TABLE table_pk;

INSERT INTO  table_pk
VALUES ('guest1', 'password1', 'tel1');

-- ORA-00001: 무결성 제약 조건(HANUL.PKTBL_ID_PK)에 위배됩니다


-- =============================================================================
-- p.382 다른 테이블과 관계를 맺는 FOREIGN KEY
-- 외래 키, 외부키 ==> 서로 다른 테이블 간 관계(식별관계 vs 비식별관계)
-- ※ 특정 테이블에서 PK 제약조건을 지정한 컬럼을 다른 테이블의 특정 컬럼에서 참조하겠다는 의미
-- ※ 사원-부서 테이블 : 사원 정보 등록할 때 부서 테이블의 부서코드(PK)를 참조하겠다 ==> 존재하는 부서에 사원 등록!
-- HR로 변경, 임의의 사원을 등록
DESC employees;
INSERT INTO employees (employee_id, last_name, email, hire_date, job_id, department_id)
VALUES (employees_seq.NEXTVAL, 'SEON', 'SEONYEONGHUN', SYSDATE, 'SA_MAN', 50);

INSERT INTO employees (employee_id, last_name, email, hire_date, job_id, department_id)
VALUES (employees_seq.NEXTVAL, 'KIM', 'SEONWOO', SYSDATE, 'SA_REP', 270);

INSERT INTO employees (employee_id, last_name, email, hire_date, job_id, department_id)
VALUES (employees_seq.NEXTVAL, 'KIM', 'SEONWOO', SYSDATE, 'SA_REP', 270);


-- 실습 14-37. 제약조건 확인 (EMP, DEPT)

SELECT  constraint_name, constraint_type, r_owner, r_constraint_name
FROM    user_constraints
WHERE   table_name IN ('EMPLOYEES', 'DEPARTMENTS')
ORDER BY 1;


-- p.384 FOREIGN KEY 지정하기
-- HANUL 계정으로 실습
-- DEPT_FK : hr.departments
-- EMP_FK : hr.employees

-- 1) 테이블 생성과 동시에 제약조건 추가
CREATE TABLE 테이블명 (
컬럼명1 자료형(길이) 제약조건, -- SYS_C0XXXX 으로 제약조건을 시스템이 작명
컬럼명2 자료형(길이) CONSTRAINT 제약조건명 제약조건,
...계속..
-- 테이블 레벨에서 정의
컬럼 자료형 CONSTRAINT 제약조건명 REFERENCES 참조테이블(참조컬럼명)
);

CREATE TABLE dept_fk (
    deptno NUMBER(2) CONSTRAINT DEPTFK_DEPTNO_PK PRIMARY KEY,
    dname VARCHAR2(14) NOT NULL,
    loc NUMBER(4)
);

CREATE TABLE emp_fk (
    empno NUMBER(4) CONSTRAINT EMPFK_EMPNO_PK PRIMARY KEY,
    ename VARCHAR2(10),
    job VARCHAR2(9),
    mgr NUMBER(4),
    hiredate DATE,
    sal NUMBER(7,2),
    comm NUMBER(7,2),
    deptno NUMBER(2) CONSTRAINT empfk_deptno_fk REFERENCES dept_fk(deptno)
);

INSERT INTO dept_fk
VALUES (10, '총무부', 062);

INSERT INTO emp_fk 
VALUES (1000, '홍길동', '과장', NULL, SYSDATE, 3000, 0.05, 10);
-- ORA-02291: 무결성 제약조건(HANUL.EMPFK_DEPTNO_FK)이 위배되었습니다- 부모 키가 없습니다
-- 부서 데이터 먼저 등록한 뒤 다시 재시도!

INSERT INTO dept_fk
VALUES (20, '물류부', 061);

INSERT INTO emp_fk 
VALUES (1001, '김선우', '사원', 1000, SYSDATE, 2500, 0.01, 10);

ROLLBACK;
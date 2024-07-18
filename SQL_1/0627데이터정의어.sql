-- 12. 데이터 정의어

-- DQL : SELECT
-- DML :
-- DDL (Data Definition Language, 데이터 정의 언어) : CREATE, ALTER, DROP
-- DCL 
-- TCL

-- ※  DBA 그룹 : Database Administrator 계정에 해당 --> 생성, 삭제, 수정, 변경이 자유롭다

--p.311 데이터 정의어 사용할때 유의점
-- ※ DML과 다르게 명령어를 수행하면 데이터베이스 수행한 내용이 바로 반영됩니다.
-- 예 ) DML : COMMIT, ROLLBACK으로 트랜잭션 제어 <----> DDL : 자동 COMMIT (영구적으로 변경)
-- ※ DDL 사용시 ROLLBACK을 통한 실행 취소가 불가능함


--=======================================================================================
--12-1) CRATE : 데이터베이스 객체 생성
--=======================================================================================
CREATE TABLE 소유 계정.테이블 이름(
        열1이름 열1자료형,
        열2이름 열2자료형,
        ...
        열N이름 열N자료형
        )
테이블 이름 생성 규칙
--1) 테이블 이름은 문자로 시작(한글 가능)
--2) 테이블 이름은 30byte (18c 기준, 21c는 조금더? 허용)
--3) 같은 사용자 소유의 테이블 이름은 중복될 수 없다.
--4) 테이블 이름은 영문자(한글 가능), 숫자(0~9), 특수문자 $, #, _ 를 사용할 수 있다.
--5) SQL 키워드는 테이블 이름으로 사용할 수 없다. (ex. SELECT, FROM...예약어)

-- 열 이름 생성 규칙
--1) 열 이름은 문자로 시작해야 한다.
--2) 열 이름은 30byte 이하여야 한다.
--3) 한 테이블의 열 이름은 중복될 수 없다.
--4) 열 이름은 영문자(한글 가능), 숫자(0~9), 특수문자 $, #, _ 를 사용할 수 있다.
--5) SQL 키워드는 열 이름으로 사용할 수 없다. (ex. SELECT, FROM,... 예약어)

-- 오라클 데이터베이스 자료형
-- 숫자, 문자, 날짜 <---> NUMBER, VARCHAR2, DATE 자료형
-- 1) NUMBER : INT, FLOAT, DOUBLE, TINYINT, ... 오라클 내부에서는 NUMBER로 적용
-- ※ (바이트 길이 | 문자길이)를 지정하지 않으면 최대 4000byte 까지 저장
-- NUMBER(m, n) : 전체 길이 m, 소수부 길이 n (정수부 길이 : m - n)
-- 2) VARCHAR2 : String, char ... 오라클 내부에서는 VARCHAR2로 적용
-- ※ VARCHAR는 오라클이 사용하는 용도
-- CHAR : [고정길이 문자열 자료형]    vs  VARCHAR2[가변길이 문자열 자료형]

-- 3) DATE : 날짜 자료형
-- ※ TO_DATE()를 사용하지 않아도~ DATE로 정의된 컬럼의 데이터는 날짜 형태(YY/MM/DD, RR-MM-DD)로 암시적 형변환 진행됨
-- 문자 데이터, 날짜 데이터는 ' (Single Quote) 처리

-- 4) OBJECT : Character, Binary, FILE 형태 자료형
-- 내부 오브젝트 : CLOB, BLOB [2GB 이상]
-- 외부 오브젝트 : BFILE, BTEXT --> 참조 자료형[4GB 이상]


-- p.313 실습 12-1. 자료형을 각각 정의하여 새 테이블 만들기
-- 새 테이블 만들기 : 직접 or CTAS : 구조 만 or 구조 + 데이터 복사
-- EMP_DDL, 사번/이름/업무/담당 매니저/이바일/월급여/수수료/부서번호를 저장하는 테이블 생성
-- ※ 데이터베이스 객체는 소문자로 작성 ==> 오라클 엔진이 내부적으로 대문자로 저장. 꼭 소문자 저장을 원하면 ""Double Quote처리

CREATE TABLE emp_ddl (
         empno NUMBER(4),
         ename VARCHAR(10),
         job    VARCHAR(9),
         mgr    NUMBER(4),
         hiredate DATE,
         sal    NUMBER(7,2),
         comm   NUMBER(7, 2),
         deptno NUMBER(2)
         
);
--Table EMP_DDL이(가) 생성되었습니다.

--p.314 기존 테이블 열 구조와 데이터를 복사하여 새 테이블 만들기 : CTAS
CREATE TABLE dept_ddl AS
SELECT  department_id, department_name, location_id
FROM    hr.departments;

DESC dept_ddl;

SELECT  *
FROM    dept_ddl;

-- p.315 기존 테이블 열구조와 일부 데이터만 복사하여 새 데이터 만들기 : CTAS + WHERE 조건절

CREATE TABLE emp_ddl_30 AS
SELECT  *
FROM    hr.employees
WHERE   department_id = 30;

-- p.314 기존 테이블의 열 구조만 복사하여 새 테이블 저장하기
CREATE TABLE empdept_ddl AS
SELECT  e.employee_id, e.first_name, e.salary, e.job_id,
        d.department_name
FROM    hr.employees e, hr.departments d;        
WHERE   1<>1;

SELECT  *
FROM    user_tables;

desc user_tables;

-- 14장에 제약조건을 이용해 각 컬럼에 저장할 데이터를 제한할 수 있다. (ex 급여는 월 2000이상이 되게 제한)


--=======================================================================================
--12-2) ALTER : 데이터베이스 객체 수정
--=======================================================================================
-- 이미 생성된 오라클 데이터베이스 객체(대표: 테이블)를 변경(=수정)할때 사용합니다.
-- ex. 새 컬럼 추가, 삭제 또는 컬럼의 자료형, 길이를 변경하는 작업

--1) ADD 추가할 열 이름 (자료형/바이트 길이) : 새 컬럼 추가
--ALTER TABLE 테이블 명
-- ADD 열 이름 자료형(바이트길이);

CREATE TABLE emp_alter AS
SELECT  *
FROM    hr.employees;

SELECT  *
FROM    emp_alter;

--HP라는 가변길이문자(20바이트) 열을 추가하시오
ALTER   TABLE emp_alter
ADD HP VARCHAR2(20);
--Table EMP_ALTER이(가) 변경되었습니다. --다 NULL

--2) RENAME : 열 이름을 변경하는 명령어
-- RENAME COLUMN 열이름1 TO 열이름2;

-- 실습 12-8. HP라는 컬럼을 TEL이라는 이름으로 변경
ALTER TABLE emp_alter
RENAME COLUMN hp to tel;
-- Table EMP_ALTER이(가) 변경되었습니다.


-- 3) MODIFY : 열의 자료형을 변경하는 명령
-- MODIFY 열 이름 자료형(바이트 길이)
-- ※ 데이터가 이미 있는 테이블에서 바이트 길이 수정할때 더 큰값은 문제없으나, 축소하려고 하면 에러발생
ALTER TABLE emp_alter
MODIFY employee_id NUMBER(4);
--ORA-01440: 정도 또는 자리수를 축소할 열은 비어 있어야 합니다/ 

--4) DROP : 특정 열을 삭제하는 명령
-- DROP COLUMN 컬럼명;
-- ※ RENAME COLUMN 컬럼명;

DESC    emp_alter;

-- DDL : DML과 다르게 자동으로 COMMIT ==> 물리적으로 저장장치(HDD, SSD) 영구 변경 확정되는 명령
ROLLBACK; --안됨


--TEL 컬럼
ALTER TABLE emp_alter
DROP COLUMN manager_id;
-- Table EMP_ALTER이(가) 변경되었습니다.

--=======================================================================
-- RENAME : 테이블의 이름을 변경하는 명령
-- RENAME 이전 테이블명 TO 이후 테이블명;
--=======================================================================

--실습 12-13. EMP_ALTER 테이블을 EMP_RENAME 으로 변경
RENAME emp_alter TO emp_rename;


RENAME emp_rename TO emp_ddl;
--======================================================================
--ORA-00955: 기존의 객체가 이름을 사용하고 있습니다
-- RENAME 명령 사용시, 중복되지 않도록 변경할 테이블명을 봐야함
--=====================================================================

--=====================================================================
-- 12-5) TRUNCATE : 테이블의 데이터를 삭제하는 명령어
-- DELETE VS TRUNCATE 차이 - COMMIT,PRLLBACK vs 자동 COMMIT
-- TRUNCATE TABLE 테이블 명;
--=====================================================================
-- p.322 실습 12-14 EMP_RENAME 테이블 전체 데이터 삭제하기 : 구조는 남고, 데이터는 모두 삭제
SELECT *
FROM    emp_rename;

TRUNCATE TABLE emp_rename;
-- Table EMP_RENAME이(가) 잘렸습니다.
ROLLBACK;
--롤백 완료.
SELECT  *
FROM    emp_rename;
--※ 삭제 후 복구가 되지 않기때문에, TRUNCATE 명령어 사용시 주의!!
-- 오라클 함수 :                    TRUNC 함수 - 숫자 데이터, 날짜 데이터(포맷팅 양식 필요) 


--=======================================================================================
--12-3) DROP : 데이터베이스 객체 삭제
-- DROP TABLE 테이블 명;
--=======================================================================================
-- ※ 데이터베이스객체중 테이블(Table)이 가장 많이 사용된다 ==> 데이터 보관, 관리하는 용도
DROP TABLE emp_rename;
--Table EMP_RENAME이(가) 삭제되었습니다.
-- 휴지통에서 복구(FLASHBACK) 할 수 있음
-- 완전히 삭제하려면 DROP TABLE emp_rename PURGE ==> DROP TABLE 테이블명 PURGE, 완전히 삭제 = PURGE

DROP TABLE emp_rename PURGE;
--Table EMP_RENAME이(가) 삭제되었습니다.

--Q1. EMP_HW 테이블을 교재를 참고해서 생성
CREATE TABLE emp_hw(
    empno NUMBER(4),
    ename VARCHAR2(10),
    job VARCHAR2(9),
    mgr NUMBER(4),
    hiredate DATE,
    sal NUMBER(7,2),
    comm NUMBER(7,2),
    deptno NUMBER(2)
    );
--Table EMP_HW이(가) 생성되었습니다

-- Q2. EMP_HW 테이블에 BIGO 열을 추가, BIGO는 가변문자 20바이트
ALTER TABLE emp_hw
ADD bigo VARCHAR2(20);

SELECT *
FROM    emp_hw;

--Q3. emp_hw테이블의 BIGO 열의 크기를 30바이트로 변경
ALTER TABLE   emp_hw
MODIFY bigo VARCHAR2(30);
-- Table EMP_HW이(가) 변경되었습니다
DESC    emp_hw;
--이름       널? 유형 
--BIGO        VARCHAR2(30)         

--04. EMP_HW 테이블의 BIGO 열을 REMARK로 변경하세요 
ALTER TABLE emp_hw       
RENAME COLUMN bigo TO remark;
--DROP COLUMN 컬럼명;
--Table EMP_HW이(가) 변경되었습니다.

--Q5. EMP_HW 테이블에 EMP 테이블의 데이터를 모두 저장해보세요, 단 REMARK 열은 NULL로 삽입합니다.
INSERT INTO emp_hw (empno, ename, job, mgr, hiredate, sal, comm, deptno)
VALUES (7369, 'SWITH', 'CLERK', 7902, '1980-12-17', 800, NULL, 20);
-- 1 행 이(가) 삽입되었습니다.
INSERT INTO emp_hw (empno, ename, job, mgr, hiredate, sal, comm, deptno)
VALUES (7499, 'ALLEN', 'SALESMAN', 7698, '1981-02-20', 1600, 300, 30);
INSERT INTO emp_hw (empno, ename, job, mgr, hiredate, sal, comm, deptno)
VALUES (7521, 'WORD', 'SALESMAN', 7698, '1980-02-22', 1250, 500, 30);

SELECT *
FROM    emp_hw;
--Q6. 지금까지 사용한 emp_hw 테이블을 삭제해보세요
DROP TABLE emp_hw;
-- PURGE : 완전 삭제 (휴지통 거치지 않기)

--플래시백 명령어
FLASHBACK TABLE 테이블명 TO BEFORE DROP RENAME TO 복구시 변경할 테이블명;
        
        
        
        
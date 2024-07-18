-- p.266 셋째마당. 데이터를 조작, 정의, 제어하는 SQL 배우기

--SQL : Structured Query Language, 구조화된 질의어
-- PL/SQL : Procedural Language extension / SQL - SQL에 프로그래밍 문법을 적용
-- SQL 종류
-- 1) DQL : Data Query Language ==> SELECT
-- 2) DML : Data Manipulation Language ==> INSERT, UPDATE, DELETE
--          INSERT - 신규 테이블 생성(추가)
--          UPDATE
-- 3) DDL : Data Definition Language ==> CREATE, ALTER, DROP ==> 데이터베이스 객체 생성,수정,삭제
-- 4) DXL : Data Control Language ==> GRANT, REVOKE
-- 5) TCL : Transaction Control Language ==> COMMIT, ROLLBACK | TRUNK

-- 스키마 < -- > 계정 : 동일하게 취급하는 경우

--실습을 위한 사용자 계정 생성 : *SYSTEM 으로 로그인
-- 계정, 테이블, ...데이터베이스 객체 ==> 생성하는 명령 CREATE
-- ※ 오라클 12c 이후부터는 계정생성 규칙 c## 로 시작하도록 강제
-- 보안 규칙을 안화 ==> c##이 아닌, 아무 아이디로 정의할 수 있도록 설정을 임시로 변경
ALTER SESSION SET "_ORACLE_SCRIPT" = true;

--소문자 hanul ==> 실제 DB에서는 HANUL 로 저장된다.
-- 꼭 소문자로 생성하려면 "로 묶어서 실행
CREATE USER hanul IDENTIFIED BY 0000;

-- 계정이 있어도 권한(Previlege)없으면 작업할 수 없다 ==> 로그인도 안됨..
-- 교재 15장에 사용자 권한, 롤에 대한 부분이 있음
-- connect : 접속(로그인, 세션)
-- dba : 관리자 그룹
-- resource : 데이터에 접근 권한
GRANT connect, dba, create view, resource TO hanul;

--Session이(가) 변경되었습니다.
--
--User HANUL이(가) 생성되었습니다.
--
--Grant을(를) 성공했습니다.

--hanul 계정으로 실습을 진행

--p.266 테이블 생성하기

-- i. 테이블 명, 컬럼명, 자료형, 제약조건 정의
--CREATE TABLE 테이블명(
--컬럼명1 자료형 제약조건,
--컬럼명2 자료형 제약조건,
--...등등
-- )

-- ii. 테이블을 다른 테이블의 SELECT 된 데이터를 기준으로 생성( CTAS)
-- 1) 구조 + 데이터 복사

-- CREATE TABLE 테이블명 AS
-- SELECT 컬럼명1, 컬럼명2,...
--FROM  대상테이블
-- WHERE 조건절

-- 2) 구조만 복사
-- CREATE TABLE 테이블명 AS
-- SELECT 컬럼명1, 컬럼명2,...
-- FROM  대상테이블
-- WHERE 조건절(거짓)


--실습 10-1 1. departments 테이블을 복사해서 dept_temp 테이블을 생성
DESC hr.departments;

--이름              널?       유형           
----------------- -------- ------------ 
--DEPARTMENT_ID   NOT NULL NUMBER(4)    
--DEPARTMENT_NAME NOT NULL VARCHAR2(30) 
--MANAGER_ID               NUMBER(6)    
--LOCATION_ID              NUMBER(4)

--I. CTAS로 테이블 복사
-- 구조, 테이블 복사
CREATE TABLE dept_temp AS
SELECT  *
FROM    hr.departments;

DESC    dept_temp;
--이름              널?       유형           
----------------- -------- ------------ 
--DEPARTMENT_ID            NUMBER(4)    
--DEPARTMENT_NAME NOT NULL VARCHAR2(30) 
--MANAGER_ID               NUMBER(6)    
--LOCATION_ID              NUMBER(4)  

SELECT  *
FROM    dept_temp;

-- 2) 구조만 복사( 1>5은 거짓이기 때문에 구조만 복사)
CREATE TABLE dept_temp3 AS
SELECT  *
FROM    hr.departments
WHERE   1 > 5;

SELECT *
FROM    dept_temp3;

-- II.직접테이블을 생성
CREATE TABLE    dept_temp2 (
    department_id   NUMBER(4) NOT NULL,
    department_name VARCHAR2(30) NOT NULL,
    manager_id NUMBER(6),
    location_id NUMBER(4)
    );

SELECT  *
FROM    dept_temp2;



-- 테이블 생성하기 : (1) SQL 명령어 (2) GUI - 마우스 우클릭 > 테이블 생성..
-- 1-1) CTAS 구조 + 데이터 or 구조만
-- 1-2) CRATE TABLE 문장 ==> 테이블명, 컬럼명, 데이터 타입(길이), 제약조건 정의
-- ※ 가급적이면 SQL으로 작성해보고, 그래픽으로도 만들수 있다는걸 이해(sql developer)

--테이블 삭제
DROP TABLE dept_temp2;
Table DEPT_TEMP2이(가) 삭제되었습니다.

-- 1. dept.temp 테이블 생성
-- CTAS 활용
CREATE TABLE dept_temp AS
SELECT  *
FROM    hr.departments
WHERE   1>5;

DROP TABLE dept_temp PURGE;
--직접 생성
CREATE TABLE dept_temp(
        deptno NUMBER(4) NOT NULL,
        dname VARCHAR2(30) NOT NULL,
        loc VARCHAR2(20) NOT NULL
        );

-- 2. 샘플 데이터 추가 ( p.266 실습 10-2 참고)
-- INSERT INTO 테이블명 [(컬럼명1, 컬럼명2, ...)]
-- VALUES (값1, 값2, ...)
-- ※ 테이블의 컬럼순서대로 데이터 입력 ==> [(컬럼명1,...)]이 불필요
-- 10번 부서 ACCOUNTING NEW YORK 매니저 NYLL로 입력

INSERT INTO dept_temp
VALUES (10, 'ACCOUNTING', 'NEW YORK');
INSERT INTO dept_temp
VALUES (20, 'RESERCH', 'DALLAS');
INSERT INTO dept_temp
VALUES (30, 'SALES', 'CHICAGO');
INSERT INTO dept_temp
VALUES (40, 'OPERATIONS', 'BOSTON');

--조회
SELECT *
FROM    dept_temp;
--컬럼의 순서를 임의로 지정할때
INSERT INTO dept_temp (loc, dname, deptno)
VALUES ('GWANGJU', 'DEVELOPMENT', 50);

-- p.268 INSERT 문 오류가 발생하는 케이스
-- 지정한 열 갯수와 각 열에 입력할 데이터 갯수가 불일치 : SQL 오류: ORA-00913: 값의 수가 너무 많습니다
-- 자료형이 맞지 않거나 열 길이를 초과하는 데이터를 입력할 때 : SQL 오류: ORA-12899: "HANUL"."DEPT_TEMP"."DNAME" 열에 대한 값이 너무 큼
-- 그 밖에 제약조건을 위반했을떄 (NOT NULL --> NULL 값을 입력할 때) : SQL 오류: ORA-01400: NULL을 ("HANUL"."DEPT_TEMP"."DNAME") 안에 삽입할 수 없습니다

DESC dept_temp;

SELECT *
FROM    dept_temp;


INSERT INTO dept_temp
VALUES ('60', 'DATABASE', 'SEOUL', 'KIMHYEONJUN'); -- 3갠데 4개라 안들어감


INSERT INTO dept_temp
VALUES ('60', 'DATABASE', 'SEOUL');

INSERT INTO dept_temp
VALUES ('70', '간다라마바사아자차카타파하', 'SEOUL');

INSERT INTO     dept_temp
VALUES ('80', '', NULL);


--==============================================================
-- 테이블에 NULL 데이터 입력: 데이터가 확정되지 않았거나, 굳이 넣을 필요가 없는
-- 데이터인 경우
-- ※ 위 케이스가 아니라면, NULL은 잘못된 데이터일 가능성!!!(데이터 입력, 처리과정의 MISS)
-- 1) 명시적으로 NULL 또는 '' 를 입력하는 방법
-- 2) 대상 열을 생략해, 암시적으로 NULL이 입력되는 방법
--===============================================================

-- p. 272 EMP_TEMP 테이블 만들기
-- CTAS로 생성 : 구조 + 데이터 복사 or 구조만
-- 직접 생성

DESC hr.employees;

--이름             널?       유형           의미
---------------- -------- ------------ 
--EMPLOYEE_ID    NOT NULL NUMBER(6)         사원ID
--FIRST_NAME              VARCHAR2(20)      이름
--LAST_NAME      NOT NULL VARCHAR2(25)      성
--EMAIL          NOT NULL VARCHAR2(25)      이메일ID
--PHONE_NUMBER            VARCHAR2(20)      전화번호
--HIRE_DATE      NOT NULL DATE              입사일
--JOB_ID         NOT NULL VARCHAR2(10)      업무ID
--SALARY                  NUMBER(8,2)       월급여
--COMMISSION_PCT          NUMBER(2,2)       수수료율
--MANAGER_ID              NUMBER(6)         매니저ID
--DEPARTMENT_ID           NUMBER(4)         부서ID

-- as : ~처럼 ~만큼     
CREATE TABLE emp_temp AS
SELECT  *
FROM    hr.employees
WHERE   1<>1;

-- 직접
CREATE TABLE emp_temp2(
    empno NUMBER(4) PRIMARY KEY,
    ename VARCHAR2(50) NOT NULL,
    job VARCHAR2(30) NOT NULL,
    mgr NUMBER(4),
    hiredate DATE,
    sal NUMBER(6) NOT NULL,
    comm NUMBER(4),
    deptno NUMBER(4)
);    

--복사해온 emp_temp
INSERT INTO emp_temp
VALUES (00001, '길동', '홍', 'GILDONG', '82.062.362.7797', SYSDATE, 'ASSISTANT', 2000, NULL, 9999, 10);

INSERT INTO emp_temp
VALUES (00002, '보고', '장', 'BOGOBOGO', '82.062.830.8282', ADD_MONTHS(SYSDATE, -1), 'RESEARCH', 3000, NULL, 9999, 20);
-- emp_temp 의 컬럼이랑 일치해야함 갯수 위치. 



SELECT *
FROM    emp_temp;

-- 직접만든 emp_temp2
INSERT INTO emp_temp2
VALUES (9999, '홍길동', 'ACCOUNTANT', NULL, SYSDATE, 2500, 1000, 10);

SELECT *
FROM    emp_temp2;

--======================================================================
-- p. 273 날짜 데이터를 입력할 때 유의점 : 년/월/일 순서를 반대로 일/월/년 순서로
-- 입력하면 오류 발생되고 데이터가 입력되지 않음<--> 추가 제약조건 설정 필요

INSERT INTO emp_temp2
VALUES (8888, '이순신', 'ACCOUNTANT', NULL, '24/06/26', 2500, 1000, 10);

INSERT INTO emp_temp2
VALUES (7777, '강감찬', 'ANALYST', NULL, '26/06/24', 3500, 0, 30);

INSERT INTO emp_temp2
VALUES (6666, '장보고', 'GENERAL', NULL, '2026/06/24', 5500, 0, 40);

--p.278 INSER문에서 서브쿼리를 사용할 때 유의점
-- 1) VALUES 절은 사용하지 않는다.
-- 2) 데이터가 추가되는 테이블의 열 갯수와 서브쿼리의 열 갯수가 일치해야 한다.
-- 3)             "         "     자료형과 서브쿼리의 자료형이 일치해야 한다.

--p.275 서브쿼리를 사용하여 한번에 여러 데이터 추가하기
-- 오라클 조인 : 비등가 조인 (조인 조건이 =이 아닌 다른 연산자 : BETWEEN 등 을 사용하는 조인연산) ※ 거의 사용하지 않는다.
-- 서브쿼리 : SQL 문장안에 또다른 () 안에 SQL 문장
-- SALGRADE 없어서~ 사원테이블에서 5000~10000 사이의 급여를 받는 사원정보를 조회함

-- ITAS : 입력할 떄~ (다량의 데이터를 조회한 결과를 한꺼번에 저장)
-- CTAS : 생성할 때~ (테이블 생성시 조회된 결과를 복샇여 저장하거나, 구조만 복사할떄)
INSERT  INTO emp_temp2 (empno, ename, job, mgr, hiredate, sal, comm, deptno)
SELECT  employee_id, first_name, job_id, manager_id, hire_date, salary, commission_pct, department_id
FROM    hr.employees
WHERE   salary BETWEEN 5000 AND 10000;



--====================================================================
-- p.277 테이블에 있는 데이터 수정 : UPDATE(기존 데이터를 변경)
--====================================================================
desc dept_temp;

SELECT  *
FROM    dept_temp;

--UPDATE문의 기본 사용법
-- UPDATE 테이블
-- SET 컬럼명 = 값,
--      컬럼명2 = 값2,
--         ...계속...
-- WHERE 조건절
-- ※ WHERE 조건절 생략 ==> 모든 테이블의 데이터가 수정됨! (그래서 WHERE조건절을 사용해야함)

--p.278 DEPT_TEMP2의 데이터 업데이트하기 : Gwangu -> seoul로 변경

--작업취소 : ROLLBACK
-- ※ 실수로 6개 행을 업데이트 --> 취소! (업데이트 전으로 돌아감)
ROLLBACK;  
-- TCL : Transaction Control Language / 트랙젝션 제어언어 
-- 1) ROLLBACK : 작업 취소 --> 변경, 삭제, 삽입을 되돌림 (메모리에서 작업취소)
-- 2) COMMIT : 작업 확정 --> 변경, 삭제, 삽입한 데이터 확정( 물리적 저장하는 것)
-- 3) SAVEPOINT 이름 : 세이브포인트 지정명령(롤백할때 특정 세이브포인트로 되돌아가기)
-- RALLBACK 했으면 COMMIT 해야함!

UPDATE dept_temp
SET loc = 'SEOUL'
WHERE   deptno = 50;

--10	ACCOUNTING	NEW YORK
--20	RESERCH	DALLAS
--30	SALES	CHICAGO
--40	OPERATIONS	BOSTON
--50	DEVELOPMENT	SEOUL
--60	DATABASE	SEOUL
COMMIT;


-- Q. OPERATIONS 부서의 위치를 BOSTON 에서 
UPDATE dept_temp
SET loc = 'ATLANTA'          
WHERE   deptno = (SELECT deptno
                  FROM dept_temp
                  WHERE dname = 'OPERATIONS');
COMMIT;                  
                  
UPDATE dept_temp
SET loc = 'LAS VEGAS',
          dname = 'MANAGEMENT'
WHERE   deptno = 40;
COMMIT;                  


--=====================================================================
-- UPDATE문 사용할 때 유의점
-- 실무에서도 UPDATE문에 사용하는 WHERE 조건식이 정확한 데이터를 대상으로 하는지
-- 꼼꼼하게 따져보고 쿼리를 수행, 자칫 애를 먹는 상황이 발생한다.(WHERE절 생략하면)
-- ※ 수백만 건이 수정되는 사고가 발생할수도 있음.
--=====================================================================


--=====================================================================
-- p.283 테이블에 잇는 데이터 삭제하기 : DELETE
--=====================================================================
-- DELETE문의 기본형식
-- DELETE [FROM] 테이블명
-- WHERE 조건절
-- ※ WHERE 조건절 생략시 모든 데이터 행이 영향을 받음 ==> 실수로 모든 데이터 삭제할수도 있음!!

--실습 10-22. hr 계정의 employees 테이블의 데이터를 참조해서 사번,이름,업무,매니저,...부서코드를
-- 갖는 사원정보를 emp_temp2 테이블로 저장

-- CTAS : CRATE TABLE AS SELECT 이하~
CREATE TABLE emp_temp3 AS
SELECT  employee_id AS empno, first_name AS ename, job_id AS job, manager_id AS mgr, hire_date AS hiredate,
        salary AS sal,  salary * NVL(commission_pct, 0) AS comm, department_id AS deptno
FROM    hr.employees;

DESC    emp_temp3;

SELECT  *
FROM    emp_temp3;

--DLETE FROM이나 없어도됨
DELETE FROM emp_temp3
WHERE   empno BETWEEN 200 AND 300;

ROLLBACK;

COMMIT;
-- p. 284 실습 10-24. 업무가 MAN인 사원을 모두 삭제 : 데이터 일부분 삭제
DELETE FROM emp_temp3
WHERE   job LIKE '%MAN'; -- 12개 행 삭제

--p.285 실습 10-24. 서브쿼리를 사용하여 데이터 삭제
-- 급여구가 : 2100 ~ 3000
-- 부서번호 : 50 또는 80(부서원이 많은~)

DELETE FROM emp_temp3
WHERE   empno IN (SELECT empno
                    FROM    emp_temp3
                    WHERE   sal BETWEEN 2100 AND 3000
                    AND     deptno = 50); -- 22개 행이 삭제되었습니다.
COMMIT;                    
-- p. 285 1분 복습~ 급여가 5000 이하인 사원을 모두 삭제
DELETE  FROM    emp_temp3
WHERE   sal <= 5000; -- 27행 삭제

-- SELECT 로 영향받는 데이터를 확인
SELECT  *
FROM    emp_temp3;
WHERE   sal <= 5000; -- 27rows

-- 부서가 10, 30, 50, 70, 90 에 근무하는 사원을 모두 삭제
DELETE  FROM emp_temp3
WHERE   deptno IN (10, 30, 50, 70, 90); -- 10개 행 삭제

SELECT  *
FROM    emp_temp3
WHERE   deptno IN (10, 30, 50, 70, 90); -- 10rows

COMMIT;

DELETE  FROM emp_temp3;

ROLLBACK;

--p.287 잊기전에 한번더
--Q1. CHAP10WH_DEPT 테이블에 50, 60, 70, 80번 부서를 등록하는 SQL을 작성
CREATE TABLE CHAR10WH_EMP AS
SELECT *
FROM    hr.employees;

CREATE TABLE CHAR10HW_DEPT AS
SELECT  *
FROM    hr.departments;

DESC CHAP10HW_DEPT;

DELETE FROM CHAP10HW_DEPT;

SELECT *
FROM    CHAP10HW_DEPT;

--50,60,70,80 부서 정보 등록
INSERT INTO CHAP10HW_DEPT
VALUES (50, 'ORACLE', NULL, 2200);

INSERT INTO CHAP10HW_DEPT
VALUES (60, 'SQL', NULL, 2300);

INSERT INTO CHAP10HW_DEPT
VALUES (70, 'SELECT', NULL, 2400);

INSERT INTO CHAP10HW_DEPT
VALUES (80, 'DML', NULL, 2500);

-- Q2. 8명의 사원정보를 CHAP10HW_EMP 테이블에 삽입

DESC CHAP10HW_EMP;

INSERT INTO CHAP10HW_EMP (employee_id, last_name, job_id, manager_id, hire_date, salary, commission_pct, department_id, email)
VALUES (7201, 'TEST_USER1', 'MANAGER', 7788, '2016/01/02', 4500, NULL, 50, 'TEST_USER1');

INSERT INTO CHAP10HW_EMP (employee_id, last_name, job_id, manager_id, hire_date, salary, commission_pct, department_id, email)
VALUES (7202, 'TEST_USER2', 'MANAGER', 7201, '2016/02/21', 1800, NULL, 50, 'TEST_USER2');

SELECT *
FROM    CHAP10HW_EMP;

COMMIT;


--Q3. CHAP10HW_EMP 테이블의 50번 부서에 근무하는 사원들의 평균 급여보다 많은 급여를 받는 사원들을 70번 부서로 옮기는 SQL문 작성

--I. 50번 부서에 근무중인 사원의 평균급여
SELECT  ROUND(AVG(salary))
FROM    chap10hw_emp
WHERE   department_id=50;


-- II. 전체 사원들을 평균급여 기준으로 필터링
SELECT  employee_id, first_name, last_name, salary, department_id
FROM    chap10hw_emp
WHERE   salary > 3462;


--III. 사원정보 업데이트
UPDATE chap10hw_emp
SET department_id = 70
WHERE   salary > ( SELECT  ROUND(AVG(salary))
                    FROM    chap10hw_emp
                    WHERE   department_id= 50 );


SELECT  *
FROM    chap10hw_emp
WHERE   salary >3462; --업데이트 완료

COMMIT;
--서브쿼리 사용하면 한번에 가능


--Q4. CHAP10HW_EMP에 속한 사원중, 60번 부서의 사원중에 입사일이 가장 빠른 사원보다 늦게 입사한 사원들의 급여를 10% 인상하고
-- 80번 부서로 옮기는 sql문장을 작성
-- 그룹함수 : MIN(), MAX() 함수는 순자만이 아닌 문자, 날짜를 비교할 수 있는 함수
UPDATE chap10hw_emp
SET salary = salary + salary * 0.1, 
    department_id = 80
WHERE   hire_date > (SELECT MIN(hire_date)
                    FROM chap10hw_emp
                    WHERE   department_id = 60); --책의 데이터와 달라서 60번 부서 사원이 없음  그래서 아래 쿼리로 만들었음


SELECT  *
FROM chap10hw_emp
WHERE   department_id =  60;

UPDATE chap10hw_emp
SET department_id = 60
WHERE   employee_id IN (169, 170, 176);

COMMIT;

-- Q5. CHAP10HW_EMP에 속한 사원중 급여 등급이 5인 사원을 삭제하는 SQL문을 작성
-- SALGRADE 테이블이 없음.
-- 급여 구간으로 2100 ~ 24000 을 5단계로 임의로 나누어, 해당하는 사원을 삭제하기
-- 1 2100 ~ 5000
-- 2 5000 ~ 10000
-- 3 10000 ~ 15000
-- 4 15000 ~ 20000
-- 5 20000 ~ 24000

DELETE FROM chap10hw_emp
WHERE   salary BETWEEN 20000 AND 24000;

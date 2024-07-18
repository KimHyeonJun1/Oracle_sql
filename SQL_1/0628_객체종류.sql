-- 13. 객체종류
-- 오라클이 데이터 보관 및 관리를 위한 1) 여러 기능과 2) 저장공간을 객체(Object)를 통해서
-- 제공함
-- ※ 테이블(Table) : SQL문과 더불어 가장 많이 사용하는 객체 중 하나

--  P.327 데이터 사전(DICTIONARY)
-- 오라클 데이터 사전은 (1) 사용자 테이블과 (2) 데이터 사전으로 나뉜다.
-- (1) 사용자 테이블 : 관리할 데이터를 저장할 테이블 --> emp, dept, salgrade.. 등등
-- (2) 데이터 사전 : 데이터베이스를 구성하고 운영하는데 필요한 모든 정보를 저장하는
--     특수한 테이블로, 데이터베이스가 생성되는 시점에 자동으로 만들어 진다.
--      ※ 메모리, 선능, 사용자, 권한, 객체 등 ==> 데이터베이스 운영관련 중요한 데이터가 보관됨.
--      ※ 사용자가 데이터 사전에 접근하거나 작업하는것은 허용하지 않는다 ==> 뷰(View) 제공해서
--      SELECT 명령으로 열람할 수 있다.

-- 현재 세션에 등록된 사용자 테이블 목록을 조회하는 명령
SELECT *
FROM    user_tables;

-- HR 계정으로 로그인 한 후 실행
SELECT  *
FROM    dba_tables;

-- ORA-00942
--P.331 보안문제를 일으킬 수 있어서~ 오류로 표현!

SELECT *
FROM    v$nls_papameters; --v: View

ALTER SESSION SET NLS_LANGUAGE = 'ENGLISH'; -- 현재 세션에서만 변경되고, 이후에 재 로그인시 초기화됨!
ALTER SESSION SET NLS_DATE_FORMAT = 'YY/MM/DD'; -- 기본적으로 RR/MM/DD 설정



SELECT *
FROM    all_objects
WHERE   object_name = 'DUAL';


--==================================================================================
-- 접두어                  설명        
--==================================================================================                        
-- USER_XXX : 현재 세션의 사용자가 소유한 객체 정보
-- ALL_XXX : 모든 사용가능한 객체 정보 | 다른 계정의 소유 객체중 사용이 허락된 객체
-- DBA_XXX : 관리자 권한을 가진 사용자가 볼수 있는 객체 정보
-- v$_XXX : 데이터베이스 성능관련 객체 정보
--===================================================================

--p.328 데이터 사전 조회 명령
SELECT *
FROM    dict;

SELECT  *
FROM    dictionary;

SELECT *
FROM    user_objects
WHERE   object_type = 'TABLE';

--HR 계정으로 확인
SELECT *
FROM    user_views; -- 뷰 : 가상의 테이블



SELECT  *
FROM    emp_details_view; -- 테이블의 정보를 조회해보기!

DESC    emp_details_view;
INSERT INTO emp_details_view
VALUES ();

--오라클 데이터베이스 객체 종류
--====================================================================
-- 1) 테이블 : 관리할 데이터를 저장하는 객체(DDL로 생성, 수정, 삭제, DML로 데이터 입력, 수정, 삭제)
-- 2) 뷰 : 가상의 테이블, 하나 이상의 테이블을 조회하는 SQL문을 저장하는 객체
-- ※ emp20 이라는 테이블을 조회하는 SQL 문장 작성 vs 조회문을 저장한 뷰를 조회
--3) 시퀀스 : 특정 규칙에 맞는 연속 숫자를 생성하는 개체 (예 : 사원등록 --> 사번을 일련번호로 생성하고 기록하는 개체)
-- 테이블
-- 뷰
-- 인덱스
-- 시퀀스
-- 동의어
-- ↑ 사용빈도가 높은 오라클 데이터베이스 객체

-- ↓ 사용빈도가 낮은 오라클 데이터베이스 객체
-- 프로시저
-- 함수
-- 트리거
-- 패키지
-- 구체화된 뷰
-- 큐 

--==============================================================================
--P.338 뷰
-- 1) 편리성 - 매번 작성하지 않고~ select 문의 복잡도를 완화하거나 특정 열을 노출하지 않으려고 할 때
-- 2) 보안성 - 노출이 허용되지 않는 예민한 데이터를 감추고자 할 때 (주민등록번호, 주소, ... 특정할 수 있는 민감성 데이터) 
--==============================================================================
SELECT  employee_id, first_name, job_id, department_id
FROM    employees
WHERE   department_id = 20;

SELECT  *
FROM    emp20; -- 아직 없지만, emp20이라는 뷰를 생성해두면 매번 SQL 작성을 하지 않아도 되는것

-- 뷰 생성
--CRATE [OR REPLACE] VIEW 뷰 이름 AS
--SELECT  이하~
--[WITH READ ONLY]

CREATE OR REPLACE VIEW emp20 AS
SELECT *
FROM    employees
WHERE   department_id = 20
WITH READ ONLY; -- 권장!
--View EMP20이(가) 생성되었습니다

SELECT *
FROM user_views;

SELECT *
FROM    emp20;

--뷰 삭제후 다시 뷰 생성 vs CREATE OR REPLAVE VIEW
-- 같은 이름의 뷰에 컬럼을 조절해서 원하는 컬럼만 포함하여 뷰 생성
CREATE OR REPLACE VIEW emp_20 AS
SELECT  employee_id, first_name, job_id
FROM    employees
WHERE   department_id = 20
WITH READ ONLY;

SELECT *
FROM    emp_20;

--뷰 삭제
-- DROP VIEW 뷰이름;
DROP VIEW emp_20;
--View EMP_20이(가) 삭제되었습니다.
-- 뷰가 삭제되어도 테이블, 데이터는 삭제되지 않는다

SELECT *
FROM    employees
WHERE   department_id= 20;

--구체화된 뷰 (MATERIALIZED VIEW) : 뷰에서도 데이터만 따로 분리하는뷰 / 거의 사용하지 않는다.


--P.344 인라인 뷰를 사용한 TOP-N SQL 문
-- 실습 13-20. ROWNUM 을 추가로 조회하기
-- 가상의 컬럼 : ROWNUM - 연속적인 일렬번호, (조회했을떄) VS 순위라고 하기에는..좀?
SELECT ROWNUM, e.*
FROM    employees e;

-- 실습 13-22. 인라인 뷰 서브쿼리를 ==> 사원을 급여순위로 조회
-- 순위로 정렬한 데이터를 ROWNUM 을 기준으로 TOP-N 데이터를 조회
CREATE OR REPLACE VIEW salary_top3 AS
SELECT ROWNUM, e.*
FROM    (SELECT *
        FROM employees
        ORDER BY  salary DESC) e
WHERE   ROWNUM <= 3
WITH READ ONLY;
-- ORA-00998: 이 식은 열의 별명과 함께 지정해야 합니다




--=============================================================================
--p.348 시퀀스
-- 특전 규칙에 맞는 연속적인 숫자, 일련번호를 생성하는 개체 ==> 데이터 입력시 활용
-- CREATE SEQUENCE 시퀀스 이름
-- INCREMENT BY n : 증분(값이 증가하는)
-- START WITH n : 시작값
-- MAXVALUE n : 최대값
-- MINVALUE n : 최소값
-- CYCLE | NO CYCLE
-- CACHE n | NO CACHE : 기본값 20
--=============================================================================
--p. 350 시퀀스 사용
--employees_seq를 사용 ==> 신규 사원 등록
desc employees;

INSERT INTO employees(employee_id,last_name,email, hire_date,job_id)
VALUES (employees_seq.NEXTVAL, 'KIM', 'HYEONJUN', SYSDATE, 'SA_REP');

SELECT *
FROM    employees
WHERE   last_name = 'KIM';

--연습용 데이터니까 롤백
ROLLBACK;
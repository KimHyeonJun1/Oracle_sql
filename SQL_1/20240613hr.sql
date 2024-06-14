-- 한줄 주석

/*
여러줄
주석
*/

--그날그날 학습한 SQL에 대해, 파일로 저장하기(현재: 로그인한 계정 -SESSION, 저장화면 ==>파일명으로 탭이름 변경)

-- p.25 관계형 데이터베이스와 SQL

-- 1) 데이터 : 자료(data, 가공되지 않은 사실), 정보(information, 가공된 데이터 )를 의미
-- 2) 데이터베이스 : 데이터 관리시스템 (DBMS-동시 공유,효율적인 데이터관리) vs 파일시스템(동시에 공유/작업 불가) 차이
--    관계형데이터베이스(Relational DBMS) : 기업이라던지 정부기관등은 거대한 서비스를 제공하는 주체가 사용하는 데이터베이스
--    오라클 : 대표적인 관계형 데이터베이스 시스템(DBMS)
--    테이블 : 2차원 표(행,열) 형태로 데이터를 저장, 관리하는 데이터베이스 객체(ex> 학생정보, 성적정보, 장학금정보 ...)
--    행 : 하나의 개체를 구성하는 여러 값을 가로로 늘어뜨린 형태 ==> 한 사람의 데이터
--    열 : 저장하고자 하는 데이터를 대표하는 이름, 공통특성
--    p.30 한발 더 나가기 ( 테이블 - 관계Relation, 행 - 튜플 or 레코드, 열 - 애트리뷰트 or 필드)


-- 3) SQL(Structured Query Language, 구조화된/구조적인 질의 언어) : 오라클 DBMS에 데이터를 요청(입력,조회,수정,삭제)하고, 그 결과를 반환
--    그 결과를 반환, 읽을때는 '에스큐엘', '시퀄'
-- 3-1) DQL : (Data Query Language) 데이터를 원하는 방식으로 조회 ==> SELECT
-- 3-2) DML : (Data Maniqulation Language) 데이터를 저장,수정,삭제 ==> INSERT, UPDATE, DELELTE  | TRUNCATE
-- 3-3) DDL : (Data Definition Language) 데이터 관리를 위한 데이터베이스 객체를 생성,수정삭제 ==> CREATE, ALTER, DROP
-- 3-4) TCL : (Transaction Control Language) 트랜잭션 제어(영구 저장, 취소) ==> COMMIT, ROLLBACK
-- 3-5) DCL : (Data Control Language) 데이터 사용 권한(관리자 -> 개발자 또는 관련자) ==> GRANT, REVOKE


/*================================p.73 실습용 테이블 들여다보기
    교재: 오라클 18c     vs   우리는 21c
    샘플 스키마 : SCOTT  vs   HR  - 오라클 18c 이후부터는 샘플스키마를 별도로 추가해야함
    = 데이터의 구조나 실제 데이터도 조금씩 다름
==================================*/
-- ※ SQL 은 대, 소문자를 구분하지 않음
-- ※ 쿼리실행은 (블럭을 지정한 뒤) CTRL + ENTER 또는 ▶ 단추 클릭
-- 1. 테이블의 구조 확인 명령 : DESC or DECRIBE
-- DESC 테이블이름;
-- DESCRIBE 테이블이름;
DESCRIBE employees;    -- spacebar로 한칸 띄워서
DESC     employees;    -- tab눌러서 탭 간격을 띄어서    

--이름             널?       유형        의미     
---------------- -------- ------------ 
--EMPLOYEE_ID    NOT NULL NUMBER(6)       사원 코드 or 사원 번호
--FIRST_NAME              VARCHAR2(20)    사원 이름
--LAST_NAME      NOT NULL VARCHAR2(25)    사원 성
--EMAIL          NOT NULL VARCHAR2(25)    사원 (사내)이메일(주소)
--PHONE_NUMBER            VARCHAR2(20)    사원 연락처 or 전화번호
--HIRE_DATE      NOT NULL DATE            사원 입사일
--JOB_ID         NOT NULL VARCHAR2(10)    사원 직무/직급/직책코드 or 번호
--SALARY                  NUMBER(8,2)     사원 월급 or 급여
--COMMISSION_PCT          NUMBER(2,2)     사원 (영업파트) 수수료율(Percentage)
--MANAGER_ID              NUMBER(6)       사원의 상사/관리자 (사원)코드 or 번호
--DEPARTMENT_ID           NUMBER(4)       사원의 소속 부서_코드 or 번호

--NOT NULL : 빈 문자를 허용하지 않는다 ==> 데이터를 입력할때 반드시 해당 속성/필드는 값을 제공해야한다는 듯 -->제약조건

-- ===============================오라클 데이터베이스 객체의 자료형=============================
-- ※ 오라클 데이터베이스 객체의 자료형
-- 1) NUMBER : 숫자형 --> Int, Float, Double    ==> NUMBER(자릿수), NUMBER(전체자릿수,소수점이하 자릿수)
-- 2) VARCHAR2 : 가변 문자형 --> String         ==> VARCHAR2(바이트길이) / 일반적으로 영문1자 : 1Byte, 한글1자 : 2Byte vs (오라클) 3Byte
-- 3) CHAR : 고정 문자형 --> Char
-- 그밖에도 많은 자료형이 있지만? JAVA도 Int, String 사용하듯이, 자주 쓰는것만!

-- Q. 나머지 테이블들의 구조도 확인해보세요(모든 테이블)

DESC departments; --담당 부서

--이름              널?       유형         의미  
----------------- -------- ------------ 
--DEPARTMENT_ID   NOT NULL NUMBER(4)       부서 코드 or 부서 번호
--DEPARTMENT_NAME NOT NULL VARCHAR2(30)    부서 이름
--MANAGER_ID               NUMBER(6)       부서 관리자 or 부서 책임자
--LOCATION_ID              NUMBER(4)       부서 위치 코드

DESC countries;

--이름           널?       유형           의미
-------------- -------- ------------ 
--COUNTRY_ID   NOT NULL CHAR(2)           국가 코드 or 아이디 or 번호
--COUNTRY_NAME          VARCHAR2(40)      국가이름
--REGION_ID             NUMBER            (국가가 포함된 대륙) 지역코드

DESC job_history;

--이름            널?       유형           의미
--------------- -------- ------------ 
--EMPLOYEE_ID   NOT NULL NUMBER(6)         사원 코드 or 아이디
--START_DATE    NOT NULL DATE              업무 시작일자/시간
--END_DATE      NOT NULL DATE              업무 종료일자/시간
--JOB_ID        NOT NULL VARCHAR2(10)      사원 업무 코드/번호
--DEPARTMENT_ID          NUMBER(4)         사원 (소속)부서 코드

DESC jobs;

--이름         널?       유형           의미
------------ -------- ------------  
--JOB_ID     NOT NULL VARCHAR2(10)      업무 아이디 / 코드/ 번호  
--JOB_TITLE  NOT NULL VARCHAR2(35)      업무 제목 / 이름
--MIN_SALARY          NUMBER(6)         최소 급여
--MAX_SALARY          NUMBER(6)         최대 급여

DESC locations;

--이름             널?       유형         의미  
---------------- -------- ------------ 
--LOCATION_ID    NOT NULL NUMBER(4)      위치 아이디 / 코드 / 번호
--STREET_ADDRESS          VARCHAR2(40)   도로 주소
--POSTAL_CODE             VARCHAR2(12)   우편 번호
--CITY           NOT NULL VARCHAR2(30)   도시 이름
--STATE_PROVINCE          VARCHAR2(25)   행정 구역: 국)시,군,구,해)주
--COUNTRY_ID              CHAR(2)        국가 아이디

DESC regions;

--이름          널?       유형           의미
------------- -------- ------------ 
--REGION_ID   NOT NULL NUMBER            지역(대륙) 아이디 / 코드
--REGION_NAME          VARCHAR2(25)      지역 이름

-- p.76 데이터를 조회하는 방법
-- 셀렉션(Selection) : 행 선택
-- 프로젝션(Projection) : 열 선택
-- 셀렉션 x 프로젝션 : 특정 열을 가진 행을 선택
-- 조인(Join) : 2개 이상의 테이블의 관계를 이용해 행/열을 선택

-- p.80 SQL의 기본 뼈대, SELECTR절과 FROM 절
-- 1) 사원 테이블의 구조를 먼저 조회 : DESC 명령
DESC employees;
--2) 사원 테이블의 데이터를 조회 : SELECT
-- SELECT *(모든 컬럼) FROM 테이블명
-- SELECT 컬럼명1, 컬럼명2... FROM 테이블명;

-- ※ 요약
-- 사원수 : 107명
-- 부서수 : 27개
-- 부서위치 수(도시) : 23곳
-- 업무수 : 19개
-- 국가수 : 25개
SELECT *
FROM employees;

SELECT employee_id, first_name, job_id, department_id
FROM employees;

-- SQL 문장을, 블럭 지정 후에 CTRL + F7(자동 서식 적용) 으로, 코드를 정리할 수 있음
-- 보기좋게 띄어쓰기 할때 Spacebar, Tab을 적절히 활용
SELECT
    *
FROM
    departments;
SELECT *
FROM countries;
SELECT *
FROM jobs;
SELECT *
FROM locations;
SELECT *
FROM job_history;

-- p.82 DISTINCT
SELECT  employee_id, first_name, department_id
FROM    employees;
-- 200 Jenifer 10
-- 202 pat 20
-- ...생략...

SELECT  department_id, department_name, location_id
FROM    departments;
--10	Administration		1700
--20	Marketing		1800
-- ..생략...

SELECT  DISTINCT department_id
FROM    employees;

SELECT employee_id, first_name, salary, job_id, department_id
FROM employees;

--사번     이름     월급여     업무코드    부서코드
--178	Kimberely	7000	   SA_REP	    (null: 인턴쉽, 계약직)

SELECT  *
FROM    jobs;
--업무코드     업무명             최소월급여 최대월급여
--SA_REP	Sales Representative	6000      	12008

-- p.84 한눈에 보기좋게 (컬럼의) 별칭(Alias) 설정하기


--1. 컬럼명 (공백) 별칭명 : 가독성 나쁜
--SELECT 컬럼명1 별칭1, 컬럼명2 별칭2, ...
--FROM  테이블명

--2. 컬럼명 AS 별칭명 : 가독성 좋은
--SELECT 컬럼명1 AS 별칭1, 컬럼명2 AS 별칭2, ...
--FROM  테이블명

SELECT  employee_id 사번, first_name 이름, salary 월급여, department_id 부서코드
FROM employees;

--컬럼의 별칭은 언제 사용하나??

--p.84 실습 4-9 열에 연산식을 사용하여 출력하고자 할때
-- 사칙연산 : +, -, *, /, %(는 없고, MOD함수를 사용함)을 하면, 컬럼명이 바뀜
-- 함수사용하면 컬럼명이 바뀜 : SUM(), AVG()...
-- 결과적으로, 컬럼명을 변경해서 조회할 때

-- Salary : 월 급여
-- Salary * 12 : 연 급여 (연봉)
-- Salary * 12 + Salary * Commission_pct : 실 급여 + 수당
SELECT first_name, salary, Salary * 12 + Salary * Commission_pct AS 실지급액, department_id
FROM employees;



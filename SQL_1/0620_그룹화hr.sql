--p.177. 실습 7-1. SUM함수를 사용하여 급여 합계 출력하기

--다중행 함수와 그룹화 : 결과 행(row)

-- I. 다중행 함수 [=집계함수]
-- SUM() : 합계를 구하는 함수
-- COUNT() : 데이터의 갯수, 성능의 미미한 차이 -> COUNT(*) VS COUNT(employee_id)
-- MAX() : 최댓값
-- MIN() : 최솟값
-- MX / MIN : 날짜 데이터 컬럼에서도 집계 ==> 어떤 의미인지
-- AVG() : 평균값을 구하는 함수 ==> 소수점 ==> ROUND(), TRUNC(), CEIL(), FLOOR()

-- II. 그룹화 : 어떤 기준에 의해서 묶어서 조회
-- SELECT : 컬럼
-- FROM : 테이블
-- WHERE : 조건
-- GORUP BY : 그룹화 하는 기준 컬럼
-- ORDER BY : 정렬 기준, 방법 | 항상 마지막에 작성 (예외 : 서브쿼리에서는 마지막이 아닌 경우)

--===================================
--07-1)다중행 함수
--===================================

--p.177 실습 7-1 SUM 함수를 사용하여 급여 합계 출력하기
-- 사용자 테이블 조회 : 현재 로그인한(=세션) 계정 소유
SELECT *
FROM user_tables;

SELECT  TO_CHAR(LAST_DAY(SYSDATE), 'YYYY/MM/DD') AS 지급일, 
        TO_CHAR(SUM(salary), '$999,999') AS 급여합계,
        TO_CHAR(ROUND(AVG(salary)), '$99,999') AS 급여평균,
        COUNT(*) AS "사원수 합계"
FROM    employees;

--COUNT() : NULL은 집계하지 않음 ★ /NULL은 집계에서 제외됨
SELECT  COUNT(DISTINCT(department_id)) AS cnt
FROM    employees;

SELECT *
FROM    employees
WHERE   department_id Is NULL;

SELECT  MAX(salary) AS max_salary,
        MIN(salary) AS min_salary
FROM    employees;

SELECT   *
FROM    employees
WHERE   salary = 24000;

SELECT  *
FROM    employees
WHERE   salary = 2100;

-- p.183 실습 7-12. 날짜 데이터에서 MAX, MIN 함수 사용하기
-- 샘플 스키마 : 입사일 01년도 ~ 08년도
-- MAX(datetime) : 가장 최근 날짜
-- MIN(datetime) : 가장 먼저 날짜
SELECT MAX(hire_date)
FROM    employees;

DESC employees;

SELECT  *
FROM    employees
WHERE   hire_date = TO_DATE('08/04/21', 'RR/MM/DD');

SELECT  MAX(first_name),
        MIN(first_name)
FROM    employees;        

----===================================
--07-2) 결과값을 원하는 열로 묵어 출력하는 GROUP BY 절
--===================================
-- SUM(), MAX(), MIN(), AVG() ==> 결과가 단일 행

--부서(별, 기준) 급여의 평균을 조회
SELECT  department_id, ROUND(AVG(salary)) AS AVG_SALARY
FROM    employees
WHERE   department_id IS NOT NULL
GROUP BY    department_id
ORDER BY    department_id;

--전체 사원의 수를 조회
SELECT department_id, COUNT(*), SUM(salary), AVG(salary), MAX(salary), MIN(salary)
FROM    employees
GROUP BY    department_id
ORDER BY    department_id;
--========================================
-- ORA-00937: 단일 그룹의 그룹 함수가 아닙니다 ==> 집계컬럼과 일반컬럼 사용시, GROUP BY 추가
-- 1) GROUP BY 절을 추가, 집계함수 옆에(집계하지 않는) '일반컬럼'을 표기
--================================================

--p.186실습 7-16 (위)
SELECT  AVG(salary)
FROM    employees
WHERE   department_id = 10
UNION ALL
SELECT  AVG(salary)
FROM    employees
WHERE   department_id = 20;

--======================================================
-- GROUP BY 절을 사용할 때 유의점 : 다중집행함수(집계, 그룹화) 함수 사용할 때 일반 컬럼은
-- GROUP BY 절에 '명시'하되, 생략할 수 있다
--======================================================

SELECT  AVG(salary)
FROM    employees
GROUP BY department_id;

--======================================================
-- ORA-00979: GROUP BY 표현식이 아닙니다 --> SELECT 절에 일반 컬럼을 모두
-- GROUP BY 절에 명시하면 됨.
--======================================================

SELECT  job_id, COUNT(*) AS COUNT, TO_CHAR(AVG(salary), '99,999') AS AVG_SAL
FROM    employees
GROUP BY    job_id
ORDER BY    AVG_SAL DESC;

--======================================================
--07-3) HAVING 절 : GROUP BY 절에 조건을 줄 때 사용함
--======================================================
-- SELECT 절
-- FROM 절
-- WHERE 절
-- GROUP BY 절
-- HAVING 절
-- ORDER BY 절
--======================================================
-- p.190 실습 7-20. 각 부서의 직책별 평균 급여를 구하되, 평균 급여가 2000 이상인 그룹만 조회
SELECT department_id, job_id, TO_CHAR(ROUND(AVG(salary)), '99,999') AS AVG_SAL
FROM    employees
--WHERE  department_id >= 50
GROUP BY    department_id, job_id
HAVING  AVG(salary) >= 10000
--HAVING  department_id >= 50
ORDER BY    department_id;

--======================================================
-- HAVING 절 : GROUP BY 절을 사용해 그룹화된 결과중 출력(그룹)을 선별(제한)하는 조건식
-- WHERE 절 : 출력 대상 행을 제한하는 조건식 ==> 일반 조건식
-- p. 192 HAVING절 사용시 유의점 : WHERE 절에 그룹화함수 조건식을 사용할 경우 ==> 에러 ORA-009341
-- ※ WHERE 조건 ==> HAVING 절에 사용할수 있음
--======================================================

--p.192 WHERE 절과 HAVING절의 차이점
-- 1) WHERE 절을 사용하지 않고, HAVING절만 사용하는 경우
SELECT  department_id, job_id, AVG(salary) AS avg_salary
FROM    employees
--WHERE   
GROUP BY    department_id, job_id
HAVING AVG(salary) >= 5000
ORDER BY 1; --컬럼명 대신, 컬럼의 번호도 사용할 수 있음.

-- 2) WHERE 절을 사용하지 않고, HAVING절만 사용하는 경우
-- WHERE 절이 먼저 실행되어, 출력 대상행을 제어하고 --> 이후에 GROUP BY 절에 의해 그룹화하고, HAVING절에의해 출력그룹을 제한함
SELECT  department_id, job_id, AVG(salary) AS avg_salary
FROM    employees
WHERE   salary <= 3000
GROUP BY    department_id, job_id
HAVING AVG(salary) >= 2000;

--3) WHERE절만 사용할 때
SELECT  department_id, job_id, salary
FROM    employees
WHERE   salary <= 3000
ORDER BY    department_id, job_id;


--==========================================================
-- p.195 그룹화와 관련도니 여러 함수 : 실무에서 바로 사용할 확률이 높지 않으니,
-- 간단히 훑어보거나 나중에 필요할때 다시 찾아보세요~
--==========================================================
--GROUP BY 절에 작성하는 함수

--1)ROLLUP, CUBE : 특수 함수(=그룹화된 데이터의 합계를 함께 출력하는 함수)
-- p.196 실습7-24. 부서별, 직무별, 사원의 수 / 급여 최대 / 급여 합계 / 급여 평균을 조회
SELECT  department_id, job_id, COUNT(*) AS cnt, MAX(salary) AS max, SUM(salary) AS sum, ROUND(AVG(salary)) AS average
FROM    employees
--WHERE
GROUP BY    CUBE(department_id, job_id)
--HAVING
ORDER BY    department_id, job_id;

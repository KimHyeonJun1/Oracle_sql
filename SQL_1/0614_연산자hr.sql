--p.83 한눈에 보기 좋게 별칭 설정하기

-- 1) 연산식 사용 --> 컬럼명이 변경
-- 2) 함수 사용 --> 컬럼명이 변경
--※ 보기좋게 결과를 출력하고자 하면? Alias(별칭) 사용

DESC employees;
    
SELECT first_name, salary AS 월급, salary * commission_pct AS 커미션금액, salary * 12 + salary * commission_pct AS 총지급액
FROM employees;

-- NULL : 빈 값 --> 이상한 값? 데이터에 이상(입력하는 단계 이상이거나, 연산과정에서?)
-- NULL을 연산식에 넣으면? 계산값이 도출되지 않음 => NULL처리를 위한 함수 존재
SELECT 10 + NULL
FROM dual;

-- ===========================================
--p.88 데이터 정렬 | ORDER BY
-- ===========================================
-- 1) 오름차순 : 작은값 --> 큰값 : a -> z , 1,2,3, --> 9,10
-- 2) 내림차순 : 큰값 --> 작은값 : z -> a, 9,10 --> 3,2,1,
-- ※ ORDER BY 지정하지 않으면? 기본적으로 오라클 엔진(Engine)이 테이블의 기본키 등을 기준으로 정렬 --> 테이블 생성시 그렇게 동작..

--오름차순 : 작은 -> 큰 : TJ 사람이 급여 최저, Steven 급여 최고
-- Ascending : ASC (약어), ORDER BY 기본값
SELECT  employee_id, first_name, salary, job_id, department_id
FROM    employees
ORDER BY salary ASC;

--내림차순 : 큰 -> 작은 : DESC
-- Descending : DESC (약어)
SELECT  employee_id, first_name, salary, job_id, department_id
FROM    employees
ORDER BY salary DESC;

-- 정렬 기준 컬럼을 1개 이상 사용 : 컬럼명을 콤마로 구분
SELECT  employee_id, first_name, salary, job_id, department_id
FROM    employees
ORDER BY first_name ASC, salary DESC;

-- =================================================
-- ORDER BY 주의사항 : 꼭 필요한 경우가 아니라면 사용하지 않는 것이 좋다
-- 데이터의 양 또는 정렬 방식에 따라 출력 데이터를 선정하는 시간 <정렬시간 (시간이 더 걸림)
-- =================================================

-- p.92 잊기전에 한번 더
-- Q2. employees 테이블의 job_id 열의 데이터를 중복 없이 조회 (DISTINCT VS ALL)
-- 부서번호 null : 계약직/프리랜서 사원(아직 부서가 결정되지 않은 ?? 배치전? 발령 전?)
SELECT  DISTINCT department_id
FROM    employees
ORDER BY department_id ASC;

SELECT DISTINCT job_id
FROM    employees
ORDER BY job_id;  -- 19rows

SELECT  *
FROM    jobs;
--Q3. employees 테이블의 컬럼의 별칭을 다음과 같이 적용하고, 부서번호 기준 내림차순, 사원이름 기준 오름차순 정렬
-- employee_id ==> emp_no
-- first_name ==> ename
-- manager_id ==> mgr
-- salary ==> sal
-- comission pct ==> comm | 실제로는 salary * commission_pct를 해야 , 교재의 COMM과 같은 결과
-- department_id ==> dept_no

-- DQL(Data Query Language) : 데이터 질의 언어 ==> SELECT

SELECT
    employee_id    AS emp_no,
    first_name     AS ename,
    manager_id     AS mgr,
    salary         AS sal,
    commission_pct AS comm,
    department_id  AS dept_no
FROM    employees
ORDER BY  department_id DESC, first_name ASC;

--==========================================
-- 05. WHERE 절과 연산자
-- =========================================

-- 절(clause, 절 이란 주어와 서술어의 형태를 지닌 문장 단위를 말함)
-- SELECT 절
-- FROM절
-- WHERE 절
-- ORDER BY 절 : 꼭 필요한 경우 아니면 사용하지 않는게 좋다 ==> DB 튜닝, 최적화 하지 않은 상태에서 사용하지 않도록 당부
-- ※ ORDER BY 절은, 특별한 경우가(=서브쿼리 파트) 아니라면 SQL 문장의 마지막에 위치함!

-- 실습 5-2. 부서번호가 30인 데이터를 조회 ==> 구매부서에 근무하는 사원의 목록을 조회
-- 30, 구매부서(Purchasing)
SELECT  *
FROM    departments;

SELECT  *
FROM    employees
WHERE   department_id = 30; --6rows 

-- 오라클에서는 = 는 대입/할당 연산자(x), 비교연산자(동등비교) / 자료형이 같은...
DESC employees;
-- DEPARTMENT_ID        NUMBER(4) : 숫자형 컬럼(4바이트)

SELECT  employee_id, first_name, department_id, manager_id
FROM    employees
WHERE   salary = 24000;
--132	TJ	50	121
--100	Steven	90	


-- ======================================
-- p.97 여러개의 조건식을 사용하는 AND, OR 연산자
-- ======================================
-- AND : 조건식 모두 TRUE ==> 최종 TRUE (~~이면서)
-- OR : 조건식중 하나라도 TRUE ==> 최종 TRUE (~~이거나)

--실습 5-3 AND 연산자로 30번 부서에 근무하면서 업무가 SALSAMAN인 사원을 조회하시오
-- 80번 Sales(영어부), SALSEMAN ==> 영업/판매사원??vs SA_MAN ==>Sales Manager, 영업판매 매니저 사원

-- ======================================
--문자 데이터 / 날짜 데이터 ==> '(Single Quote)로 묶어 주기
-- 컬럼명, 테이블명 ==> "(Double Quote)로 묶을 수 있지만, 귀찮은 관계로.. 보통 생략함!
-- ======================================
SELECT *
FROM    "employees"; --오라클 엔진은 테이블이나 사용자 생성시 기본적으로 대문자로 저장, 필요시 소문자로 저장하려면 "묶어야함
                        -- 중요

SELECT  employee_id, first_name, job_id, department_id
FROM    employees
WHERE   department_id = 80
AND job_id = 'SA_MAN';

SELECT *
FROM    jobs
WHERE   job_id = 'SA_MAN';

--p.실습5-4, OR 연산자로 여러개의 출력 조건 사용하기
-- 30번 부서에 소속된 사원이거나 업무가 CLERK 인 사원을 조회하시오
-- PU_CHERK, ST_CLERK< SH_CLERK

SELECT *
FROM    employees
WHERE   job_id = 'PU_CLERK'
--OR      job_id = 'ST_CLERK'
--OR      job_id = 'SH_CLERK'
OR      department_id = 30;

--p.99 1분 복습, 부서 번호가 20 이거나 직업이 SA_MAN인 사원의 정보만 나오도록 조회
SELECT *
FROM    employees
WHERE   department_id = 20
OR      job_id = 'SA_MAN';



SELECT *
FROM    departments
WHERE   department_id = 20;

--================================================
-- p.100 연산자의 종류와 활용방법 ==> SELECT절 또는 WHERE절에 사용
--================================================
-- 1) 산술연산자 : +, -, *, /
--      └나머지 연산자 % 대신, 오라클에서는 MOD() 함수를 사용!
-- 2) 비교연산자 : >, >=, <, <=, [ <> | != | ^= ]
-- 3) 논리부정연산자 : NOT : AND/OR, NOT
-- 4) IN연산자 : OR 연사자를 대신~
-- 5) BETWEEN A AND B 연산자 : 범위를 제한
-- 6) LIKE 연산자 : 문자열 패턴 찾는
-- 7) IS NULL 연산자 : NULL 유무에 따른..
-- 8) 집합 연산자 : 합집합, 교집합, 차집합 /DB에 수학의 집합을 적용 <---> JOIN과 다른 차이점
--     └SQL 문장 사이에 작성
-- ※ 연산자 우선순위(p.124)

-- p.101 실습 505 곱셈 산술 연산자를 사용해서 사원들의 연봉을 조회
-- I. 산술연산자를 SELCET절에 사용
SELECT employee_id, first_name, salary AS 월급여, salary * 12 AS 연봉
FROM    employees
--WHERE   commission_pct IS NOT NULL;
WHERE   commission_pct IS NULL;

--NULL 처리 함수를 사용해 NULL 값을 0으로 치환해서 곱셈 ==> 전체 사원의 급여정보를 조회(영업부 유무와 상관없이)

--commission_pct : 수수료 --> 영업부 사원 vs 일반사원(NULL)

-- II. 산술 연산자를 WHERE절에 사용
SELECT *
FROM    employees
WHERE   salary * 12 = 36000;    --2rows


SELECT employee_id, first_name, salary AS month_salary, salary * 12 AS annual_salary
FROM    employees
--WHERE   salary * 12 = 36000;
WHERE   annual_salary * 12 = 36000;

--ORA-00904: "ANNUAL_SALARY": 부적합한 식별자
-- WHERE절에 별칭(Alias)을 사용할 수 없다.

-- p.102 실습 5-6 대소 비교 연산자를 이용한 조회
-- 월급여가 3000 이상인 사원을 조회
SELECT employee_id AS emp_no,
       first_name AS fname,
       salary AS month_sal,
       department_id AS dept_no
FROM    employees
WHERE   salary >= 3000
--AND     salary <= 5000  이런식으로 AND를 써서 범위설정 가능
ORDER BY    month_sal ASC; --83명

-- 부서가 30,50,70 에 해당하는 사원정보를 조회
SELECT employee_id AS emp_no,
       first_name AS fname,
       salary AS month_sal,
       department_id AS dept_no
FROM    employees
WHERE   department_id = 30
OR      department_id = 50
OR      department_id = 70
ORDER BY    month_sal ASC; --52명

SELECT *
FROM    jobs;

SELECT *
FROM    employees
WHERE   salary >= 2500
AND     job_id = 'ST_MAN';  --5명


SELECT *
FROM    employees
WHERE   first_name >= 'F';


-- p.104 등가비교 연산자
-- = : 같다
-- !=, <>, ^= : 같지않다
    

SELECT *
FROM    employees
--WHERE   salary != 3000 -- 105명
--WHERE   salary = 3000; -- 2명
WHERE   salary ^= 3000; -- 105명


--p.105 실습 5-12 NOT 연산자를 사용하여 출력하기
-- NOT 위치 : 컬럼 앞 or 연산자 앞
-- IN 연산자   NOT IN 연산자
-- LIKE 연산자 NOT LIKE 연산자
-- BETWEEN 연산자 NOT BETWEEN 연산자
SELECT *
FROM    employees
WHERE   salary NOT = 3000;
--WHERE   NOT salary = 3000; -- 이게 맞음
--ORA-00920: 관계 연산자가 부적합합니다


-- p. 106 IN 연산자
-- I. OR 연산자 사용 : 전체 107명중 30,50,70 부서원은 52명
SELECT *
FROM    employees
WHERE   department_id = 30
OR      department_id = 50
OR      department_id = 70;


-- II. IN 연산자 사용
SELECT *
FROM    employees
--WHERE   department_id IN (30, 50, 70);
WHERE   department_id IN('30','50','70'); -- 오류가 안나는 이유는 자동으로 형변환 되어서
-- 오라클 엔진 ==> 자동 형변환 case
--              <== 개발자의 명시적 형변환 - 형변환 함수

SELECT *
FROM    jobs;   

--OR 연산자 사용
SELECT  employee_id, first_name, job_id, salary, department_id
FROM    demployees
WHERE   job_id = 'SA_MAN'
OR      job_id = 'PU_MAN'
OR      job_id = 'ST_MAN'
ORDER BY employee_id;

-- IN 연산자 사용
SELECT  employee_id, first_name, job_id, salary, department_id
FROM    employees
WHERE   job_id IN ('SA_MAN','PU_MAN','ST_MAN')
ORDER BY employee_id;

--=================================================
--NOT 컬럼 IN or 컬럼 NOT IN : 컬럼 앞 or 연산자 앞에 NOT 을 붙일수 있다 둘다 똑같음
--=================================================
SELECT  employee_id, first_name, job_id, salary, department_id
FROM    employees
WHERE   NOT job_id IN ('SA_MAN','PU_MAN','ST_MAN')
ORDER BY employee_id;

SELECT  employee_id, first_name, job_id, salary, department_id
FROM    employees
WHERE    job_id  NOT IN ('SA_MAN','PU_MAN','ST_MAN')
ORDER BY employee_id;

SELECT  employee_id, first_name, job_id, salary, salary * 12 AS annual_salary, department_id --연봉 조회
FROM    employees
WHERE   salary * 12 IN (30000, 50000, 70000)
ORDER BY employee_idsecure_employeesp.109 BETWEEN A AND B 연산자
-- ~이상 ~이하 값을 조회

--실습 5-17   사원의 월급여가 2000이상 3000이하인 사원을 조회
--  I. 논리조건연산자
SELECT employee_id, first_name, hire_date, job_id, salary
FROM    employees
WHERE   salary >= 2000
AND     salary <= 3000
ORDER BY salary DESC;

-- II. BETWEEN 연산자 + NOT
-- 1) 컬럼앞에 NOT
SELECT employee_id, first_name, hire_date, job_id, salary
FROM    employees
WHERE   NOT salary BETWEEN 2000 AND 3000
ORDER BY salary;

-- 2) 연산자 앞에 NOT
SELECT employee_id, first_name, hire_date, job_id, salary
FROM    employees
WHERE   salary NOT BETWEEN 2000 AND 3000
ORDER BY salary;

-- p. 110 LIKE 연산자와 와일드 카드
-- 일부 문자열이 포함되어 있는 데이터를 조회할때 사용
-- 1) _ : 1개의 문자를 의미 
-- 2) % : 길이와 상관없이(문자 없는 경우도 포함)모든 문자 데이터를 의미

-- p.111 실습 5-20 이름이 S로 시작하는 사원을 모두 조회
-- 문자는 대,소문자를 구분하며 '로 묵음
SELECT  employee_id, first_name, department_id
FROM    employees
WHERE   first_name LIKE '%s'
--ORDER BY    employee_id ASC; 
ORDER BY 3 ASC; -- department_id 가 작은값에서 큰순서로 순서대로 정렬


--실습 5-21 사원의 이름 두번째 글자가 l인 사원만 출력하기
SELECT  employee_id, first_name, department_id
FROM    employees
WHERE   first_name LIKE '_l%';

SELECT  employee_id, first_name, department_id
FROM    employees
WHERE   first_name LIKE '%l_'; -- 이름 마지막 두번째 글짜가 l인 사원 출력하기
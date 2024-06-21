--p.112 실습 5-22 사원의 이름중 AM이 포함되어 있는 사원의 데이터 출력하기
-- 문자, 대/소문자 구분 ==> 'am' vs 'AM' 인지 구분
-- 공백 ==> salary * 12 AS "annual salary" (""안넣으면 에러 공백이 있기 때문) : ' 와  "의 차이~
-- SQL 문장은 대/소문자를 구분 x ==> SELLECT or select ... 똑같다.
-- 와일드카드 : _ , %
SELECT  employee_id, first_name AS fname, department_id AS dept_no
FROM    employees
WHERE   first_name LIKE '%nn%' -- WHERE 절에 별칭(Alias) 사용할 수 없음
ORDER BY    first_name; --4 rows

--NOT + LIKE 사용 | 위치
-- 1) 컬럼 앞
SELECT  employee_id, first_name AS fname, department_id AS dept_no
FROM    employees
WHERE   NOT first_name LIKE '%nn%' -- WHERE 절에 별칭(Alias) 사용할 수 없음
ORDER BY    first_name; -- 103rows
--2) 연산자 앞
SELECT  employee_id, first_name AS fname, department_id AS dept_no
FROM    employees
WHERE   first_name NOT LIKE '%nn%' -- WHERE 절에 별칭(Alias) 사용할 수 없음
ORDER BY    first_name; -- 103rows

--p.113 와일드 카드 문자가 데이터의 일부인 경우 + ESCAPE 처리
SELECT  *
FROM    employees
WHERE  job_id LIKE '%H\_C%' ESCAPE '\'
ORDER BY    employee_id;


-- ========================================================
-- p.114 IS NULL 연산자
-- ========================================================

-- null 연산 x
-- null 비교 x
-- null : 빈 값? 빈 데이터 ? --> why null ? ==> 입력을 잘못했거나

--실습 5-24. 사원의 정보중 이름, 월급여, 연봉총액을 조회
-- 영업부 : commission_pct가 NULL 아닌, 사원들
SELECT
    employee_id,
    first_name,
    salary,
    salary * commission_pct               AS camm,
    salary * 12 + salary * commission_pct AS "ANNUAL Salary",
    department_id
FROM    employees
WHERE   commission_pct IS NOT NULL;
-- WHERE   commission_pct = NULL; 이렇겐 X

-- ========================================
-- NULL 데이터 처리를 위한 함수 제공 / 6장에서 확인!!
-- ========================================
--  사원테이블 : committion_pct (영업부인지 아닌지)
--               manager_id (매니저 유무) : 관리감독 유무
--               department_id (부서 소속 유무) : 정규직 vs 비정규직
SELECT  'ORACLE' AS COMPANY, employee_id, first_name, last_name, hire_date, salary commission_pct, manager_id, department_id
FROM    employees
WHERE   manager_id IS NULL;

SELECT *
FROM    departments
WHERE   department_id = 90;

-- =============================================
-- 집합 연산자 vs 조인 : 서로 반대되는 ? 비교되는 ! 개념
-- =============================================
-- 집합 : 수학에서~ 개념! : 합집합, 차집합, 교집합, 여집합,, 등등
-- 서로 다른 데이터(=구조, 데이터 갯수) 달라도 ! ==> 연산할 수 있다.
-- 집합은 수직으로 합침 / 관계 무관 vs 조인은 수평으로 합침 /관계가 필수
-- 조인(JOIN) 연산할때 집합과 비교할 예정/ 오늘은 건너뜀 -- 조인은 수평으로 합침 , 집합은 수직으로 합침 //관계가 필수

--=========================================================
-- p.125 잊기전에 한번더! (05장. WHERE절과 연산자 복습문제)
--=========================================================
--01. EMPLOYEES 테이블을 사용해서, 사원이름이 S(또는 s)로 끝나는 사원의 데이터를 모두 조회
SELECT employee_id, first_name, hire_date, department_id
FROM    employees
WHERE   first_name LIKE '%s'; -- 7rows

--Q2. 사번, 이름, 직책, 급여, 부서번호를 조회 ==> 30번 부서에 근무하고 직책이 SALESMAN(SA_MAN)인 사원
SELECT employee_id, first_name || ' '|| last_name AS fullname, job_id, salary, department_id 
FROM    employees
WHERE  department_id = 80
AND    job_id = 'SA_MAN';
     
SELECT *
FROM    departments; -- 교재의 30번 Sales라면, HR 샘플에서는 80번 부서가 Sales 부서

--Q3. 부서가 20번, 30번에 근무하고 있는 사원중 급여가 2000 초과하는 사원의 번호, 이름, 급여, 부서번호를 조회
-- 교재 : 집합 연산자 사용하는 방식(PASS), 집합 연산자 사용하지 않는 방식
SELECT  employee_id, first_name, salary, department_id
FROM    employees
WHERE   salary > 2000
AND     department_id = 20 
ORDER BY    employee_id; -- 2rows

SELECT  employee_id, first_name, salary, department_id
FROM    employees
WHERE   salary > 2000
AND     department_id = 30
ORDER BY    employee_id; --6rows

SELECT  employee_id, first_name, salary, department_id
FROM    employees
WHERE   salary > 2000 AND department_id = 20
OR      salary > 2000 AND department_id = 30
ORDER BY    employee_id;    -- 8rows

--Q4. 사원중에서 급여가 2000 이상 3000이하 범위 이외의 값을 가진 데이터만 출력
SELECT  employee_id, first_name || ' ' || last_name AS name, job_id, manager_id, hire_date, salary, salary * commission_pct, department_id
FROM    employees
WHERE   salary < 2000
OR      salary > 3000
ORDER BY    salary ASC; -- 81rows

-- BETWEEN A AND B : A이상 B 이하
SELECT  employee_id, first_name || ' ' || last_name AS name, job_id, manager_id, hire_date, salary, salary * commission_pct, department_id
FROM    employees
WHERE   NOT salary BETWEEN 2000 AND 3000
ORDER BY    salary ASC; -- 81rows
--NOT 연산자
-- 1) 컬럼 앞
-- 2) 연산자 앞

--Q5. 사원 이름에 E(또는 e)가 포함된 30번 부서의 사원중, 급여가 1000~2000 사이가 아닌
-- 사원의 이름, 사원 번호, 급여, 부서번호를 조회
-- UPPER(), LOWER() : 문자열 대문자, 소문자 처리 함수
SELECT  first_name, employee_id, salary, department_id
FROM    employees
WHERE   LOWER(first_name || ' ' || last_name) LIKE '%e%'
AND     department_id = 30
AND     NOT salary BETWEEN 1000 AND 2000
ORDER BY    salary; -- 4rows

-- Q6. 추가수당이 존재하지 않고, 상급자가 있고, 직책이 MANAGER(_MAN), CLERK(_CLERK)인 사원중에서
-- 사원의 이름 두번째 글자가 L(도는 l)이 아닌 사원으 ㅣ정보를 출력
SELECT employee_id, first_name, job_id, hire_date, salary, salary * commission_pct AS come, department_id
FROM    employees
WHERE   salary * commission_pct IS NULL
AND     manager_id IS NOT NULL
AND     job_id LIKE '%\_MAN' ESCAPE '\'
OR     job_id LIKE '%\_CLERK' ESCAPE '\'
AND     NOT first_name LIKE '_l%'
ORDER BY    job_id; --49 rows
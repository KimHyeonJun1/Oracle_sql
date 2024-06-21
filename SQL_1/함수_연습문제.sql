-- 01. 사원 테이블에서 부서코드가 100, 110 인 부서에 속한 사원들의
--사번, 성명, 급여, 부서코드, 15%인상된 급여 조회 - 인상된 급여는 정수로 표현
--컬럼명은 Increased Salary 로 표시한다.
-- ※ 인상된 급여 : 급여 + 급여 X 15%
SELECT employee_id, first_name, salary, department_id,
       TRUNC(salary + salary * 0.15) AS "Increased Salary"
FROM    employees;       


--02. 사원 테이블에서 이름(first_name)이 A로 시작하는 
--모든 사원의 이름과 이름의 길이를 조회(LENGTH()함수)하는 쿼리문 작성.
SELECT  first_name, LENGTH(first_name) AS name_length
FROM    employees
WHERE   first_name LIKE 'A%'
ORDER   BY 2;


--03. 80번 부서원의 이름과 급여를 조회하는 쿼리문을 작성한다.
--단, 급여는 15자 길이로 왼쪽에 $ 기호가 채워진 형태로 표시되도록 한다.
SELECT  first_name, LPAD(salary, 15, '$') AS salary, department_id
FROM    employees
WHERE   department_id = 80;


--04. 60번 부서, 80번 부서, 100번 부서에 소속된 사원의 
--사번, 성, 전화번호, 전화번호의 지역번호, 개인번호를 조회하는 쿼리문 작성
--단, 개인번호의 컬럼은 private_number, 지역번호의 컬럼은 local_number 라고 표시하고, 
--지역번호는 515.124.4169 에서 515, 
--           590.423.4568 에서 590, 
--            011.44.1344.498718 에서 011 이 지역번호라 한다.
--
-- 개인번호는 515.124.4169 에서 4169, 
--            590.423.4568 에서 4568, 
--      011.44.1344.498718 에서 498718 이 개인번호라 한다.
--    
--부서코드가 60,80,100 인 부서에 속한 사원들의 
--사번, 성, 전화번호, 지역번호, 개인번호 조회하는 쿼리문 작성
--
SELECT employee_id, last_name, phone_number,
       SUBSTR(phone_number, 1, INSTR(phone_number, '.') -1) AS local_number,
       SUBSTR(phone_number, INSTR(phone_number, '.',-1, 1)+1) AS private_number
       
FROM    employees
WHERE   department_id IN(60,80,100);

--01. 사원테이블에서 30번 부서의 사번, 성명, 급여, 근무개월수, 근무년수를 조회
--단, 근무개월수는 오늘 날짜를 기준으로 날짜함수를 사용
-- ADD_MONTHS()
-- MONTHS_BETWEEN()
-- 근무년수 : 근무개월수 / 12 ===> 반올림/버림 함수
SELECT  employee_id, first_name, salary,
        ROUND(MONTHS_BETWEEN(SYSDATE, hire_date)) AS 근무개월수,
        ROUND( MONTHS_BETWEEN(SYSDATE, hire_date) / 12) AS 근무년수
      
FROM    employees;        


--02. 급여가 12000 이상인 사원들의 
--사번, 성명, 급여를 조회하여 급여순으로 정렬한다.
--급여는 공백없이(TRIM, FM) 천단위 기호(,)를 사용하여 표현한다.


--03. 2005년 전(2004년까지)에 입사한 사원들의 
--사번, 성명, 입사일자, 입사일의 요일(DAY, DY) 을 조회하여 
--최근에 입사(DESC)한 사원순으로 정렬한다.


--사번, 성, 부서코드, 업무코드, 입사일자, 매니저코드, 매니저존재여부(NVL, NVL2 각각 사용) 조회

--보너스는 
--부서코드가  10~30 이면 급여의 10%
--            40~60 이면 급여의 20%
--           70~100 이면 급여의 30%
--           그외 부서원은 급여의 5%
--
--사번, 성, 부서코드, 급여, 보너스 조회


--보너스는 
--부서코드가 20이하 이면           급여의 30%
--급여가 10000 이상이면            급여의 20%
--업무코드가 clerk 종류의 업무이면 급여의 10%
--그외는                           급여의 5%
--
--사번, 이름, 성, 부서코드, 급여, 업무코드, 보너스 조회


--1. 사원들의 사번, 이름, 업무코드, 업무등급 조회
--업무등급은 업무코드에 따라 분류한다.
--DECODE 와 CASE~END 사용하여 조회
--
--업무코드    업무등급
--AD_PRES      A
--ST_MAN       B
--IT_PROG      C
--SA_REP       D
--ST_CLERK     E
--그 외        X

--2. 모든 사원의 각 사원들의 근무년수, 근속상태를 파악하고자 한다.
--사원들의 사번, 성, 입사일자, 근무개월수, 근무년수, 근속상태 조회
--근무년수는 오늘을 기준으로 근무한 년수를 정수로 표현한다.
--근속상태는 근무년수에 따라 표현한다.
--근무년수가 15년 미만 이면              '15년 미만 근속'으로 표현
--           15년 이상 17년 미만 이면    '17년 미만 근속'으로 표현
--           17년 이상 이면              '17년 이상 근속'으로 표현     


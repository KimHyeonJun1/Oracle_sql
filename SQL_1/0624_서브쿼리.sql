    -- 9장. 서브쿼리
-- SQL문 속의 또 다른 SQL 문을 서브쿼리( Sub Query) 라고 한다.
-- 어떤 상황이나 조건에 따라 변할수 있는 데이터 값을 비교하거나, 근거로 하기위해 SQL문 안에 작성하는
-- 또다른 SQL 문을 의미함.
-- ※ 조인과 더불어 실무에서 자주 사용하는 문법 ==> 숙지하는 것이 좋다.
-- ※ 서브쿼리는 필수가 아니나, 실무에서 활용 ==> 메인쿼리, 서브쿼리 차이점

-- 서브쿼리 종류
-- 1) 서브쿼리 실행 결과에 따라 : 단일 행, 다중 행, 다중 열(=컬럼) 서브쿼리
--      그룹함수: SUM(), MAX(), MIN(), COUNT(), AVG() ==> 결과가 단일 행이 나옴
-- 2) 사용위치에 따라 : WHERE : 가장 일반적인 사용처, FROM : 어떤 테이블인것처럼, SELECT: 어떤 컬럼인것처럼

-- ※ 서브쿼리가 메인쿼리보다 먼저 실행됨.


-- p.242 실습 9-1
SELECT  first_name, salary
FROM    employees
WHERE   UPPER(first_name) = 'KI'; -- 급여 2400

-- II. 일반쿼리 --> ki 급여보다 높은 급여를 받는 사원 조회
SELECT  first_name, salary
FROM    employees
WHERE   salary > 2400; -- 102명


-- III. 서브쿼리

SELECT  first_name, salary
FROM    employees
WHERE   salary >  ( SELECT   salary 
                    FROM    employees
                    WHERE   first_name = 'Ki' ); -- 102명

--==============================================================
-- p.244 서브쿼리의 특징
-- 1. 서브쿼리는 연산자와 같은 비교 또는 조회 대상의 오른쪽에 놓이며, 괄호로 묶어서 사용
-- 2. 특수한 몇몇 경우를 제외하고 대부분의 서브쿼리에서는 OREDR BY를 사용할 수 없다.
-- 3. 서브쿼리의 SELECT 절에 명시한 열은, 메인 쿼리의 비교 대상과 같은 자료형과 같은 개수로 지정해야 한다.
-- 4. 서브쿼리의 SELECT 문의 결과 행 수는 메인쿼리의 연산자 종류와 호환이 가능해야 한다.
--       └ ORA-01427: 단일 행 하위 질의에 2개 이상의 행이 리턴되었습니다. 라는 오류가 발생할 수 있음
--==============================================================






 --=============================================================                 
-- p.246. 09-2 단일 행 서브쿼리   
-- 단일 행 연산자 : > , >= , =, <=, <, [<> | ^= | !=]
 --=============================================================  
SELECT  first_name, salary
FROM    employees
WHERE   salary >  ( SELECT   salary 
                    FROM    employees
                    WHERE   department_id = 20 ); 
                    
                    
-- Q. 30번 부서의 평균 급여보다 많은 급여를 받는 사원을 조회 (단, 평균급여는 반올림하여 처리)
-- I. 30 번 부서의 평균 급여 조회 : 4150
SELECT  AVG(salary)
FROM    employees
WHERE   department_id = 30;

-- II. 4150 보다 많은 급여를 받는 사원을 조회
SELECT employee_id, first_name, salary, department_id
FROM    employees
WHERE   salary >  4150;  -- 63rows

-- III. 단일 행 서브쿼리로 변경하여 조회

SELECT employee_id, first_name, salary, department_id
FROM    employees
WHERE   salary > (SELECT  AVG(salary)
                    FROM    employees
                    WHERE   department_id = 30); -- 63rows
                    
-- 가장 많은 급여를 받는 사원의 정보를 조회 하시오
-- I. 가장 많은 급여를 조회
-- II. 사원정보를 조회하면 급여 기준으로 필터링 : 값은 값
SELECT  employee_id, first_name, salary, job_id, department_id
FROM    employees
WHERE   salary = (SELECT MAX(salary)
                  FROM  employees
                  );
                  
-- p.246 실습 9-4. 사원중 이름이 SCOTT 보다 빨리 입사한 사원을 조회
-- 1. Ki 사원의 입사일 조회 : 07/12/12
SELECT  *
FROM    employees
WHERE   first_name = 'Ki' ;
-- 2. 다른 사원들과 Ki 사원의 입사일을 기준으로 필터링
SELECT  employee_id, first_name, hire_date, department_id
FROM    employees
WHERE   hire_date <  (SELECT      hire_date
                      FROM        employees
                      WHERE       first_name = 'Ki');


-- p.247 실습 9-5. 20번 부서에 속한 사원중 전체 사원의 평균 급여보다 높은 급여를 받는
-- 사원의 정보와 소속 부서 정보를 함께 조회 하시오
-- 조인연산, 서브쿼리

-- ※ 서브쿼리는 필수가 아니지만, 메인쿼리를 여러번에 걸쳐서 처리하는 것보다 효율적이다.
--I. 20번 부서의 평균급여 조회
SELECT  AVG(salary)
FROM    employees
WHERE   department_id = 20;

-- II. 사원-부서정보 조인연산
SELECT  e.employee_id, e.first_name, e.salary, e.department_id,
        d.department_name
FROM    employees e, departments d
WHERE   e.department_id = d.department_id   -- 조인 조건
AND     e.salary > (SELECT  AVG(salary)
                    FROM    employees
                    WHERE   department_id = 20) --일반 조건
ORDER BY 3;

            
                  
 --=============================================================                 
-- p.246. 09-3 다중 행 서브쿼리                  
 -- IN : OR 연산자 대신 --> 여러개값들중 하나에 해당
 -- IN, ANY(또는 SOME), ALL , EXISTS  ==> =ANY, =SOME
 -- ALL : 모든 조건에 부합해야하는것
 -- EXISTS : 서브쿼리 실행결과가 있다면 --> 조회, 없다면 --> 조회x
 --=============================================================        
 --p.249 실습 9-6 사원중에서 20번 부서나 30번 부서에 소속된 사원을 조회
 SELECT *
 FROM   employees
-- WHERE  department_id = 20
-- OR     department_id = 30;
 WHERE  department_id IN (20,30);
 
 -- 실습 9-7 각 부서별 최고 급여와 동일한 급여를 받는 사원 정보 조회
 -- I. 부서별 최고 급여를 조회
 SELECT department_id, MAX(salary)
 FROM   employees
-- WHERE  department_id IS NOT NULL
GROUP BY department_id
ORDER BY 1;
 -- II. 이 최고 급여와 같은 급여를 받는 사원을(다시) 조회
 
 --1) IN 연산자
 SELECT employee_id, first_name, hire_date, salary, job_id, department_id
 FROM   employees
 WHERE  salary IN ( SELECT MAX(salary)
                    FROM    employees
                    GROUP BY department_id)
ORDER BY    department_id;           --24rows          
--=====================================================                    
 --ORA-01427: 단일 행 하위 질의에 2개 이상의 행이 리턴되었습니다. -->IN 연산자로 대체             
--=====================================================                    

--2) ANY(또는 SOME) : 메인쿼리와 조건식을 사용한 결과가 하나라도 true이면, 최종 true를 반환하는 서브쿼리 연산자
SELECT employee_id, first_name, hire_date, salary, job_id, department_id
 FROM   employees
 WHERE  salary = SOME ( SELECT MAX(salary)
                    FROM    employees
                    GROUP BY department_id)
ORDER BY    department_id;             --24 rows SOME또는 ANY 결과값 똑같음       
--============================

--3) ANY (또는 SOME) 대소비교
-- p.252 실습9-11. 30번 부ㅜ서 사원들의 최대 급여보다 적은 급여를 받는 사원 정보 출력하기
-- i. 30번 부서 사원들의 최대급여를 조회
-- ii. 전체 사원중에서 30번 부서 사원들의 최대급여와 비교해서 '적은'급여를 받는 사원을 조회
-- iii. 서브쿼리로, 전체 사원들중 30번 부서 사원들의 ~비교해서 ~ 사원을 조회
SELECT  employee_id, first_name, salary, department_id
FROM    employees
WHERE   salary < ANY ( SELECT   salary
                    FROM    employees
                    WHERE   department_id =30)
ORDER BY salary;
--=======================================================================
-- < ANY : 최대값(MAX) 미만의 값들과 일치하는 결과행이 조회 (작다ANY)
-- > ANY : 최소값(MIN) 초과하는 값들과 일치하는 결과행이 조회
--=======================================================================
SELECT  employee_id, first_name, salary, department_id
FROM    employees
WHERE   salary > ANY ( SELECT   salary
                    FROM    employees
                    WHERE   department_id =30)
ORDER BY salary;


-- 4) ALL 연산자
--========================================================================
-- < ALL : MIN() 보다 작은~ 
-- > ALL : MAX() 보다 큰~
--========================================================================
--30 번 부서원의 급여 : 2500,2600,2800,2900,3100,11000
SELECT  employee_id, first_name, salary, department_id
FROM    employees
WHERE   salary > ALL ( SELECT   salary
                    FROM    employees
                    WHERE   department_id =30)
ORDER BY salary; -- 11000보다 큰 10명


SELECT  employee_id, first_name, salary, department_id
FROM    employees
WHERE   salary < ALL ( SELECT   salary
                    FROM    employees
                    WHERE   department_id =30)
ORDER BY salary; -- 2500보다 작은 6명

--=======================================================================
-- > ANY | MAX() - 최대값과 비교해서 최대값보다 작은거 전부조회
-- < ANY | MIN() - 최소값과 비교해서 최소값보다 큰거 전부조회
-- = ANY | IN() - 일치하는 어떤
-- > ALL | MAX() - 최대값보다 큰거 전부조회
-- < ALL | MIN() - 최소값보다 작은거 전부조회
-- EXISTS : 서브쿼리 결과가 있다면 조회 아니면 X
--========================================================================

-- 5) EXOSTS : 서브쿼리에 결과값이 하나 이상 존재하면 조건식이 모두 true, 존재하지 않으면 모두 false
-- p.256 실습 9-16. 서브쿼리 결과값이 존재하는 경우
-- ※ 특정 서브쿼리 결과값의 존재 유무를 통해, 메인 쿼리의 데이터 노출 여부를 결정할때 간혹 사용한다.
SELECT  *
FROM    employees
WHERE   EXISTS ( SELECT department_name
                FROM    departments
                WHERE   department_id = 10 );


-- 부서가 존재하지 않는 경우 : 10~110 , 부서가 존재하고 매니저가 배정된 부서, 120 ~270 : 부서만 존재, 매니저가 배정되지 않은
SELECT  *
FROM    employees
WHERE   EXISTS ( SELECT department_name
                FROM    departments
                WHERE   department_id = 280 );




 -- III. 서브쿼리 --> 사원정보를 조회할때 급여가 각 부서별 최고급여를 받는 사람과 같은 사원을 조회
 
  --============================================================================
 -- p.258. 09-4 다중 열(컬럼) 서브쿼리 : 서브쿼리 실행결과 열이 여러개 포함된 값을 반환
 -- 서브쿼리 SELECT 절에 비교할 데이터를 여러개 지정하는 방식, 메인쿼리에 비교할 열을 괄호로 묶어 명시하고,
 -- 서브쿼리에서는 괄호로 묵은 데이터와 같은 자료형 데이터를 SELECT 절에 명시한다
 --============================================================================
 -- 실습 9-18. 부서별 최고급여를 받는 사원을 조회하는 서브쿼리
 -- I. 부서별 최고급여를 조회
 -- II. 전체 사원들중에서 비교
 
 SELECT MAX(salary)
 FROM   employees
 GROUP BY   department_id;
 
 
 -- III. 다중 열 서브쿼리
 -- DDL 작성시 다시 한번 언급.
 SELECT *
 FROM   employees
 WHERE  salary = ANY (SELECT MAX(salary)
                    FROM employees
                    GROUP BY department_id);
 
 

 SELECT *
 FROM   employees
 -- WHERE  (비교할 컬럼1, 컬럼2...) IN(서브쿼리: 다중 행, 다중 열)
WHERE   (department_id, salary) IN (SELECT   department_id, MAX(salary)
                                     FROM    employees
                                     GROUP BY department_id);
 --============================================================================
--  조회 목적 보다는 어떤 테이블에 여러 컬럼의 값을 입력하거나 수정할때 활용이 좋다 ==> DDL /테이블 생성할때
--  보통: 테이블 생성, 데이터 입력 <--> 테이블 생성과 동시에 조회된 데이터를 한번에 여러 열에 입력할때
--============================================================================

 
 --==================================================================
 -- 서브쿼리 종류, 사용위치에 따른 구분
 -- p. 259 09-5) 인라인 뷰 서브쿼리 : FROM 절에 사용하는 서브쿼리
 -- p. 261 09-6) 스칼라 서브쿼리 : SELECT 절에 사용하는 서브쿼리
 -- ※ 일반적으로 서브쿼리는 WHERE 절에 사용한다
 -- ※ 서브쿼리는 필수가 아니지만, 실무 현장에 사용하는 경우가 많다.
 --==================================================================
--FROM 절 : 연산에 필요한 테이블을 나열하는 곳 ==> 서브쿼리 실행결과가 마치 어떤 테이블이 있는것 처럼 ==> 가상의 테이블처럼?
 -- ※ 현재 작업에 불필요한 열이 너무 많아, 일부 행과 열만 사용하고자 할 떄
 -- 실습 9-19. 인라인 뷰 사용하기
 
 
 -- I. 인라인 뷰 사용하지 않기
 SELECT e.employee_id, e.first_name, e.department_id,
        d.department_name,
        l.city  AS LOC
FROM    employees e, departments d, locations l
WHERE   e.department_id = d.department_id
AND     d.location_id = l.location_id
AND     e.department_id = 10;
 
 -- II. 실습 9-19
 SELECT e10.employee_id, e10.first_name, e10.department_id,
        d.department_name,
        l.city
 FROM   (SELECT *
         FROM   employees
         WHERE  department_id = 10) e10,
         (SELECT *
         FROM   departments ) d,
         (SELECT *
         FROM   locations ) l
WHERE   e10.department_id = d.department_id
AND     d.location_id = l.location_id;
 
 --=============================================
 --서브쿼리와 WITH 절 : FROM 절에 너무 많은 서브쿼리를 지정하면, 가독성, 선능이 떨어질수 있다
 -- WITH 절 형식
 -- WITH
 -- [별칭 1] AS (SELECT 이하~),
 -- [별칭 2] AS (SELECT 이하~),
 -- SELECT 절
 -- FROM 별칭1, 별칭2, ...
 -- WHERE 절/ 이하~
  --=============================================

WITH
e10 AS (SELECT *
         FROM   employees
         WHERE  department_id = 10),
d   AS (SELECT *
         FROM   departments),
l   AS (SELECT *
         FROM   locations)
SELECT   e10.employee_id, e10.first_name, e10.department_id,
         d.department_name,
         l.city
FROM    e10, d, l        
WHERE   e10.department_id = d.department_id
AND     d.location_id = l.location_id;    
 
 --===========================================================
 --p.261. 스칼라 서브쿼리 : SELECT 절에 사용하는 서브쿼리
 -- SELECT 절에 하나의 열(=컬럼) 영역으로 결과를 출력할 수 있다.
 --===========================================================
-- 스칼라 서브쿼리 사용하지 않고 ==> 조인연산
SELECT  e.employee_id, e.first_name, e.salary,
        d.department_name 
FROM    employees e, departments d 
WHERE   e.department_id = d.department_id(+); --일반적인 조인형식


--스칼라 서브쿼리를 사용해서 조인 사용하지 않고
SELECT  e.employee_id, e.first_name, e.salary,
        (SELECT department_name --location_id 붙이면 아래 ora-00913오류
        FROM    departments d
        WHERE   d.department_id = e.department_id)
FROM    employees e;
--==========================================================
--ORA-00913: 값의 수가 너무 많습니다 : 스칼라(Scalar, 크기값만 갖는 개념) vs 벡터 (Vector, 크기와 위치값을 갖는 개념)
-- 스칼라 서브쿼리 실행 결과 ==> 단일 열(=컬럼) 처럼 값을 반환하여야 함
--==========================================================




 --==========================================================
 -- 상호 연관 서브쿼리 : 서브 쿼리의 결과 값을 다시 메인 쿼리로 돌려주는 방식
 -- 서브쿼리에 결과에 메인 쿼리가 결과가 포함된? 연간되? ==> JOIN 연산의 형식
 -- ※ 성능 저하의 원인 될수 있꼬, 사용빈도가 높지 않음
 -- 수십, 수백만건~ 되어야 성능저하를 체감! 
 --==========================================================
 SELECT employee_id, first_name, salary, department_id
 FROM   employees e1
 WHERE  salary > (SELECT    MIN(salary)
                    FROM    employees e2
                    WHERE   e2.department_id = e1.department_id)
 ORDER BY   department_id, salary; 
  
  --====================================================================
 -- p.262 잊기 전에 한번더 
-- Q1. 전체 사원중 ALLEN과 같은 직책인 사원들의 사원정보(사번, 이름, 급여, 직무), 부서정보를 조회(부서번호, 부서명)
-- ALEEN이 없으니까 Ki로 변경
SELECT  job_id
FROM    employees
WHERE   first_name = 'Ki'; -- Ki의 직무 : ST_CLERK

SELECT e.job_id, e.employee_id, e.first_name, e.salary,
        d.department_id, d.department_name
FROM     employees e, departments d
WHERE   e.department_id = d.department_id
AND job_id = 'ST_CLERK'; -- 20rows join

SELECT e.job_id, e.employee_id, e.first_name, e.salary,
        d.department_id, d.department_name
FROM     employees e, departments d
WHERE   e.department_id = d.department_id
AND job_id = (SELECT    job_id
                FROM    employees
                WHERE   first_name = 'Ki'); -- 20 rows 일반(WHERE절에 사용하는) 서브쿼리
                
SELECT e.job_id, e.employee_id, e.first_name, e.salary,
        d.department_id, d.department_name
FROM     employees e INNER JOIN departments d
ON   e.department_id = d.department_id
WHERE job_id = (SELECT    job_id
                FROM    employees
                WHERE   first_name = 'Ki');-- 20rows 일반(WHERE절에 사용하는)ANSI + 서브쿼리 조인                

-- Q2. 전체 사원의 평균 급여보다 높은 급여를 받는 사원들의 사원 정보, 부서 정보
-- 단 출력시 급여가 많은 순으로 정렬하되 급여가 같을 경우 사원 번호를 기준으로 오름차순으로 정렬하기
-- 전체사원 평균 급여 : 6462
SELECT  e.employee_id, e.first_name, d.department_name, e.hire_date, l.city, e.salary
FROM    employees e, departments d, locations l
WHERE   e.department_id = d.department_id
AND     d.location_id = l.location_id
AND     e.salary > (SELECT ROUND(AVG(salary))
                    FROM    employees)
ORDER BY    e.salary DESC, e.employee_id ASC;


--Q3. 10번 부서에 근무하는 사원 중 30번 부서에는 존재하지 않는 직책을 가진 사원들의 사원 정보, 부서 정보를 조회
-- I. 30번 부서에 근무하는 사원의 직책을 조회
SELECT  job_id
FROM    employees
WHERE   department_id = 30;

-- 결과행 여러개 ==> IN, = ANY, >ANY, <ANY, > ALL, <ALL.. => 다중 행서브쿼리
-- NOT IN, NOT BETWEEN, NOT LIKE ...

-- II. 사원정보, 부서정보
-- 30번 부서원의 직무 : PU_MAN, PU_CLERK (6명)
SELECT  e.employee_id, e.first_name, e.job_id, e.department_id,
        d.department_name, 
        l.city
FROM    employees e, departments d, locations l
WHERE   e.department_id = d.department_id
AND     d.location_id = l.location_id
AND     e.department_id = 10
AND     job_id NOT IN (SELECT  job_id
                        FROM    employees
                        WHERE   department_id = 30);
-- Q4. 직책이 SALESMAN(=SA_MAN)인 사원들의 최고 급여보다 높은 급여를 받는 사원들의 사원정보를 조회
SELECT  employee_id, first_name, salary
FROM    employees
WHERE   salary > (SELECT    MAX(salary)
                    FROM    employees
                    WHERE   job_id = 'SA_MAN'); -- 14000 이상 사원 3rows
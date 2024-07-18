-- p.119 집합 연산자
-- 수학의 집합개념을 데이터베이스에 적용 ==> 조인과의 차이점 : 테이블의 관계가 없어도 마치 하나의 텡비ㅡㄹ 데이터처럼 조회 가능
-- 1) 합집합 : (UNION)  : 두 집합의 데이터를 합친 결과를 반환 ==> 오라클에서는 중복된 데이터를 제거하여 반환!
--      └ 만약, 중복된 데이터를 제거하지 않으려면 UNION ALL(중복된 값을 포함) 을 사용해야 함.

-- 2) 차집합 : (MINUS)  : 두 집합에서 한쪽에만 해당하는 데이터를 연산의 결과로 반환
-- 3) 교집합 : (INTERSECT)  : 두 집합의 공통 데이터만 연산의 결과로 반환
-- ※ SET 연산은 컬럼 갯수, 데이터 타입이 중요함 => 일치해야함.

-- 실습 5-30. 합집합 연산자를 사용하여 데이터 조회
SELECT  employee_id, first_name, salary, department_id
FROM    employees 
WHERE   department_id = 10
UNION   ALL
SELECT  employee_id, first_name, salary, department_id
FROM    employees
WHERE   department_id = 10
UNION   ALL
SELECT  employee_id, first_name, salary, department_id
FROM    employees
WHERE   department_id = 10;

-- p.120 실습 5-31. 집합 연산자를 사용해 출력 열 갯수가 다를떄 ==> 오류발생
SELECT  employee_id AS 사번, first_name AS 이름, salary AS 급여, department_id AS 부서번호 -- AS 첫번째만 해도 나옴
FROM    employees
WHERE   department_id = 10
UNION
SELECT  employee_id, first_name, salary
FROM    employees
WHERE   department_id = 20;

--실습 5-32
SELECT  employee_id, first_name, salary, department_id
FROM    employees
WHERE   department_id = 10
UNION
SELECT  employee_id, first_name,  email, salary
FROM    employees
WHERE   department_id = 20;

--=================================================================
--ORA-01789: 질의 블록은 부정확한 수의 결과 열을 가지고 있습니다.
--ORA-01790: 대응하는 식과 같은 데이터 유형이어야 합니다
-- 집합 연산은 컬럼의 갯수, 데이터 타입이 일치해야 실행됨.
--=================================================================



SELECT  employee_id, first_name, salary, department_id
FROM    employees
WHERE   department_id BETWEEN 10 AND 30
MINUS
SELECT  employee_id, first_name, salary, department_id
FROM    employees
WHERE   department_id = 20; -- 20번부서가 빠져서  총 9명에서 7명

-- IN 연산자 : 이게 결과는 같은데 위에보다 훨씬 간단함.
SELECT  employee_id, first_name, salary, department_id
FROM    employees
WHERE   department_id IN(10,30);

-- INTERSECT 연산자
SELECT  employee_id, first_name, salary, department_id
FROM    employees
WHERE   department_id BETWEEN 10 AND 30
INTERSECT
SELECT  employee_id, first_name, salary, department_id
FROM    employees
WHERE   department_id = 20;


SELECT  first_name
FROM    employees
WHERE   department_id = 50
INTERSECT
SELECT  first_name
FROM    employees
WHERE   department_id = 80;



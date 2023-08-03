

/* 함수 : 컬럼의 값을 읽어서 연산한 결과를 반환
*
* 단일 행 함수 : N개의 값을 읽어서 N개의 결과를 반환
* 그룹 함수    : N개의 값을 읽어서 1개의 결과를 반환(합계, 평균, 최대, 최소)
* 
* 함수는 SELECT문의 
* SELECT절, WHERE절, ORDER BY절, GRUUP BY절, HAVING절 사용 가능
*
*/

-------------------------------------------------------

-- ** 단일 행 함수**

-- 1) LENGTH(컬럼명 | 문자열) : 길이 반환

SELECT EMAIL, LENGTH(EMAIL) FROM EMPLOYEE;

-- INSTR(컬럼명 | 문자열, '찾을 문자열' [, 찾기 시작할 위치 [, 순번])
-- 지정한 위치부터 지정한 순번째로 검색되는 문자의 위치를 반환

-- 문자열을 앞에서부터 검색하여 첫번째 B 위치 조회
SELECT INSTR('AABAACAABBAA', 'B') FROM DUAL; 

-- 문자열을 5번째 문자부터 검색하여 첫번째 B 위치 조회
SELECT INSTR('AABAACAABBAA', 'B', 5) FROM DUAL; 

-- 문자열을 5번째 문자부터 검색해서 두번째 B의 위치 조회
SELECT INSTR('AABAACAABBAA', 'B', 5, 2) FROM DUAL; 

-- EMPLOYEE 테이블에서 사원명, 이메일, 이메일 중 '@'의 위치 조회
SELECT EMP_NAME, EMAIL,INSTR(EMAIL, '@') FROM EMPLOYEE;

------------------------------------------------------------

-- 2) SUBSTR(컬럼명 | '문자열', 잘라내기 시작할 위치, [,잘라낼 길이]) 
-- 컬럼이나 문자열에서 지정한 위치부터 지정된 길이만큼 문자열을 잘라서 반환
-- 잘라낼 길이 생략시 끝까지 잘라냄

-- EMPLOYEE 에서 사원명, 이메일 중 아이디만 조회
SELECT EMP_NAME, EMAIL, SUBSTR(EMAIL, 1, INSTR(EMAIL, '@')-1) FROM EMPLOYEE;
 
-----------------------------------------------------------------------

-- 3) TRIM([ [옵션] '문자열' | 컬럼명 FROM] '문자열' | 컬럼명)
-- 주어진 컬럼이나 문자열의 앞, 뒤, 양쪽에 있는 지정된 문자를 제거
--> 양쪽 공백 제거에 사용

-- 옵션 : LEADING(앞쪽), TRAILING(뒤쪽), BOTH(양쪽)

SELECT TRIM('            H E L L O           ') FROM DUAL;
SELECT TRIM(BOTH '#' FROM '#######%#안녕####^###')FROM DUAL; -- 중간에 다른 글자 있으면 거기서 멈춤

-------------------------------------------------------------------------

-- ** 숫자 관련 함수 **

-- 1) ABS(숫자 | 컬럼명) : 절대값
-- WHERE절에서도 가능
SELECT ABS(10), ABS(-10) FROM DUAL;
SELECT '절대값 같음' FROM DUAL
WHERE ABS(10) = ABS(-10);

---------------------------------------------------------------------------

-- 2) MOD(숫자 | 컬럼명, 숫자  | 컬럼명) : 나머지 값 반환
-- EMPLOYEE 테이블에서 사원의 월급을 100만으로 나눴을 떄 나머지 조회

SELECT EMP_NAME, SALARY, MOD(SALARY, 1000000) FROM EMPLOYEE ;

-- EMPLOYEE 에서 사번이 짝수 인 사원의 사번 이름
SELECT EMP_ID, EMP_NAME FROM EMPLOYEE WHERE MOD(EMP_ID, 2) = 0; 

-- EMPLOYEE 에서 사번이 짝수 인 사원의 사번 이름
SELECT EMP_ID, EMP_NAME FROM EMPLOYEE WHERE MOD(EMP_ID, 2) = 1; 

---------------------------------------------------------------------------

-- 3) ROUND(숫자 | 컬럼명 [, 소수점 위치]) : 반올림
SELECT ROUND(123.456) FROM DUAL; -- 소수점 첫번째에서 반올림

SELECT ROUND(123.456, 1) FROM DUAL; -- 소수점 첫번째까지 표현

-- 4) CEIL(숫자 | 컬럼명) : 올림  -- 소수점 위치 못 넣음
-- 5) FLOOR(숫자 | 컬럼명) : 내림

SELECT CEIL(123.456345), FLOOR(123.9) FROM DUAL; 

-- 6) TRUNC(숫자 | 컬럼명 [, 소수점 위치 OR 정수 위치]) : 특정 위치 아래를 버림(첨삭)
SELECT TRUNC(12423.1245424, 2) FROM DUAL; -- 소수점 2번째 자리까지 남김
SELECT TRUNC(12423.1245424, -2) FROM DUAL; -- 10의 자리 까지 버림 

SELECT FLOOR(-123.5), TRUNC(-123.5) FROM DUAL;

---------------------------------------------------------------------------



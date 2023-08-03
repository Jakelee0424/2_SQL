--한줄 주석
/* 범위 주석 */

-- ctrl + enter : 한줄 실행 
-- alt + x : 전체 실행
-- f3 : 편집기 선택
-- alt + ] : 새 sql 편집기 
-- ctrl + shift + 위/아래 : 행이동


-- 새로운 사용자 계정 생성
ALTER SESSION SET "_ORACLE_SCRIPT" = TRUE;
CREATE USER kh IDENTIFIED BY kh1234;


-- 사용자 계정 권한 부여
GRANT RESOURCE, CONNECT TO kh;


-- 객체가 생성될 수 있는 공간 할당량 지정
ALTER USER kh DEFAULT TABLESPACE SYSTEM QUOTA UNLIMITED ON SYSTEM;
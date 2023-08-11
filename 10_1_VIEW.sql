/* VIEW
	
	- SELECT문의 실행 결과(RESULT SET)를 저장하는 객체
	- 논리적 가상 테이블
		-> 테이블 모양을 하고는 있지만
			실제로 값을 저장하고 있지는 않음.

	** VIEW 사용 목적 **
	1) 복잡한 SELECT문을 쉽게 재사용하기 위해서 사용.
	2) 테이블의 진짜 모습을 감출 수 있어 보안상 유리함.
	
	***** VIEW 사용 시 주의사항 *****
	1) 가상의 테이블(실제 테이블 X) -> ALTER 구문 사용 불가
	2) VIEW를 이용한 DML(INSERT/UPDATE/DELETE)가 
	   가능한 경우도 있지만 
	   많은 제약이 따르기 때문에 SELECT 용도로 사용 하는 것을 권장.


    [VIEW 생성 방법]
    CREATE [OR REPLACE] [FORCE | NOFORCE] VIEW 뷰이름 [(alias[,alias]...)]
    AS subquery
    [WITH CHECK OPTION]
    [WITH READ ONLY];
    
    -- 1) OR REPLACE 옵션 : 기존에 동일한 뷰 이름이 존재하는 경우 덮어쓰고, 
    --                      존재하지 않으면 새로 생성.
    -- 2) FORCE / NOFORCE 옵션
    --      FORCE : 서브쿼리에 사용된 테이블이 존재하지 않아도 뷰 생성
    --      NOFORCE : 서브쿼리에 사용된 테이블이 존재해야만 뷰 생성(기본값)
    -- 3) WITH CHECK OPTION 옵션 : 옵션을 설정한 컬럼의 값을 수정 불가능하게 함.
    -- 4) WITH READ ONLY 옵션 : 뷰에 대해 조회만 가능(DML 수행 불가)    
*/

-- ============================================================
-- HR 인사관리 시스템 DB 초기화 SQL
-- Database: dlive_insa
-- ============================================================

USE dlive_insa;

-- 사원 기본 마스터 테이블
CREATE TABLE IF NOT EXISTS PHM_EMP_C (    
    EMP_ID              INT NOT NULL             COMMENT '사원id',
    COMPANY_CD          VARCHAR(10) NOT NULL       COMMENT '인사영역',
    EMP_NO              VARCHAR(10) NOT NULL       COMMENT '사원번호',
    EMP_NM              VARCHAR(40)                COMMENT '사원성명',
    ENG_NM              VARCHAR(40)                COMMENT '사원성명(영문)',
    CHI_NM              VARCHAR(40)                COMMENT '사원성명(한문)',
    CTZ_NO              VARCHAR(13)                COMMENT '주민번호',
    EMP_KIND_CD         VARCHAR(10)                COMMENT '직원구분코드 [PHM_EMP_KIND_CD]',
    HIRE_CD             VARCHAR(10)                COMMENT '채용구분코드 [CAM_CAU_CD]',
    IN_OFFI_YN          CHAR(1)                     COMMENT '재직여부',
    SEX_CD              VARCHAR(10)                COMMENT '성별코드(PHM_SEX_CD)',
    BIRTH_YMD           DATE                        COMMENT '생년월일',
    SOLAR_TYPE          CHAR(1)                     COMMENT '음양구분(1:양, 2:음)',
    POS_GRD_CD          VARCHAR(10)                COMMENT '직급코드 [PHM_POS_GRD_CD]',
    POS_GRD_YMD         DATE                        COMMENT '직급승진일',
    NEXT_POS_GRD_YMD    DATE                        COMMENT '차기직급승진일',
    POS_CD              VARCHAR(10)                COMMENT '직위코드 [PHM_POS_CD]',
    POS_YMD             DATE                        COMMENT '직위임용일',
    YEARNUM             VARCHAR(2)                 COMMENT '호봉',
    YEARNUM_YMD         DATE                        COMMENT '호봉승급일',
    NEXT_YEARNUM_YMD    DATE                        COMMENT '차기호봉승급일',
    ORG_CD              VARCHAR(10)                COMMENT '발령부서코드',
    ORG_YMD             DATE                        COMMENT '발령부서전입일',
    PAY_KIND_CD         VARCHAR(10)                COMMENT '급여구분코드 [CAM015]',
    PAY_ORG_CD          VARCHAR(10)                COMMENT '급여부서코드',
    WORK_ORG_CD         VARCHAR(10)                COMMENT '근무부서코드',
    WORK_ORG_YMD        DATE                        COMMENT '근무부서전입일',
    DUTY_CD             VARCHAR(10)                COMMENT '직책코드 [PHM_CALL_CD]',
    DUTY_YMD            DATE                        COMMENT '직책부여일',
    CALL_CD             VARCHAR(10)                COMMENT '호칭코드',
    CALL_YMD            DATE                        COMMENT '호칭부여일',
    JOB_CD              VARCHAR(10)                COMMENT '직무코드',
    JOB_YMD             DATE                        COMMENT '직무담당일',
    HIRE_YMD            DATE NOT NULL               COMMENT '입사일자',
    ANNUAL_CAL_YMD      DATE                        COMMENT '연차기산일',
    RETIRE_YMD          DATE                        COMMENT '퇴직일',
    RETIRE_PLAN_YMD     DATE                        COMMENT '퇴직예정일',
    RETIRE_TYPE_CD      VARCHAR(10)                COMMENT '퇴직구분코드 [CAM_CAU_CD]',
    TRAINING_S_YMD      DATE                        COMMENT '수습시작일자',
    TRAINING_E_YMD      DATE                        COMMENT '수습종료일자',
    EMP_KIND_SUB_CD     VARCHAR(10)                COMMENT '직원세부구분 [PHM_EMP_STYPE_CD]',
    REPREDUTY_CD        VARCHAR(10)                COMMENT '대표담당업무',
    FILE_NM             VARCHAR(100)               COMMENT '사진파일명',
    FILE_ID             VARCHAR(100)               COMMENT '사진파일ID',
    ANNUAL_DD           INT(3)                   COMMENT '연차보전일수',
    MOD_USER_ID         INT NOT NULL             COMMENT '변경자',
    MOD_DATE            DATE NOT NULL               COMMENT '변경일',
    CON_YMD             DATE                        COMMENT '계약종료예정일',
    PRIMARY KEY (EMP_ID)
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='인사기본';


-- 발령 이력 테이블
CREATE TABLE IF NOT EXISTS CAM_HISTORY_C
(    
    CAM_HISTORY_ID  INT          NOT NULL    COMMENT '발령이력ID',
    EMP_ID          INT          NOT NULL    COMMENT '사원ID',
    STA_YMD         DATE            NOT NULL    COMMENT '발령일자',
    END_YMD         DATE            NOT NULL    COMMENT '발령종료일',
    WRITE_DATE      DATE            NOT NULL    COMMENT '투입일시',
    TYPE_CD         VARCHAR(10)    NOT NULL    COMMENT '발령유형코드 [CAM_TYPE_CD]',
    CAU_CD          VARCHAR(10)                COMMENT '발령사유코드 [CAM_CAU_CD]',
    CAM_DOC_ID      INT          NOT NULL    COMMENT '발령품의서ID',
    COMPANY_CD      VARCHAR(10)                COMMENT '발령인사영역 [PHM_COMPANY_CD]',
    ORG_CD          VARCHAR(10)                COMMENT '발령부서',
    POS_CD          VARCHAR(10)                COMMENT '발령직위 [PHM_POS_CD]',
    POS_GRD_CD      VARCHAR(10)                COMMENT '발령직급 [PHM_POS_GRD_CD]',
    JOB_CD          VARCHAR(10)                COMMENT '발령직렬',
    DUTY_CD         VARCHAR(10)                COMMENT '발령직책 [PHM_CALL_CD]',
    CALL_CD         VARCHAR(10)                COMMENT '발령호칭',
    EMP_KIND_CD     VARCHAR(10)                COMMENT '발령직원구분 [PHM_EMP_KIND_CD]',
    COMPANY_CHN_YN  CHAR(1)         NOT NULL    COMMENT '인사영역변경여부',
    ORG_CHN_YN      CHAR(1)         NOT NULL    COMMENT '부서변경여부',
    POS_CHN_YN      CHAR(1)         NOT NULL    COMMENT '직위변경여부',
    POS_GRD_CHN_YN  CHAR(1)         NOT NULL    COMMENT '직급변경여부',
    JOB_CHN_YN      CHAR(1)         NOT NULL    COMMENT '직무변경여부',
    DUTY_CHN_YN     CHAR(1)         NOT NULL    COMMENT '호칭변경여부',
    EMP_KIND_CHN_YN CHAR(1)         NOT NULL    COMMENT '직원구분변경여부',
    HIRE_YN         CHAR(1)         NOT NULL    COMMENT '채용여부',
    RETIRE_YN       CHAR(1)         NOT NULL    COMMENT '퇴직여부',    
    SEND_YN         CHAR(1)                     COMMENT '겸직여부',
    REST_YN         CHAR(1)                     COMMENT '휴직여부',
    REN_YMD         DATE                        COMMENT '휴직복직예정일',
    BABY_YMD        DATE                        COMMENT '출산예정일',
    REST_RTN_YN     CHAR(1)                     COMMENT '휴직복직여부',
    DIS_YN          CHAR(1)                     COMMENT '파견여부',
    DIS_KIND_CD     VARCHAR(10)                COMMENT '파견구분 [CAM_DIS_KIND_CD]',
    DIS_RTN_YMD     DATE                        COMMENT '파견복귀예정일',
    DIS_ORG_CD      VARCHAR(10)                COMMENT '파견부서코드',
    DIS_AREA_NM     VARCHAR(40)                COMMENT '파견처명',
    DIS_RTN_YN      CHAR(1)                     COMMENT '파견복직여부',
    HIRE_CD         VARCHAR(10)                COMMENT '채용구분코드_사용하지 않음 [PHM_HIRE_CD]',
    YEARNUM         VARCHAR(2)                 COMMENT '발령호봉',
    YEARNUM_CHN_YN  CHAR(1)                     COMMENT '호봉변경여부',
    REASON_CD       VARCHAR(10)                COMMENT '채용구분 [CAM_REASON_CD]',
    MAS_YN          CHAR(1)                     COMMENT '인사반영여부',
    NOTE            VARCHAR(200)               COMMENT '비고',
    MOD_USER_ID     INT          NOT NULL    COMMENT '변경자',
    MOD_DATE        DATE            NOT NULL    COMMENT '변경일',
    OUT_NOTE        VARCHAR(100)               COMMENT '퇴직사유',
    OUT_YMD         DATE                        COMMENT '퇴직일자',
    DIS_POS_CD      VARCHAR(10)                COMMENT '파견직위',
    DIS_DUTY_CD     VARCHAR(10)                COMMENT '파견직책',
    DIS_POS_GRD_CD  VARCHAR(10)                COMMENT '파견지점',
    CON_YMD         DATE                        COMMENT '계약종료예정일',
    
    PRIMARY KEY (CAM_HISTORY_ID)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='발령이력';




-- 조직 테이블
CREATE TABLE IF NOT EXISTS ORM_ORG_C
(
    ORM_ORG_ID      INT NOT NULL         COMMENT '조직정보ID',
    COMPANY_CD      VARCHAR(10) NOT NULL    COMMENT '인사영역 [PHM_COMPANY_CD]',
    ORG_CD          VARCHAR(10) NOT NULL    COMMENT '조직코드',
    STA_YMD         DATE NOT NULL           COMMENT '적용시작일자',
    END_YMD         DATE NOT NULL           COMMENT '적용종료일자',
    ORG_NM          VARCHAR(100)            COMMENT '소속명',
    SHORT_NM        VARCHAR(100)            COMMENT '조직약명',
    FULL_NM         VARCHAR(100)            COMMENT '조직전체명',
    ENG_NM          VARCHAR(100)            COMMENT '조직영문명',
    HR_ORG_NM       VARCHAR(40)             COMMENT '인사조직명',
    SUPER_ORG_CD    VARCHAR(10)             COMMENT '상위조직코드',
    MGR_ORG_CD      VARCHAR(10)             COMMENT '사업본부조직코드',
    CONTROL_ORG_CD  VARCHAR(10)             COMMENT '관리조직코드',
    ORG_TYPE_CD     VARCHAR(10)             COMMENT '계층코드 [ORM_ORG_LEVEL_CD]',
    WORK_AREA_CD    VARCHAR(10)             COMMENT '작업장코드 [ORM_WORK_AREA_CD]',
    COST_ORG_CD     VARCHAR(10)             COMMENT '코스트센터',
    SQ              VARCHAR(20)             COMMENT '조직순차',
    ORG_REASON_CD   VARCHAR(10)             COMMENT '조직변경사유코드 [ORM_REASON_CD]',
    REG_ORG_YN      CHAR(1)                 COMMENT '공식조직유무',
    ORG_LINE        VARCHAR(500)            COMMENT '조직라인',
    ORG_S_YMD       DATE                    COMMENT '개설일자',
    ORG_E_YMD       DATE                    COMMENT '폐쇄일자',
    ORG_ETC_CD1     VARCHAR(10)             COMMENT '기타코드1',
    ORG_ETC_CD2     VARCHAR(10)             COMMENT '기타코드2',
    ORG_ETC_CD3     VARCHAR(10)             COMMENT '기타코드3',
    NOTE            VARCHAR(200)            COMMENT '비고',
    MOD_USER_ID     INT NOT NULL         COMMENT '변경자',
    MOD_DATE        DATE NOT NULL       COMMENT '변경일' ,
    
    PRIMARY KEY (ORM_ORG_ID)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='조직정보';


-- 공통코드 테이블
CREATE TABLE IF NOT EXISTS XFRMD2C
(
    CD_ID       INT         NOT NULL     COMMENT '코드ID',
    CD          VARCHAR(10)   NOT NULL     COMMENT '코드',
    CD_NM       VARCHAR(100)               COMMENT '코드명',
    SYSTEM_CD   VARCHAR(10)                COMMENT '시스템코드',
    SHORT_NM    VARCHAR(40)                COMMENT '코드약명',
    FOR_NM      VARCHAR(100)               COMMENT '외국어명',
    COMPANY_CD  VARCHAR(10)   NOT NULL     COMMENT '회사코드(인사영역)',
    CD_KIND     VARCHAR(100)  NOT NULL     COMMENT '코드분류',
    STA_YMD     DATE           NOT NULL     COMMENT '생성일자',
    END_YMD     DATE           NOT NULL     COMMENT '종료일자',
    PRINT_NM    VARCHAR(100)               COMMENT '출력명',
    ORD_NO      VARCHAR(10)                COMMENT '정렬순서',
    CONV_CD     VARCHAR(20)                COMMENT '변환코드',
    ETC_CD1     VARCHAR(100)               COMMENT '기타코드1',
    ETC_CD2     VARCHAR(100)               COMMENT '기타코드2',
    ETC_CD3     VARCHAR(100)               COMMENT '기타코드3',
    ETC_CD4     VARCHAR(100)               COMMENT '기타코드4',
    ETC_CD5     VARCHAR(100)               COMMENT '기타코드5',
    ETC_CD6     VARCHAR(100)               COMMENT '기타코드6',
    ETC_CD7     VARCHAR(100)               COMMENT '기타코드7',
    ETC_CD8     VARCHAR(100)               COMMENT '기타코드8',
    ETC_CD9     VARCHAR(100)               COMMENT '기타코드9',
    ETC_CD10    VARCHAR(100)               COMMENT '기타코드10',
    NOTE        VARCHAR(100)               COMMENT '비고',
    MOD_USER_ID INT                      COMMENT '변경자',
    MOD_DATE    DATE                        COMMENT '변경일시',
    
    PRIMARY KEY (CD_ID)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='공통코드';




-- 샘플 데이터


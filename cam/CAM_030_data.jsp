<%@ page language="java" contentType="application/json; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ include file="../common/db_include.jsp" %>
<%
    request.setCharacterEncoding("UTF-8");
    response.setCharacterEncoding("UTF-8");
    response.setHeader("Cache-Control", "no-cache");

    final String SQL_FILE = "CAM_030.xml";

    String action = nvl(request.getParameter("action"));
    StringBuilder json = new StringBuilder();

    Connection conn = null;
    PreparedStatement pstmt = null;
    CallableStatement cstmt = null;
    ResultSet rs = null;

    try {
        conn = getConnection(application);

        // ============================================================
        // 발령 목록 조회
        // ============================================================
        if ("search".equals(action)) {
            String fromDt = nvl(request.getParameter("fromDt"));
            String toDt   = nvl(request.getParameter("toDt"));
            String orgCd  = nvl(request.getParameter("orgCd"));
            String typeCd = nvl(request.getParameter("typeCd"));
            String empNm  = nvl(request.getParameter("empNm"));

            // CAM_030.xml > searchList: INFORMATION_SCHEMA COLUMN_COMMENT [CD_KIND] 기반 10개 XFRMD2C JOIN
            StringBuilder sql = new StringBuilder(getSql(SQL_FILE, "searchList", application));

            if (!orgCd.isEmpty())  sql.append(" AND h.ORG_CD = ?");
            if (!typeCd.isEmpty()) sql.append(" AND h.TYPE_CD = ?");
            if (!empNm.isEmpty())  sql.append(" AND e.EMP_NM LIKE ?");
            sql.append(" ORDER BY h.STA_YMD DESC, h.CAM_HISTORY_ID DESC LIMIT 200");

            pstmt = conn.prepareStatement(sql.toString());
            int pi = 1;
            pstmt.setString(pi++, fromDt.isEmpty() ? "1900-01-01" : fromDt);
            pstmt.setString(pi++, toDt.isEmpty()   ? "9999-12-31" : toDt);
            if (!orgCd.isEmpty())  pstmt.setString(pi++, orgCd);
            if (!typeCd.isEmpty()) pstmt.setString(pi++, typeCd);
            if (!empNm.isEmpty())  pstmt.setString(pi++, "%" + empNm + "%");
            rs = pstmt.executeQuery();

            json.append("[");
            boolean first = true;
            while (rs.next()) {
                if (!first) json.append(",");
                first = false;
                json.append("{")
                    .append("\"camHistoryId\":").append(rs.getInt("CAM_HISTORY_ID")).append(",")
                    .append("\"empId\":").append(rs.getInt("EMP_ID")).append(",")
                    .append("\"empNo\":\"").append(escJson(rs.getString("EMP_NO"))).append("\",")
                    .append("\"empNm\":\"").append(escJson(rs.getString("EMP_NM"))).append("\",")
                    .append("\"ssnNo\":\"").append(escJson(rs.getString("CTZ_NO"))).append("\",")
                    .append("\"staDt\":\"").append(escJson(rs.getString("STA_YMD"))).append("\",")
                    .append("\"yearnum\":\"").append(escJson(rs.getString("YEARNUM"))).append("\",")
                    .append("\"sendYn\":\"").append(escJson(rs.getString("SEND_YN"))).append("\",")
                    // 코드 원값
                    .append("\"typeCd\":\"").append(escJson(rs.getString("TYPE_CD"))).append("\",")
                    .append("\"cauCd\":\"").append(escJson(rs.getString("CAU_CD"))).append("\",")
                    .append("\"companyCd\":\"").append(escJson(rs.getString("COMPANY_CD"))).append("\",")
                    .append("\"orgCd\":\"").append(escJson(rs.getString("ORG_CD"))).append("\",")
                    .append("\"posCd\":\"").append(escJson(rs.getString("POS_CD"))).append("\",")
                    .append("\"posGrdCd\":\"").append(escJson(rs.getString("POS_GRD_CD"))).append("\",")
                    .append("\"dutyCd\":\"").append(escJson(rs.getString("DUTY_CD"))).append("\",")
                    .append("\"empKindCd\":\"").append(escJson(rs.getString("EMP_KIND_CD"))).append("\",")
                    .append("\"disKindCd\":\"").append(escJson(rs.getString("DIS_KIND_CD"))).append("\",")
                    .append("\"hirecCd\":\"").append(escJson(rs.getString("HIRE_CD"))).append("\",")
                    .append("\"reasonCd\":\"").append(escJson(rs.getString("REASON_CD"))).append("\",")
                    .append("\"jobCd\":\"").append(escJson(rs.getString("JOB_CD"))).append("\",")
                    // COLUMN_COMMENT [CD_KIND] 기반 해석된 코드명
                    .append("\"typeNm\":\"").append(escJson(rs.getString("type_nm"))).append("\",")
                    .append("\"cauNm\":\"").append(escJson(rs.getString("cau_nm"))).append("\",")
                    .append("\"companyNm\":\"").append(escJson(rs.getString("company_nm"))).append("\",")
                    .append("\"orgNm\":\"").append(escJson(rs.getString("org_nm"))).append("\",")
                    .append("\"posNm\":\"").append(escJson(rs.getString("pos_nm"))).append("\",")
                    .append("\"posGrdNm\":\"").append(escJson(rs.getString("pos_grd_nm"))).append("\",")
                    .append("\"dutyNm\":\"").append(escJson(rs.getString("duty_nm"))).append("\",")
                    .append("\"jobNm\":\"").append(escJson(rs.getString("job_nm"))).append("\",")
                    .append("\"empKindNm\":\"").append(escJson(rs.getString("emp_kind_nm"))).append("\",")
                    .append("\"disKindNm\":\"").append(escJson(rs.getString("dis_kind_nm"))).append("\",")
                    .append("\"hireNm\":\"").append(escJson(rs.getString("hire_nm"))).append("\",")
                    .append("\"reasonNm\":\"").append(escJson(rs.getString("reason_nm"))).append("\",")
                    .append("\"workSoNm\":\"").append(escJson(rs.getString("work_so_nm"))).append("\",")
                    // 부가 필드
                    .append("\"restYn\":\"").append(escJson(rs.getString("REST_YN"))).append("\",")
                    .append("\"renDt\":\"").append(escJson(rs.getString("REN_YMD"))).append("\",")
                    .append("\"babyDt\":\"").append(escJson(rs.getString("BABY_YMD"))).append("\",")
                    .append("\"conDt\":\"").append(escJson(rs.getString("CON_YMD"))).append("\",")
                    .append("\"disYn\":\"").append(escJson(rs.getString("DIS_YN"))).append("\",")
                    .append("\"disRtnDt\":\"").append(escJson(rs.getString("DIS_RTN_YMD"))).append("\",")
                    .append("\"disOrgCd\":\"").append(escJson(rs.getString("DIS_ORG_CD"))).append("\",")
                    .append("\"disPosCd\":\"").append(escJson(rs.getString("DIS_POS_CD"))).append("\",")
                    .append("\"disDutyCd\":\"").append(escJson(rs.getString("DIS_DUTY_CD"))).append("\",")
                    .append("\"disPosGrdCd\":\"").append(escJson(rs.getString("DIS_POS_GRD_CD"))).append("\",")
                    .append("\"note\":\"").append(escJson(rs.getString("NOTE"))).append("\",")
                    .append("\"outNote\":\"").append(escJson(rs.getString("OUT_NOTE"))).append("\"")
                    .append("}");
            }
            json.append("]");

        // ============================================================
        // 공통코드 목록 조회 (드롭다운용)
        // INFORMATION_SCHEMA.COLUMNS > COLUMN_COMMENT [CD_KIND] 기반 동적 조회
        // 반환 키 = CD_KIND 값 (예: "CAM_TYPE_CD":[...], "PHM_POS_CD":[...])
        // ============================================================
        } else if ("getCodes".equals(action)) {

            // Step 1: CAM_HISTORY_C COLUMN_COMMENT에서 CD_KIND 목록 추출
            String kindMapSql = getSql(SQL_FILE, "getColCdKindMap", application);
            PreparedStatement psKinds = conn.prepareStatement(kindMapSql);
            ResultSet rsKinds = psKinds.executeQuery();

            java.util.LinkedHashSet<String> kindSet = new java.util.LinkedHashSet<>();
            while (rsKinds.next()) {
                kindSet.add(rsKinds.getString("cd_kind"));
            }
            rsKinds.close();
            psKinds.close();

            json.append("{");

            // Step 2: CD_KIND별 XFRMD2C 코드 목록 조회 (SHORT_NM 포함)
            boolean firstKind = true;
            for (String ck : kindSet) {
                if (!firstKind) json.append(",");
                firstKind = false;
                json.append("\"").append(ck).append("\":[");
                PreparedStatement ps2 = conn.prepareStatement(
                    "SELECT CD, CD_NM, SHORT_NM FROM XFRMD2C " +
                    "WHERE CD_KIND = ? AND END_YMD = '9999-12-31' " +
                    "ORDER BY CAST(ORD_NO AS UNSIGNED)");
                ps2.setString(1, ck);
                ResultSet rs2 = ps2.executeQuery();
                boolean f2 = true;
                while (rs2.next()) {
                    if (!f2) json.append(",");
                    f2 = false;
                    json.append("{\"cd\":\"").append(escJson(rs2.getString("CD")))
                        .append("\",\"cdNm\":\"").append(escJson(rs2.getString("CD_NM")))
                        .append("\",\"shortNm\":\"").append(escJson(rs2.getString("SHORT_NM")))
                        .append("\"}");
                }
                rs2.close();
                ps2.close();
                json.append("]");
            }

            // PHM_POS_GRD_CD(담당지점/파견지점), PHM_HOBONG(호봉)은 INFORMATION_SCHEMA 루프에서 처리됨
            json.append("}");

        // ============================================================
        // 저장 (저장 프로시저 호출)
        // ============================================================
        } else if ("save".equals(action)) {
            String camHistoryId = nvl(request.getParameter("camHistoryId"), "0");
            String empId        = nvl(request.getParameter("empId"));
            String staDt        = nvl(request.getParameter("staDt"));
            String typeCd       = nvl(request.getParameter("typeCd"));
            String cauCd        = nvl(request.getParameter("cauCd"));
            String companyCd    = nvl(request.getParameter("companyCd"));
            String orgCd        = nvl(request.getParameter("orgCd"));
            String posGrdCd     = nvl(request.getParameter("posGrdCd"));   // 담당지점(SO) [PHM_POS_GRD_CD]
            String jobCd        = nvl(request.getParameter("jobCd"));      // 발령직무 [PHM_JOB_CD]
            String posCd        = nvl(request.getParameter("posCd"));
            String dutyCd       = nvl(request.getParameter("dutyCd"));
            String empKindCd    = nvl(request.getParameter("empKindCd"));
            String yearnum      = nvl(request.getParameter("yearnum"));
            String reasonCd     = nvl(request.getParameter("reasonCd"));   // 채용구분 [CAM_REASON_CD]
            String sendNm       = nvl(request.getParameter("sendNm"));
            String restYn       = nvl(request.getParameter("restYn"), "N");
            String renDt        = nvl(request.getParameter("renDt"));
            String babyDt       = nvl(request.getParameter("babyDt"));
            String conDt        = nvl(request.getParameter("conDt"));
            String disYn        = nvl(request.getParameter("disYn"), "N");
            String disKindCd    = nvl(request.getParameter("disKindCd"));
            String disRtnDt     = nvl(request.getParameter("disRtnDt"));
            String disOrgCd     = nvl(request.getParameter("disOrgCd"));
            String disPosCd     = nvl(request.getParameter("disPosCd"));
            String disDutyCd    = nvl(request.getParameter("disDutyCd"));
            String disPosGrdCd  = nvl(request.getParameter("disPosGrdCd"));

            cstmt = conn.prepareCall(
                "{call sp_cam030_save(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)}");
            int ci = 1;
            cstmt.setInt   (ci++, Integer.parseInt(camHistoryId));
            cstmt.setInt   (ci++, Integer.parseInt(empId));
            cstmt.setString(ci++, staDt);
            cstmt.setString(ci++, typeCd);
            cstmt.setString(ci++, cauCd.isEmpty()       ? null : cauCd);
            cstmt.setString(ci++, companyCd.isEmpty()   ? null : companyCd);
            cstmt.setString(ci++, orgCd.isEmpty()       ? null : orgCd);
            cstmt.setString(ci++, posCd.isEmpty()       ? null : posCd);
            cstmt.setString(ci++, dutyCd.isEmpty()      ? null : dutyCd);
            cstmt.setString(ci++, empKindCd.isEmpty()   ? null : empKindCd);
            cstmt.setString(ci++, yearnum.isEmpty()     ? null : yearnum);
            cstmt.setString(ci++, null); // p_hirec_cd: HIRE_CD는 사용 안 함 (REASON_CD 별도 UPDATE)
            cstmt.setString(ci++, sendNm.isEmpty()      ? null : sendNm);
            cstmt.setString(ci++, restYn);
            cstmt.setString(ci++, renDt.isEmpty()       ? null : renDt);
            cstmt.setString(ci++, babyDt.isEmpty()      ? null : babyDt);
            cstmt.setString(ci++, conDt.isEmpty()       ? null : conDt);
            cstmt.setString(ci++, disYn);
            cstmt.setString(ci++, disKindCd.isEmpty()   ? null : disKindCd);
            cstmt.setString(ci++, disRtnDt.isEmpty()    ? null : disRtnDt);
            cstmt.setString(ci++, disOrgCd.isEmpty()    ? null : disOrgCd);
            cstmt.setString(ci++, disPosCd.isEmpty()    ? null : disPosCd);
            cstmt.setString(ci++, disDutyCd.isEmpty()   ? null : disDutyCd);
            cstmt.setString(ci++, disPosGrdCd.isEmpty() ? null : disPosGrdCd);
            cstmt.setInt   (ci++, 1); // mod_user_id (고정 - 추후 세션 연동)

            boolean hasRs = cstmt.execute();
            int newId = 0;
            if (hasRs) {
                rs = cstmt.getResultSet();
                if (rs != null && rs.next()) newId = rs.getInt("new_id");
            }

            // 프로시저가 반환한 나머지 결과셋/업데이트카운트를 모두 소진한다.
            // (소진하지 않고 같은 커넥션에서 후속 UPDATE 실행 시 MySQL "명령 순서 오류" 발생)
            if (rs != null) { rs.close(); rs = null; }
            while (true) {
                if (cstmt.getMoreResults()) {
                    ResultSet tmp = cstmt.getResultSet();
                    if (tmp != null) tmp.close();
                } else if (cstmt.getUpdateCount() == -1) {
                    break;
                }
            }
            cstmt.close();
            cstmt = null;

            // COLUMN_COMMENT 기반 추가 컬럼 직접 UPDATE
            // POS_GRD_CD(담당지점 [PHM_POS_GRD_CD]), REASON_CD(채용구분 [CAM_REASON_CD]), JOB_CD(발령직무 [PHM_JOB_CD])
            int targetId = (newId > 0) ? newId : Integer.parseInt(camHistoryId);
            pstmt = conn.prepareStatement(
                "UPDATE CAM_HISTORY_C SET " +
                "  POS_GRD_CD = ?, " +
                "  REASON_CD  = ?, " +
                "  JOB_CD     = ? " +
                "WHERE CAM_HISTORY_ID = ?");
            pstmt.setString(1, posGrdCd.isEmpty() ? null : posGrdCd);
            pstmt.setString(2, reasonCd.isEmpty()  ? null : reasonCd);
            pstmt.setString(3, jobCd.isEmpty()     ? null : jobCd);
            pstmt.setInt   (4, targetId);
            pstmt.executeUpdate();

            json.append("{\"result\":\"ok\",\"newId\":").append(newId).append("}");

        // ============================================================
        // 삭제
        // ============================================================
        } else if ("delete".equals(action)) {
            String camHistoryId = nvl(request.getParameter("camHistoryId"));
            pstmt = conn.prepareStatement(
                "DELETE FROM CAM_HISTORY_C WHERE CAM_HISTORY_ID = ?");
            pstmt.setInt(1, Integer.parseInt(camHistoryId));
            pstmt.executeUpdate();
            json.append("{\"result\":\"ok\"}");

        } else {
            json.append("{\"error\":\"Unknown action: ").append(escJson(action)).append("\"}");
            response.setStatus(400);
        }

    } catch (Exception e) {
        json.setLength(0);
        json.append("{\"result\":\"error\",\"message\":\"")
            .append(escJson(e.getMessage())).append("\"}");
        response.setStatus(500);
    } finally {
        if (rs    != null) try { rs.close();    } catch (Exception ig) {}
        if (pstmt != null) try { pstmt.close(); } catch (Exception ig) {}
        if (cstmt != null) try { cstmt.close(); } catch (Exception ig) {}
        if (conn  != null) try { conn.close();  } catch (Exception ig) {}
    }

    out.print(json.toString());
    out.flush();
%>

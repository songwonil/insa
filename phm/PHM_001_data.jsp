<%@ page language="java" contentType="application/json; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ include file="../common/db_include.jsp" %>
<%
    request.setCharacterEncoding("UTF-8");
    response.setCharacterEncoding("UTF-8");
    response.setHeader("Cache-Control", "no-cache");

    final String SQL_FILE = "PHM_001.xml";
    String action = nvl(request.getParameter("action"));
    StringBuilder json = new StringBuilder();

    Connection conn = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;

    try {
        conn = getConnection(application);

        // ============================================================
        // 직원 검색
        // ============================================================
        if ("search".equals(action)) {
            String nm     = nvl(request.getParameter("nm"));
            String status = nvl(request.getParameter("status"));

            StringBuilder sql = new StringBuilder(getSql(SQL_FILE, "searchEmp", application));
            if (!nm.isEmpty())                             sql.append(" AND e.EMP_NM LIKE ?");
            if ("1".equals(status) || "2".equals(status)) sql.append(" AND e.IN_OFFI_YN = 'Y'");
            else if ("3".equals(status))                  sql.append(" AND e.IN_OFFI_YN = 'N'");
            sql.append(" ORDER BY e.EMP_NM LIMIT 100");

            pstmt = conn.prepareStatement(sql.toString());
            if (!nm.isEmpty()) pstmt.setString(1, "%" + nm + "%");
            rs = pstmt.executeQuery();

            json.append("[");
            boolean first = true;
            while (rs.next()) {
                if (!first) json.append(",");
                first = false;
                json.append("{")
                    .append("\"empId\":").append(rs.getInt("EMP_ID")).append(",")
                    .append("\"empNm\":\"").append(escJson(rs.getString("EMP_NM"))).append("\",")
                    .append("\"deptNm\":\"").append(escJson(rs.getString("dept_nm"))).append("\",")
                    .append("\"positionNm\":\"").append(escJson(rs.getString("position_nm"))).append("\",")
                    .append("\"workStatus\":\"").append(escJson(rs.getString("work_status"))).append("\"")
                    .append("}");
            }
            json.append("]");

        // ============================================================
        // 단건 사원 조회
        // ============================================================
        } else if ("getEmp".equals(action)) {
            String empId = nvl(request.getParameter("empId"));

            pstmt = conn.prepareStatement(getSql(SQL_FILE, "getEmp", application));
            pstmt.setInt(1, Integer.parseInt(empId));
            rs = pstmt.executeQuery();

            if (rs.next()) {
                String workStatus = "Y".equals(nvl(rs.getString("IN_OFFI_YN"))) ? "1" : "3";
                json.append("{")
                    .append("\"empId\":").append(rs.getInt("EMP_ID")).append(",")
                    .append("\"empNo\":\"").append(escJson(rs.getString("EMP_NO"))).append("\",")
                    .append("\"empNm\":\"").append(escJson(rs.getString("EMP_NM"))).append("\",")
                    .append("\"empNmEng\":\"").append(escJson(rs.getString("ENG_NM"))).append("\",")
                    .append("\"empNmHanja\":\"").append(escJson(rs.getString("CHI_NM"))).append("\",")
                    .append("\"empSsn\":\"").append(escJson(rs.getString("CTZ_NO"))).append("\",")
                    .append("\"empGender\":\"").append(escJson(rs.getString("SEX_CD"))).append("\",")
                    .append("\"empBirthDt\":\"").append(escJson(rs.getString("BIRTH_YMD"))).append("\",")
                    .append("\"workStatus\":\"").append(workStatus).append("\",")
                    .append("\"corpCd\":\"").append(escJson(rs.getString("COMPANY_CD"))).append("\",")
                    .append("\"corpNm\":\"").append(escJson(rs.getString("corp_nm"))).append("\",")
                    .append("\"grpJoinDt\":\"").append(escJson(rs.getString("ANNUAL_CAL_YMD"))).append("\",")
                    .append("\"corpJoinDt\":\"").append(escJson(rs.getString("HIRE_YMD"))).append("\",")
                    .append("\"deptCd\":\"").append(escJson(rs.getString("ORG_CD"))).append("\",")
                    .append("\"deptNm\":\"").append(escJson(rs.getString("dept_nm"))).append("\",")
                    .append("\"positionNm\":\"").append(escJson(rs.getString("pos_label"))).append("\",")
                    .append("\"titleNm\":\"").append(escJson(rs.getString("duty_label"))).append("\",")
                    .append("\"workSo\":\"").append(escJson(rs.getString("work_so_nm"))).append("\",")
                    .append("\"jobType\":\"").append(escJson(rs.getString("JOB_CD"))).append("\",")
                    .append("\"dutyNm\":\"").append(escJson(rs.getString("REPREDUTY_CD"))).append("\",")
                    .append("\"photoPath\":\"").append(escJson(rs.getString("FILE_NM"))).append("\",")
                    .append("\"mobileNo\":\"\",\"officeTel\":\"\",\"homeTel\":\"\",")
                    .append("\"empNationality\":\"내국인\",\"eduLevel\":\"\",")
                    .append("\"corpEmail\":\"\",\"personalEmail\":\"\",")
                    .append("\"veteranYn\":\"N\",\"disabilityYn\":\"N\",")
                    .append("\"clubNm\":\"\",\"maritalStatus\":\"\",")
                    .append("\"hometown\":\"\",\"homeAddr\":\"\"")
                    .append("}");
            } else {
                json.append("{\"error\":\"사원을 찾을 수 없습니다.\"}");
                response.setStatus(404);
            }

        // ============================================================
        // 사원 정보 저장
        // ============================================================
        } else if ("saveEmp".equals(action)) {
            String empId      = nvl(request.getParameter("empId"));
            String empNm      = nvl(request.getParameter("empNm"));
            String empNmHanja = nvl(request.getParameter("empNmHanja"));
            String empNmEng   = nvl(request.getParameter("empNmEng"));
            String empSsn     = nvl(request.getParameter("empSsn"));
            String workStatus = nvl(request.getParameter("workStatus"));
            String grpJoinDt  = nvl(request.getParameter("grpJoinDt"));
            String corpJoinDt = nvl(request.getParameter("corpJoinDt"));
            String workSo     = nvl(request.getParameter("workSo"));
            String positionNm = nvl(request.getParameter("positionNm"));
            String titleNm    = nvl(request.getParameter("titleNm"));
            String empGender  = nvl(request.getParameter("empGender"));
            String empBirthDt = nvl(request.getParameter("empBirthDt"));
            String jobType    = nvl(request.getParameter("jobType"));
            String dutyNm     = nvl(request.getParameter("dutyNm"));

            int    empIdInt = Integer.parseInt(empId);
            String inOffiYn = "3".equals(workStatus) ? "N" : "Y";
            String empNo    = "E" + String.format("%03d", empIdInt);

            pstmt = conn.prepareStatement(getSql(SQL_FILE, "saveEmp", application));
            int i = 1;
            pstmt.setInt   (i++, empIdInt);
            pstmt.setString(i++, empNo);
            pstmt.setString(i++, empNm);
            pstmt.setString(i++, empNmEng.isEmpty()   ? null : empNmEng);
            pstmt.setString(i++, empNmHanja.isEmpty() ? null : empNmHanja);
            pstmt.setString(i++, empSsn.isEmpty()     ? null : empSsn);
            pstmt.setString(i++, inOffiYn);
            pstmt.setString(i++, empGender.isEmpty()  ? null : empGender);
            pstmt.setString(i++, empBirthDt.isEmpty() ? null : empBirthDt);
            pstmt.setString(i++, corpJoinDt.isEmpty() ? null : corpJoinDt);
            pstmt.setString(i++, grpJoinDt.isEmpty()  ? null : grpJoinDt);
            pstmt.setString(i++, positionNm.isEmpty() ? null : positionNm);
            pstmt.setString(i++, titleNm.isEmpty()    ? null : titleNm);
            pstmt.setString(i++, jobType.isEmpty()    ? null : jobType);
            pstmt.setString(i++, dutyNm.isEmpty()     ? null : dutyNm);
            pstmt.setString(i++, workSo.isEmpty()     ? null : workSo);
            pstmt.executeUpdate();

            json.append("{\"result\":\"ok\",\"message\":\"저장되었습니다.\"}");

        // ============================================================
        // 발령 이력
        // ============================================================
        } else if ("getAppoint".equals(action)) {
            String empId = nvl(request.getParameter("empId"));

            pstmt = conn.prepareStatement(getSql(SQL_FILE, "getAppoint", application));
            pstmt.setInt(1, Integer.parseInt(empId));
            rs = pstmt.executeQuery();

            json.append("[");
            boolean first = true;
            while (rs.next()) {
                if (!first) json.append(",");
                first = false;
                json.append("{")
                    .append("\"appointId\":").append(rs.getInt("CAM_HISTORY_ID")).append(",")
                    .append("\"appointDt\":\"").append(escJson(rs.getString("STA_YMD"))).append("\",")
                    .append("\"appointType\":\"").append(escJson(rs.getString("appoint_type"))).append("\",")
                    .append("\"fromDeptNm\":\"").append(escJson(rs.getString("from_dept_nm"))).append("\",")
                    .append("\"toDeptNm\":\"").append(escJson(rs.getString("to_dept_nm"))).append("\",")
                    .append("\"fromPosition\":\"").append(escJson(rs.getString("from_position"))).append("\",")
                    .append("\"toPosition\":\"").append(escJson(rs.getString("to_position"))).append("\",")
                    .append("\"remark\":\"").append(escJson(rs.getString("remark"))).append("\"")
                    .append("}");
            }
            json.append("]");

        // ============================================================
        // 가족/학력/경력 - 해당 테이블 없음
        // ============================================================
        } else if ("getFamily".equals(action) || "getEdu".equals(action) || "getCareer".equals(action)) {
            json.append("[]");

        } else {
            json.append("{\"error\":\"Unknown action\"}");
            response.setStatus(400);
        }

    } catch (Exception e) {
        json.setLength(0);
        json.append("{\"result\":\"error\",\"message\":\"").append(escJson(e.getMessage())).append("\"}");
        response.setStatus(500);
    } finally {
        if (rs    != null) try { rs.close();    } catch (Exception ignore) {}
        if (pstmt != null) try { pstmt.close(); } catch (Exception ignore) {}
        if (conn  != null) try { conn.close();  } catch (Exception ignore) {}
    }

    out.print(json.toString());
    out.flush();
%>

<%@ page language="java" contentType="application/json; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ include file="db_include.jsp" %>
<%
    request.setCharacterEncoding("UTF-8");
    response.setCharacterEncoding("UTF-8");
    response.setHeader("Cache-Control", "no-cache");

    String action = nvl(request.getParameter("action"));
    StringBuilder json = new StringBuilder();

    Connection conn = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;

    try {
        conn = getConnection(application);

        // ============================================================
        // 코드 검색 (XFRMD2C)
        // params: cdKind(필수), keyword(선택, 코드명/코드값 LIKE)
        // return: [{cd, cdNm, shortNm}, ...]
        // ============================================================
        if ("codeSearch".equals(action)) {
            String cdKind  = nvl(request.getParameter("cdKind"));
            String keyword = nvl(request.getParameter("keyword"));

            if (cdKind.isEmpty()) {
                json.append("[]");
            } else {
                StringBuilder sql = new StringBuilder(
                    "SELECT CD, CD_NM, SHORT_NM FROM XFRMD2C " +
                    "WHERE CD_KIND = ? AND END_YMD = '9999-12-31' ");
                if (!keyword.isEmpty()) {
                    sql.append("AND (CD_NM LIKE ? OR CD LIKE ?) ");
                }
                sql.append("ORDER BY CAST(ORD_NO AS UNSIGNED)");

                pstmt = conn.prepareStatement(sql.toString());
                int pi = 1;
                pstmt.setString(pi++, cdKind);
                if (!keyword.isEmpty()) {
                    String kw = "%" + keyword + "%";
                    pstmt.setString(pi++, kw);
                    pstmt.setString(pi++, kw);
                }
                rs = pstmt.executeQuery();

                json.append("[");
                boolean first = true;
                while (rs.next()) {
                    if (!first) json.append(",");
                    first = false;
                    json.append("{")
                        .append("\"cd\":\"")     .append(escJson(rs.getString("CD")))      .append("\",")
                        .append("\"cdNm\":\"")   .append(escJson(rs.getString("CD_NM")))   .append("\",")
                        .append("\"shortNm\":\"").append(escJson(rs.getString("SHORT_NM"))).append("\"")
                        .append("}");
                }
                json.append("]");
            }

        // ============================================================
        // 부서 검색 (ORM_ORG_C)
        // params: keyword(선택, 부서명/조직코드 LIKE)
        // return: [{orgCd, orgNm, shortNm, parentNm}, ...]
        // ============================================================
        } else if ("deptSearch".equals(action)) {
            String keyword = nvl(request.getParameter("keyword"));

            StringBuilder sql = new StringBuilder(
                "SELECT o.ORG_CD, o.ORG_NM, " +
                "  COALESCE(o.SHORT_NM, '')  AS SHORT_NM, " +
                "  COALESCE(p.ORG_NM,   '')  AS PARENT_NM " +
                "FROM ORM_ORG_C o " +
                "LEFT JOIN ORM_ORG_C p " +
                "  ON o.SUPER_ORG_CD = p.ORG_CD AND p.END_YMD = '9999-12-31' " +
                "WHERE o.END_YMD = '9999-12-31' ");
            if (!keyword.isEmpty()) {
                sql.append("AND (o.ORG_NM LIKE ? OR o.ORG_CD LIKE ?) ");
            }
            sql.append("ORDER BY o.ORG_CD LIMIT 300");

            pstmt = conn.prepareStatement(sql.toString());
            if (!keyword.isEmpty()) {
                String kw = "%" + keyword + "%";
                pstmt.setString(1, kw);
                pstmt.setString(2, kw);
            }
            rs = pstmt.executeQuery();

            json.append("[");
            boolean first = true;
            while (rs.next()) {
                if (!first) json.append(",");
                first = false;
                json.append("{")
                    .append("\"orgCd\":\"")   .append(escJson(rs.getString("ORG_CD")))   .append("\",")
                    .append("\"orgNm\":\"")   .append(escJson(rs.getString("ORG_NM")))   .append("\",")
                    .append("\"shortNm\":\"") .append(escJson(rs.getString("SHORT_NM"))) .append("\",")
                    .append("\"parentNm\":\"").append(escJson(rs.getString("PARENT_NM"))).append("\"")
                    .append("}");
            }
            json.append("]");

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
        if (conn  != null) try { conn.close();  } catch (Exception ig) {}
    }

    out.print(json.toString());
    out.flush();
%>

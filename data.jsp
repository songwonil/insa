<%@ page language="java" contentType="application/json; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.io.BufferedReader" %>
<%
    // 1. 서버가 요청을 받을 때와 응답을 보낼 때의 인코딩을 UTF-8로 강제 지정 (★핵심)
    request.setCharacterEncoding("UTF-8");
    response.setCharacterEncoding("UTF-8");

    // 1. CORS 허용 설정 (React 서버의 주소에 맞게 설정, 테스트용으로 전체 허용)
    response.setHeader("Access-Control-Allow-Origin", "*");
    response.setHeader("Access-Control-Allow-Methods", "GET, POST, OPTIONS");
    response.setHeader("Access-Control-Allow-Headers", "Content-Type");

    // OPTIONS preflight 요청 처리
    if ("OPTIONS".equalsIgnoreCase(request.getMethod())) {
        response.setStatus(HttpServletResponse.SC_OK);
        return;
    }

    String method = request.getMethod();
    String jsonResponse = "";

    if ("GET".equalsIgnoreCase(method)) {
        // GET 요청 처리: 단순한 테스트용 JSON 반환
        jsonResponse = "{\"status\": \"success\", \"message\": \"안녕! 순수 JSP 파일(data.jsp)에서 보낸 GET! 데이터야123.\"}";
        
    } else if ("POST".equalsIgnoreCase(method)) {
        // POST 요청 처리: React가 보낸 JSON 바디 읽기
        StringBuilder sb = new StringBuilder();
        BufferedReader reader = request.getReader();
        String line;
        while ((line = reader.readLine()) != null) {
            sb.append(line);
        }
        String requestBody = sb.toString(); // React에서 보낸 JSON 데이터

        // 받은 데이터를 그대로 포함해서 응답 데이터 작성
        // (실제 개발 시에는 여기서 라이브러리를 쓰거나 DB 로직을 수행합니다)
        jsonResponse = "{\"status\": \"success\", \"message\": \"JSP가 POST 데이터를 잘 받았어!\", \"receivedData\": " + requestBody + "}";
    }

    // 2. 최종 JSON 응답 출력
    out.print(jsonResponse);
    out.flush();
%>
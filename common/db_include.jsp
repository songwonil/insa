<%@ page import="java.sql.*" %>
<%@ page import="io.github.cdimascio.dotenv.Dotenv" %>
<%!
    // DB 연결 공통 메서드
    public Connection getConnection(javax.servlet.ServletContext ctx) throws Exception {
        String envPath = ctx.getRealPath("/WEB-INF");
        Dotenv dotenv = Dotenv.configure().directory(envPath).load();
        String dbUrl  = dotenv.get("DB_URL");
        String dbUser = dotenv.get("DB_USER");
        String dbPass = dotenv.get("DB_PASSWORD");
        Class.forName("com.mysql.cj.jdbc.Driver");
        return DriverManager.getConnection(dbUrl, dbUser, dbPass);
    }

    // SQL XML 로드 및 캐시 (application scope)
    public java.util.Map<String, String> loadSqlMap(String xmlFile, javax.servlet.ServletContext ctx) throws Exception {
        String cacheKey = "SQL_CACHE_" + xmlFile;
        java.util.Map<String, String> map =
            (java.util.Map<String, String>) ctx.getAttribute(cacheKey);
        if (map != null) return map;

        map = new java.util.LinkedHashMap<String, String>();
        String xmlPath = ctx.getRealPath("/WEB-INF/sql/" + xmlFile);
        javax.xml.parsers.DocumentBuilder builder =
            javax.xml.parsers.DocumentBuilderFactory.newInstance().newDocumentBuilder();
        org.w3c.dom.Document doc = builder.parse(new java.io.File(xmlPath));
        org.w3c.dom.NodeList nodes = doc.getElementsByTagName("sql");
        for (int i = 0; i < nodes.getLength(); i++) {
            org.w3c.dom.Element el = (org.w3c.dom.Element) nodes.item(i);
            map.put(el.getAttribute("id"), el.getTextContent().trim());
        }
        ctx.setAttribute(cacheKey, map);
        return map;
    }

    public String getSql(String xmlFile, String id, javax.servlet.ServletContext ctx) throws Exception {
        java.util.Map<String, String> map = loadSqlMap(xmlFile, ctx);
        String sql = map.get(id);
        if (sql == null) throw new Exception("SQL not found: " + xmlFile + "#" + id);
        return sql;
    }

    // null-safe getString
    public String nvl(String s) { return (s == null) ? "" : s; }

    // JSON 문자열 이스케이프
    public String escJson(String s) {
        if (s == null) return "";
        return s.replace("\\","\\\\").replace("\"","\\\"")
                .replace("\r","\\r").replace("\n","\\n").replace("\t","\\t");
    }
%>

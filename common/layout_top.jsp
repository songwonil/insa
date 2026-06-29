<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    String loginUser = "김은경";
    // TODO: 세션에서 로그인 사용자 정보 가져오기
    // String loginUser = (String) session.getAttribute("loginUser");
%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<title>HR 인사관리 시스템 - (주)딜라이브</title>
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
<script src="${pageContext.request.contextPath}/js/common.js"></script>
</head>
<body>
<div id="wrap">

<!-- ===== 헤더 ===== -->
<div id="header">
    <div class="logo_wrap">
        <div class="logo_main">D'<span>LIVE</span></div>
        <div class="logo_sub">(주)딜라이브</div>
    </div>
    <div class="header_right">
        <div class="top_links">
            <a href="#">포털배치</a>
            <a href="#">비밀번호변경</a>
            <a href="#">직원검색</a>
            <a href="#">담당자연락처</a>
        </div>
        <div class="user_bar">
            <div class="user_greeting">
                <strong><%= loginUser %>님</strong> 반갑습니다
                <button class="btn_logout" onclick="if(confirm('로그아웃 하시겠습니까?')) location.href='${pageContext.request.contextPath}/';">LOG-OUT</button>
            </div>
            <div class="main_nav">
                <a href="#">My인사</a>
                <a href="#">HR전자결재</a>
                <a href="#">HR에 시민</a>
            </div>
        </div>
    </div>
</div>

<!-- ===== 서브 메뉴바 ===== -->
<div id="sub_menu_bar">
    <button class="btn_menu" id="btnToggleMenu">MENU</button>
    <button class="btn_menu">BOOKMARK</button>
</div>

<!-- ===== 콘텐츠 래퍼 ===== -->
<div id="content_wrap">

<!-- ===== 좌측 메뉴 ===== -->
<div id="left_nav">
    <div class="left_agent_wrap">
        <div class="left_agent_label">◎ 총괄담당</div>
        <select>
            <option>전체</option>
        </select>
        <button class="btn_hide">HIDE</button>
    </div>

    <div class="left_menu_group">
        <div class="left_menu_title" onclick="toggleMenu(this)">인력계획 <span class="arrow">▶</span></div>
        <div class="left_menu_items">
            <a href="#">인력계획현황</a>
        </div>
    </div>
    <div class="left_menu_group">
        <div class="left_menu_title" onclick="toggleMenu(this)">인력운영 <span class="arrow">▶</span></div>
        <div class="left_menu_items">
            <a href="#">인력현황</a>
            <a href="#">발령관리</a>
        </div>
    </div>
    <div class="left_menu_group">
        <div class="left_menu_title open" onclick="toggleMenu(this)">개인기록 <span class="arrow">▶</span></div>
        <div class="left_menu_items open">
            <a href="${pageContext.request.contextPath}/phm/PHM_001.jsp" class="${activeMenu eq 'PHM_001' ? 'active' : ''}">개인기록(전산)</a>
            <a href="#">인사기록카드(FULL)</a>
            <a href="#">인사기록카드(요약)</a>
            <a href="#">사원자료복사</a>
        </div>
    </div>
    <div class="left_menu_group">
        <div class="left_menu_title" onclick="toggleMenu(this)">증문서 <span class="arrow">▶</span></div>
        <div class="left_menu_items">
            <a href="#">증명서 발급</a>
        </div>
    </div>
    <div class="left_menu_group">
        <div class="left_menu_title" onclick="toggleMenu(this)">상벌관리 <span class="arrow">▶</span></div>
        <div class="left_menu_items">
            <a href="#">상벌내역</a>
        </div>
    </div>
    <div class="left_menu_group">
        <div class="left_menu_title" onclick="toggleMenu(this)">근태관리 <span class="arrow">▶</span></div>
        <div class="left_menu_items">
            <a href="#">근태현황</a>
        </div>
    </div>
    <div class="left_menu_group">
        <div class="left_menu_title" onclick="toggleMenu(this)">현황관리 <span class="arrow">▶</span></div>
        <div class="left_menu_items">
            <a href="#">인사현황</a>
        </div>
    </div>
    <div class="left_menu_group">
        <div class="left_menu_title" onclick="toggleMenu(this)">인사통계 <span class="arrow">▶</span></div>
        <div class="left_menu_items">
            <a href="#">통계조회</a>
        </div>
    </div>
    <div class="left_menu_group">
        <div class="left_menu_title" onclick="toggleMenu(this)">연명 <span class="arrow">▶</span></div>
        <div class="left_menu_items">
            <a href="#">연명부</a>
        </div>
    </div>
    <div class="left_menu_group">
        <div class="left_menu_title" onclick="toggleMenu(this)">교육관리 <span class="arrow">▶</span></div>
        <div class="left_menu_items">
            <a href="#">교육이력</a>
        </div>
    </div>
    <div class="left_menu_group">
        <div class="left_menu_title" onclick="toggleMenu(this)">인건비계획 <span class="arrow">▶</span></div>
        <div class="left_menu_items">
            <a href="#">인건비현황</a>
        </div>
    </div>
    <div class="left_menu_group">
        <div class="left_menu_title" onclick="toggleMenu(this)">시스템관리 <span class="arrow">▶</span></div>
        <div class="left_menu_items">
            <a href="#">코드관리</a>
            <a href="#">권한관리</a>
        </div>
    </div>
    <div class="left_menu_group">
        <div class="left_menu_title" onclick="toggleMenu(this)">급여관리 <span class="arrow">▶</span></div>
        <div class="left_menu_items">
            <a href="#">급여현황</a>
        </div>
    </div>
    <div class="left_menu_group">
        <div class="left_menu_title" onclick="toggleMenu(this)">평가관리 <span class="arrow">▶</span></div>
        <div class="left_menu_items">
            <a href="#">평가이력</a>
        </div>
    </div>
    <div class="left_menu_group">
        <div class="left_menu_title" onclick="toggleMenu(this)">성과평가 <span class="arrow">▶</span></div>
        <div class="left_menu_items">
            <a href="#">성과평가</a>
        </div>
    </div>
    <div class="left_menu_group">
        <div class="left_menu_title" onclick="toggleMenu(this)">조직관리 <span class="arrow">▶</span></div>
        <div class="left_menu_items">
            <a href="#">조직도</a>
        </div>
    </div>
</div>
<!-- ===== 좌측 메뉴 끝 ===== -->

<!-- ===== 메인 콘텐츠 시작 ===== -->
<div id="main_content">

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    String activeMenu = "PHM_001";
    String pageContext_empId = request.getParameter("empId");
    if (pageContext_empId == null) pageContext_empId = "";
%>
<%@ include file="../common/layout_top.jsp" %>

<!-- 브레드크럼 -->
<div class="breadcrumb">
    <a href="#">인력운영</a>
    <span class="sep">›</span>
    <a href="#">개인기록</a>
    <span class="sep">›</span>
    <span class="current">개인기록(전산)</span>
    <span class="page_code">PHM_001</span>
    <button class="btn_del" onclick="if(confirm('탭을 닫겠습니까?')) history.back();">del ×</button>
</div>

<!-- 인사기본사항 섹션 -->
<div class="section_box">
    <div class="section_header">
        <div class="section_title">인사기본사항</div>
        <div class="btn_group">
            <button class="btn btn_save" onclick="saveEmpInfo()">&#128190; 인사기록변경</button>
            <button class="btn" onclick="openPhotoUpload()">&#128247; 사진등록</button>
            <button class="btn btn_print" onclick="printCard()">&#128438; 인사기록카드출력</button>
        </div>
    </div>

    <div class="emp_header_wrap">
        <!-- 사진 영역 -->
        <div class="emp_photo_area">
            <div class="emp_photo_box" id="photoBox" onclick="openPhotoUpload()" title="클릭하여 사진 등록">
                <span id="photoPlaceholder">사진<br>없음</span>
                <img id="empPhoto" src="" alt="사원사진" style="display:none;">
            </div>
        </div>

        <!-- 기본 정보 테이블 -->
        <table class="emp_info_table">
            <colgroup>
                <col width="70"><col width="200"><col width="70"><col width="200"><col width="70"><col>
            </colgroup>
            <tr>
                <td class="lbl">성명</td>
                <td class="val">
                    <div class="search_box">
                        <input type="text" id="empNmLast" class="name_last" maxlength="5" placeholder="성">
                        <input type="text" id="empNmFirst" class="name_first" maxlength="10" placeholder="이름">
                        <button class="btn_search" onclick="searchEmp()">&#128269;</button>
                    </div>
                </td>
                <td class="lbl">성명(한문)</td>
                <td class="val"><input type="text" id="empNmHanja" style="width:150px;"></td>
                <td class="lbl">주민번호</td>
                <td class="val"><input type="text" id="empSsn" style="width:120px;" placeholder="000000-0000000"></td>
            </tr>
            <tr>
                <td class="lbl">근무상태</td>
                <td class="val">
                    <select id="workStatus" style="width:80px;">
                        <option value="1">재직</option>
                        <option value="2">휴직</option>
                        <option value="3">퇴직</option>
                    </select>
                </td>
                <td class="lbl">그룹입사일</td>
                <td class="val"><input type="text" id="grpJoinDt" style="width:100px;" placeholder="YYYY-MM-DD"></td>
                <td class="lbl">법인입사일</td>
                <td class="val"><input type="text" id="corpJoinDt" style="width:100px;" placeholder="YYYY-MM-DD"></td>
            </tr>
            <tr>
                <td class="lbl">소속법인</td>
                <td class="val"><input type="text" id="corpNm" style="width:160px;" readonly></td>
                <td class="lbl">근무SO</td>
                <td class="val"><input type="text" id="workSo" style="width:120px;"></td>
                <td class="lbl">소속부서</td>
                <td class="val"><input type="text" id="deptNm" style="width:200px;" readonly></td>
            </tr>
            <tr>
                <td class="lbl">직위/직책</td>
                <td class="val">
                    <input type="text" id="positionNm" style="width:80px;" placeholder="직위">
                    /
                    <input type="text" id="titleNm" style="width:80px;" placeholder="직책">
                </td>
                <td class="lbl">휴대폰</td>
                <td class="val"><input type="text" id="mobileNo" style="width:120px;" placeholder="010-0000-0000"></td>
                <td class="lbl">근속년수</td>
                <td class="val"><span id="workYears" style="font-weight:bold; color:#1a3a8b;"></span></td>
            </tr>
            <tr>
                <td class="lbl">사내전화</td>
                <td class="val"><input type="text" id="officeTel" style="width:120px;"></td>
                <td class="lbl">자택번호</td>
                <td class="val"><input type="text" id="homeTel" style="width:120px;"></td>
                <td class="lbl"></td>
                <td class="val">
                    <input type="hidden" id="empId">
                    <span id="empIdDisp" style="color:#888; font-size:11px;"></span>
                </td>
            </tr>
        </table>
    </div>
</div>

<!-- 탭 영역 -->
<div class="tab_wrap" id="mainTabWrap">
    <div class="tab_bar" id="mainTabBar">
        <div class="tab_item active" data-tab="basic">기본</div>
        <div class="tab_item" data-tab="appoint">발령</div>
        <div class="tab_item" data-tab="name">이름</div>
        <div class="tab_item" data-tab="personal">인적사항</div>
        <div class="tab_item" data-tab="tel">전화번호</div>
        <div class="tab_item" data-tab="addr">주소</div>
        <div class="tab_item" data-tab="memorial">기념일</div>
        <div class="tab_item" data-tab="family">가족</div>
        <div class="tab_item" data-tab="edu">학력</div>
        <div class="tab_item" data-tab="career">경력</div>
        <div class="tab_item" data-tab="cert">자격</div>
        <div class="tab_item" data-tab="lang">어학</div>
        <div class="tab_item" data-tab="military">병역</div>
        <div class="tab_item" data-tab="account">계좌</div>
        <div class="tab_item" data-tab="disability">장애</div>
        <div class="tab_item" data-tab="veteran">보훈</div>
        <div class="tab_item" data-tab="duty">담당업무</div>
        <div class="tab_item" data-tab="biz">출장</div>
        <div class="tab_item" data-tab="training">교육</div>
        <div class="tab_item" data-tab="eval">평가</div>
        <div class="tab_item" data-tab="reward">상벌</div>
        <div class="tab_item" data-tab="club">동호회</div>
        <div class="tab_item" data-tab="condol">경조사</div>
        <div class="tab_item" data-tab="longterm">장기근속기준일 관리</div>
        <div class="tab_item" data-tab="retire">퇴직금기산일</div>
        <div class="tab_item" data-tab="guarantee">신원보증</div>
        <div class="tab_item" data-tab="health">건강</div>
        <div class="tab_item" data-tab="workplace">근무지</div>
        <div class="tab_item" data-tab="etc">기타</div>
        <div class="tab_item" data-tab="therapy">감정치유휴가 관리</div>
        <div class="tab_item" data-tab="tenure">근속수</div>
        <div class="tab_nav_btns">
            <button onclick="scrollTabLeft()">&#171;&#171;</button>
            <button onclick="scrollTabLeft()">&#60;</button>
            <button onclick="scrollTabRight()">&#62;</button>
            <button onclick="scrollTabRight()">&#187;&#187;</button>
        </div>
    </div>

    <div class="tab_content">

        <!-- ===== 기본 탭 ===== -->
        <div class="tab_pane active" id="tab_basic">
            <div class="sub_section">
                <div class="sub_section_title">인적사항 상세내용</div>
                <table class="data_table">
                    <colgroup>
                        <col width="90"><col width="220"><col width="90"><col width="220"><col width="90"><col>
                    </colgroup>
                    <tr>
                        <td class="lbl">한글성명</td>
                        <td><input type="text" id="empNmFull" class="w200"></td>
                        <td class="lbl">한자성명</td>
                        <td><input type="text" id="b_empNmHanja" class="w200"></td>
                        <td class="lbl">영문명</td>
                        <td><input type="text" id="b_empNmEng" class="w200"></td>
                    </tr>
                    <tr>
                        <td class="lbl">성별</td>
                        <td>
                            <select id="b_gender" class="w100">
                                <option value="">선택</option>
                                <option value="M">남</option>
                                <option value="F">여</option>
                            </select>
                        </td>
                        <td class="lbl">생년월일</td>
                        <td><input type="text" id="b_birthDt" class="w150" placeholder="YYYY-MM-DD"></td>
                        <td class="lbl">국적</td>
                        <td>
                            <select id="b_nationality" class="w100">
                                <option value="내국인">내국인</option>
                                <option value="외국인">외국인</option>
                            </select>
                        </td>
                    </tr>
                    <tr>
                        <td class="lbl">최종학력</td>
                        <td>
                            <select id="b_eduLevel" class="w150">
                                <option value="">선택</option>
                                <option value="고졸">고졸</option>
                                <option value="전문대졸">전문대졸</option>
                                <option value="대학교졸">대학교졸</option>
                                <option value="대학원졸">대학원졸</option>
                                <option value="박사">박사</option>
                            </select>
                        </td>
                        <td class="lbl">직무구분</td>
                        <td><input type="text" id="b_jobType" class="w150"></td>
                        <td class="lbl">담당업무</td>
                        <td><input type="text" id="b_dutyNm" class="w200"></td>
                    </tr>
                    <tr>
                        <td class="lbl">회사이메일</td>
                        <td><input type="text" id="b_corpEmail" class="w200"></td>
                        <td class="lbl">개인이메일</td>
                        <td><input type="text" id="b_personalEmail" class="w200"></td>
                        <td class="lbl">보훈/장애여부</td>
                        <td>
                            보훈 <select id="b_veteranYn" class="w100" style="width:55px;">
                                <option value="N">N</option>
                                <option value="Y">Y</option>
                            </select>
                            &nbsp;
                            장애 <select id="b_disabilityYn" class="w100" style="width:55px;">
                                <option value="N">N</option>
                                <option value="Y">Y</option>
                            </select>
                        </td>
                    </tr>
                    <tr>
                        <td class="lbl">동호회</td>
                        <td><input type="text" id="b_clubNm" class="w200"></td>
                        <td class="lbl">결혼정보</td>
                        <td>
                            <select id="b_maritalStatus" class="w100">
                                <option value="">선택</option>
                                <option value="미혼">미혼</option>
                                <option value="기혼">기혼</option>
                                <option value="이혼">이혼</option>
                                <option value="사별">사별</option>
                            </select>
                        </td>
                        <td class="lbl">본적</td>
                        <td><input type="text" id="b_hometown" class="w300"></td>
                    </tr>
                    <tr>
                        <td class="lbl">현주소</td>
                        <td colspan="5"><input type="text" id="b_homeAddr" style="width:500px;"></td>
                    </tr>
                </table>
            </div>
        </div>

        <!-- ===== 발령 탭 ===== -->
        <div class="tab_pane" id="tab_appoint">
            <div class="sub_section">
                <div class="sub_section_title">발령 이력</div>
                <div class="grid_wrap">
                    <table class="grid_table" id="appointGrid">
                        <thead>
                            <tr>
                                <th>No</th>
                                <th>발령일</th>
                                <th>발령종류</th>
                                <th>이전부서</th>
                                <th>발령부서</th>
                                <th>이전직위</th>
                                <th>발령직위</th>
                                <th>비고</th>
                            </tr>
                        </thead>
                        <tbody id="appointBody">
                            <tr><td colspan="8" class="text_center">사번을 검색하여 주십시오.</td></tr>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>

        <!-- ===== 인적사항 탭 ===== -->
        <div class="tab_pane" id="tab_personal">
            <div class="sub_section">
                <div class="sub_section_title">인적사항 상세</div>
                <p style="color:#888; font-size:11px; padding:10px;">기본 탭의 인적사항 상세내용을 참고하세요.</p>
            </div>
        </div>

        <!-- ===== 가족 탭 ===== -->
        <div class="tab_pane" id="tab_family">
            <div class="sub_section">
                <div class="sub_section_title">가족사항</div>
                <div style="text-align:right; margin-bottom:4px;">
                    <button class="btn btn_new" onclick="addFamily()">+ 추가</button>
                </div>
                <div class="grid_wrap">
                    <table class="grid_table" id="familyGrid">
                        <thead>
                            <tr>
                                <th>No</th>
                                <th>관계</th>
                                <th>성명</th>
                                <th>성별</th>
                                <th>생년월일</th>
                                <th>동거여부</th>
                                <th>관리</th>
                            </tr>
                        </thead>
                        <tbody id="familyBody">
                            <tr><td colspan="7" class="text_center">가족 정보가 없습니다.</td></tr>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>

        <!-- ===== 학력 탭 ===== -->
        <div class="tab_pane" id="tab_edu">
            <div class="sub_section">
                <div class="sub_section_title">학력사항</div>
                <div style="text-align:right; margin-bottom:4px;">
                    <button class="btn btn_new" onclick="addEdu()">+ 추가</button>
                </div>
                <div class="grid_wrap">
                    <table class="grid_table" id="eduGrid">
                        <thead>
                            <tr>
                                <th>No</th>
                                <th>학교명</th>
                                <th>전공</th>
                                <th>학력구분</th>
                                <th>입학일</th>
                                <th>졸업일</th>
                                <th>졸업구분</th>
                                <th>관리</th>
                            </tr>
                        </thead>
                        <tbody id="eduBody">
                            <tr><td colspan="8" class="text_center">학력 정보가 없습니다.</td></tr>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>

        <!-- ===== 경력 탭 ===== -->
        <div class="tab_pane" id="tab_career">
            <div class="sub_section">
                <div class="sub_section_title">경력사항</div>
                <div style="text-align:right; margin-bottom:4px;">
                    <button class="btn btn_new" onclick="addCareer()">+ 추가</button>
                </div>
                <div class="grid_wrap">
                    <table class="grid_table" id="careerGrid">
                        <thead>
                            <tr>
                                <th>No</th>
                                <th>회사명</th>
                                <th>부서</th>
                                <th>직위</th>
                                <th>입사일</th>
                                <th>퇴사일</th>
                                <th>담당업무</th>
                                <th>관리</th>
                            </tr>
                        </thead>
                        <tbody id="careerBody">
                            <tr><td colspan="8" class="text_center">경력 정보가 없습니다.</td></tr>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>

        <!-- 나머지 탭 (준비 중) -->
        <div class="tab_pane" id="tab_name"><p style="padding:20px; color:#888;">준비 중입니다.</p></div>
        <div class="tab_pane" id="tab_tel"><p style="padding:20px; color:#888;">준비 중입니다.</p></div>
        <div class="tab_pane" id="tab_addr"><p style="padding:20px; color:#888;">준비 중입니다.</p></div>
        <div class="tab_pane" id="tab_memorial"><p style="padding:20px; color:#888;">준비 중입니다.</p></div>
        <div class="tab_pane" id="tab_cert"><p style="padding:20px; color:#888;">준비 중입니다.</p></div>
        <div class="tab_pane" id="tab_lang"><p style="padding:20px; color:#888;">준비 중입니다.</p></div>
        <div class="tab_pane" id="tab_military"><p style="padding:20px; color:#888;">준비 중입니다.</p></div>
        <div class="tab_pane" id="tab_account"><p style="padding:20px; color:#888;">준비 중입니다.</p></div>
        <div class="tab_pane" id="tab_disability"><p style="padding:20px; color:#888;">준비 중입니다.</p></div>
        <div class="tab_pane" id="tab_veteran"><p style="padding:20px; color:#888;">준비 중입니다.</p></div>
        <div class="tab_pane" id="tab_duty"><p style="padding:20px; color:#888;">준비 중입니다.</p></div>
        <div class="tab_pane" id="tab_biz"><p style="padding:20px; color:#888;">준비 중입니다.</p></div>
        <div class="tab_pane" id="tab_training"><p style="padding:20px; color:#888;">준비 중입니다.</p></div>
        <div class="tab_pane" id="tab_eval"><p style="padding:20px; color:#888;">준비 중입니다.</p></div>
        <div class="tab_pane" id="tab_reward"><p style="padding:20px; color:#888;">준비 중입니다.</p></div>
        <div class="tab_pane" id="tab_club"><p style="padding:20px; color:#888;">준비 중입니다.</p></div>
        <div class="tab_pane" id="tab_condol"><p style="padding:20px; color:#888;">준비 중입니다.</p></div>
        <div class="tab_pane" id="tab_longterm"><p style="padding:20px; color:#888;">준비 중입니다.</p></div>
        <div class="tab_pane" id="tab_retire"><p style="padding:20px; color:#888;">준비 중입니다.</p></div>
        <div class="tab_pane" id="tab_guarantee"><p style="padding:20px; color:#888;">준비 중입니다.</p></div>
        <div class="tab_pane" id="tab_health"><p style="padding:20px; color:#888;">준비 중입니다.</p></div>
        <div class="tab_pane" id="tab_workplace"><p style="padding:20px; color:#888;">준비 중입니다.</p></div>
        <div class="tab_pane" id="tab_etc"><p style="padding:20px; color:#888;">준비 중입니다.</p></div>
        <div class="tab_pane" id="tab_therapy"><p style="padding:20px; color:#888;">준비 중입니다.</p></div>
        <div class="tab_pane" id="tab_tenure"><p style="padding:20px; color:#888;">준비 중입니다.</p></div>
    </div>
</div>

<!-- ===== 사원 검색 모달 ===== -->
<div class="modal_overlay" id="searchModal">
    <div class="modal_box" style="min-width:500px;">
        <div class="modal_header">
            직원 검색
            <button class="modal_close" onclick="closeModal('searchModal')">✕</button>
        </div>
        <div class="modal_body">
            <div class="search_form" style="margin-bottom:8px;">
                <span class="s_label">성명</span>
                <input type="text" id="searchNm" style="width:120px;" placeholder="성명 입력" onkeydown="if(event.keyCode==13) doSearch()">
                <span class="s_label">근무상태</span>
                <select id="searchStatus">
                    <option value="">전체</option>
                    <option value="1" selected>재직</option>
                    <option value="2">휴직</option>
                    <option value="3">퇴직</option>
                </select>
                <button class="btn btn_save" onclick="doSearch()">검색</button>
            </div>
            <div class="grid_wrap" style="max-height:300px; overflow-y:auto;">
                <table class="grid_table">
                    <thead>
                        <tr>
                            <th>사번</th>
                            <th>성명</th>
                            <th>부서</th>
                            <th>직위</th>
                            <th>근무상태</th>
                        </tr>
                    </thead>
                    <tbody id="searchResultBody">
                        <tr><td colspan="5" class="text_center">검색 결과가 없습니다.</td></tr>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</div>

<script>
var CTX = '${pageContext.request.contextPath}';

$(document).ready(function () {
    // 탭 클릭 처리
    $('#mainTabBar .tab_item').on('click', function () {
        $('#mainTabBar .tab_item').removeClass('active');
        $('#mainTabWrap .tab_pane').removeClass('active');
        $(this).addClass('active');
        var tabId = $(this).data('tab');
        $('#tab_' + tabId).addClass('active');

        // 탭 전환 시 부가 데이터 로딩
        var empId = $('#empId').val();
        if (empId) {
            if (tabId === 'appoint') loadAppoint(empId);
            if (tabId === 'family') loadFamily(empId);
            if (tabId === 'edu') loadEdu(empId);
            if (tabId === 'career') loadCareer(empId);
        }
    });

    // 초기 empId 파라미터 처리
    var initEmpId = '<%= pageContext_empId %>';
    if (initEmpId) {
        loadEmpInfo(initEmpId);
    }
});

// 직원 검색 팝업 열기
function searchEmp() {
    $('#searchNm').val($('#empNmLast').val() + $('#empNmFirst').val());
    openModal('searchModal');
    doSearch();
}

// 검색 실행
function doSearch() {
    var nm = $('#searchNm').val();
    var status = $('#searchStatus').val();
    ajaxGet(CTX + '/phm/PHM_001_data.jsp', {action:'search', nm:nm, status:status}, function(err, data) {
        if (err) { showMsg('검색 중 오류가 발생했습니다.'); return; }
        var html = '';
        if (!data || data.length === 0) {
            html = '<tr><td colspan="5" class="text_center">검색 결과가 없습니다.</td></tr>';
        } else {
            $.each(data, function(i, row) {
                var statusNm = row.workStatus === '1' ? '재직' : (row.workStatus === '2' ? '휴직' : '퇴직');
                html += '<tr onclick="selectEmp(\'' + row.empId + '\')" style="cursor:pointer;">';
                html += '<td class="text_center">' + row.empId + '</td>';
                html += '<td>' + nvl(row.empNm) + '</td>';
                html += '<td>' + nvl(row.deptNm) + '</td>';
                html += '<td>' + nvl(row.positionNm) + '</td>';
                html += '<td class="text_center">' + statusNm + '</td>';
                html += '</tr>';
            });
        }
        $('#searchResultBody').html(html);
    });
}

// 직원 선택
function selectEmp(empId) {
    closeModal('searchModal');
    loadEmpInfo(empId);
}

// 사원 정보 로드
function loadEmpInfo(empId) {
    ajaxGet(CTX + '/phm/PHM_001_data.jsp', {action:'getEmp', empId:empId}, function(err, data) {
        if (err || !data || data.error) {
            showMsg('사원 정보를 불러올 수 없습니다.');
            return;
        }
        fillEmpForm(data);
    });
}

// 폼에 데이터 채우기
function fillEmpForm(d) {
    $('#empId').val(nvl(d.empId));
    $('#empIdDisp').text('사번: ' + nvl(d.empId));

    // 성명 분리 (성 + 이름)
    var nm = nvl(d.empNm);
    if (nm.length > 1) {
        $('#empNmLast').val(nm.substring(0, 1));
        $('#empNmFirst').val(nm.substring(1));
    } else {
        $('#empNmLast').val(nm);
        $('#empNmFirst').val('');
    }

    $('#empNmHanja').val(nvl(d.empNmHanja));
    $('#empSsn').val(nvl(d.empSsn));
    $('#workStatus').val(nvl(d.workStatus) || '1');
    $('#grpJoinDt').val(nvl(d.grpJoinDt));
    $('#corpJoinDt').val(nvl(d.corpJoinDt));
    $('#corpNm').val(nvl(d.corpNm));
    $('#workSo').val(nvl(d.workSo));
    $('#deptNm').val(nvl(d.deptNm));
    $('#positionNm').val(nvl(d.positionNm));
    $('#titleNm').val(nvl(d.titleNm));
    $('#mobileNo').val(nvl(d.mobileNo));
    $('#officeTel').val(nvl(d.officeTel));
    $('#homeTel').val(nvl(d.homeTel));
    $('#workYears').text(calcYears(d.corpJoinDt));

    // 기본 탭 - 인적사항
    $('#empNmFull').val(nvl(d.empNm));
    $('#b_empNmHanja').val(nvl(d.empNmHanja));
    $('#b_empNmEng').val(nvl(d.empNmEng));
    $('#b_gender').val(nvl(d.empGender));
    $('#b_birthDt').val(nvl(d.empBirthDt));
    $('#b_nationality').val(nvl(d.empNationality) || '내국인');
    $('#b_eduLevel').val(nvl(d.eduLevel));
    $('#b_jobType').val(nvl(d.jobType));
    $('#b_dutyNm').val(nvl(d.dutyNm));
    $('#b_corpEmail').val(nvl(d.corpEmail));
    $('#b_personalEmail').val(nvl(d.personalEmail));
    $('#b_veteranYn').val(nvl(d.veteranYn) || 'N');
    $('#b_disabilityYn').val(nvl(d.disabilityYn) || 'N');
    $('#b_clubNm').val(nvl(d.clubNm));
    $('#b_maritalStatus').val(nvl(d.maritalStatus));
    $('#b_hometown').val(nvl(d.hometown));
    $('#b_homeAddr').val(nvl(d.homeAddr));

    // 사진
    if (d.photoPath) {
        $('#empPhoto').attr('src', CTX + '/' + d.photoPath).show();
        $('#photoPlaceholder').hide();
    } else {
        $('#empPhoto').hide();
        $('#photoPlaceholder').show();
    }
}

// 사원 정보 저장
function saveEmpInfo() {
    var empId = $('#empId').val();
    if (!empId) {
        showMsg('사번이 없습니다. 직원을 먼저 검색해 주세요.');
        return;
    }
    if (!confirm('인사 기록을 저장하시겠습니까?')) return;

    var nm = $('#empNmLast').val() + $('#empNmFirst').val();
    var params = {
        action: 'saveEmp',
        empId: empId,
        empNm: nm,
        empNmHanja: $('#empNmHanja').val(),
        empSsn: $('#empSsn').val(),
        workStatus: $('#workStatus').val(),
        grpJoinDt: $('#grpJoinDt').val(),
        corpJoinDt: $('#corpJoinDt').val(),
        workSo: $('#workSo').val(),
        positionNm: $('#positionNm').val(),
        titleNm: $('#titleNm').val(),
        mobileNo: $('#mobileNo').val(),
        officeTel: $('#officeTel').val(),
        homeTel: $('#homeTel').val(),
        empNmEng: $('#b_empNmEng').val(),
        empGender: $('#b_gender').val(),
        empBirthDt: $('#b_birthDt').val(),
        empNationality: $('#b_nationality').val(),
        eduLevel: $('#b_eduLevel').val(),
        jobType: $('#b_jobType').val(),
        dutyNm: $('#b_dutyNm').val(),
        corpEmail: $('#b_corpEmail').val(),
        personalEmail: $('#b_personalEmail').val(),
        veteranYn: $('#b_veteranYn').val(),
        disabilityYn: $('#b_disabilityYn').val(),
        clubNm: $('#b_clubNm').val(),
        maritalStatus: $('#b_maritalStatus').val(),
        hometown: $('#b_hometown').val(),
        homeAddr: $('#b_homeAddr').val()
    };

    ajaxPost(CTX + '/phm/PHM_001_data.jsp', params, function(err, data) {
        if (err || (data && data.result === 'error')) {
            showMsg('저장에 실패했습니다: ' + (data ? data.message : err));
        } else {
            showMsg('저장되었습니다.');
            loadEmpInfo(empId);
        }
    });
}

// 발령 이력 로드
function loadAppoint(empId) {
    ajaxGet(CTX + '/phm/PHM_001_data.jsp', {action:'getAppoint', empId:empId}, function(err, data) {
        var html = '';
        if (!data || data.length === 0) {
            html = '<tr><td colspan="8" class="text_center">발령 이력이 없습니다.</td></tr>';
        } else {
            $.each(data, function(i, row) {
                html += '<tr>';
                html += '<td class="text_center">' + (i+1) + '</td>';
                html += '<td class="text_center">' + nvl(row.appointDt) + '</td>';
                html += '<td>' + nvl(row.appointType) + '</td>';
                html += '<td>' + nvl(row.fromDeptNm) + '</td>';
                html += '<td>' + nvl(row.toDeptNm) + '</td>';
                html += '<td>' + nvl(row.fromPosition) + '</td>';
                html += '<td>' + nvl(row.toPosition) + '</td>';
                html += '<td>' + nvl(row.remark) + '</td>';
                html += '</tr>';
            });
        }
        $('#appointBody').html(html);
    });
}

// 가족 정보 로드
function loadFamily(empId) {
    ajaxGet(CTX + '/phm/PHM_001_data.jsp', {action:'getFamily', empId:empId}, function(err, data) {
        var html = '';
        if (!data || data.length === 0) {
            html = '<tr><td colspan="7" class="text_center">가족 정보가 없습니다.</td></tr>';
        } else {
            $.each(data, function(i, row) {
                html += '<tr>';
                html += '<td class="text_center">' + (i+1) + '</td>';
                html += '<td>' + nvl(row.relation) + '</td>';
                html += '<td>' + nvl(row.familyNm) + '</td>';
                html += '<td class="text_center">' + (row.familyGender === 'M' ? '남' : (row.familyGender === 'F' ? '여' : '')) + '</td>';
                html += '<td class="text_center">' + nvl(row.familyBirthDt) + '</td>';
                html += '<td class="text_center">' + (row.liveTogether === 'Y' ? '동거' : '별거') + '</td>';
                html += '<td class="text_center"><button class="btn" onclick="deleteFamily(' + row.familyId + ')">삭제</button></td>';
                html += '</tr>';
            });
        }
        $('#familyBody').html(html);
    });
}

// 학력 정보 로드
function loadEdu(empId) {
    ajaxGet(CTX + '/phm/PHM_001_data.jsp', {action:'getEdu', empId:empId}, function(err, data) {
        var html = '';
        if (!data || data.length === 0) {
            html = '<tr><td colspan="8" class="text_center">학력 정보가 없습니다.</td></tr>';
        } else {
            $.each(data, function(i, row) {
                html += '<tr>';
                html += '<td class="text_center">' + (i+1) + '</td>';
                html += '<td>' + nvl(row.schoolNm) + '</td>';
                html += '<td>' + nvl(row.major) + '</td>';
                html += '<td>' + nvl(row.eduLevel) + '</td>';
                html += '<td class="text_center">' + nvl(row.enterDt) + '</td>';
                html += '<td class="text_center">' + nvl(row.graduateDt) + '</td>';
                html += '<td>' + nvl(row.graduateType) + '</td>';
                html += '<td class="text_center"><button class="btn" onclick="deleteEdu(' + row.eduId + ')">삭제</button></td>';
                html += '</tr>';
            });
        }
        $('#eduBody').html(html);
    });
}

// 경력 정보 로드
function loadCareer(empId) {
    ajaxGet(CTX + '/phm/PHM_001_data.jsp', {action:'getCareer', empId:empId}, function(err, data) {
        var html = '';
        if (!data || data.length === 0) {
            html = '<tr><td colspan="8" class="text_center">경력 정보가 없습니다.</td></tr>';
        } else {
            $.each(data, function(i, row) {
                html += '<tr>';
                html += '<td class="text_center">' + (i+1) + '</td>';
                html += '<td>' + nvl(row.companyNm) + '</td>';
                html += '<td>' + nvl(row.deptNm) + '</td>';
                html += '<td>' + nvl(row.positionNm) + '</td>';
                html += '<td class="text_center">' + nvl(row.joinDt) + '</td>';
                html += '<td class="text_center">' + nvl(row.resignDt) + '</td>';
                html += '<td>' + nvl(row.dutyNm) + '</td>';
                html += '<td class="text_center"><button class="btn" onclick="deleteCareer(' + row.careerId + ')">삭제</button></td>';
                html += '</tr>';
            });
        }
        $('#careerBody').html(html);
    });
}

// 탭 좌우 스크롤
function scrollTabLeft()  { $('#mainTabBar').scrollLeft($('#mainTabBar').scrollLeft() - 150); }
function scrollTabRight() { $('#mainTabBar').scrollLeft($('#mainTabBar').scrollLeft() + 150); }

// 사진 업로드
function openPhotoUpload() {
    var empId = $('#empId').val();
    if (!empId) { showMsg('사번이 없습니다. 직원을 먼저 검색해 주세요.'); return; }
    showMsg('사진 등록 기능은 추후 구현됩니다.');
}

// 인사기록카드 출력
function printCard() {
    var empId = $('#empId').val();
    if (!empId) { showMsg('사번이 없습니다.'); return; }
    window.open(CTX + '/phm/PHM_001_print.jsp?empId=' + empId, '_blank', 'width=800,height=600');
}

function addFamily()  { showMsg('추가 기능은 추후 구현됩니다.'); }
function addEdu()     { showMsg('추가 기능은 추후 구현됩니다.'); }
function addCareer()  { showMsg('추가 기능은 추후 구현됩니다.'); }
function deleteFamily(id)  { if(confirm('삭제하시겠습니까?')) showMsg('삭제 기능은 추후 구현됩니다.'); }
function deleteEdu(id)     { if(confirm('삭제하시겠습니까?')) showMsg('삭제 기능은 추후 구현됩니다.'); }
function deleteCareer(id)  { if(confirm('삭제하시겠습니까?')) showMsg('삭제 기능은 추후 구현됩니다.'); }
</script>

<%@ include file="../common/layout_bottom.jsp" %>

/* ============================================================
   D'LIVE HR 인사관리 시스템 공통 스크립트
   ============================================================ */

// 좌측 메뉴 토글
function toggleMenu(el) {
    el.classList.toggle('open');
    var items = el.nextElementSibling;
    if (items) items.classList.toggle('open');
}

// 전체 메뉴 토글 (MENU 버튼)
$(document).ready(function () {
    $('#btnToggleMenu').on('click', function () {
        $('#left_nav').toggle();
    });

    // 탭 클릭 이벤트 위임
    $(document).on('click', '.tab_item', function () {
        var tabId = $(this).data('tab');
        var tabWrap = $(this).closest('.tab_wrap');
        tabWrap.find('.tab_item').removeClass('active');
        tabWrap.find('.tab_pane').removeClass('active');
        $(this).addClass('active');
        tabWrap.find('#tab_' + tabId).addClass('active');
    });
});

// 탭 초기화
function initTabs(containerId, defaultTab) {
    var $wrap = $('#' + containerId);
    $wrap.find('.tab_item').first().addClass('active');
    $wrap.find('.tab_pane').first().addClass('active');
    if (defaultTab) {
        $wrap.find('.tab_item').removeClass('active');
        $wrap.find('.tab_pane').removeClass('active');
        $wrap.find('.tab_item[data-tab="' + defaultTab + '"]').addClass('active');
        $wrap.find('#tab_' + defaultTab).addClass('active');
    }
}

// 로딩 표시/숨기기
function showLoading() { $('#loadingOverlay').addClass('show'); }
function hideLoading() { $('#loadingOverlay').removeClass('show'); }

// 알림 메시지 (alert 대체)
function showMsg(msg, type) {
    alert(msg);
}

// AJAX GET 요청 공통
function ajaxGet(url, params, callback) {
    showLoading();
    $.ajax({
        url: url,
        type: 'GET',
        data: params,
        dataType: 'json',
        success: function (data) {
            hideLoading();
            if (callback) callback(null, data);
        },
        error: function (xhr) {
            hideLoading();
            if (callback) callback(xhr.responseText || '오류가 발생했습니다.');
        }
    });
}

// AJAX POST 요청 공통
function ajaxPost(url, params, callback) {
    showLoading();
    $.ajax({
        url: url,
        type: 'POST',
        data: params,
        dataType: 'json',
        success: function (data) {
            hideLoading();
            if (callback) callback(null, data);
        },
        error: function (xhr) {
            hideLoading();
            if (callback) callback(xhr.responseText || '오류가 발생했습니다.');
        }
    });
}

// 날짜 포맷 (YYYY-MM-DD → YYYY.MM.DD)
function fmtDate(s) {
    if (!s) return '';
    return s.replace(/-/g, '.');
}

// 날짜 포맷 (YYYY-MM-DD → YYYY년 MM월 DD일)
function fmtDateKr(s) {
    if (!s || s.length < 10) return s || '';
    return s.substring(0, 4) + '년 ' + s.substring(5, 7) + '월 ' + s.substring(8, 10) + '일';
}

// 빈 값 처리
function nvl(v, d) { return (v === null || v === undefined || v === '') ? (d || '') : v; }

// 근속년수 계산
function calcYears(joinDt) {
    if (!joinDt) return '';
    var join = new Date(joinDt);
    var now = new Date();
    var years = now.getFullYear() - join.getFullYear();
    var m = now.getMonth() - join.getMonth();
    if (m < 0 || (m === 0 && now.getDate() < join.getDate())) years--;
    return years + '년';
}

// 모달 열기/닫기
function openModal(id) { $('#' + id).addClass('open'); }
function closeModal(id) { $('#' + id).removeClass('open'); }

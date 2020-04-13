<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri= "http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>전체 메모 조회</title>
	<!-- jquery 3.4.1 -->
	<script src="/hyeri/resources/js/jquery/jquery-3.4.1.min.js"></script>
	<!-- bpopup 0.11.0 -->
	<script src="/hyeri/resources/js/bpopup/bpopup-0.11.0.min.js"></script>
	<!-- bootstrap -->
	<script src="/hyeri/resources/bootstrap/js/bootstrap.min.js"></script>
	<link href="/hyeri/resources/bootstrap/css/bootstrap.min.css" rel="stylesheet">
	<style>
		.nav a {font-size:medium;}
	</style>
</head>
<script>
	$(document).ready(function(){
		var pageType = '${pageType}';
		$('input:radio[name=memoType]:input[value=shrd]').attr("checked", true);

		$("#logout").click(function(){
			fn_logout();
		});

		$("#btnRegister").click(function(){
			location.href="/hyeri/memo/${pageType}/register_memo.html";
		});

		//체크박스 클릭 시 동정태그 생성
		$("#memoBody").on('click', 'input:checkbox', function(){
			var chkYn = $(this).is(':checked');
			var memoSn = $(this).data('sn');
			var chFxdYn = chkYn ? 'Y' : 'N';
			var curCheckbox = $(this);

			$.ajax({
				url: "updateFxdYn.ajax"
				,type: 'POST'
				,data: {
					'memoSn' : memoSn
					,'fxdYn' : chFxdYn
				}
				,datatype:"json"
				,success:function(result){

					if("fail"==result.msg){ 	// 고정여부 수정 실패
						alert("상단고정 갯수가 초과되었습니다.\n기존 고정메모를 해제 후 진행해주시기바랍니다.");
						curCheckbox.prop("checked", false);	 //체크 해제

					}else{   // 고정여부 수정 성공
						var	fxdMm = result.fxdMemoList;		//고정 메모 리스트
						var mm = result.memoList;			//일반 메모 리스트
						var page = result.pageMaker;		//페이징정보

						var html = "";
						var pageHtml = "";

						// 고정목록 생성
						if( fxdMm != null && fxdMm.length > 0 ) {
							$.each(fxdMm, function(index, item){
								html += "<div class=\"col-md-3\">";
								html += "<div class=\"card mb-4 box-shadow\"><div class=\"card-body\" style=\"background: lightyellow;\">";
								html += "<p class=\"card-text\" onclick=\"moveDetailPage('" + $(this).prop("memoSn") +"');return false;\">" + $(this).prop("cntnt") + "</p>";

								// 체크박스
								html += "<div class=\"custom-control custom-checkbox\">";
								html += "<input class=\"custom-control-input\" type=\"checkbox\" id=\"" + $(this).prop("memoSn") +"-CB\" data-sn=\"" + $(this).prop("memoSn") + "\" checked>";
								html += "<label class=\"custom-control-label\" for=\"" + $(this).prop("memoSn") + "-CB\">고정</label>";
								html += "</div>";

								html += "<div class=\"d-flex justify-content-between align-items-center\">";
								html += "<small class=\"text-muted\">" + $(this).prop("mdfDttm") + "</small>";
								html += "</div></div></div></div>";
								html += "</tr>";
							})
						}

						// 일반메모목록 생성
						if( mm != null && mm.length > 0 ) {
							$.each(mm, function(index, item){
								html += "<div class=\"col-md-3\">";
								html += "<div class=\"card mb-4 box-shadow\"><div class=\"card-body\" style=\"background: lightyellow;\">";
								html += "<p class=\"card-text\" onclick=\"moveDetailPage('" + $(this).prop("memoSn") +"');return false;\">" + $(this).prop("cntnt") + "</p>";

								// 체크박스
								html += "<div class=\"custom-control custom-checkbox\">";
								html += "<input class=\"custom-control-input\" type=\"checkbox\" id=\"" + $(this).prop("memoSn") +"-CB\" data-sn=\"" + $(this).prop("memoSn") + "\">";
								html += "<label class=\"custom-control-label\" for=\"" + $(this).prop("memoSn") + "-CB\">고정</label>";
								html += "</div>";

								html += "<div class=\"d-flex justify-content-between align-items-center\">";
								html += "<small class=\"text-muted\">" + $(this).prop("mdfDttm") + "</small>";
								html += "</div></div></div></div>";
								html += "</tr>";
							})
						}

						//페이징
						if( page != null ) {
							pageHtml += "<ul class=\"pagination justify-content-center\">";
							if( page.prev ) pageHtml += "<li class=\"page-link\"><a class=\"page-link\" href=\"#\" onclick=\"movePage(${pageMaker.startPage-1});return false;\">&laquo;</a></li>";
							for( var i = page.startPage; i <= page.endPage; i++ ) {
								if( page.cri.page == i ) {
									pageHtml += "<li class=\"page-item active\">";
								} else {
									pageHtml += "<li class=\"page-item\">";
								}
								pageHtml += "<a class=\"page-link\" href=\"#\" onclick=\"movePage(" + i + ");return false;\">" + i + "</a></li>";

							}
							if( page.next && page.endPage > 0 ) pageHtml += "<li class=\"page-link\"><a class=\"page-link\" href=\"#\" onclick=\"movePage(${pageMaker.startPage+1});return false;\">&raquo;</a></li>";
							pageHtml += "</ul>";
						}

						$("#memoBody").empty();
						$("#memoBody").html(html);
						$("#pageNav").empty();
						$("#pageNav").html(pageHtml);
					}
				}
			});
		});

		//메모 타입 선택(라디오타입 : 개별/공유)
		$("input[name=memoType]").change(function(){
			var type = $(this).val();
			if( "indvd" == type ) {
				location.href="/hyeri/memo/indvd/list_memo.html";
			} else if ( "shrd" == type ) {
				location.href="/hyeri/memo/shrd/list_memo.html";
			}
		});

	});

	//로그아웃
	function fn_logout() {
		if(confirm("로그아웃하시겠습니까?")){
			$.ajax({
				url: "/hyeri/home/logout.ajax"
				,type: 'POST'
				,datatype:"json"
				,success:function(result){
					if("success"==result.msg){
						alert("로그아웃되었습니다.");
						location.href = "/hyeri/home/login.html";
					}
				}
			});
		}
	}

	//마이페이지 접근 팝업
	function popupAcsMyPage(path) {
		$("#path").val(path);
		$("#popupAcsMyPage").bPopup({
			modalClose: false
		});
	}

	//페이지 이동
	function movePage(num) {
		$('#page').val(num);
		$('#infoForm').prop('method', 'GET');
		$('#infoForm').prop('action', 'list_memo.html');
		$('#infoForm').submit();
	}

	//수정페이지 이동
	function moveDetailPage(memoSn) {
		$('#memoSn').val(memoSn);
		$('#infoForm').prop('method', 'GET');
		$('#infoForm').prop('action', '/hyeri/memo/${pageType}/modify_memo.html');
		$('#infoForm').submit();
	}

</script>
<body>
	<header>
		<div class="navbar navbar-dark bg-dark box-shadow">
		<div class="container">
			<div class="justify-content-between">
				<a href="/hyeri/memo/indvd/list_memo.html" class="navbar-brand align-items-center">
					<strong>WebMemo</strong>
				</a>
			</div>
			<ul class="nav">
				<li class="nav-item dropdown">
					<a class="navbar-brand dropdown-toggle" href="http://example.com" id="dropdown01" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">마이페이지</a>
					<div class="dropdown-menu" aria-labelledby="dropdown01">
						<a class="dropdown-item" onclick="popupAcsMyPage('mmbr'); return false;">회원정보 수정</a>
						<a class="dropdown-item" onclick="popupAcsMyPage('pwd'); return false;">비밀번호 수정</a>
						<a class="dropdown-item" onclick="popupAcsMyPage('email'); return false;">이메일 수정</a>
						<a class="dropdown-item" onclick="popupAcsMyPage('wthdrMmbr'); return false;">회원탈퇴</a>
					</div>
				</li>
				<li class="nav-item active">
					<a href="#" id="logout" class="navbar-brand">로그아웃</a>
				</li>
			</ul>
		</div>
		</div>
	</header>

	<main role="main">
		<section class="jumbotron text-center">
			 <div class="container">
				<!-- 정보 영역 -->
				<form id="infoForm" method="GET">
					 <input type="hidden" name="memoSn" id="memoSn">
					 <input type="hidden" name="page" id="page" value="${requestVO.page}">
					 <input type="hidden" name="searchType" id="searchType" value="cntnt">
					 <div class="form-label-group">
							<button class="btn btn-warning" style="float:right;width:10%;" id="btnSrch">검색</button>
							<input class="form-control" style="width:90%" type="text" name="searchText" id="searchText" placeholder="메모 내용을 검색해주세요" value="${requestVO.searchText}">
					 </div>
				</form>
			 </div>
		</section>
		<div class="album py-5 bg-light">
			<div class="container">
			<div class="btn-group btn-group-toggle mb-5" data-toggle="buttons">
				<c:if test="${pageType eq 'indvd'}">
					<label class="btn btn-outline-primary active">
						<input type="radio" name="memoType" id="radioIndvd" value="indvd" autocomplete="off"> 개인메모
					</label>
					<label class="btn btn-outline-primary">
						<input type="radio" name="memoType" id="radioShrd" value="shrd" autocomplete="off"> 공유메모
					</label>
				</c:if>
				<c:if test="${pageType eq 'shrd'}">
					<label class="btn btn-outline-primary">
						<input type="radio" name="memoType" id="radioIndvd" value="indvd" autocomplete="off"> 개인메모
					</label>
					<label class="btn btn-outline-primary active">
						<input type="radio" name="memoType" id="radioShrd" value="shrd" autocomplete="off"> 공유메모
					</label>
				</c:if>
			</div>

				<div class="row" id="memoBody">
					<!-- 고정메모는 개인메모탭에서만 활성화 -->
					<c:if test="${pageType eq 'indvd'}">
						<c:forEach items="${fxdMemoList}" var="vo">
							<div class="col-md-3">
								<div class="card mb-4 box-shadow">
									<div class="card-body" style="background: lightyellow;">
										<p class="card-text" onclick="moveDetailPage(${vo.memoSn});return false;">
											 ${vo.cntnt}
										</p>
										<div class="custom-control custom-checkbox">
											<input class="custom-control-input" type="checkbox" id="${vo.memoSn}-CB" data-sn="${vo.memoSn}" checked>
											<label class="custom-control-label" for="${vo.memoSn}-CB">고정</label>
										</div>
										<div class="d-flex justify-content-between align-items-center">
											<small class="text-muted">${vo.mdfDttm}</small>
										</div>
									</div>
								</div>
							</div>
						</c:forEach>
					</c:if>

					<c:forEach items="${memoList}" var="vo">
						<div class="col-md-3">
							<div class="card mb-4 box-shadow">
								<div class="card-body" style="background: lightyellow;">
									<p class="card-text" onclick="moveDetailPage(${vo.memoSn});return false;">
											 ${vo.cntnt}
									</p>
									<!-- 고정체크는 개인메모탭에서만 활성화 -->
									<c:if test="${pageType eq 'indvd'}">
										<div class="custom-control custom-checkbox">
											<input class="custom-control-input" type="checkbox" id="${vo.memoSn}-CB" data-sn="${vo.memoSn}">
											<label class="custom-control-label" for="${vo.memoSn}-CB">고정</label>
										</div>
									</c:if>
									<div class="d-flex justify-content-between align-items-center">
										<small class="text-muted">${vo.mdfDttm}</small>
										<!-- 소유ID, 공유형태 노출은 개인메모탭에서만 활성화 -->
										<c:if test="${pageType eq 'shrd'}">
											<small class="text-muted">${vo.ownerId}</small>
											<c:set var="st" value="${vo.allShrdYn}"/>
											<c:choose>
												<c:when test="${st eq 'Y'}">
													<small class="text-muted">전체공유</small>
												</c:when>
												<c:when test="${st eq 'N'}">
													<small class="text-muted">선택공유</small>
												</c:when>
											</c:choose>
										</c:if>
									</div>
								</div>
							</div>
						</div>

					</c:forEach>
				</div>
				<button class="btn btn-info my-2 pull-right" id="btnRegister">등록</button>
			</div>
		</div>
	</main>

	<nav id="pageNav" aria-label="Page navigation" style="margin-top: 20px;">
		<ul class="pagination justify-content-center">
			<!-- 이전 버튼 -->
			<c:if test="${pageMaker.prev}">
				<li class="page-link"><a class="page-link" href="#" onclick="movePage(${pageMaker.startPage-1});return false;">&laquo;</a></li>
			</c:if>

			<!-- 페이지 번호 -->
			<c:forEach begin="${pageMaker.startPage}" end="${pageMaker.endPage}" var="idx">
				<li class="page-item <c:out value="${pageMaker.cri.page == idx ? 'active' : ''}"/>">
					<a class="page-link" href="#" onclick="movePage(${idx});return false;">${idx}</a>
				</li>
			</c:forEach>

			<!-- 다음 버튼 -->
			<c:if test="${pageMaker.next && pageMaker.endPage > 0}">
				<li class="page-link"><a class="page-link" href="#" onclick="movePage(${pageMaker.startPage+1});return false;">&raquo;</a></li>
			</c:if>
		</ul>
	</nav>
	<!-- layerPopup -->
	<%@include file="/WEB-INF/views/home/popup_acs_myPage.jsp" %>
</body>
</html>
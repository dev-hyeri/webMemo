<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri= "http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>Insert title here</title>
	<!-- jquery 3.4.1 -->
	<script src="/hyeri/resources/js/jquery/jquery-3.4.1.min.js"></script>
	<!-- bpopup 0.11.0 -->
	<script src="/hyeri/resources/js/bpopup/bpopup-0.11.0.min.js"></script>
	<!-- bootstrap -->
	<script src="/hyeri/resources/bootstrap/js/bootstrap.min.js"></script>
	<link href="/hyeri/resources/bootstrap/css/bootstrap.min.css" rel="stylesheet">
	<style>
		.table{
			table-layout: fixed;
		}
		.nav a {font-size:medium;}
	</style>
	</head>

<script>
	$(document).ready(function(){

		$("#logout").click(function(){
			fn_logout();
		});

		// 회원조회 이동
		$("#mmbrList").click(function(){
			location.href="list_mmbr.html";
		})

		// 에러내역조회 이동
		$("#errorList").click(function(){
			location.href="list_error.html";
		})
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
		$('#infoForm').prop('action', 'list_error.html');
		$('#infoForm').submit();
	}

	//상세 페이지 이동
	function moveDetailPage(errorSn) {
		$('#errorSn').val(errorSn);
		$('#infoForm').prop('method', 'GET');
		$('#infoForm').prop('action', 'detail_error.html');
		$('#infoForm').submit();
	}

</script>
<body>
	<header>
		<div class="navbar navbar-dark bg-dark box-shadow">
		<div class="container">
			<div class="justify-content-between">
				<a href="/hyeri/admin/list_mmbr.html" class="navbar-brand align-items-center">
					<strong>WebMemo Admin</strong>
				</a>
				<a href="/hyeri/memo/indvd/list_memo.html" class="navbar-brand align-items-center">
					<font size=2>WebMemo</font>
				</a>
			</div>
			<ul class="nav">
				<li class="nav-item active">
					<a href="#" id="mmbrList" class="navbar-brand">회원관리</a>
				</li>
				<li class="nav-item active">
					<a href="#" id="errorList" class="navbar-brand">에러내역</a>
				</li>
				<li class="nav-item dropdown">
					<a class="navbar-brand dropdown-toggle" href="http://example.com" id="dropdown01" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">마이페이지</a>
					<div class="dropdown-menu" aria-labelledby="dropdown01">
						<a class="dropdown-item" onclick="popupAcsMyPage('mmbr'); return false;">회원정보 수정</a>
						<a class="dropdown-item" onclick="popupAcsMyPage('pwd'); return false;">비밀번호 수정</a>
						<a class="dropdown-item" onclick="popupAcsMyPage('email'); return false;">이메일 수정</a>
					</div>
				</li>
				<li class="nav-item active">
					<a href="#" id="logout" class="navbar-brand">로그아웃</a>
				</li>
			</ul>
		</div>
		</div>
	</header>
	<section class="jumbotron text-center">
		 <div class="container">
			<!-- 정보 영역 -->
			<form id="infoForm" method="GET">
				<input type="hidden" name="errorSn" id="errorSn" value="-1">
				<input type="hidden" name="page" id="page" value="${requestVO.page}">
				<input type="hidden" name="searchType" id="searchType" value="loginId">
				<div class="form-label-group">
					<button class="btn btn-warning" style="float:right;width:10%;" id="btnSrch">검색</button>
					<input class="form-control" style="width:90%" type="text" name="searchText" id="searchText" placeholder="사용자ID를 검색 해주세요." value="${requestVO.searchText}">
				</div>
			</form>
		 </div>
	</section>
	<div class="container">
		에러내역
		<table class="table table-hover text-center">
			<thead>
				<tr>
					<th>No.</th>
					<th>예외 사항</th>
					<th>사용자ID</th>
					<th>발생 시간</th>
				</tr>
			</thead>

			<tbody>
				<c:forEach items="${listError}" var="vo">
					<tr>
						<td>${vo.errorSn}</td>
						<td style="text-align:left;text-overflow:ellipsis; overflow:hidden"><a href="#" onclick="moveDetailPage(${vo.errorSn});return false;" title="${vo.excpt}">${vo.excpt}</a></td>
						<td>${vo.loginId}</td>
						<td>${vo.rgstDttm}</td>
					</tr>
				</c:forEach>
			</tbody>
		</table>
		<!-- 페이징 -->
		<nav aria-label="Page navigation" style="margin-top: 20px;">
			<ul class="pagination justify-content-center">
				<!-- 이전 버튼 -->
				<c:if test="${pageMaker.prev}">
					<li class="page-item"><a class="page-link" href="#" onclick="movePage(${pageMaker.startPage-1});return false;">&laquo;</a></li>
				</c:if>

				<!-- 페이지 번호 -->
				<c:forEach begin="${pageMaker.startPage}" end="${pageMaker.endPage}" var="idx">
					<li class="page-item <c:out value="${pageMaker.cri.page == idx ? 'active' : ''}"/>">
						<a class="page-link" href="#" onclick="movePage(${idx});return false;">${idx}</a>
					</li>
				</c:forEach>

				<!-- 다음 버튼 -->
				<c:if test="${pageMaker.next && pageMaker.endPage > 0}">
					<li class="page-item"><a class="page-link" href="#" onclick="movePage(${pageMaker.endPage+1});return false;">&raquo;</a></li>
				</c:if>
			</ul>
		</nav>
	</div>
	<!-- layerPopup -->
	<%@include file="/WEB-INF/views/home/popup_acs_myPage.jsp" %>
</body>
</html>
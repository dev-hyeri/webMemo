<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>에러 상세</title>
	<!-- jquery 3.4.1 -->
	<script src="/hyeri/resources/js/jquery/jquery-3.4.1.min.js"></script>
	<!-- bpopup 0.11.0 -->
	<script src="/hyeri/resources/js/bpopup/bpopup-0.11.0.min.js"></script>
	<!-- bootstrap -->
	<script src="/hyeri/resources/bootstrap/js/bootstrap.min.js"></script>
	<link href="/hyeri/resources/bootstrap/css/bootstrap.min.css" rel="stylesheet">
	</head>
	<style>
		.nav a {font-size:medium;}
		table {table-layout:fixed;}
	</style>
<script>
	$(document).ready(function(){

		$("#logout").click(function(){
			fn_logout();
		});

		// 회원조회 이동
		$("#mmbrList").click(function(){
			location.href="list_mmbr.html";
		});

		$("#btnList").click(function(){
			$("#infoForm").prop("method","GET");
			$("#infoForm").prop("action","list_error.html");
			$("#infoForm").submit();
		});

		$("#btnDelete").click(function(){
			if(confirm("삭제하시겠습니까?")){
				fn_deleteError();
			}
		});
	});

	//에러 내역 삭제
	function fn_deleteError(){
		var errorSn = ${vo.errorSn};

		$.ajax({
			url: "delete_error.ajax"
			,type: 'POST'
			,data: {"errorSn" : errorSn}
			,datatype:"json"
			,success:function(result){
				if("success"==result["msg"]){
					alert("삭제 완료하였습니다.");
					$("#infoForm").prop("method","GET");
					$("#infoForm").prop("action","list_error.html");
					$("#infoForm").submit();

				}else if("fail"==result["msg"]){
					alert("삭제 오류가 발생하였습니다.");
				}
			}
		});
	}
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

	//페이지 이동
	function movePage(num) {
		$('#page').val(num);
		$('#infoForm').prop('method', 'GET');
		$('#infoForm').prop('action', 'list_error.html');
		$('#infoForm').submit();
	}

	//마이페이지 접근 팝업
	function popupAcsMyPage(path) {
		$("#path").val(path);
		$("#popupAcsMyPage").bPopup({
			modalClose: false
		});
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
	<form id="infoForm">
		<input type="hidden" name="page" id="page" value="${requestVO.page}">
		<input type="hidden" name="searchType" id="searchType" value="loginId">
		<input type="hidden" name="searchText" id="searchText" value="${requestVO.searchText}">
	</form>
	<div class="container" >
		<table class="table table-bordered table-lg mt-5">
			<colgroup>
				<col width="100px!important">
				<col width="">
			</colgroup>
			<tbody>
				<tr>
					<th>No.</th>
					<td>${vo.errorSn}</td>
				</tr>
				<tr>
					<th>예외 사항</th>
					<td>${vo.excpt}</td>
				</tr>
				<tr>
					<th>로그인 ID</th>
					<td>${vo.loginId}</td>
				</tr>
				<tr>
					<th>발생 시간</th>
					<td>${vo.rgstDttm}</td>
				</tr>
				<tr>
					<th>세부 사항</th>
					<td>
						<div style="overflow-x:scroll; height:100%; width:100%">
							${vo.cntnt}
						</div>
					</td>
				</tr>
			</tbody>
		</table>
		<button class="btn btn-secondary mb-5" style="margin-left:7px;" id="btnList">목록</button>
		<button class="btn btn-secondary mb-5" id="btnDelete">삭제</button>
	</div>
	<!-- layerPopup -->
	<%@include file="/WEB-INF/views/home/popup_acs_myPage.jsp" %>
</body>
</html>
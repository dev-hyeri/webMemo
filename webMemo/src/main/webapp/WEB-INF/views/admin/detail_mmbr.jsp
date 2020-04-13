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
		.nav a {font-size:medium;}
	</style>
</head>
<script>
	$(document).ready(function(){

		$("#btnList").click(function(){
			$("#infoForm").prop("method","GET");
			$("#infoForm").prop("action","list_mmbr.html");
			$("#infoForm").submit();
		});

		$("#errorList").click(function(){
			location.href="list_error.html";
		});

		$("#logout").click(function(){
			fn_logout();
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
	<form id="infoForm">
		<input type="hidden" name="page" id="page" value="${requestVO.page}">
		<input type="hidden" name="searchType" id="searchType" value="loginId">
		<input type="hidden" name="searchText" id="searchText" value="${requestVO.searchText}">
	</form>
	<div class="container" style="width: 30%!important">
		<table class="table table-md mt-5">
			<tbody>
			<tr>
				<th>ID</th>
				<td>${vo.loginId}</td>
			</tr>
			<tr>
				<th>등록 메모</th>
				<td>${vo.memoCnt}개</td>
			</tr>
			<tr>
				<th>이름</th>
				<td>${vo.mmbrNm}</td>
			</tr>
			<tr>
				<th>권한</th>
				<td>
					<c:set var="cd" value="${vo.authCd}"/>
					<c:choose>
						<c:when test="${cd eq '01'}">
						관리자</c:when>
						<c:when test="${cd eq '02'}">
						일반 사용자</c:when>
						<c:when test="${cd eq '03'}">
						승인 대기</c:when>
					</c:choose>
				</td>
			</tr>
			<tr>
				<th>생년월일</th>
				<td>${vo.mmbrBirth}</td>
			</tr>
			<tr>
				<th>성별</th>
				<td>
					<c:set var="sex" value="${vo.mmbrSex}"/>
					<c:choose>
						<c:when test="${sex eq 'M'}">
						남자(M)</c:when>
						<c:when test="${sex eq 'F'}">
						여자(F)</c:when>
					</c:choose>
					</td>
			</tr>
			<tr>
				<th>전화번호</th>
				<td>${vo.mmbrTel}</td>
			</tr>
			<tr>
				<th>이메일</th>
				<td>${vo.mmbrEmail}</td>
			</tr>
			<tr>
				<th>가입일시</th>
				<td>${vo.joinDttm}</td>
			</tr>
			</tbody>
		</table>
		<button class="btn btn-secondary" style="margin-left:10px" id="btnList">목록</button>
	</div>
	<!-- layerPopup -->
	<%@include file="/WEB-INF/views/home/popup_acs_myPage.jsp" %>
</body>
</html>
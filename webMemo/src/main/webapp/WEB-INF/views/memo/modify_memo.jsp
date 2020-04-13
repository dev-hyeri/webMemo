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

		// 다른 작성자의 메모를 열람하는경우 입력기능 제한.
		if( '${sessionScope.loginId}' != '${memoVO.ownerId}' ) {
			disabledAction();
		}

		// 고정여부 세팅
		if( "Y" == '${memoVO.fxdYn}' ) {
			$('#chFxdYn').prop("checked", true);
		}

		// 전체 공유 여부 세팅
		if( "Y" == '${memoVO.allShrdYn}' ) {
			$('#chAllShrdYn').prop("checked", true);
		}

		// 공유ID 세팅
		if( '${shrdVO.shrdIds}' != '' && '${shrdVO.shrdIds}' != null ) {
			$('#chShrdYn').prop("checked", true);
			var shrdIds = '${shrdVO.shrdIds}'.split(',');

			for( var i = 0; i < shrdIds.length; i++ ) {
				$("#p_"+shrdIds[i]).prop("checked", true)
			}
		}

		//메모 수정 내용 저장
		$("#btnSave").click(function(){
			if($("#cntnt").val() == '' || $("#cntnt").val() ==  null){
				alert("내용을 입력해주세요.");
				$("#cntnt").focus();

			}else{
				fn_modifyMemo();
			}
		});

		//메모 삭제
		$("#btnDelete").click(function(){
			if(confirm("메모를 삭제하시겠습니까?")){
				fn_deleteMemo();
			}
		});

		//메모 내용 메일 보내기
		$("#btnSendMail").click(function(){
			if(confirm("해당 메모를 \n메일 주소(   "+"${mmbrVO.mmbrEmail}"+"   )로 \n전송하시겠습니까??")){
				fn_sendMailMemo();
			}
		});

		//목록 이동
		$("#btnList").click(function(){
			$("#formMdfMemo").prop("method","GET");
			$("#formMdfMemo").prop("action","list_memo.html");
			$("#formMdfMemo").submit();
		});

		$("#chAllShrdYn").click(function(){
			if($("#chShrdYn").prop("checked")){
				alert("개별공유 체크 해제 후 사용바랍니다.");
				 $(this).prop("checked",false);
			}
		});

		$("#chShrdYn").click(function(){
			if($("#chAllShrdYn").is(":checked")){
				alert("전체공유 체크 해제 후 사용바랍니다.");
				 $(this).prop("checked",false);
			}else{
				$('#popupMmbr').bPopup({
					modalClose: false
				});
			}
		});

		$("#logout").click(function(){
			fn_logout();
		});
	});

	//기능 제한
	function disabledAction(){
		$("#cntnt").prop("readonly", true);
		$("#chShrdYn").prop("disabled", true);
		$("#chAllShrdYn").prop("disabled", true);
		$("#btnSave").hide();
		$("#btnDelete").hide();
	}

	//메모 수정
	function fn_modifyMemo(){
		var formJson = $("#formMdfMemo").serializeArray();

		$.ajax({
			url: "modify_memo.ajax"
			,type: 'POST'
			,data: formJson
			,datatype:"json"
			,success:function(result){
				if("success"==result["msg"]){
					alert("수정 완료하였습니다.");
					$("#formMdfMemo").prop("method","GET");
					$("#formMdfMemo").prop("action","list_memo.html");
					$("#formMdfMemo").submit();
				}else{
					alert("저장 오류가 발생하였습니다.");
				}
			}
		});
	}

	//메모 삭제
	function fn_deleteMemo(){
		$.ajax({
			url: "delete_memo.ajax"
			,type: 'POST'
			,data: {"memoSn":$("#memoSn").val()}
			,datatype:"json"
			,success:function(result){
				if("success"==result["msg"]){
					alert("삭제 완료하였습니다.");
					$("#formMdfMemo").prop("method","GET");
					$("#formMdfMemo").prop("action","list_memo.html");
					$("#formMdfMemo").submit();
				}else{
					alert("삭제 오류가 발생하였습니다.");
				}
			}
		});
	}

	//메모 내용 메일 보내기
	function fn_sendMailMemo(){
		var mmbrEmail = "${mmbrVO.mmbrEmail}";
		var mmbrNm = "${mmbrVO.mmbrNm}";
		var loginId = "${mmbrVO.loginId}";
		var cntnt = "${memoVO.mailCntn}";

		$.ajax({
			url: "sendMail_memo.ajax"
			,type: 'POST'
			,data: {
					"loginId" : loginId
					,"mmbrEmail" :  mmbrEmail
					,"mmbrNm" :  mmbrNm
					,"cntnt" : cntnt
					}
			,datatype:"json"
			,success:function(result){
				if("success"==result["msg"]){
					alert("메일 전송 완료하였습니다.");
				}else{
					alert("전송 오류가 발생하였습니다.");
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

	<main role="main" class="container">
	      <div class="jumbotron mt-4">
			<form id="formMdfMemo">
				<input type="hidden" name="page" id="page" value="${requestVO.page}">
				<input type="hidden" name="shrdIds" id="shrdIds">
				<input type="hidden" name="searchType" id="searchType" value="cntnt">
				<input type="hidden" name="searchText" id="searchText" value="${requestVO.searchText}">
				<input type="hidden" name="memoSn" id="memoSn" value="${memoVO.memoSn}">
				<div class="row">
					<textarea class="form-control col-6" style="background-color:lightyellow" rows="20" cols="60" name="cntnt" id="cntnt">${memoVO.cntnt}</textarea>
					<div class="col-6">
						<table class="table ml-3">
							<!-- 고정메모는 개인 메모탭에서만 활성화 -->
							<c:if test="${pageType eq indvd}">
								<tr>
									<th>고정</th>
									<td><input type=checkbox name="fxdYn" id="chFxdYn" value="Y">고정
								</tr>
							</c:if>
							<tr>
								<th>공유</th>
								<td>
								    <div class="custom-control custom-checkbox mr-sm-2">
										<input class="custom-control-input" type="checkbox" name="allShrdYn" id="chAllShrdYn" value="Y">
										<label class="custom-control-label" for="chAllShrdYn">전체</label>
									</div>
									<div class="custom-control custom-checkbox mr-sm-2">
										<input class="custom-control-input" type="checkbox" id="chShrdYn" value="Y">
										<label class="custom-control-label" for="chShrdYn">선택</label>
									</div>
								</td>
							</tr>
							<tr>
								<th>작성자 ID</th>
								<td>${memoVO.ownerId}</td>
							</tr>
							<tr>
								<th>등록일시</th>
								<td>${memoVO.rgstDttm}</td>
							</tr>
							<tr>
								<th>수정일시</th>
								<td>${memoVO.mdfDttm}</td>
							</tr>
							<tr>
								<td colspan=2>*작성자 외 수정할 수 없습니다.</td>
							</tr>
						</table>
						<div class="text-center mt-5">
							<button class="btn btn-primary btn-md col-2" type="button" id="btnSave">저장</button>
							<button class="btn btn-secondary btn-md col-2" type="button" id="btnDelete">삭제</button>
							<button class="btn btn-secondary btn-md  col-2" type="button" id="btnList">목록</button>
							<button class="btn btn-secondary btn-md col-2" type="button" id="btnSendMail">메일</button>
						</div>
					</div>
				</div>
			</form>
		</div>
	</main>

	<!-- layer popup1 -->
	<%@include file="popup_list_mmbr.jsp" %>
	<!-- layerPopup2 -->
	<%@include file="/WEB-INF/views/home/popup_acs_myPage.jsp" %>
</body>
</html>
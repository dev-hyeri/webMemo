<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>Insert title here</title>
	<!-- jquery 3.4.1 -->
	<script src="/hyeri/resources/js/jquery/jquery-3.4.1.min.js"></script>
	<!-- bpopup 0.11.0 -->
	<script src="/hyeri/resources/js/bpopup/bpopup-0.11.0.min.js"></script>
	<script src="/hyeri/resources/bootstrap/js/bootstrap.min.js"></script>
	<link href="/hyeri/resources/bootstrap/css/bootstrap.min.css" rel="stylesheet">
	<style>
	.nav a {font-size:medium;}
	.table { text-align:center}
	</style>
</head>
<script>
	$(document).ready(function(){

		//메모 등록
		$("#btnRegister").click(function(){
			if($("#cntnt").val() == '' || $("#cntnt").val() ==  null){ //내용이 없을 경우
				alert("내용을 입력해주세요.");
				$("#cntnt").focus();

			}else{
				fn_registerMemo();
			}
		});

		//목록 이동
		$("#btnList").click(function(){
			if("indvd" == '${pageType}'){
				location.href="/hyeri/memo/indvd/list_memo.html";
			}else{
				location.href="/hyeri/memo/shrd/list_memo.html";
			}
		});

		$("#chAllShrdYn").click(function(){
			if($("#chShrdYn").prop("checked")){
				alert("개별공유 체크 해제 후 사용바랍니다.");
				 $(this).prop("checked",false);
			}
		});

		$("#chShrdYn").click(function(){
			if($("#chAllShrdYn").prop("checked")){
				alert("전체공유 체크 해제 후 사용바랍니다.");
				 $(this).prop("checked",false);
			}else{
				$('#popupMmbr').bPopup({ //회원ID 리스트 팝업 실행
					modalClose: false
				});
			}
		});

		$("#logout").click(function(){
			fn_logout();
		});
	});

	//메모 등록
	function fn_registerMemo(){
		var formJson = $("#formRgstMemo").serializeArray();
		var allShrdYn = $("#allShrdYn").is(":checked");
		var shrdIds = $("#shrdIds").val();

		$.ajax({
			url: "register_memo.ajax"
			,type: 'POST'
			,data: formJson
			,datatype:"json"
			,success:function(result){
				if("success" == result["msg"]){
					alert("저장되었습니다");

					// 공유하는 메모의 경우 공유메모 목록으로 리다이렉트.
					if( allShrdYn || (shrdIds != null && shrdIds != '') ) {
						location.href = "/hyeri/memo/shrd/list_memo.html";
					} else {
						location.href="/hyeri/memo/indvd/list_memo.html";
					}
				}else{
					alter("오류가 발생하였습니다.");
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
		<div class="jumbotron justify-content-md-center mt-4">
			<form id="infoForm">
				<input type="hidden" name="page" id="page" value="${requestVO.page}">
				<input type="hidden" name="searchType" id="searchType" value="cntnt">
				<input type="hidden" name="searchText" id="searchText" value="${requestVO.searchText}">
			</form>
			<form id="formRgstMemo">
				<input type="hidden" name="shrdIds" id="shrdIds">
				<div class="text-center">
					<h4>새 메모 등록</h4><br>
					<textarea class="col-6" style="background-color:lightyellow;" rows="20" cols="60" name="cntnt" id="cntnt"></textarea>
					</div>
					<div>
						<table class="table col-md-6 offset-md-3" >
							<tr>
								<td>
									<div class="custom-control custom-checkbox mr-sm-2">
										<input class="custom-control-input" type="checkbox" name="allShrdYn" id="chAllShrdYn" value="Y">
										<label class="custom-control-label font-weight-bold" style="font-weight-bold:true" for="chAllShrdYn">전체 공유</label>
									</div>
									</td>
									<td>
									<div class="custom-control custom-checkbox mr-sm-2">
										<input class="custom-control-input " type="checkbox" id="chShrdYn" value="Y">
										<label class="custom-control-label font-weight-bold" for="chShrdYn">선택 공유</label>
									</div>
								</td>
							</tr>
						</table>
					</div>
					</form>
					<div class="text-center">
						<button class="btn btn-primary btn-md col-4" type="button" id="btnRegister">등록</button>
						<button class="btn btn-secondary btn-md col-2" type="button" id="btnList">목록</button>
					</div>
		</div>
	</main>
	<!-- layer popup1 -->
	<%@include file="popup_list_mmbr.jsp" %>
	<!-- layerPopup2 -->
	<%@include file="/WEB-INF/views/home/popup_acs_myPage.jsp" %>
</body>
</html>
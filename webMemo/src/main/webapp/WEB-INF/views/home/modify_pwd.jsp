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
	<!-- bootstrap -->
	<script src="/hyeri/resources/bootstrap/js/bootstrap.min.js"></script>
	<link href="/hyeri/resources/bootstrap/css/bootstrap.min.css" rel="stylesheet">
	<style>
		.nav a {font-size:medium;}
		.btn {margin-top: 10px;}
	</style>
</head>
<script>
	$(document).ready(function(){

		$("#btnModify").click(function(){
			fn_mdfPw();
		});

		$("#btnCancel").click(function(){
			history.back();
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

	//비밀번호 수정
	function fn_mdfPw(){
		if(this.checkValidate()){
			if(confirm("비밀번호를 변경하시겠습니까?")){
				$.ajax({
					url: "modify_mmbrInfo.ajax"
					,type: 'POST'
					,data: {"loginId": "${vo.loginId}"
							,"pwd":$("#pwd").val() }
					,datatype:"json"
					,success:function(result){
						if("success"==result.msg){
							alert("수정되었습니다.");
							location.href = "/hyeri/memo/indvd/list_memo.html";

						}else{
						    alert("오류가 발생했습니다.");
						}
					}
				});
			}
		}
	}

	//필수 값 체크
	function checkValidate() {
		var obj_arr = [	// input 아이디         	, 유효성체크타입
						["pwd"			, "pwd"]
						,["pwdcheck"	, "checkPwd"]
					];

		var obj_val = null;
		var rtn_val = true;
		var tmp_rtn_val = true;

		for( var i = 0; i < obj_arr.length; i++ ) {
			obj_val = $("#" + obj_arr[i][0] ).val();

			if( obj_val != null && obj_val != '' ) {
				this.offMsg(obj_arr[i][0]);
				// 유효성 검사가 실패한 경우에만 결과변수에 저장.
				tmp_rtn_val = this.regCheckVal(obj_val, obj_arr[i][1], obj_arr[i][0]);
				if( !tmp_rtn_val ) rtn_val = tmp_rtn_val;

			} else {
				this.onMsg(obj_arr[i][0], "");
				rtn_val = false;
			}
			obj_val = null;
		}
		return rtn_val;
	}

	function regCheckVal(val, type, objId) {
		var rtn = false;

		if ( "pwd" == type ) {
			if( /^(?=.*[a-z])(?=.*[0-9])(?=.*[!@#$%^*()\-_=+\\\|\[\]{};:\'",.<>\/?]).{8,16}$/.test(val) ) {
				rtn = true;
			} else {
				this.onMsg(objId, "영문 소문자,숫자,특수문자를 하나 이상 포함. 8 ~ 16 자리");
			}
		} else if ("checkPwd" == type){
				this.offMsg(objId);
				if(val == $("#pwd").val()){
					rtn = true;
				}else{
					this.onMsg(objId,"비밀번호가 일치하지 않습니다.");
				}
			}
		if( rtn ) this.offMsg(objId);
		return rtn;
	}

	//메시지 영역 ON
	function onMsg( id, msg ){
		$("#fail_" + id ).show();
		if( "" == msg ) {
			$("#fail_" + id ).html("필수 입력 항목입니다.");
		} else {
			$("#fail_" + id ).html(msg);
		}
	}

	// 메시지 영역 OFF
	function offMsg( id ){
		$("#fail_" + id ).hide();
	}
</script>
<body class="bg-light">
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
	<div class="container" style="margin-bottom: 100px;">
		<div class="py-5 text-center">
			<h2>비밀번호 수정</h2>
			<h6>안전한 비밀번호로 내정보를 보호하세요.</h6>
		</div>
		<div class="row justify-content-md-center">
			<div class="col-md-6">
				<div class="mb-3">
					<label for="loginId">아이디</label>
					<input type="text" class="form-control" name="loginId" id="loginId" value="${vo.loginId}" readonly="readonly">
				</div>
				<div class="mb-3">
					<label for="email">새 비밀번호</label>
					<input type="password" class="form-control" name="pwd" id="pwd" placeholder="영문 소문자,숫자,특수문자를 하나 이상 포함. 8 ~ 16 자리">
					<div class="invalid-feedback" id="fail_pwd"></div>
				</div>
				<div class="mb-3">
					<label for="email">새 비밀번호 재입력</label>
					<input type="password" class="form-control" name="pwdcheck" id="pwdcheck">
					<div class="invalid-feedback" id="fail_pwdcheck"></div>
				</div>
				<button class="btn btn-primary btn-md"  type="button" id="btnModify">수정</button>
				<button class="btn btn-secondary btn-md"  type="button" id="btnCancel">취소</button>
			</div>
		</div>
	</div>
	<!-- layerPopup -->
	<%@include file="/WEB-INF/views/home/popup_acs_myPage.jsp" %>
</body>
</html>
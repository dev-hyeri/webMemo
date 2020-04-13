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
	</style>
</head>
<script>
	$(document).ready(function(){
		$("#btnEmailCheck").click(function(){
			fn_emailCheck();
		});

		$("#btnModify").click(function(){
			fn_mdfEmail();
		});

		$("#btnCancel").click(function(){
			history.back();
		});

		$("#logout").click(function(){
			if(confirm("로그아웃하시겠습니까?")){
				fn_logout();
			}
		});
	});

	//로그아웃
	function fn_logout() {
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

	//이메일 수정
	function fn_mdfEmail(){

		if(this.checkValidate()){
			if(confirm("이메일을 변경하시겠습니까?\n변경 시 로그아웃되며 메일 인증 후 서비스 이용 가능합니다.")){

				$.ajax({
					url: "modify_mmbrInfo.ajax"
					,type: 'POST'
					,data: {"loginId": "${vo.loginId}"
							,"mmbrEmail":$("#afMmbrEmail").val() }
					,datatype:"json"
					,success:function(result){
						if("success"==result.msg){
							alert("수정되었습니다. 메일 인증 후 다시 로그인바랍니다.");
							fn_logout();

						}else{
						    alert("오류가 발생했습니다.");
						}
					}
				});
			}
		}
	}

	//마이페이지 접근 팝업
	function popupAcsMyPage(path) {
		$("#path").val(path);
		$("#popupAcsMyPage").bPopup({
			modalClose: false
		});
	}

	//이메일 중복체크
	function fn_emailCheck(){

		var bfMmbrEmail = $("#bfMmbrEmail").val(); // 변경 전 이메일
		var afMmbrEmail = $("#afMmbrEmail").val(); // 변경 할 이메일

		if(afMmbrEmail == null || afMmbrEmail == ''){
			alert("이메일을 입력해주시기 바랍니다.");

		}else {
			if( this.regCheckVal(afMmbrEmail, "email", "afMmbrEmail")) {
				$.ajax({
				url: "emailCheck.ajax"
				,type: 'POST'
				,data: {
						"loginId": "${vo.loginId}"
						,"mmbrEmail":afMmbrEmail
						}
				,datatype:"json"
				,success:function(result){
						if(result==0){
							$("#emailCheckVal").val(afMmbrEmail);
							alert("사용 가능한 이메일입니다.");

						}else if(result==1){
							if(bfMmbrEmail == afMmbrEmail){
								alert("기존 메일정보와 동일합니다.");
							}
							alert("이미 존재하는 이메일입니다. \n 다른 이메일을 사용하시기 바랍니다.");

						}else{
							alert("에러가 발생하였습니다.");
						}
					}
				});
			}
		}
	}

	//필수 값 체크
	function checkValidate() {
		var obj_arr = [	// input 아이디         , 유효성체크타입
						["afMmbrEmail"		, "email"]
						,["emailCheckVal"	, "checkEmail"]
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

			} else if("checkEmail" == obj_arr[i][1] && "" == obj_val){
					alert("이메일 중복 체크는 필수입니다.");
					rtn_val = false;

			}else{
					this.onMsg(obj_arr[i][0], "");
					rtn_val = false;
			}
			obj_val = null;
		}
		return rtn_val;
	}

	// 항목별 유효성 검사
	function regCheckVal(val, type, objId) {
		var rtn = false;

		if("email" == type){
			if( /^[A-Za-z0-9_\.\-]+@[A-Za-z0-9\-]+\.[A-Za-z0-9\-]+/.test(val) ){
				rtn = true;
			}else{
				this.onMsg(objId, "이메일 형식 입력 ex)aaaa@memo.com");
			}
		}else if ( "checkEmail" == type ){
			if( val == $("#afMmbrEmail").val() ) {
				rtn = true;
			} else {
				alert("이메일 중복 체크는 필수입니다.");
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
	<input type="hidden" id="emailCheckVal" value="">
	<div class="container" style="margin-bottom: 100px;">
		<div class="py-5 text-center">
			<h2>이메일 수정</h2>
			<h6>비밀번호 찾기, 메모 내용 내메일로 보내기 등 <br>본인확인이 필요한 경우 사용할 이메일 주소입니다.<br></h6>
		</div>
		<div class="row justify-content-md-center">
			<div class="col-md-6">
				<div class="mb-4">
					<label for="loginId">아이디</label>
					<input type="text" class="form-control" name="loginId" id="loginId" value="${vo.loginId}" readonly="readonly">
				</div>
				<div class="mb-4">
					<label for="email">기존 이메일</label>
					<input type="email" class="form-control" name="bfMbrEmail" id="bfMbrEmail" value="${vo.mmbrEmail}" readonly="readonly">
					<br>
					<div class="row">
						<label for="email" style="margin-left:17px;" >변경 이메일(해당 메일로 인증 메일 전송)</label>
						<input type="email" class="col-md-8 form-control"  style="margin-left:17px;" name="afMmbrEmail" id="afMmbrEmail" placeholder="이메일 입력">
						<div class="invalid-feedback" id="fail_afMmbrEmail"></div>
						<input type="button" class="col-md-3 btn btn-secondary" style="margin-left:3px;" name="emailCheck" id="btnEmailCheck" value="중복체크" >
					</div>
				</div>
				<button class="btn btn-primary btn-lg-12" style="margin-top: 10px" type="button" id="btnModify">수정</button>
				<button class="btn btn-secondary btn-lg-12" style="margin-top: 10px" type="button" id="btnCancel">취소</button>
			</div>
		</div>
	</div>
	<!-- layerPopup -->
	<%@include file="/WEB-INF/views/home/popup_acs_myPage.jsp" %>
</body>
</html>
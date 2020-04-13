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

		//성별 체크
		$('#mmbrSex' + '${vo.mmbrSex}').prop('checked', true);

		$("#btnModify").click(function(e){
			e.preventDefault();
			fn_mdfMmbr();
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

	//회원 정보 수정
	function fn_mdfMmbr(){

		if( this.checkValidate() ) {
			if(confirm("회원정보 수정을 하시겠습니까?")) {
				var formObj = $("#mdfMmbrForm").serializeArray();

				$.ajax({
					url: "modify_mmbrInfo.ajax"
					,type: 'POST'
					,data: formObj
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
	};

	//필수 값 체크
	function checkValidate() {
		var obj_arr = [	// input 아이디    		 , 타입                     , 유효성체크타입
						 ["mmbrNm"			, "text"	, "name"]
						,["mmbrBirth"		, "date"	, "birth"]
						,["mmbrTel"			, "text"	, "phone"]
					];

		var obj_val = null;
		var rtn_val = true;
		var tmp_rtn_val = true;

		for( var i = 0; i < obj_arr.length; i++ ) {
			if( "text" == obj_arr[i][1]
				|| "password" == obj_arr[i][1]
				|| "date" == obj_arr[i][1] ) {
				obj_val = $("#" + obj_arr[i][0] ).val();
			}

			if( obj_val != null && obj_val != '' ) {
				this.offMsg(obj_arr[i][0]);
				// 유효성 검사가 실패한 경우에만 결과변수에 저장.
				tmp_rtn_val = this.regCheckVal(obj_val, obj_arr[i][2], obj_arr[i][0]);
				if( !tmp_rtn_val ) rtn_val = tmp_rtn_val;

			} else {
				this.onMsg(obj_arr[i][0], "");
				rtn_val = false;

			}
			obj_val = null;
		}

		return rtn_val;
	}

	// 항목별 유효성 검사.
	function regCheckVal( val, type, objId ) {
		var rtn = false;

		 if("name" == type){
			if( /^[가-힣]{2,6}$/.test(val) ){
				rtn = true;
			}else{
				this.onMsg(objId, "한글 2~6 자리");
			}
		}else if("birth" == type){
			if( /^(19|20)[0-9]{2}(0[1-9]|1[1-2])(0[1-9]|[1-2][0-9]|3[0-1])$/.test(val) ){
				rtn = true;
			}else{
				this.onMsg(objId, "숫자8자리 ex)20190312");
			}
		}else if("phone" == type){
			if( /^01[0179][0-9]{7,8}$/.test(val) ){
				rtn = true;
			}else{
				this.onMsg(objId, "숫자만 입력(010,017,019만 가능)");
			}
		}
		if( rtn ) this.offMsg(objId);
		return rtn;
	}

	// 메시지 영역 ON
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
			<h2>회원정보 수정</h2>
			<h6>회원정보는 개인정보처리방침에 따라 안전하게 보호되며,<br> 회원님의 명백한 동의 없이 공개 또는 제 3자에게 제공되지 않습니다.</h6>
		</div>
		<div class="row justify-content-md-center">
			<div class="col-md-6">
				<form id="mdfMmbrForm">
					<div class="mb-3">
						<label for="loginId">아이디</label>
						<div class="row">
							<input type="text" class="form-control" style="margin-left: 17px;" name="loginId" id="loginId" value="${vo.loginId}" readonly="readonly">
						</div>
						<div class="invalid-feedback" id="fail_loginId"></div>
					</div>
					<div class="mb-3">
						<label for="mmbrNm">이름</label>
						<input type="text" class="form-control" name="mmbrNm" id="mmbrNm" value="${vo.mmbrNm}" placeholder="이름 입력">
						<div class="invalid-feedback" id="fail_mmbrNm"></div>
					</div>
					<div class="mb-3">
						<label for="mmbrSex">성별</label><br>
						<div class="custom-control custom-radio custom-control-inline">
							<input id="mmbrSexM" name="mmbrSex" type="radio" value="M" class="custom-control-input" required>
							<label class="custom-control-label" for="mmbrSexM">남</label>
						</div>
						<div class="custom-control custom-radio custom-control-inline">
							<input id="mmbrSexF" name="mmbrSex" type="radio" value="F" class="custom-control-input" required>
							<label class="custom-control-label" for="mmbrSexF">여</label>
						</div>
					</div>
					<div class="mb-3">
						<label for="email">생년월일</label>
						<input type="text" class="form-control" name="mmbrBirth" id="mmbrBirth" value="${vo.mmbrBirth}" placeholder="생년월일 입력( 숫자만 )" maxlength="8">
						<div class="invalid-feedback" id="fail_mmbrBirth"></div>
					</div>
					<div class="mb-3">
						<label for="email">휴대폰 번호</label>
						<input type="text" class="form-control" name="mmbrTel" id="mmbrTel" value="${vo.mmbrTel}" placeholder="휴대폰 번호 입력( 숫자만 )">
						<div class="invalid-feedback" id="fail_mmbrTel"></div>
					</div>
				</form>
				<button class="btn btn-primary btn-lg-12" type="button" id="btnModify">수정</button>
				<button class="btn btn-secondary btn-lg-12" type="button" id="btnCancel">취소</button>
			</div>
		</div>
	</div>
	<!-- layerPopup -->
	<%@include file="/WEB-INF/views/home/popup_acs_myPage.jsp" %>
</body>
</html>
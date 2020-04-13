<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>Insert title here</title>
	<!-- jquery 3.4.1 -->
	<script src="/hyeri/resources/js/jquery/jquery-3.4.1.min.js"></script>
	<!-- bootstrap -->
	<script src="/hyeri/resources/bootstrap/js/bootstrap.min.js"></script>
	<link href="/hyeri/resources/bootstrap/css/bootstrap.min.css" rel="stylesheet">
	<style>
		.errorMsg {display:none;}
		#back{
			position: absolute;
			z-index: 100;
			background-color: #000000;
			display:none;
			left:0;
			top:0;
		}
		#loadingBar{
			position:absolute;
			left:50%;
			top: 40%;
			display:none;
			z-index:200;
		}
	</style>
</head>
<script>
	$(document).ready(function(){

		$("#btnJoin").click(function(e){
			e.preventDefault();
			fn_join();
		});

		$("#btnIdCheck").click(function(e){
			e.preventDefault();
			fn_idCheck();
		});

		$("#btnEmailCheck").click(function(e){
			e.preventDefault();
			fn_emailCheck();
		});

		$("#btnCancel").click(function(){
			location.href= "login.html";
		});

	});

	//ID중복체크
	function fn_idCheck(){
		var loginId = $("#loginId").val();

		if(loginId == null || loginId == ''){
			alert("아이디를 입력해주시기 바랍니다.");

		}else {
			if( this.regCheckVal(loginId, "id", "loginId")) {

				$.ajax({
				url: "idCheck.ajax"
				,type: 'POST'
				,data: {"loginId":loginId}
				,datatype:"json"
				,success:function(result){
						if(result==0){
							$("#idCheckVal").val(loginId);
							alert("사용 가능한 아이디입니다.");

						}else if(result==1){
							alert("이미 존재하는 아이디입니다. \n 다른 아이디를 사용하시기 바랍니다.");

						}else{
							alert("에러가 발생하였습니다.");
						}
					}
				});
			}
		}
	}

	//이메일 중복 체크
	function fn_emailCheck(){
		var mmbrEmail = $("#mmbrEmail").val();

		if(mmbrEmail == null || mmbrEmail == ''){
			alert("이메일을 입력해 주시기 바랍니다.");

		}else {
			if( this.regCheckVal(mmbrEmail, "email", "mmbrEmail")) {

				$.ajax({
				url: "emailCheck.ajax"
				,type: 'POST'
				,data: {"mmbrEmail":mmbrEmail}
				,datatype:"json"
				,success:function(result){
						if(result==0){
							$("#emailCheckVal").val(mmbrEmail);
							alert("사용 가능한 이메일입니다.");

						}else if(result==1){
							alert("이미 존재하는 이메일입니다. \n 다른 이메일을 사용하시기 바랍니다.");

						}else{
							alert("에러가 발생하였습니다.");
						}
					}
				});
			}
		}
	}

	//로딩바 생성
	function fn_LoadingBarStart() {
		var backHeight = $(document).height(); 			//뒷 배경의 상하 폭
		var backWidth = window.document.body.clientWidth; 	//뒷 배경의 좌우 폭
		var backGroundCover = "<div id='back'></div>"; 		//뒷 배경을 감쌀 커버
		var loadingBarImage = ''; 				//가운데 띄워 줄 이미지

		loadingBarImage += "<div id='loadingBar'>";
		loadingBarImage += " <img src='/hyeri/resources/img/loadingbar.gif'/>"; 	//로딩 바 이미지
		loadingBarImage += "</div>";
		$('body').append(backGroundCover).append(loadingBarImage);
		$('#back').css({ 'width': backWidth, 'height': backHeight, 'opacity': '0.3' });
		$('#back').show();
		$('#loadingBar').show();
	}

	//로딩바 제거
	function fn_LoadingBarEnd() {
		$('#back, #loadingBar').hide();
		$('#back, #loadingBar').remove();
	}

	//회원가입
	function fn_join(){
		if( this.checkValidate() ) {
			if(confirm("회원가입을 하시겠습니까?")) {

				$.ajax({
					url: "join.ajax"
					,type: 'POST'
					,data: {"loginId" : $("#loginId").val()
							,"pwd" : $("#pwd").val()
							,"mmbrNm" : $("#mmbrNm").val()
							,"mmbrSex" : $("input:radio[name='mmbrSex']:checked").val()
							,"mmbrBirth" : $("#mmbrBirth").val()
							,"mmbrTel" : $("#mmbrTel").val()
							,"mmbrEmail" : $("#mmbrEmail").val()
							}
					,datatype:"json"
					,beforeSend: function () {
							fn_LoadingBarStart();} 	//로딩바 생성
					, complete: function () {
							fn_LoadingBarEnd();} 		//로딩바 제거
					,success:function(result){
							if("success" == result["msg"]){
								alert("가입 요청이 완료되었습니다. \n메일 인증 후 로그인 바랍니다.");
								location.href="login.html";

							}else{
								alert("에러가 발생하였습니다.");
							}
						}
				});
			 }
		}
	}

	// 필수 값 체크
	function checkValidate() {
		var obj_arr = [	// input 아이디     , 타입                     , 유효성체크타입
						["loginId"			, "text"		, "id"]
						,["idCheckVal"		, "text"		, "checkId"]
						,["pwd"				, "password"	, "pwd"]
						,["pwdcheck"		, "password"	, "checkPwd"]
						,["mmbrNm"			, "text"		, "name"]
						,["mmbrBirth"		, "date"		, "birth"]
						,["mmbrTel"			, "text"		, "phone"]
						,["mmbrEmail"		, "text"		, "email"]
						,["emailCheckVal"	, "text"		, "checkEmail"]
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

			}else if("checkId" == obj_arr[i][2] && "" == obj_val){
				alert("아이디 중복 체크는 필수입니다.");
				rtn_val = false;

			} else if("checkEmail" == obj_arr[i][2] && "" == obj_val){
				alert("이메일 중복 체크는 필수입니다.");
				rtn_val = false;

			} else{
				this.onMsg(obj_arr[i][0], "");
				rtn_val = false;
			}
			obj_val = null;
		}
		return rtn_val;
	}

	// 항목별 유효성 검사
	function regCheckVal( val, type, objId ) {
		var rtn = false;

		if( "id" == type ) {
			if( /^[a-z0-9]{5,20}$/.test(val) ) {
				rtn = true;
			} else {
				this.onMsg(objId, "영문소문자,숫자만 가능. 5 ~ 20 자리");
			}
		} else if ( "checkId" == type ){
			if( val == $("#loginId").val() ) {
				rtn = true;
			} else {
				alert("아이디 중복체크는 필수입니다.");
			}
		} else if ( "pwd" == type ){
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
		}else if("name" == type){
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
		}else if("email" == type){
			if( /^[A-Za-z0-9_\.\-]+@[A-Za-z0-9\-]+\.[A-Za-z0-9\-]+/.test(val) ){
				rtn = true;
			}else{
				this.onMsg(objId, "이메일 형식 입력 ex)aaaa@memo.com");
			}
		}else if ( "checkEmail" == type ){
			if( val == $("#mmbrEmail").val() ) {
				rtn = true;
			} else {
				alert("이메일 중복체크는 필수입니다.");
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
	<input type="hidden" id="idCheckVal" value="">
	<input type="hidden" id="emailCheckVal" value="">
	<div class="container" style="margin-bottom: 100px;">
		<div class="py-5 text-center">
			<h2>회원가입</h2>
			<p class="lead">
				환영합니다!  WebMemo 사용을 위한 회원가입을 진행합니다.
			</p>
		</div>
		<div class="row justify-content-md-center">
			<div class="col-md-6">
				<form id="joinForm" class="needs-validation">
					<div class="mb-3">
						<label for="email">아이디</label>
						<div class="row">
							<input type="text" class="col-md-8 form-control" style="margin-left: 17px;" name="loginId" id="loginId" placeholder="아이디 입력">
							<input type="button" class="col-md-3 btn btn-secondary" style="margin-left:3px;" name="idCheck" id="btnIdCheck" value="중복체크" >
						</div>
						<div class="invalid-feedback" id="fail_loginId"></div>
					</div>
					<div class="mb-3">
						<label for="email">비밀번호</label>
						<input type="password" class="form-control" name="pwd" id="pwd" placeholder="영문 소문자,숫자,특수문자를 하나 이상 포함. 8 ~ 16 자리">
						<div class="invalid-feedback" id="fail_pwd"></div>
					</div>

					<div class="mb-3">
						<label for="email">비밀번호 재확인</label>
						<input type="password" class="form-control" name="pwdcheck" id="pwdcheck" placeholder="비밀번호 재입력">
						<div class="invalid-feedback" id="fail_pwdcheck"></div>
					</div>

					<div class="mb-3">
						<label for="email">이름</label>
						<input type="text" class="form-control" name="mmbrNm" id="mmbrNm" placeholder="이름 입력">
						<div class="invalid-feedback" id="fail_mmbrNm"></div>
					</div>

					<div class="mb-3">
						<label for="email">성별</label><br>
						<div class="custom-control custom-radio custom-control-inline">
							<input id="mmbrSexM" name="mmbrSex" type="radio" value="M" class="custom-control-input" checked required>
							<label class="custom-control-label" for="mmbrSexM">남</label>
						</div>
						<div class="custom-control custom-radio custom-control-inline">
							<input id="mmbrSexF" name="mmbrSex" type="radio" value="F" class="custom-control-input" required>
							<label class="custom-control-label" for="mmbrSexF">여</label>
						</div>
					</div>

					<div class="mb-3">
						<label for="email">생년월일</label>
						<input type="text" class="form-control" name="mmbrBirth" id="mmbrBirth" placeholder="생년월일 입력( 숫자만 )" maxlength="8">
						<div class="invalid-feedback" id="fail_mmbrBirth"></div>
					</div>

					<div class="mb-3">
						<label for="email">휴대폰 번호</label>
						<input type="text" class="form-control" name="mmbrTel" id="mmbrTel" placeholder="휴대폰번호 입력( 숫자만 )">
						<div class="invalid-feedback" id="fail_mmbrTel"></div>
					</div>
					<div class="mb-3">
						<label for="email">본인 확인 이메일  (해당 메일로 회원가입 인증 메일 전송)</label>
						<div class="row">
							<input type="email" class="col-md-8 form-control" style="margin-left:17px;" name="mmbrEmail" id="mmbrEmail" placeholder="이메일 입력">
							<input type="button" class="col-md-3 btn btn-secondary" style="margin-left:3px;" name="emailCheck" id="btnEmailCheck" value="중복체크" >
						</div>
						<div class="invalid-feedback" id="fail_mmbrEmail"></div>
					</div>
				</form>
				<button class="btn btn-primary btn-5" style="margin-top: 10px" type="button" id="btnJoin">회원가입</button>
				<button class="btn btn-secondary  btn-5" style="margin-top: 10px" type="button" id="btnCancel">취소</button>
			</div>
		</div>
	</div>
</body>
</html>

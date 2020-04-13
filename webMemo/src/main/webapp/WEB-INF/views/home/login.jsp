<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>Insert title here</title>
	<!-- jquery 3.4.1 -->
	<script src="/hyeri/resources/js/jquery/jquery-3.4.1.min.js"></script>
	<script src="https://cdn.jsdelivr.net/npm/js-cookie@rc/dist/js.cookie.min.js"></script>
	<!-- bpopup 0.11.0 -->
	<script src="/hyeri/resources/js/bpopup/bpopup-0.11.0.min.js"></script>
	<!-- bootstrap -->
	<script src="/hyeri/resources/bootstrap/js/bootstrap.min.js"></script>
	<link href="/hyeri/resources/bootstrap/css/bootstrap.min.css" rel="stylesheet">
	<link href="/hyeri/resources/bootstrap/css/custom_layout.css" rel="stylesheet">
</head>
<script>
	$(document).ready(function(){

		$("#loginId").val(Cookies.get('key')); //쿠키에 저장된 ID 가져오기
		if($("#loginId").val() != ""){ // 로그인ID 있을 경우 체크박스 체크
			$("#idRemember").attr("checked",true);
		}

		//ID기억하기 체크 변경 할 경우
		$("#idRemember").change(function(){
			if($("#idRemember").is(":checked")){ // 체크되어있으면 쿠키에 저장
				Cookies.set('key',$("#loginId").val(),{expires:7});
			}else{ // 체크안되어있으면 쿠키에서 삭제
				Cookies.remove('key');
			}
		});

		//로그인ID 입력 & ID기억하기 체크 되어있으면 새로 쿠키에 저장
		$("#loginId").keyup(function(){
			if($("#idRemember").is(":checked")){
				Cookies.set('key',$("#loginId").val(),{expires : 7});
			}
		});

		$("#btnJoin").click(function(){
			location.href="join.html";
		});

		$("#btnLogin").click(function(){
			fn_login();
		});

		$("#btnFindId").click(function(){
			$("#popupFindId").bPopup({
				modalClose: false
			});
		});

		$("#btnFindPwd").click(function(){
			$("#popupFindPwd").bPopup({
				modalClose: false
			});
		});

	});

	//로그인
	function fn_login(){
		var loginId = $("#loginId").val();
		var pwd = $("#pwd").val();

		if(loginId < 1){
			alert("로그인 아이디를 입력해 주시기 바랍니다.");

		}else if(pwd < 1){
			alert("로그인 비밀번호를 입력해 주시기 바랍니다.");

		}else{
			$.ajax({
				url: "login.ajax"
				,type: 'POST'
				,data: {"loginId" : loginId
						,"pwd" : pwd}
				,datatype:"json"
				,success:function(result){
					if( "success" == result["msg"] ) {
						if( "01" == result["authCd"] ) {//관리자인 경우
							location.href="/hyeri/admin/list_mmbr.html";

						} else {
							location.href="/hyeri/memo/indvd/list_memo.html";
						}

					}else if("disapproval" == result["msg"] ){//미승인 상태인 경우
						alert("이메일 인증 후 로그인해 주시기 바랍니다.");

					}else if("loginWthdr" == result["msg"] ){//탈퇴회원인 경우
						alert("탈퇴 회원입니다.");

					}else{
						alert("아이디 및 패스워드를 확인해 주시기 바랍니다.");
					}
				}
			});
		}
	}

</script>
<body>
	<form class="form-signin">
		<div class="text-center mb-4">
			<h1>WebMemo</h1>
		</div>
		<div class="form-label-group">
			<input class="form-control" type="text" name="loginId" id="loginId" placeholder="아이디">
			<label for="loginId">아이디</label>
		</div>
		<div class="form-label-group">
			<input class="form-control" type="password" name="pwd" id="pwd" placeholder="비밀번호">
			<label for="pwd">비밀번호</label>
		</div>
		<div class="checkbox mb-3">
        <label>
	          <input type="checkbox" id="idRemember"> ID 기억하기
	    </label>
	    </div>
		<button type="button" class="btn btn-lg-5 btn-warning btn-block" id="btnLogin">로그인</button>
		<button type="button" class="btn btn-lg-5 btn-secondary btn-block" id="btnJoin">회원가입</button>
		<div class="mt-2">
			<button type="button" class="btn btn-sm-6 btn-secondary" style="width:49%;" id="btnFindId">아이디 찾기</button>
			<button type="button" class="btn btn-sm-6 btn-secondary" style="width:49%; float:right;" id="btnFindPwd">비밀번호 찾기</button>
		</div>
	</form>
	<!-- layer Popup1 -->
	<%@include file = "popup_find_id.jsp" %>
	<!-- layer Popup2 -->
	<%@include file = "popup_find_pwd.jsp" %>
</body>
</html>
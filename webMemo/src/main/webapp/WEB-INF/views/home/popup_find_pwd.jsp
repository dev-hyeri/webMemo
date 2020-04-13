<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<style>
/*레이어 팝업 영역*/
	.pstyle {
		 display: none;
		 position: relative;
		 width: auto;
		 border: 5px solid #fff;
		 padding: 20px;
		 background-color: #fff;
	}
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
<div id="popupFindPwd" class="pstyle">
	<form id="findPwdForm">
		<div class="mb-3">
			<label for="loginId">아이디</label>
			<input type="text" class="form-control" name="loginId" id="pwdLoginId" placeholder="아이디 입력">
		</div>
		<div class="mb-3">
			<label for="loginId">이름</label>
			<input type="text" class="form-control" name="mmbrNm" id="pwdMmbrNm" placeholder="이름 입력">
		</div>
		<div class="mb-3">
			<label for="loginId">이메일</label>
			<input type="text" class="form-control" name="mmbrEmail" id="pwdMmbrEmail" placeholder="이메일 입력">
		</div>
		<div id="tPwdText"></div>
		<br>
		<button class="btn btn-primary" type="button" id="btnFindPwdd">비밀번호 찾기</button>
		<button class="btn btn-secondary" style="padding-left: 25px;padding-right: 25px;" type="button" id="btnClosePwd">닫기</button>
	</form>
</div>
<script>
	$("#btnFindPwdd").click(function(){
		fn_findPwd();
	});

	$("#btnClosePwd").click(function(){
		fn_closePwd();
	});

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

	//비밀번호 찾기
	function fn_findPwd(){
		var pwdId = $('#pwdLoginId').val();
		var pwdName = $('#pwdMmbrNm').val();
		var pwdEmail = $('#pwdMmbrEmail').val();

		if( pwdId != '' && pwdId != null
			&& pwdName != '' && pwdName != null
			&& pwdEmail != '' && pwdEmail != null ) {// 입력칸 다 입력 했을 경우

			var formObj = $("#findPwdForm").serializeArray();

			$.ajax({
		        url:"findPwd.ajax",
		        type:'POST',
		        data: formObj,
		        dataType : "json",
		        beforeSend: function () {
					fn_LoadingBarStart();}, 	//로딩바 생성
				complete: function () {
					fn_LoadingBarEnd();}, 		//로딩바 제거
		        success:function(result){
		        	var html = "";

					if("fail"== result["msg"]){
						html += "존재하는 사용자 정보가 없습니다.";
						$("#tPwdText").html(html);

					}else if("success" == result["msg"]){
						html += "사용자 메일로 <br>임시 비밀번호를 전송하였습니다.";
						$("#tPwdText").html(html);
					}
				}
			});

		} else {// 입력칸에 공백 있을 경우
			alert("모든 항목을 입력해 주시기 바랍니다.");
		}
	}

	//비밀번호 찾기 창 닫기
	function fn_closePwd(){
		$("#pwdLoginId").val("");
		$("#pwdMmbrNm").val("");
		$("#pwdMmbrEmail").val("");
		$("#popupFindPwd").bPopup().close();
	}
</script>

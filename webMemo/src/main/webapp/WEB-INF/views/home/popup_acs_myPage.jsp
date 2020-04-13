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
</style>
<div id="popupAcsMyPage" class="pstyle">
	<input type="hidden" name="path" id="path">
	<div class="mb-3">
		<label for="mpPwd">회원 비밀번호 확인</label><br>
		<input type="password" name="mpPwd" id="mpPwd" placeholder="비밀번호 입력">
	</div>
	<button class="btn btn-primary btn-sm" type="button" id="btnCheck">확인</button>
	<button class="btn btn-secondary btn-sm" type="button" id="btnCloseMp">닫기</button>
</div>
<script>
	$("#btnCheck").click(function(){
		fn_checkPwd();
	});

	$("#btnCloseMp").click(function(){
		fn_closeMp();
	});

	function fn_checkPwd(){
		if($("#mpPwd").val().length < 1){
			alert("비밀번호를 입력해주세요.");

		}else{
			$.ajax({
				url: "/hyeri/home/access_myPage.ajax"
				,type: 'POST'
				,data: {"pwd" : $("#mpPwd").val() }
				,datatype:"json"
				,success:function(result){
					if( "success" == result["msg"] ) {
						if("mmbr"==$("#path").val()){ //회원정보 수정
							fn_closeMp();
							location.href="/hyeri/home/modify_mmbr.html";

						}else if("pwd"==$("#path").val()){//비밀번호 수정
							fn_closeMp();
							location.href="/hyeri/home/modify_pwd.html";

						}else if("email"==$("#path").val()){//이메일 수정
							fn_closeMp();
							location.href="/hyeri/home/modify_email.html";

						}else if("wthdrMmbr"==$("#path").val()){//회원 탈퇴
							fn_withdraw();
						}

					}else if("fail" == result["msg"]){
						alert("비밀번호가 일치하지 않습니다.");

					}else{
						alert("오류가 발생했습니다.");
					}
				}
			});
		}
	}

	//비밀번호 확인창 닫기
	function fn_closeMp(){
		$("#mpPwd").val(''); //내용 삭제
		$("#popupAcsMyPage").bPopup().close();
	}

	//회원 탈퇴
	function fn_withdraw(){
		if(confirm("회원탈퇴를 진행하시겠습니까?\n탈퇴 시 저장되어있는 메모는 모두 삭제됩니다.")){

			$.ajax({
				url: "/hyeri/home/withdraw_mmbr.ajax"
				,type: 'POST'
				,data: {"loginId" : '${sessionScope.loginId}'}
				,datatype:"json"
				,success:function(result){

					if( "success" == result["msg"] ) {
						alert("탈퇴 완료하였습니다.\n그동안 이용해 주셔서 감사합니다.");
						location.href="/hyeri/home/login.html";

					}else{
						alert("오류가 발생하였습니다.");
					}
				}
			});
		}
	}
</script>
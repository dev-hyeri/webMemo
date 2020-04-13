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
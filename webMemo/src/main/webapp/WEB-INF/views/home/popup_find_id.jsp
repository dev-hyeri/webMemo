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
<div id="popupFindId" class="pstyle">
	<form id="findIdForm">
		<div class="mb-3">
			<label for="mmbrNm">이름</label>
			<input type="text" class="form-control" name="mmbrNm" id="idMmbrNm" placeholder="이름 입력">
		</div>
		<div class="mb-3">
			<label for="mmbrNm">생년월일</label>
			<input type="text" class="form-control" name="mmbrBirth" id="idMmbrBirth" placeholder="숫자8자리 ex)20190312">
		</div>
		<div class="mb-3">
			<label for="mmbrNm">핸드폰번호</label>
			<input type="text" class="form-control" name="mmbrTel" id="idMmbrTel" placeholder="숫자만 ex)01099999999">
		</div>
		<div id="tIdText"></div>
		<br>
		<button class="btn btn-primary" type="button" id="btnFindIdd">아이디 찾기</button>
		<button class="btn btn-secondary" style="padding-left: 25px;padding-right: 25px;" type="button" id="btnCloseId">닫기</button>
	</form>
</div>
<script>
	$("#btnFindIdd").click(function(){
		fn_findId();
	});

	$("#btnCloseId").click(function(){
		fn_closeId();
	});

	//아이디 찾기
	function fn_findId(){
		var idNm = $('#idMmbrNm').val();
		var	idBirth = $('#idMmbrBirth').val();
		var idTel = $('#idMmbrTel').val();

		if( idNm != '' && idNm != null
			&& idBirth != '' && idBirth != null
			&& idTel != '' && idTel != null ) {// 입력칸 다 입력 했을 경우

			var formObj = $("#findIdForm").serializeArray();

			$.ajax({
		        url:"findId.ajax",
		        type:'POST',
		        data: formObj,
		        dataType : "json",
		        success:function(result){
					if("fail"== result["msg"]){
						var html =  "존재하는 아이디가 없습니다.";
						$('#tIdText').html(html);

					}else if("success" == result["msg"]){
						var idList = result.idList;
						var id = "";
						var idTemp = "";
						var html = "사용자ID :  ";

						$.each(idList, function(index, item){
							id = $(this).prop("loginId"); //idList 하나씩 id에 저장
							idTemp = id.substring(0,3); // 셋째자리까지만 노출

							for(var i=3; i < id.length; i++){ //나머지 자리는 *로 대체
								idTemp +="*";
							}
							html += idTemp;

							// 마지막 값이 아닌경우 '/'로 구분
							if(index != (idList.length-1)){
								html+= "   /   ";
							}
						});
						$('#tIdText').html(html);
					}
				}
			});

		} else { // 입력칸에 공백 있을 경우
			alert("모든 항목을 입력해 주시기 바랍니다.");
		}
	}

	//아이디 찾기 창 닫기
	function fn_closeId(){
		$("#idMmbrNm").val("");
		$("#idMmbrBirth").val("");
		$("#idMmbrTel").val("");
		$("#tIdText").val("");
		$("#popupFindId").bPopup().close();
	}

</script>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri= "http://java.sun.com/jsp/jstl/core" %>
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
<div id="popupMmbr" class="pstyle">
	<div>
		공유 ID
		<table class="table">
			<thead>
				<tr>
					<th>선택</th>
					<th>아이디</th>
					<th>이름</th>
				</tr>
			</thead>
			<tbody id="pTBodyMmbr">
				<c:forEach items="${otherMmbrList}" var="vo">
					<tr>
						<td>
							<div class="custom-control custom-checkbox">
								<input class="custom-control-input" type="checkbox" data-id="${vo.loginId}" id="p_${vo.loginId}">
								<label class="custom-control-label" for="p_${vo.loginId}"></label>
							</div>
						</td>
						<td>${vo.loginId}</td>
						<td>${vo.mmbrNm}</td>
					</tr>
				</c:forEach>
			</tbody>
		</table>
	</div>
	<button class="btn btn-primary btn-block" type="button" id="btnCnfrm">확인</button>
</div>
<script>
	var shrdIds = "";

	$("#btnCnfrm").click(function(){
		shrdIds = "";
		$("#pTBodyMmbr input:checkbox").each(function(){// 체크되어있는 아이디 저장
			if( $(this).is(":checked") ) {
				shrdIds += $(this).data("id") + ",";
			}
		});

		$("#shrdIds").val(shrdIds);		// 공유ID 세팅
		if(""!=$("#shrdIds").val()){ 		//공유 ID있는 경우 체크
			$("#chShrdYn").prop("checked",true);
		}else{								//공유 ID없는 경우 체크 해제
			$("#chShrdYn").prop("checked",false);
		}

		// 팝업 종료
		$("#popupMmbr").bPopup().close();
	});

</script>
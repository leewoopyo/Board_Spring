<%@page import="java.time.format.DateTimeFormatter"%>
<%@page import="java.time.LocalDate"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, javax.sql.*, java.io.*"%>
<%@ page import="kr.ac.Hotel.service.*,kr.ac.Hotel.dto.*"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@taglib uri="http://www.springframework.org/tags" prefix="spring"%> 
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/insertDB.css">
</head>
<body>

<%
//오늘 날짜를 포함해서 30일 동안의 날짜를 구할 필요가 있어서 JSP문으로 계산
LocalDate currentDate = LocalDate.now();		//localdate로 오늘 날짜를 구함
String today = currentDate.format(DateTimeFormatter.ofPattern("yyyy-MM-dd"));		//구한 오늘 날짜를 String형으로 변환
String onemonth_Later = currentDate.plusDays(29).format(DateTimeFormatter.ofPattern("yyyy-MM-dd")); 	//오늘로부터 29일뒤의 날짜를 구함
%>

<%-- <c:out value="${resv_date}"></c:out>
<c:out value="${room}"></c:out> --%>


<!-- 화면에 출력되는 부분 -->
<section style="width: 80%; margin: auto; margin-bottom: 100px;">
	<h2>예약 정보 입력</h2>
	<hr style="border-width: 2px; border-color: black;">
	<form id="post_param" name="post_param" method="post">
		<p>이름</p> 
		<div class="input_section">
			<input type="text" name="name" id="name" maxlength="8" onfocusout="check_name()"/><div class="validation" id="name_validation"></div><br>
		</div>
		
		<p>예약일자</p> 
		<div class="input_section">
			<input type="date" name="resv_date" id="resv_date" min="<%=today %>" max="<%=onemonth_Later %>" onfocusout="check_date()"/><div class="validation" id="date_validation"></div><br>  
		</div>
		
		<p>예약 방 선택</p>
		<div class="input_section">
			<div class="imagebox" id="deluxe">
				<div><img src='${pageContext.request.contextPath}/resources/images/deluxe.jpg'></div>
				<div class="radio_check"><input type="radio" name="room" value=1>Deluxe Room</div>
			</div>
			<div class="imagebox" id="suite">
				<div><img src='${pageContext.request.contextPath}/resources/images/suite.jpg'></div>
				<div class="radio_check"><input type="radio" name="room" value=2>Suite Room</div>
			</div>
			<div class="imagebox" id="royal">
				<div><img src='${pageContext.request.contextPath}/resources/images/royal.jpg'></div>
				<div class="radio_check"><input type="radio" name="room" value=3>Royal Room</div>
			</div>
		</div>
		
		<p>주소</p>
		<div class="input_section">
			<input type="text" id="postcode" name="postcode" placeholder="우편번호" readonly>
			<input type="button" id="find_addr" onclick="execDaumPostcode()" value="우편번호 찾기">
		</div>
		<div class="input_section" style="display: grid;">
			<input type="text" id="roadAddress" name="roadaddress" style="width: 600px;" placeholder="도로명주소" readonly>
			<input type="text" id="jibunAddress" name="jibunaddress" style="width: 600px;" placeholder="지번주소" readonly>
			<span id="guide" style="color:#999;display:none"></span>
			<input type="text" id="extraAddress" name="extraaddress" style="width: 600px;" placeholder="참고항목">
			<input type="text" id="detailAddress" name="detailaddress" style="width: 600px;" placeholder="상세주소">
		</div>
		<div class="validation" id="addr_validation"></div>
		<br>
		<input type="hidden" name="addr" id="addr">
		
		<p>전화번호</p> 
		<div class="input_section">
			<select name="telnum1" id="telnum1">
			    <option value="010">010</option>
			    <option value="011">011</option>
			    <option value="017">017</option>
			</select>
			<p style="font-size: 38px;">-</p><input type="number" name="telnum2" id="telnum2" maxLength="4" oninput="next_focus()">
			<p style="font-size: 38px;">-</p><input type="number" name="telnum3" id="telnum3" maxLength="4" oninput="next_focus()">
		</div>
		<div class="validation" id="telnum_validation"></div>
		<br>
		<input type="hidden" name="telnum" id="telnum">
		
		<p>입금자 명</p>
		<div class="input_section">
			<input type="text" name="in_name" id="in_name" maxlength="8" onfocusout="check_in_name()"><div class="validation" id="in_name_validation"></div><br>
		</div>
		
		<p>남기실 말</p>
		<div class="input_section">
			<textarea name="comment" id="comment" style=""></textarea><div class="validation" id="comment_validation"></div><br>
		</div>
		
		<input type="hidden" name="param_resv_date" id="param_resv_date"> 
		<input type="hidden" name="param_room" id="param_room"> 
		<input type="hidden" name="write_date" id="write_date" value="<%=today %>"> 
		<input type="hidden" name="processing" id="processing" value="1"> 
		<input type="button" value="수정하기" class ="submit_btn" id="update_btn" onclick="sendparam('u')">
		<input type="button" value="삭제하기" class ="submit_btn" id="delete_btn" onclick="sendparam('d')">
	</form>
</section>	
	
	
	
<script src="http://code.jquery.com/jquery-latest.min.js"></script>
<script src="https://t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
<script src="${pageContext.request.contextPath}/resources/js/insertDB.js"></script>

<script type="text/javascript">
//페이지 로드 시 각 태그에 맞는 값을 집어넣음
$( document ).ready(function() {
	//파라메터 받은 값을 기준으로 value값을 설정해서 넣음
	//각 태그를 가져옴
	let name = document.getElementById("name");	//이름 태그 
	let resv_date = document.getElementById("resv_date")	//예약일 태그 
	let room = document.getElementsByName("room");	//방 정보 태그 
	//주소 태그 --> 예약시 '/'를 기준으로 입력 했었음, 그래서  받은 다음에 /기준으로 나누고, 
	//해당 태그에 알맞게 값을 넣음
	let addrArray = '${resv_data.addr}'.split('/') ;	
	let postcode = document.getElementById("postcode");
	let roadAddress = document.getElementById("roadAddress");
	let jibunAddress = document.getElementById("jibunAddress");
	let extraAddress = document.getElementById("extraAddress");
	let detailAddress = document.getElementById("detailAddress");
	//전화번호 태그도 '-' 기준으로 값을 나누고 각 태그에 알맞게 값을 넣음
	let telnumArray = '${resv_data.telnum}'.split('-') ;
	let telnum1 = document.getElementById("telnum1");
	let telnum2 = document.getElementById("telnum2");
	let telnum3 = document.getElementById("telnum3");
	
	let in_name = document.getElementById("in_name");	//입금자명	
	let comment = document.getElementById("comment");	//코멘트

	let param_resv_date = document.getElementById("param_resv_date");	//수정전 예약일 
	let param_room = document.getElementById("param_room");		//수정 전 방 정보

	//이름 value값 넣기
	name.value = '${resv_data.name}';
	//날짜 value값 넣기 
	resv_date.value = '${resv_data.resv_date}'.substring(0,10);
	param_resv_date.value = '${resv_data.resv_date}'.substring(0,10);
	//room정보를 받고 radio버튼이 클릭 될 수 있게 함
	for(var i=0; i<room.length; i++) {
	    if(room[i].value == ${resv_data.room}) {
	    	room[i].checked = true;
	    }else{
		    console.log(room[i].value);
		    console.log(${resv_data.room});
		}
	}
	param_room.value = '${resv_data.room}';
	//주소 value값 가져오기-->split으로 나눈 값을 알맞게 넣음
	postcode.value = addrArray[0];
	roadAddress.value = addrArray[1];
	jibunAddress.value = addrArray[2];
	extraAddress.value = addrArray[3];
	detailAddress.value = addrArray[4];
	//전화번호 value값 가져오기 -->split으로 나눈 값을 알맞게 넣음
	telnum1.value = telnumArray[0];
	telnum2.value = telnumArray[1];
	telnum3.value = telnumArray[2];
	//입금자명 value값 가져오기 
	in_name.value = '${resv_data.in_name}'
	//남기실 말 안에 들어가는 글 가져오기
	comment.innerHTML = `${resv_data.comment}`;
});


</script>

</body>
</html>
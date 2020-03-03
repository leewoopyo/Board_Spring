<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
   <%@ page import ="java.sql.*, javax.sql.*, java.io.*" %>
   <%@ page import ="kr.ac.kopo.service.*, kr.ac.kopo.dto.*" %>
   <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
	
	<h3>전체 데이터</h3>
	<hr>
	<!-- 전체 리스트가 출력되는 테이블 생성   -->
	<table cellspacing=1 width=600 border=1>
		<tr>
			<td width=50><p align=center>이름</p></td>
			<td width=50><p align=center>학번</p></td>
			<td width=50><p align=center>국어</p></td>
			<td width=50><p align=center>영어</p></td>
			<td width=50><p align=center>수학</p></td>
		</tr>
		<!-- JSTL의 choose태그 로 조건문 실행 -->
		<!-- 만약 list가 비어있다면 -->
		<!-- 코드를 출력한다????? -->
		<!-- list를 출력한다.  -->
		<c:choose>
			<c:when test="${empty list}">
				<tr>
					<td colspan=3>
						<spring:message code="common.listEmpty"/>
					</td>
				</tr>
			</c:when>
			<c:otherwise>
					<tr>
						<td width=50><p align=center>${list.name}</p></td>
						<td width=50><p align=center>${list.studentid}</p></td>
						<td width=50><p align=center>${list.kor}</p></td>
						<td width=50><p align=center>${list.eng}</p></td>
						<td width=50><p align=center>${list.mat}</p></td>
					</tr>
			</c:otherwise>
		</c:choose>
	</table>

</body>
</html>
<!-- views/miniHome/main -->
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<html lang="ko" style="resizeable:no">
<head>
<meta charset="UTF-8">
<title>미니홈피</title>
<link rel="stylesheet" href="../../../../resources/css/minihome/fonts.css" />
<link rel="stylesheet" href="../../../../resources/css/minihome/frame.css" />
<link rel="stylesheet" href="../../../../resources/css/minihome/board.css" />
<link rel="stylesheet" href="../../../../resources/css/minihome/album.css" />
<link rel="stylesheet" href="../../../../resources/css/minihome/audio.css" />
<link rel="icon" href="../../../../resources/images/minihome/favicon.png" type="image/x-icon">
</head>
<body>
	<div class="main-frame">
		<div class="bookcover">
			<div class="bookdot">
				<div class="page">
					<div class="profile-container">
						<div class="header profile-title font-neo">
							TODAY&nbsp;<span class="today-span">${todayCnt }</span>&nbsp;| TOTAL ${totalCnt }
						</div>
						<div class="box profile-box">
							<div class="profile-image">
								<c:set var="imagePath" value="/resources/images/${image}" />
								<img class="profile-image-img" src="/../../../../resources/images/download/${image}" alt="프로필 이미지" />
							</div>
							<div class="profile-dot">---------------------------------</div>
							<div class="profile-text font-kyobohand">
								<c:out value="${msg}" escapeXml="false"/>
							</div>
							<div class="profile-history">
								<c:if test="${sessionScope.userId.userNickname eq userNickname }">
									<a 
									  class="profile-edit" 
									  onclick="openNewWindowMinihomeProfileEdit()">Edit
									</a>
								</c:if>
								<form action="/mnHome/miniroomHistoryView" method="POST" id="frmHistory" target="miniroomWindow">
		                        	<input type="hidden" name="targetNickname" id="targetNickname" value=${userNickname }>
		                        </form>
		                        <a
		                          class="profile-hs"
		                          onclick="openNewWindowMiniroomHistory()">History                        
		                        </a>
							</div>
							<div class="profile-dot">---------------------------------</div>
							<c:if test="${userGender eq 'M'}">
	                        	${userName }&#128102
							</c:if>
							<c:if test="${userGender eq 'F'}">
	                        	${userName }&#128103
							</c:if>
							<div class="profile-dropDown">
								<select id="friendSelect" onchange="redirectToMainView()">
		                           <option value="" disabled selected hidden="">파도타기</option>
								    <c:forEach var="friend" items="${friend}" varStatus="status">
								        <option value="${friend.Name}">${friend.Name}(${friend.userEmail})</option>
								    </c:forEach>
								</select>
							</div>
						</div>
					</div>
					<div class="content-container">
						<div class="header content-title">
							 <div id="divHomeTitle" class="content-title-name">${title }</div>
							 <input id="newTitle" class="content-title-name"  type="hidden" value="${title }">
							 <input id="hiddenUserNickname" type="hidden" value="${userNickname }">
							 <c:if test="${sessionScope.userId.userNickname eq userNickname }">
								<div>
									<input type="button" id="btn-title-edit" class="btn-edit" value="수정">
									<input type="hidden" id="btn-title-save"class="btn-edit" value="저장">
								</div>
							 </c:if>
							<div class="content-title-url">
								https://www.helloworld.com/minihome/${userNickname }</div>
						</div>
						<div class="box content-box">
						
						<div class="board-container">
							<table class="board-table">
								<thead>
									<tr>
										<th class="th-checkbox">
											<c:if test="${sessionScope.userId.userNickname eq userNickname }">
												<input type="checkbox" id="checkbox-all">
											</c:if>
										</th>
										<th class="th-title">제목</th>
										<th class="th-writer">작성자</th>
										<th class="th-view">조회수</th>
									</tr>
								</thead>							
								<tbody>
									<c:if test="${list eq null || list.size() <=0}">
										<td colspan="4" class="noneMsg">아직 게시물이 없습니다.</td>
									</c:if>
									<c:if test="${list ne null}">
										<c:forEach items="${list}" var="list" varStatus="i">
											<tr>
												<td class="td-checkbox"><input type="checkbox" class="boardCheck" name="boardDel" value="${list.seq}"></input></td>
												<td class="td-title" data-boarddetail="/mnHome/boardDetail/${list.userNickname}/${list.seq}">${list.title}
												<c:if test="${list.newcontent==1 }">
													<img src="../../../../resources/images/minihome/newIcon.png" class="newIcon">
												</c:if>
												</td>												
												<td class="td-writer"><a href="<c:url value="/mnHome/mainView/${list.userNickname }" />">${list.userNickname}</a></td>
												<td class="td-view">${list.hits}</td>
											</tr>
										</c:forEach>
									</c:if>
														
								</tbody>						
							</table>	
							<div class="board-btn">
								<c:if test="${sessionScope.userId.userNickname eq userNickname }">
									<!-- <input type="button" value="이동"> -->
									<input type="button" id="btnBoardDelete" value="삭제" data-boardDelete="<c:url value='/mnHome/boardDelete'/>">
									<input type="button" class="btnBoardWrite" value="등록" data-boardWrite="<c:url value='/mnHome/boardWriteView/${userNickname}'/>">
								</c:if>
							</div>	
							
							<!-- paging -->
					        <div class="board-pages">
					            <c:forEach var="page" begin="1" end="${totalPage}">
						             <span class="board-page" data-page="/mnHome/boardView/${userNickname }/${page}">
						                  | ${page}
						             </span>
					            </c:forEach>
					        </div>	
						</div>
							
						</div>
					</div>
					
					<div class="menu-container">
               
					<div class="menu-content" data-tab="<c:url value='/mnHome/mainView/${userNickname }'/>"
						style=" background-color: 
								<c:choose>
									<c:when test="${menuProductName == 'red' }">red</c:when>
									<c:when test="${menuProductName == 'yellow' }">yellow</c:when>
									<c:when test="${menuProductName == 'black' }">black</c:when>
									<c:when test="${menuProductName == 'blue' }">blue</c:when>
									<c:when test="${menuProductName == 'purple' }">purple</c:when>
									<c:when test="${menuProductName == 'white' }">white</c:when>
									<c:when test="${menuProductName == 'green' }">green</c:when>
									<c:when test="${menuProductName == 'lime' }">lime</c:when>
									<c:when test="${menuProductName == 'grey' }">grey</c:when>
									<c:when test="${menuProductName == 'navy' }">navy</c:when>
									<c:when test="${menuProductName == 'rgb(42, 140, 168)' }">rgb(42, 140, 168)</c:when>
								</c:choose>
					">
						<span class="menu-content-span"
						style=" color: 
								<c:choose>
									<c:when test="${menuProductName == 'red' }">lightgreen</c:when>
									<c:when test="${menuProductName == 'yellow' }">navy</c:when>
									<c:when test="${menuProductName == 'black' }">white</c:when>
									<c:when test="${menuProductName == 'blue' }">orange</c:when>
									<c:when test="${menuProductName == 'purple' }">lightgreen</c:when>
									<c:when test="${menuProductName == 'white' }">black</c:when>
									<c:when test="${menuProductName == 'green' }">red</c:when>
									<c:when test="${menuProductName == 'lime' }">pink</c:when>
									<c:when test="${menuProductName == 'grey' }">brown</c:when>
									<c:when test="${menuProductName == 'navy' }">yellow</c:when>
									<c:when test="${menuProductName == 'rgb(42, 140, 168)' }">white</c:when>
								</c:choose>
					">
						홈
					</span>
					</div>
					<div class="menu-content" data-tab="<c:url value='/mnHome/diaryView/${userNickname }'/>"
					style=" background-color: 
								<c:choose>
									<c:when test="${menuProductName == 'red' }">red</c:when>
									<c:when test="${menuProductName == 'yellow' }">yellow</c:when>
									<c:when test="${menuProductName == 'black' }">black</c:when>
									<c:when test="${menuProductName == 'blue' }">blue</c:when>
									<c:when test="${menuProductName == 'purple' }">purple</c:when>
									<c:when test="${menuProductName == 'white' }">white</c:when>
									<c:when test="${menuProductName == 'green' }">green</c:when>
									<c:when test="${menuProductName == 'lime' }">lime</c:when>
									<c:when test="${menuProductName == 'grey' }">grey</c:when>
									<c:when test="${menuProductName == 'navy' }">navy</c:when>
									<c:when test="${menuProductName == 'rgb(42, 140, 168)' }">rgb(42, 140, 168)</c:when>
								</c:choose>
					">
						<span class="menu-content-span"
						style=" color: 
								<c:choose>
									<c:when test="${menuProductName == 'red' }">lightgreen</c:when>
									<c:when test="${menuProductName == 'yellow' }">navy</c:when>
									<c:when test="${menuProductName == 'black' }">white</c:when>
									<c:when test="${menuProductName == 'blue' }">orange</c:when>
									<c:when test="${menuProductName == 'purple' }">lightgreen</c:when>
									<c:when test="${menuProductName == 'white' }">black</c:when>
									<c:when test="${menuProductName == 'green' }">red</c:when>
									<c:when test="${menuProductName == 'lime' }">pink</c:when>
									<c:when test="${menuProductName == 'grey' }">brown</c:when>
									<c:when test="${menuProductName == 'navy' }">yellow</c:when>
									<c:when test="${menuProductName == 'rgb(42, 140, 168)' }">white</c:when>
								</c:choose>
					">
						다이어리
					</span>
					</div>
					<div class="menu-content" data-tab="<c:url value='/mnHome/albumView/${userNickname }'/>"
					style=" background-color: 
								<c:choose>
									<c:when test="${menuProductName == 'red' }">red</c:when>
									<c:when test="${menuProductName == 'yellow' }">yellow</c:when>
									<c:when test="${menuProductName == 'black' }">black</c:when>
									<c:when test="${menuProductName == 'blue' }">blue</c:when>
									<c:when test="${menuProductName == 'purple' }">purple</c:when>
									<c:when test="${menuProductName == 'white' }">white</c:when>
									<c:when test="${menuProductName == 'green' }">green</c:when>
									<c:when test="${menuProductName == 'lime' }">lime</c:when>
									<c:when test="${menuProductName == 'grey' }">grey</c:when>
									<c:when test="${menuProductName == 'navy' }">navy</c:when>
									<c:when test="${menuProductName == 'rgb(42, 140, 168)' }">rgb(42, 140, 168)</c:when>
								</c:choose>
					">
						<span class="menu-content-span"
						style=" color: 
								<c:choose>
									<c:when test="${menuProductName == 'red' }">lightgreen</c:when>
									<c:when test="${menuProductName == 'yellow' }">navy</c:when>
									<c:when test="${menuProductName == 'black' }">white</c:when>
									<c:when test="${menuProductName == 'blue' }">orange</c:when>
									<c:when test="${menuProductName == 'purple' }">lightgreen</c:when>
									<c:when test="${menuProductName == 'white' }">black</c:when>
									<c:when test="${menuProductName == 'green' }">red</c:when>
									<c:when test="${menuProductName == 'lime' }">pink</c:when>
									<c:when test="${menuProductName == 'grey' }">brown</c:when>
									<c:when test="${menuProductName == 'navy' }">yellow</c:when>
									<c:when test="${menuProductName == 'rgb(42, 140, 168)' }">white</c:when>
								</c:choose>
					">
						사진첩
					</span>
					</div>
					<div id="tabBoard" class="menu-content" data-tab="<c:url value='/mnHome/boardView/${userNickname }'/>"
					style=" background-color: 
								<c:choose>
									<c:when test="${menuProductName == 'red' }">red</c:when>
									<c:when test="${menuProductName == 'yellow' }">yellow</c:when>
									<c:when test="${menuProductName == 'black' }">black</c:when>
									<c:when test="${menuProductName == 'blue' }">blue</c:when>
									<c:when test="${menuProductName == 'purple' }">purple</c:when>
									<c:when test="${menuProductName == 'white' }">white</c:when>
									<c:when test="${menuProductName == 'green' }">green</c:when>
									<c:when test="${menuProductName == 'lime' }">lime</c:when>
									<c:when test="${menuProductName == 'grey' }">grey</c:when>
									<c:when test="${menuProductName == 'navy' }">navy</c:when>
									<c:when test="${menuProductName == 'rgb(42, 140, 168)' }">rgb(42, 140, 168)</c:when>
								</c:choose>
					">
						<span class="menu-content-span"
						style=" color: 
								<c:choose>
									<c:when test="${menuProductName == 'red' }">lightgreen</c:when>
									<c:when test="${menuProductName == 'yellow' }">navy</c:when>
									<c:when test="${menuProductName == 'black' }">white</c:when>
									<c:when test="${menuProductName == 'blue' }">orange</c:when>
									<c:when test="${menuProductName == 'purple' }">lightgreen</c:when>
									<c:when test="${menuProductName == 'white' }">black</c:when>
									<c:when test="${menuProductName == 'green' }">red</c:when>
									<c:when test="${menuProductName == 'lime' }">pink</c:when>
									<c:when test="${menuProductName == 'grey' }">brown</c:when>
									<c:when test="${menuProductName == 'navy' }">yellow</c:when>
									<c:when test="${menuProductName == 'rgb(42, 140, 168)' }">white</c:when>
								</c:choose>
					">
						게시판
					</span>
					</div>
					<div class="menu-content" data-tab="<c:url value='/mnHome/visitView/${userNickname }'/>"
					style=" background-color: 
								<c:choose>
									<c:when test="${menuProductName == 'red' }">red</c:when>
									<c:when test="${menuProductName == 'yellow' }">yellow</c:when>
									<c:when test="${menuProductName == 'black' }">black</c:when>
									<c:when test="${menuProductName == 'blue' }">blue</c:when>
									<c:when test="${menuProductName == 'purple' }">purple</c:when>
									<c:when test="${menuProductName == 'white' }">white</c:when>
									<c:when test="${menuProductName == 'green' }">green</c:when>
									<c:when test="${menuProductName == 'lime' }">lime</c:when>
									<c:when test="${menuProductName == 'grey' }">grey</c:when>
									<c:when test="${menuProductName == 'navy' }">navy</c:when>
									<c:when test="${menuProductName == 'rgb(42, 140, 168)' }">rgb(42, 140, 168)</c:when>
								</c:choose>
					">
						<span class="menu-content-span"
						style=" color: 
								<c:choose>
									<c:when test="${menuProductName == 'red' }">lightgreen</c:when>
									<c:when test="${menuProductName == 'yellow' }">navy</c:when>
									<c:when test="${menuProductName == 'black' }">white</c:when>
									<c:when test="${menuProductName == 'blue' }">orange</c:when>
									<c:when test="${menuProductName == 'purple' }">lightgreen</c:when>
									<c:when test="${menuProductName == 'white' }">black</c:when>
									<c:when test="${menuProductName == 'green' }">red</c:when>
									<c:when test="${menuProductName == 'lime' }">pink</c:when>
									<c:when test="${menuProductName == 'grey' }">brown</c:when>
									<c:when test="${menuProductName == 'navy' }">yellow</c:when>
									<c:when test="${menuProductName == 'rgb(42, 140, 168)' }">white</c:when>
								</c:choose>
					">
						방명록
					</span>
					</div>
					<c:if test="${sessionScope.userId.userNickname eq userNickname }">
						<div class="menu-content" data-tab="<c:url value='/mnHome/settingView/${userNickname }'/>"
						style=" background-color: 
								<c:choose>
									<c:when test="${menuProductName == 'red' }">red</c:when>
									<c:when test="${menuProductName == 'yellow' }">yellow</c:when>
									<c:when test="${menuProductName == 'black' }">black</c:when>
									<c:when test="${menuProductName == 'blue' }">blue</c:when>
									<c:when test="${menuProductName == 'purple' }">purple</c:when>
									<c:when test="${menuProductName == 'white' }">white</c:when>
									<c:when test="${menuProductName == 'green' }">green</c:when>
									<c:when test="${menuProductName == 'lime' }">lime</c:when>
									<c:when test="${menuProductName == 'grey' }">grey</c:when>
									<c:when test="${menuProductName == 'navy' }">navy</c:when>
									<c:when test="${menuProductName == 'rgb(42, 140, 168)' }">rgb(42, 140, 168)</c:when>
								</c:choose>
					">
							<span class="menu-content-span"
							style=" color: 
								<c:choose>
									<c:when test="${menuProductName == 'red' }">lightgreen</c:when>
									<c:when test="${menuProductName == 'yellow' }">navy</c:when>
									<c:when test="${menuProductName == 'black' }">white</c:when>
									<c:when test="${menuProductName == 'blue' }">orange</c:when>
									<c:when test="${menuProductName == 'purple' }">lightgreen</c:when>
									<c:when test="${menuProductName == 'white' }">black</c:when>
									<c:when test="${menuProductName == 'green' }">red</c:when>
									<c:when test="${menuProductName == 'lime' }">pink</c:when>
									<c:when test="${menuProductName == 'grey' }">brown</c:when>
									<c:when test="${menuProductName == 'navy' }">yellow</c:when>
									<c:when test="${menuProductName == 'rgb(42, 140, 168)' }">white</c:when>
								</c:choose>
					">
						관리
					</span>
						</div>      
					</c:if>
                  
               </div>
					
				</div>
			</div>
		</div>
	</div>
</body>
</html>
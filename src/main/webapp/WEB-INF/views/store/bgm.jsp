<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>

<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>HelloWorld</title>
	<link href="/resources/css/index/main.css" rel="stylesheet">
	<link href="/resources/css/index/store.css" rel="stylesheet">
	<link href="/resources/css/index/bgm.css" rel="stylesheet">
	<link rel="icon" href="../../../../resources/images/minihome/favicon.png" type="image/x-icon">
</head>

<body>
	<div class="index-frame">
		<div class="divIndexMenu index-header">
	      <div class="index-header-left">
	         <a class="logoATag" href="<c:url value='/'/>">
	           <img class="index-header-logo" id="loginLogo" src="<c:url value="/resources/images/mainLogo.png"/>">
	         </a>
	       </div>
				<h5 id="userDotori" class="right">내 도토리 : <span id="userDotoriCnt">${sessionScope.userDotoriCnt}</span> 개</h5>
	       <div class="index-header-right">
	            <a href="<c:url value='/store/minimiView'/>" class="index-a-store">상점</a>
	            <a href="<c:url value='/notice/noticeView'/>" class="index-a-notice">공지사항</a>
	            <a href="<c:url value="/helloworld/minihome/main" />" class="index-a-mnh">내 미니홈피</a>
				<a href="<c:url value="/" />" class="index-a-logout">로그아웃</a>
	       </div>
      </div>

		<div id="divHiUser">
			<a class="storeAtag" href="/store/minimiView">미니미</a>
			<a class="storeAtag" href="/store/skinView">스킨</a>
			<a class="storeAtag" href="/store/menuView">메뉴</a>
			<a class="storeAtag" href="/store/dotoriView">도토리</a>
			<a class="storeAtag present" href="/store/bgmView">bgm</a>
		</div>
	
	
		<div class="bgm-frame">
		
			<div class="bgm-search-group">
				<input type="text" class="bgm-search-input" id="searchInput" onkeyup="search()"placeholder="제목 혹은 가수명을 입력하세요" maxlength="18" autofocus>
				<button class="bgm-search-btn" id="searchBtn"></button> <!-- 돋보기 아이콘 css 처리 -->
			</div>
			
			<div class="bgm-list-group bgm-grid">
				<div><input type="checkbox" id="selectAllCheckbox"></div>
				<div>순번</div>
				<div>제목</div>
				<div>아티스트</div>
				<div>재생시간</div>
				<div>금액</div>
			</div>
			
			<div id="test">
<%-- 			<c:forEach var="bgm" items="${bgmInfo}" varStatus="seq">
				<div class="bgm-list bgm-grid" id="ajaxTable bgm-list">
					<div><input type="checkbox" id="checkbox${i}></div>
					<div><c:out value="${seq.count }"/></div>
					<div><c:out value="${bgm.title }"/></div>
					<div><c:out value="${bgm.artist }"/></div>
					<div><c:out value="${bgm.runningTime }"/></div>
					<div><c:out value="${bgm.bgmPrice }"/></div>
				</div>
			</c:forEach> --%>
			</div>
			
			<div class="bgm-buy">
				<input type="button" value="구매" onclick="openNewWindowBgmBuy()">
			</div>
			
		</div>
	
	</div>
	<div class="bottom-fix">
		<hr>
		<h1>team core</h1>
	</div>
	
	<form id="frmSearch" action="<c:url value='/store/bgmView'/>" method="post">
		<input type="hidden" name="content" id="content">	
	</form>
	
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script>
function reloadParentWindow() {
    location.reload();
}

//검색 기능
function search(){
	$('#content').val($('#searchInput').val());
	$.ajax({
		method:"POST"
		,url: '<c:url value="/store/bgm/searchBgm"/>'
		,data: {content:$('#content').val()}		
	}).done(function( msg ){
		var resultHtml = '';
		if('success'==msg.result){
			if(msg.data.length>0){
            $.each(msg.data, function(i, item) {
            	resultHtml += '<div class="bgm-list bgm-grid" id="ajaxTable">';
                resultHtml += '<div><input type="checkbox" id="checkbox' + i + '"></div>';
                resultHtml += '<div>' + (i + 1) + '</div>';
                resultHtml += '<div>' + item.title + '</div>';
                resultHtml += '<div>' + item.artist + '</div>';
                resultHtml += '<div>' + item.runningTime + '</div>';
                resultHtml += '<div>' + item.bgmPrice + '</div>';
                resultHtml += '</div>';
                $('#test').html(resultHtml);
            });
            $(document).ready(function() {
                $('.bgm-list.bgm-grid').click(function() {
                    $(this).find('input[type="checkbox"]').prop('checked', function(i, checked) {
                        return !checked;
                    });
                });
            });
            $('#selectAllCheckbox').on('change', function () {
                var isChecked = $(this).prop('checked');
                for (var i = 0; i < msg.data.length; i++) {
                    $('#checkbox' + i).prop('checked', isChecked);
                }
                console.log("전체선택");
            });
		} else {
			 resultHtml += '<div>';
             resultHtml += '<div style="text-align:center;">검색 결과가 없습니다.</div>';
             resultHtml += '</div>';
		}
		$('#test').html(resultHtml);			
		}else if('fail'==msg.result){
			alert('에러');
		}
	});
}

$('#searchBtn').on('click',function(){
	search();	
});

$(document).ready(function() {
	search();
});
</script>
<script>
	var selected = [];
	
	function openNewWindowBgmBuy() {
		$('.bgm-list.bgm-grid').each(function() {
		    if ($(this).find('input[type="checkbox"]').prop('checked')) {
		      var title = $(this).find('div:eq(2)').text();
		      var artist = $(this).find('div:eq(3)').text();
		      var price = $(this).find('div:eq(5)').text();
		      
		      var selectedItem = {
		        title: title,
		        artist: artist,
		        price: price
		      };

		      selected.push(selectedItem);
		    }
		  });
		var windowSettings = 'width=800, height=600, scrollbars=no, resizable=no, toolbar=no, menubar=no, left=100, top=50';
		var selectedData = JSON.stringify(selected);
		window.open('/store/bgmBuy?selectedData=' + encodeURIComponent(selectedData), '_blank', windowSettings);
	}
</script>

</body>
</html>

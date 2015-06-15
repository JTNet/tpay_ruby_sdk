/**
 * client.tpay.webtx.js
 * 상점 제공 연동 함수
 * 
 * @version 1.0
 * 
 * @date 2012. 7. 23.
 * 
 * copyright(c) 2012 www.tpay.co.kr
 * 
 * @note
 * 2012.7.23 파일 생성
 * 2012.1.10 displayShow() 함수 추가
 */

/**
 * 결제창 띄우는 함수
 */
$(function() {
	$('.nyroModal').nyroModal({
		closeOnEscape: false,
		closeOnClick: false,
		showCloseButton: false
	});
});
/**
 * 결제창 종료 함수
 */
function payWinClose(){
	$.nmTop().close();
}
/**
 * 페이지 로드 종료 후 Display 위해 호출하는 함수
 */
function displayShow(){
	$(".nyroModalCont iframe").css('opacity', '1');
	$(".nyroModalCont iframe").css('filter', '(opacity=1)');
	$(".nyroModalCont iframe").css('-khtml-opacity', '1.0');
	$(".nyroModalCont iframe").css('-moz-opacity', '1.0');
}

function resultConfirm(tid, rslt){
	var resultConfirmIframe = $('<iframe name="resultConfirmIframe" style="display:none" />').appendTo('body');
	
	var form = document.createElement("form");
	form.setAttribute("method", "post");
	form.setAttribute("target", "resultConfirmIframe");
	form.setAttribute("action", "https://webtx.tpay.co.kr/resultConfirm");
	
	var tidE = document.createElement("input");
	tidE.setAttribute("type", "hidden");
	tidE.setAttribute("name", "tid");
	tidE.setAttribute("value", tid);
	form.appendChild(tidE);
	
	var rsltE = document.createElement("input");
	rsltE.setAttribute("type", "hidden");
	rsltE.setAttribute("name", "result");
	rsltE.setAttribute("value", rslt);
	form.appendChild(rsltE);
	
	document.body.appendChild(form);
	form.submit();
}

function submitParametersToNextPage(param, url){
	var form = document.createElement("form");
	form.setAttribute("method", "post");
	form.setAttribute("target", "_self");
	form.setAttribute("action", url);
	document.body.appendChild(form);
	
	$('<input type="hidden" name="payMethod" value="" />').attr("value", param.payMethod).appendTo(form);
	$('<input type="hidden" name="mid" value="" />').attr("value", param.mid).appendTo(form);
	$('<input type="hidden" name="tid" value="" />').attr("value", param.tid).appendTo(form);
	$('<input type="hidden" name="mallUserId" value="" />').attr("value", param.mallUserId).appendTo(form);
	$('<input type="hidden" name="buyerName" value="" />').attr("value", param.buyerName).appendTo(form);
	$('<input type="hidden" name="buyerTel" value="" />').attr("value", param.buyerTel).appendTo(form);
	$('<input type="hidden" name="buyerEmail" value="" />').attr("value", param.buyerEmail).appendTo(form);
	$('<input type="hidden" name="mallReserved" value="" />').attr("value", param.mallReserved).appendTo(form);
	$('<input type="hidden" name="goodsName" value="" />').attr("value", param.goodsName).appendTo(form);
	$('<input type="hidden" name="authDate" value="" />').attr("value", param.authDate).appendTo(form);
	$('<input type="hidden" name="authCode" value="" />').attr("value", param.authCode).appendTo(form);
	$('<input type="hidden" name="fnCd" value="" />').attr("value", param.fnCd).appendTo(form);
	$('<input type="hidden" name="fnName" value="" />').attr("value", param.fnName).appendTo(form);
	$('<input type="hidden" name="resultCd" value="" />').attr("value", param.resultCd).appendTo(form);
	$('<input type="hidden" name="resultMsg" value="" />').attr("value", param.resultMsg).appendTo(form);
	$('<input type="hidden" name="cardNo" value="" />').attr("value", param.cardNo).appendTo(form);
	$('<input type="hidden" name="cardQuota" value="" />').attr("value", param.cardQuota).appendTo(form);
	$('<input type="hidden" name="cardPoint" value="" />').attr("value", param.cardPoint).appendTo(form);
	$('<input type="hidden" name="usePoint" value="" />').attr("value", param.usePoint).appendTo(form);
	$('<input type="hidden" name="balancePoint" value="" />').attr("value", param.balancePoint).appendTo(form);
	$('<input type="hidden" name="vbankNum" value="" />').attr("value", param.vbankNum).appendTo(form);
	$('<input type="hidden" name="vbankExpDate" value="" />').attr("value", param.vbankExpDate).appendTo(form);
	$('<input type="hidden" name="cashReceipt" value="" />').attr("value", param.cashReceipt).appendTo(form);
	$('<input type="hidden" name="receiptTypeNo" value="" />').attr("value", param.receiptTypeNo).appendTo(form);
	$('<input type="hidden" name="receiptType" value="" />').attr("value", param.receiptType).appendTo(form);
	$('<input type="hidden" name="ediDate" value="" />').attr("value", param.ediDate).appendTo(form);
	$('<input type="hidden" name="amt" value="" />').attr("value", param.amt).appendTo(form);
	$('<input type="hidden" name="moid" value="" />').attr("value", param.moid).appendTo(form);
	
	form.submit();
}

function changeAmt(){
	frm = document.transMgr;
	frm.action = '';
	frm.target = "_self";
	$('#transMgr').removeClass("nyroModal");
	frm.submit();
}

var onmessage = function(e) {
	if(e.data.statusCl=='0'){
		displayShow();
	}else if(e.data.statusCl=='1'){
		payWinClose();
	}else if(e.data.statusCl=='2'){
		resultResponseIframe(e.data.trans);
	}
};

function resultResponseIframe(param){
	payWinClose();
	submitParametersToNextPage(param, resultUrl);
}

$(function() {
	if(window.addEventListener){
		window.addEventListener('message', onmessage, false);
	}else{
		window.attachEvent('onmessage', onmessage);
	}
	
	$('#submitBtn').click(function() {
		if($('input[name=transType]:checked').val()=='1' && $('#payMethod').val()!='CARD' && $('#payMethod').val()!='BANK' && $('#payMethod').val()!='VBANK' ){
			alert("에스크로에서 지원하지 않는 결제수단입니다.");
			return;
		}
		
		document.transMgr.acceptCharset = 'utf-8';
        if(document.all)document.charset = 'utf-8';

		$('#transMgr').submit();
	});
});
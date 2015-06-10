require 'socket'
require 'tpay_encryptor'

class TpayController < ApplicationController
  def checkout

	#$mid = "tpaytest0m";	//상점id
	# $merchantKey = "VXFVMIZGqUJx29I/k52vMM8XG4hizkNfiapAkHHFxq0RwFzPit55D3J3sAeFSrLuOnLNVCIsXXkcBfYK1wv8kQ==";	//상점키
	# $amt = "1004";	 //결제금액
	# $moid = "toid1234567890";

	# //$ediDate, $mid, $merchantKey, $amt    
	# $encryptor = new Encryptor($merchantKey);

	# $encryptData = $encryptor->encData($amt.$mid.$moid);
	# $ediDate = $encryptor->getEdiDate();	
	# $vbankExpDate = $encryptor->getVBankExpDate();	

	# $payActionUrl = "http://webtx.tpay.co.kr";
	# $payLocalUrl = "http://kimbob79.godohosting.com";

	@mid = "tpaytest0m"	##상점id
	@merchantKey = "VXFVMIZGqUJx29I/k52vMM8XG4hizkNfiapAkHHFxq0RwFzPit55D3J3sAeFSrLuOnLNVCIsXXkcBfYK1wv8kQ==" #상점키
	@amt = "1004"	 ##결제금액
	@moid = "toid1234567890"

	#$ediDate, $mid, $merchantKey, $amt    
	#$encryptor = new Encryptor($merchantKey);
	# $encryptData = $encryptor->encData($amt.$mid.$moid);
	# $ediDate = $encryptor->getEdiDate();	
	# $vbankExpDate = $encryptor->getVBankExpDate();	

	@encryptor = TpayEncryptor.new(@merchantKey, nil )
	# puts "====================="
	# puts @encryptor.key
	# puts "====================="
	# puts @encryptor.iv

	@encryptData = @encryptor.encData(@amt + @mid + @moid)
	@ediDate = @encryptor.ediDate
	@vbankExpDate = @encryptor.getVBankExpDate

	@payActionUrl = "http://webtx.tpay.co.kr"
	#@payLocalUrl = "http://kimbob79.godohosting.com";
	@payLocalUrl = "http://127.0.0.1:3000"

	
	ip=Socket.ip_address_list.detect{|intf| intf.ipv4_private?}
	@shop_ip = ip.ip_address if ip


	# #decrypt test
	# return_ediDate = "20150610155438"
	# return_amt = "iDhwcBIJvm09VcnnrLR1eQ=="
	# return_moid = "KR03vYhH+H0NEfVvsQ9YPg=="

	# decryptor = TpayEncryptor.new(@merchantKey, return_ediDate )

	# amtDb = "1004"
	# moidDb = "toid1234567890"
	# decAmt = decryptor.decData(return_amt)
	# decMoid = decryptor.decData(return_moid)
	# puts "====DECRYPTOR============"
	# puts "Amount : " + decAmt + "         Moid : " + decMoid

	render :layout => false
  end

  def result
  	amt_from_db = "1004"
  	moid_from_db = "toid1234567890"
  	merchantKey = "VXFVMIZGqUJx29I/k52vMM8XG4hizkNfiapAkHHFxq0RwFzPit55D3J3sAeFSrLuOnLNVCIsXXkcBfYK1wv8kQ==" #상점키

  	ediDate = params[:ediDate]
  	encrypted_amt = params[:amt]
  	encrypted_moid = params[:moid]
  	tid = params[:tid]

  	@result_code = params[:resultCd]
  	@buyer_name = params[:buyerName]
	@buyer_tel = params[:buyerTel]
	@buyer_email = params[:buyerEmail]
	@product_name = params[:goodsName]
	@fn_name = params[:fnName]
	@results_msg = params[:resultMsg]
	@authDate = params[:authDate]


  	decryptor = TpayEncryptor.new(merchantKey, ediDate )
  	@decrypted_amt = decryptor.decData(encrypted_amt)
	@decrypted_moid = decryptor.decData(encrypted_moid)

	if @decrypted_amt == amt_from_db and @decrypted_moid == moid_from_db
		#Send success results
		@is_success_integrity_check = true

	else
		@is_success_integrity_check = false
	end

	# Return params
	 #  	{"payMethod"=>"CARD",
	 # "mid"=>"tpaytest0m",
	 # "tid"=>"tpaytest0m01011506101553209040",
	 # "mallUserId"=>"tpay_id",
	 # "buyerName"=>"t_구매자명",
	 # "buyerTel"=>"0212345678",
	 # "buyerEmail"=>"aaa@bbb.com",
	 # "mallReserved"=>"MallReserved",
	 # "goodsName"=>"t_상품명",
	 # "authDate"=>"150610155655",
	 # "authCode"=>"",
	 # "fnCd"=>"02",
	 # "fnName"=>"KB국민",
	 # "resultCd"=>"3021",
	 # "resultMsg"=>"유효기간 오류",
	 # "cardNo"=>"9999999999999999",
	 # "cardQuota"=>"00",
	 # "cardPoint"=>"",
	 # "usePoint"=>"000000000",
	 # "balancePoint"=>"000000000",
	 # "vbankNum"=>"",
	 # "vbankExpDate"=>"20150611",
	 # "cashReceipt"=>"",
	 # "receiptTypeNo"=>"",
	 # "receiptType"=>"",
	 # "ediDate"=>"20150610155438",
	 # "amt"=>"iDhwcBIJvm09VcnnrLR1eQ==",
	 # "moid"=>"KR03vYhH+H0NEfVvsQ9YPg=="}
	 render :layout => false
  end

  def cancel
  	@mid = "tpaytest0m"	##상점id
	@merchantKey = "VXFVMIZGqUJx29I/k52vMM8XG4hizkNfiapAkHHFxq0RwFzPit55D3J3sAeFSrLuOnLNVCIsXXkcBfYK1wv8kQ==" #상점키
	@payActionUrl = "http://webtx.tpay.co.kr"
	@payLocalUrl = "http://127.0.0.1:3000"
		ip=Socket.ip_address_list.detect{|intf| intf.ipv4_private?}
	@shop_ip = ip.ip_address if ip

	@cancel_amt = "1004"	 ##결제금액
	@moid = "toid1234567890"
	@encryptor = TpayEncryptor.new(@merchantKey, nil )
	@encryptData = @encryptor.encData(@cancel_amt + @mid + @moid)
	@ediDate = @encryptor.ediDate

  	render :layout => false
  end

  def cancel_result
  	render :layout => false
  end

end

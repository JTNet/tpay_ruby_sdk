require 'socket'
require 'tpay_encryptor'
require "net/http"

class TpayController < ApplicationController
  def checkout

	@mid = Rails.configuration.x.tpay.mid
	@payActionUrl = Rails.configuration.x.tpay.pay_url
	@payLocalUrl = Rails.configuration.x.tpay.local_url
	encryptor = TpayEncryptor.new(Rails.application.secrets.merchant_key, nil )	

	# 주문별로 다름
	@amt = "1004"	 ##결제금액
	@moid = "toid1234567890" ##상점이 주문 구분을 위해 사용하는 주문ID
	@encryptData = encryptor.encData(@amt + @mid + @moid)
	@ediDate = encryptor.ediDate
	@vbankExpDate = encryptor.getVBankExpDate

	ip=Socket.ip_address_list.detect{|intf| intf.ipv4_private?}
	@shop_ip = ip.ip_address if ip

	render :layout => false
  end

  def result
  	amt_from_db = "1004"
  	moid_from_db = "toid1234567890"

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


  	decryptor = TpayEncryptor.new(Rails.application.secrets.merchant_key, ediDate )
  	@decrypted_amt = decryptor.decData(encrypted_amt)
	@decrypted_moid = decryptor.decData(encrypted_moid)

	if @decrypted_amt == amt_from_db and @decrypted_moid == moid_from_db

		@is_success_integrity_check = true

		uri = URI.parse("https://webtx.tpay.co.kr/resultConfirm")
		req = Net::HTTP::Post.new(uri.path)
		req.set_form_data("tid"=>tid,"result"=>"000")
		Net::HTTP.start(uri.host, uri.port, :usl_ssl=>true) do |http|
			response = http.request(req)
		end
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
  	@mid = Rails.configuration.x.tpay.mid	##상점id
	@payActionUrl = Rails.configuration.x.tpay.pay_url
	@payLocalUrl = Rails.configuration.x.tpay.local_url
	
	ip=Socket.ip_address_list.detect{|intf| intf.ipv4_private?}
	@shop_ip = ip.ip_address if ip

	@cancel_amt = "1004"	 ##결제금액
	@moid = "toid1234567890"
	encryptor = TpayEncryptor.new(Rails.application.secrets.merchant_key, nil )
	@encryptData = encryptor.encData(@cancel_amt + @mid + @moid)
	@ediDate = encryptor.ediDate

  	render :layout => false
  end

  def cancel_result
  	@mid = Rails.configuration.x.tpay.mid	##상점id

	amt_from_db = "1004"
  	moid_from_db = "toid1234567890"

  	encrypted_moid = params[:moid]
  	encrypted_amt = params[:cancelAmt]

  	@pay_method = params[:payMethod]
  	ediDate = params[:ediDate]
  	@cancel_date = params[:cancelDate]
  	@result_msg = params[:resultMsg]
  	@result_code = params[:resultCd]


  	decryptor = TpayEncryptor.new(Rails.application.secrets.merchant_key, ediDate )
  	@decrypted_amt = decryptor.decData(encrypted_amt)
	@decrypted_moid = decryptor.decData(encrypted_moid)

	if @decrypted_amt == amt_from_db and @decrypted_moid == moid_from_db

		@is_success_integrity_check = true
	else
		@is_success_integrity_check = false
	end

	# Return Parameter
	# $payMethod = $_POST['payMethod'];
	# $ediDate = $_POST['ediDate'];
	# $returnUrl = $_POST['returnUrl'];
	# $resultMsg = $_POST['resultMsg'];
	# $cancelDate = $_POST['cancelDate'];
	# $cancelTime = $_POST['cancelTime'];
	# $resultCd = $_POST['resultCd'];
	# $cancelNum = $_POST['cancelNum'];
	# $cancelAmt = $_POST['cancelAmt'];
	# $moid = $_POST['moid'];

  	render :layout => false
  end

end

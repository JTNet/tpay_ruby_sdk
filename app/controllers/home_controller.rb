require 'socket'
require 'tpay_encryptor'

class HomeController < ApplicationController
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

	@encryptor = TpayEncryptor.new( @merchantKey, nil )
	# puts "====================="
	# puts @encryptor.key
	# puts "====================="
	# puts @encryptor.iv

	@encryptData = @encryptor.encData(@amt + @mid + @moid)
	@ediDate = @encryptor.ediDate
	@vbankExpDate = @encryptor.getVBankExpDate

	@payActionUrl = "http://webtx.tpay.co.kr";
	#@payLocalUrl = "http://kimbob79.godohosting.com";
	@payLocalUrl = "http://127.0.0.1:3000";

	
	ip=Socket.ip_address_list.detect{|intf| intf.ipv4_private?}
	@shop_ip = ip.ip_address if ip

	render :layout => false
  end

  def results
  end

end

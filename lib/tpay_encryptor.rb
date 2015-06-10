require 'digest'
require 'openssl'

class TpayEncryptor
	@encKey = nil
	@merchantKey = nil
	@ediDate = nil
	@key = nil
	@iv = nil

	def initialize(key, ediDate)
	#def initialize(key)

		# @merchantKey = params[:key]
		# if params[:ediDate].present?
		# 	@ediDate = ediDate	
		# else
		# 	@ediDate = Time.now.strftime("%Y%m%d%H%M%S")
		# end
		if ediDate 
			@ediDate = ediDate
		else
			@ediDate = Time.now.strftime("%Y%m%d%H%M%S")
		end

		
		
		@merchantKey = key
		
		
		@encKey = Digest::MD5.hexdigest(@ediDate + @merchantKey)

		@key = hex2bin(@encKey)
		@iv = hex2bin(strToHex(@merchantKey[0..15]))

	end


	def merchantKey
		@merchantKey
	end

	def ediDate
		@ediDate
	end

	def encKey
		@encKey
	end

	def key
		@key
	end

	def iv
		@iv
	end


	def encData(input)
		encrypt(@key, @iv, input)
	end

	def encrypt(key, iv, value)
		#php code
		# if ( is_null ($value) ){
		# 			$value = "" ;
		# 	}
		return "" if value.blank?

		cipher = OpenSSL::Cipher::Cipher.new('aes-128-cbc')
		cipher.encrypt
		# cipher.key = Base64.decode64(key)
		# cipher.iv = Base64.decode64(iv)
		cipher.key = key
		cipher.iv = iv
		encrypted_data = cipher.update(value)
		encrypted_data << cipher.final
		crypt64 = [encrypted_data].pack("m").strip

		# $value = $this->toPkcs7 ($value) ;

		# $output = mcrypt_encrypt (MCRYPT_RIJNDAEL_128, $key, $value, MCRYPT_MODE_CBC, $iv) ;
		# return base64_encode ($output) ;
	end

	def decData(input)
		decrypt(@key, @iv, input)
	end

	def decrypt(key, iv, value)
		cipher = OpenSSL::Cipher::Cipher.new('aes-128-cbc')
		cipher.decrypt
		cipher.key = key
		cipher.iv = iv
		decrypted_data = cipher.update(Base64.decode64(value))
		decrypted_data << cipher.final

		# puts "============="
		# puts decrypted_data
		# puts "============="

		return decrypted_data

	end



	def hex2bin(hexdata)
		
		if hexdata and hexdata.size >= 2
			#hexdata.gsub(/../) { |pair| pair.hex.chr }
			[hexdata].pack('H*')
		else
			""
		end
		# $bindata="";
		# 	for ($i=0;$i<strlen($hexdata);$i+=2) {
		# 			$bindata.=chr(hexdec(substr($hexdata,$i,2)));
		# 	}
		# return $bindata;
	end

	def strToHex(input_string)
		
		if input_string
			#input_string.to_i.to_s(16)
			input_string.unpack('H*')[0]
		else
			""
		end
		# php
		# $hex='';
		# for ($i=0; $i < strlen($string); $i++){
		# 	$hex .= dechex(ord($string[$i]));
		# }
		# return $hex;
	end

	def getVBankExpDate
		(Time.now + 1.day).strftime("%Y%m%d")
	end


end
require 'digest'

class TpayEncryptor
	@encKey = nil
	@merchantKey = nil
	@ediDate = nil
	@key = nil
	@iv = nil

	def initialize(params = {})

		@merchantKey = params[:key]
		if params[:ediDate].present?
			@ediDate = ediDate	
		else
			@ediDate = Time.now.strftime("%Y%m%d%H%M%S")
		end
		
		@encKey = Digest::MD5.hexdigest(@ediDate + $merchantKey)

		@key = this.hex2bin(@encKey)
		@iv = this.hex2bin(this.strToHex(@merchantKey[0..16])

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
		this.encrypt(@key, @iv, input)
	end

	def encrypt(key, iv, value)
		#php code
		# if ( is_null ($value) ){
		# 			$value = "" ;
		# 	}

		# $value = $this->toPkcs7 ($value) ;

		# $output = mcrypt_encrypt (MCRYPT_RIJNDAEL_128, $key, $value, MCRYPT_MODE_CBC, $iv) ;
		# return base64_encode ($output) ;
	end



	def hex2bin(hexdata)
		bindata = ""

		# $bindata="";
		# 	for ($i=0;$i<strlen($hexdata);$i+=2) {
		# 			$bindata.=chr(hexdec(substr($hexdata,$i,2)));
		# 	}
		# return $bindata;
	end

	def strToHex(input_string)
		output_hex = ""
		# php
		# $hex='';
		# for ($i=0; $i < strlen($string); $i++){
		# 	$hex .= dechex(ord($string[$i]));
		# }
		# return $hex;
	end


end
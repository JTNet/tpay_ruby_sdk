require 'digest'
require 'openssl'

class TpayEncryptor
	@encKey = nil
	@merchantKey = nil
	@ediDate = nil
	@key = nil
	@iv = nil

	def initialize(key, ediDate)

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
		return "" if value.blank?

		cipher = OpenSSL::Cipher::Cipher.new('aes-128-cbc')
		cipher.encrypt
		cipher.key = key
		cipher.iv = iv
		encrypted_data = cipher.update(value)
		encrypted_data << cipher.final
		crypt64 = [encrypted_data].pack("m").strip
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
		return decrypted_data

	end



	def hex2bin(hexdata)		
		if hexdata and hexdata.size >= 2
			[hexdata].pack('H*')
		else
			""
		end
	end

	def strToHex(input_string)
		
		if input_string
			input_string.unpack('H*')[0]
		else
			""
		end
	end

	def getVBankExpDate
		(Time.now + 1.day).strftime("%Y%m%d")
	end


end
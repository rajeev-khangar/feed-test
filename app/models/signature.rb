require 'openssl'
require 'base64'

class Signature
  
  def Signature.generate_sig(endpoint, params, secret)
    sig = endpoint
    params.sort.map do |key, val|
      sig += '|%s=%s' % [key, val]
    end
    digest = OpenSSL::Digest::Digest.new('sha256')
    return OpenSSL::HMAC.hexdigest(digest, secret, sig)
  end
 
end

#endpoint = '/media/657988443280050001_25025320'
#params = {
#  'access_token' => 'fb2e77d.47a0479900504cb3ab4a1f626d174d2d',
#  'count' => 10,
#}


#sig = generate_sig(endpoint, params, secret)
#print sig    
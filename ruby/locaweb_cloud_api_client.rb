require "base64"
require "digest"
require "restclient"

class LocawebCloudAPIClient

  def initialize(login, chave_secreta)
    @login = login
    @chave_secreta = chave_secreta
    @url_api = "https://cloud.locaweb.com.br/api"
  end

  def listar_servidores
    RestClient.get("#{@url_api}/instances", generate_signature(0))
  end

  def detalhar_servidor(id)
    RestClient.get("#{@url_api}/instances/#{id}", generate_signature(0))
  end

  def reiniciar_servidor(id)
    RestClient.post("#{@url_api}/instances/#{id}/reboot", generate_signature(0))
  end


  private
  def generate_signature(content_length)
    timestamp = Time.now.strftime("%Y%m%d%H%M%S")
    hash = Base64.encode64(Digest::SHA1.hexdigest("#{@login}#{content_length}#{timestamp}#{@chave_secreta}")).strip
    return { "Api-Signature" => "#{@login}:#{timestamp}:#{hash}" }
  end
end

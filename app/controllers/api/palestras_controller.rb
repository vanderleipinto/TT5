
class Api::PalestrasController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:organize_conference]
  include Api::PalestrasHelper

  def organize_conference
    file = params[:file]
    if file.present?
      data = file.read.force_encoding('UTF-8')
      
      # Transforma os dados recebidos em um array.
      lista = data.split("\n").map(&:chomp) 
      
      @palestras = transform(lista)

      puts @palestras 
            
      flash[:success] = "Dados importados com sucesso."
    else
      flash[:error] = "Por favor, selecione um arquivo para importar."
    end

    
    render json: @palestras
  end
end

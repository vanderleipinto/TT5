module PalestrasHelper

  def transform (list)
    # Transforma os itens do array em hash e insere em @palestras (CRIAR LISTA DE PALESTRAS)
    palestras = criar_lista_palestras(list)
    shifts = shifts_180(palestras)
    
    #Retorna uma array de tracks. Cada track tem uma array de palestras
    distribuir_excedente(shifts)

    p "--"*80
    puts shifts
    p "--"*80
    
    organizadas = organiza_tracks(shifts)
    p "*"*80
    puts organizadas
    p "*"*80
    organizadas
  end
  
  def criar_lista_palestras(list)
    list.map do |row|
      time = row.slice!(/\d+/).to_i
      name = (time == 0) ? row : row[0..-5]
      {name: name, duration: ((time == 0) ? 5 : time)}
    end
  end


  def shifts_180(pals)  # percorre array populando resposta com tracks de 180 min
    resposta = []
    loop do
      resposta << comb(pals)
      break if pals.sum { |palestra| palestra[:duration] } < 180
    end
    resposta << pals if pals
    resposta
  end

  
  def comb(palestras) # retornar a combinação cujo resultado da soma 180
    palestras.each_with_index do |value, index|
      palestras.combination(index + 1) do |comb|
        if comb.sum { |palestra| palestra[:duration] } == 180
          retira(palestras, comb)
          return comb
        end
      end
    end
  end
  
  def retira(palestras, combination) # retira da array a combinação passada por parâmetro
    combination.each do |item|
      palestras.delete_at(palestras.index(item)) if palestras.index(item)
    end
  end
  
  def distribuir_excedente(tracks)
    return if tracks.last.sum { |palestra| palestra[:duration] } >= 180 || tracks.length.even? # Verifica se a última sublista é maior ou igual a 180 ou se a quantidade de sublistas é par
  
    excedente = tracks.pop # Retira a última sublista
  
    tracks.each_with_index do |track, index|
      next if index.even? || track.sum { |palestra| palestra[:duration] } == 240 # Pula sublistas de índice par ou sublistas cuja soma já é igual a 240
  
      # Itera manualmente pelos elementos do excedente e adiciona apenas aqueles que não ultrapassam o limite de 240
      excedente_restante = []
      excedente.each do |elem|
        p excedente.each { |palestra| print "Excedente -> #{palestra[:duration]}," }
        if track.sum { |palestra| palestra[:duration] } + elem[:duration] <= 240
          track << elem
        else
          excedente_restante << elem
        end
        puts "\n"
      end
  
      # Atualiza o excedente com os elementos que não foram adicionados à sublista atual
      excedente = excedente_restante
    end
  end

  def organiza_tracks(tracks)
    tracks_organizadas = {}
    turno = "Track A"
    tracks.each_with_index do |row, index|
      if index.even?
        tracks[index] << {name: "almoco", duration: 60}
        tracks_organizadas[turno.to_sym] = tracks[index] + tracks[index + 1] << {name: "NetWorking Event", duration: 1}
        turno.succ!
      end
    end
    tracks_organizadas
  end

  def format_time(minutes)
    hours = minutes.to_f / 60
    minutes = minutes.to_i % 60
    format("%02d:%02d", hours.to_i, minutes.to_i)
  end



end

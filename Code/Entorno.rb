# encoding: UTF-8
module Entorno
  module_function

  VERSION = "3.3.8"

  @mapa = [
    [".", "X", ".", ".", "P"],
    [".", "X", ".", "X", "."],
    [".", ".", "A", ".", "."],
    ["P", "X", ".", "X", "."],
    [".", ".", ".", ".", "P"],
  ]

  @estado = {
    fila: 0,
    columna: 0,
    puntuacion: 0, # --- MEDIDA DE RENDIMIENTO: Puntos base de la simulación ---
    acciones: 0,   # --- MEDIDA DE RENDIMIENTO: Conteo de turnos gastados ---
    paquetes_totales: 3,
    penalizaciones: 0, # --- MEDIDA DE RENDIMIENTO: Registro de castigos por choques ---
  }

  def buscar_posicion_inicial
    @mapa.each_with_index do |fila, f_idx|
      fila.each_with_index do |celda, c_idx|
        if celda == "A"
          @estado[:fila] = f_idx
          @estado[:columna] = c_idx
          @mapa[f_idx][c_idx] = "."
          return [f_idx, c_idx]
        end
      end
    end
    [0, 0]
  end

  def limpiar_consola
    system(Gem.win_platform? ? "cls" : "clear")
  end

  def configurar_inicio(fila, columna)
    @estado[:fila] = fila
    @estado[:columna] = columna
  end

  def mapa_valido?(fila, columna)
    fila >= 0 && fila < @mapa.length && columna >= 0 && columna < @mapa[fila].length
  end

  # --- PERCEPCIONES: El entorno le arma el "chisme" al agente de cómo está el mundo ---
  def obtener_percepcion
    {
      mapa: @mapa,
      fila: @estado[:fila],
      columna: @estado[:columna],
      puntuacion: @estado[:puntuacion],
      acciones: @estado[:acciones],
    }
  end

  # --- ACCIONES Y MEDIDA DE RENDIMIENTO: Aquí se aplican los castigos, premios y el movimiento físico ---
  def aplicar_accion(mov_fila, mov_columna)
    @estado[:acciones] += 1 # --- MEDIDA DE RENDIMIENTO: Cada paso cuenta como acción ---

    if @estado[:acciones] > 50
      puts "\n Límite de 50 acciones alcanzado. Fin de la simulación."
      puts "Puntuación final: #{@estado[:puntuacion]}" # --- MEDIDA DE RENDIMIENTO ---
      puts "Paquetes restantes: #{@estado[:paquetes_totales]}"
      puts "Penalizaciones: #{@estado[:penalizaciones]}" # --- MEDIDA DE RENDIMIENTO ---

      exit
    end

    nueva_fila = @estado[:fila] + mov_fila
    nueva_columna = @estado[:columna] + mov_columna

    # --- DECISIONES / ACCIÓN DE RECOGER: Si decide quedarse y hay paquete, se cobra ---
    if mov_fila == 0 && mov_columna == 0 && @mapa[@estado[:fila]][@estado[:columna]] == "P"
      @mapa[@estado[:fila]][@estado[:columna]] = "."
      @estado[:puntuacion] += 10 # --- MEDIDA DE RENDIMIENTO: +10 por paquete ---
      @estado[:paquetes_totales] -= 1
      puts "¡Has recogido un paquete! (+10 puntos)"

      if @estado[:paquetes_totales] <= 0
        @estado[:puntuacion] += 20 # --- MEDIDA DE RENDIMIENTO: +20 por terminar todo ---
        puts "\n ¡Objetivo cumplido! Todos los paquetes recogidos (+20 bonificación)."
        puts "Puntuación final: #{@estado[:puntuacion]}" # --- MEDIDA DE RENDIMIENTO ---
        exit
      end
      return
    end

    # --- ACCIONES: Moverse si el caminito está libre, o castigar si choca ---
    if mapa_valido?(nueva_fila, nueva_columna) && @mapa[nueva_fila][nueva_columna] != "X"
      @estado[:fila] = nueva_fila
      @estado[:columna] = nueva_columna
      @estado[:puntuacion] -= 1 # --- MEDIDA DE RENDIMIENTO: -1 por cada paso normal ---
    else
      @estado[:penalizaciones] += 1 # --- MEDIDA DE RENDIMIENTO: Suma una falta ---
      puts "¡Atrapado o movimiento inválido! Penalización (-5 puntos)"
      @estado[:puntuacion] -= 5 # --- MEDIDA DE RENDIMIENTO: -5 por chocar con pared o X ---
    end
  end
end

# P = Paquete
# X = Obstaculo
# . = Camino libre

# ARRIBA     → fila - 1
# ABAJO      → fila + 1
# IZQUIERDA  → columna - 1
# DERECHA    → columna + 1
# Consultar elemento en posicion: entorno[1][0]

# carrito[:posicion][0] = 0,0
#puts "elemento actual: #{entorno[1][0]}"
#puts "elemento actual: #{carrito[:posicion][0]}"

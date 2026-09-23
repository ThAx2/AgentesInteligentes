# encoding: UTF-8
require_relative "entorno"

module Agente
  module_function

  def pensar(percepcion)
    # --- PERCEPCIONES: El agente recibe los datos de dónde está y qué hay alrededor ---
    mapa = percepcion[:mapa]
    f = percepcion[:fila]
    c = percepcion[:columna]

    puts "--- Percepción del Agente ---"
    puts "Posición actual: [#{f}, #{c}]"
    puts "Celda actual: #{mapa[f][c]}"

    # --- DECISIONES: Si estoy parado en un paquete, decido agarrarlo ---
    if mapa[f][c] == "P"
      return [0, 0] # --- ACCIÓN: Quedarse en su lugar para recolectar ---
    end

    # --- DECISIONES: Si veo un paquete a la derecha, decido ir por él ---
    if c + 1 < mapa[f].length && mapa[f][c + 1] == "P"
      return [0, 1] # --- ACCIÓN: Moverse a la derecha ---
    end

    # --- DECISIONES: Si veo un paquete a la izquierda ---
    if c - 1 >= 0 && mapa[f][c - 1] == "P"
      return [0, -1] # --- ACCIÓN: Moverse a la izquierda ---
    end

    # --- DECISIONES: Si veo un paquete abajo ---
    if f + 1 < mapa.length && mapa[f + 1][c] == "P"
      return [1, 0] # --- ACCIÓN: Moverse hacia abajo ---
    end

    # --- DECISIONES: Si veo un paquete arriba ---
    if f - 1 >= 0 && mapa[f - 1][c] == "P"
      return [-1, 0] # --- ACCIÓN: Moverse hacia arriba ---
    end

    # --- DECISIONES: Si no hay paquetes cerca, evaluar rutas libres de "X" y límites ---
    movimientos_posibles = []

    if c + 1 < mapa[f].length && mapa[f][c + 1] != "X"
      movimientos_posibles << [0, 1]
    end

    if f + 1 < mapa.length && mapa[f + 1][c] != "X"
      movimientos_posibles << [1, 0]
    end

    if c - 1 >= 0 && mapa[f][c - 1] != "X"
      movimientos_posibles << [0, -1]
    end

    if f - 1 >= 0 && mapa[f - 1][c] != "X"
      movimientos_posibles << [-1, 0]
    end

    # --- DECISIONES Y ACCIÓN: Escoger un camino al azar o quedarse quieto si está encerrado ---
    if movimientos_posibles.any?
      return movimientos_posibles.sample # --- ACCIÓN: Moverse aleatoriamente ---
    else
      return [0, 0] # --- ACCIÓN: Quedarse estático por no tener salida ---
    end
  end
end

# ==========================================
# CICLO DE VIDA DE LA SIMULACIÓN
# ==========================================
Entorno.limpiar_consola
puts "Bienvenido al Agente inteligente version 1: Ruby #{Entorno::VERSION}"

fila_inicial, col_inicial = Entorno.buscar_posicion_inicial
Entorno.configurar_inicio(fila_inicial, col_inicial)

puts "Posición inicial detectada en el mapa: [#{fila_inicial}, #{col_inicial}]"
sleep(1)

loop do
  # --- PERCEPCIONES: Consultar el estado actual del mundo ---
  percepcion = Entorno.obtener_percepcion

  puts "\nAcción N°: #{percepcion[:acciones]} / 50"

  # --- DECISIONES: El agente procesa los datos y decide su jugada ---
  decision_movimiento = Agente.pensar(percepcion)
  mov_fila = decision_movimiento[0]
  mov_columna = decision_movimiento[1]

  # --- ACCIONES: Mandar la decisión al entorno para que aplique la física y reglas ---
  Entorno.aplicar_accion(mov_fila, mov_columna)

  puts "Puntuación actual: #{Entorno.obtener_percepcion[:puntuacion]}"
  puts "====================================="
  sleep(0.5)
end

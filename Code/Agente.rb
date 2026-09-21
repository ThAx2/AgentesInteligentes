# encoding: UTF-8
VERSION = "3.3.8"
puts "Bienvenido al Agente inteligente version 1: Ruby #{VERSION}"

def limpiar_consola
  system(Gem.win_platform? ? "cls" : "clear")
end

entorno = [

  [".", ".", ".", "P", "."],

  [".", "X", ".", ".", "."],

  [".", ".", ".", "X", "P"],

  [".", ".", "P", ".", "."],

  [".", "X", ".", ".", "."],

]
$carrito = {
  posicion: [0, 0],
  puntuacion: 0,

}

def main(entorno)
  loop do
    puts "Ingresa la posicion inicial del agente"

    print "Digite la fila: [fila,columna]: "
    fila = gets.chomp.to_i

    print "Digite la columna: [#{fila},columna]: "
    columna = gets.chomp.to_i

    if fila >= 0 && fila < entorno.length &&
       columna >= 0 && columna < entorno[fila].length
      $carrito[:posicion] = [fila, columna]

      puts
      puts "Posicion actual: #{$carrito[:posicion]}"

      break
    else
      puts
      puts "Posicion invalida. Intenta nuevamente."
      puts
    end
  end
end

def paquete(entorno, row, column)
  $carrito[:puntuacion] += 1
  entorno[row][column] = "."
  puts "Has recogido un paquete correctamente: "
  puts "Puntuacion actual: #{$carrito[:puntuacion]}"
end

def element(entorno, elemento, row, column)
  puts ""
  case elemento

  when "."
    puts "Es via libre"
  when "P"
    puts "Has encontrado un paquete"
    paquete(entorno, row, column)
  else
    puts "Obstaculo"
    gatillo = false
  end
end

def sensor(entorno, row, column)
  if row >= 0 && row < entorno.length &&
     column >= 0 && column < entorno[row].length
    true
  else
    puts "\nLimite de mapa, tu posición no cambiará"
    puts "Enter para continuar: "
    gets.chomp
    false
  end
end

def movimiento(entorno, row, column)
  puts ""
  puts "Define a donde quieres desplazarte:"
  puts "1) Arriba"
  puts "2) Abajo"
  puts "3) Izquierda"
  puts "4) Derecha"

  movimiento_elegido = gets.chomp.to_i

  case movimiento_elegido

  when 1 # Arriba
    if sensor(entorno, row - 1, column)
      row -= 1
    end
  when 2 # Abajo
    if sensor(entorno, row + 1, column)
      row += 1
    end
  when 3 # Izquierda
    if sensor(entorno, row, column - 1)
      column -= 1
    end
  when 4 # Derecha
    if sensor(entorno, row, column + 1)
      column += 1
    end
  else
    puts "Movimiento no válido"
  end
  limpiar_consola
  puts "Posición actual: [#{row}, #{column}]"

  element(entorno, entorno[row][column], row, column)
  return [row, column]
end

main(entorno)
row = $carrito[:posicion][0]
column = $carrito[:posicion][1]
loop do
  row, column = movimiento(entorno, row, column)
  $carrito[:posicion] = [row, column]
end

def obstaculo(entorno, row, column)
  puts "Obstaculo encontrado en"
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

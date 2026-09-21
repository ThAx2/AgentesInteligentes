require_relative "Entorno"
def decidir_movimiento(entorno, row, column)

  # 1. Si la celda actual contiene un paquete, recogerlo
  if entorno[row][column] == "P"

    paquete(entorno, row, column)

  # 2. Si hay un paquete a la derecha, moverse a la derecha
  elsif column + 1 < entorno[row].length &&
        entorno[row][column + 1] == "P"

    column += 1

  # 3. Si hay un obstáculo al frente
  elsif row - 1 >= 0 &&
        entorno[row - 1][column] == "X"

    puts "Hay un obstáculo al frente"
    puts "Seleccionando otra dirección"

  # 4. Si hay un paquete a la izquierda, moverse a la izquierda
  elsif column - 1 >= 0 &&
        entorno[row][column - 1] == "P"

    column -= 1

  # 5. Si hay un paquete atrás, moverse hacia atrás
  elsif row + 1 < entorno.length &&
        entorno[row + 1][column] == "P"

    row += 1

  # 6. Si hay un obstáculo a la derecha
  elsif column + 1 < entorno[row].length &&
        entorno[row][column + 1] == "X"

    puts "Hay un obstáculo a la derecha"
    puts "Seleccionando otra dirección"

  # 7. Si hay un obstáculo a la izquierda
  elsif column - 1 >= 0 &&
        entorno[row][column - 1] == "X"

    puts "Hay un obstáculo a la izquierda"
    puts "Seleccionando otra dirección"

  end

  return [row, column]
end
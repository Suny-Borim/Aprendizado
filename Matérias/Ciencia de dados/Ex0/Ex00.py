def converter(valor, de, para):
  valorDeJardas = 0.9144
  valorDeMetros = 3.281
  if de == 'metros':
    if para == 'jardas':
      return valor / valorDeJardas
    elif para == 'pes':
      return valor * valorDeMetros
  elif de == 'jardas':
    if para == 'metros':
      return valor * valorDeJardas
    elif para == 'pes':
      return valor * valorDeMetros / valorDeJardas
  elif de == 'pes':
    if para == 'metros':
      return valor / valorDeMetros
    elif para == 'jardas':
      return valor * valorDeJardas / valorDeMetros
  return None


valor = float(input("Digite o valor a ser convertido: "))
de = input("Digite a unidade de origem (metros, jardas ou pés): ").lower()
para = input("Digite a unidade de destino (metros, jardas ou pés): ").lower()

resultado = converter(valor, de, para)

if resultado is not None:
  print(f"{valor} {de} equivale a {resultado:.2f} {para}.")
else:
  print("Deu errado KK")

import pandas as pd 
import math as ma

def conta():
  return ( )

numbers = pd.read_csv('https://raw.githubusercontent.com/celsocrivelaro/simple-datasets/main/seeds.csv',  header=None)
numbers.columns = ["Área A","Perímetro P","Extensão do núcleo","Largura","Coeficiente de Assimetria","Extensão do sulgo do núcleo","","",""]
#nova = numbers.drop(columns=[""])
nova = numbers[["Área A","Perímetro P","Extensão do núcleo","Largura","Coeficiente de Assimetria","Extensão do sulgo do núcleo"]]
nova = nova.dropna(axis = 0)
nova['Compactação'] = 4 * ma.radians(180) * nova['Área A'] * nova['Perímetro P']*nova['Perímetro P']


nova
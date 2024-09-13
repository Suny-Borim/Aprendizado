import matplotlib.pyplot as plt
import numpy as np

# Dados
mes = np.arange(12) + 1  # meses de 1 a 12
creme_facial = np.array([2500, 2630, 2140, 3400, 3600, 2760, 2980, 3700, 3540, 1990, 2340, 2900])
limpeza_facial = np.array([1500, 1200, 1340, 1130, 1740, 1555, 1120, 1400, 1780, 1890, 2100, 1760])
pasta_dentaria = np.array([5200, 5100, 4550, 5870, 4560, 4890, 4780, 5860, 6100, 8300, 7300, 7400])
sabonete = np.array([9200, 6100, 9550, 8870, 7760, 7490, 8980, 9960, 8100, 10300, 13300, 14400])
shampoo = np.array([1200, 2100, 3550, 1870, 1560, 1890, 1780, 2860, 2100, 2300, 2400, 1800])
hidratante = np.array([1500, 1200, 1340, 1130, 1740, 1555, 1120, 1400, 1780, 1890, 2100, 1760])

# Gráfico 1 - Total de produtos vendidos por mês - Linha
total_produtos = creme_facial + limpeza_facial + pasta_dentaria + sabonete + shampoo + hidratante

plt.figure(figsize=(10, 6))
plt.plot(mes, total_produtos, marker='o', color='b', label="Total de Produtos Vendidos")
plt.xlabel('Mês')
plt.ylabel('Total de Produtos Vendidos')
plt.title('Total de Produtos Vendidos por Mês - Linha')
plt.grid(True)
plt.xticks(mes)
plt.legend()
plt.show()

# Gráfico 2 - Gráfico com todos os produtos vendidos por mês - Linha
plt.figure(figsize=(10, 6))
plt.plot(mes, creme_facial, marker='o', label="Creme Facial")
plt.plot(mes, limpeza_facial, marker='o', label="Limpeza Facial")
plt.plot(mes, pasta_dentaria, marker='o', label="Pasta Dentária")
plt.plot(mes, sabonete, marker='o', label="Sabonete")
plt.plot(mes, shampoo, marker='o', label="Shampoo")
plt.plot(mes, hidratante, marker='o', label="Hidratante")
plt.xlabel('Mês')
plt.ylabel('Produtos Vendidos')
plt.title('Produtos Vendidos por Mês - Linha')
plt.grid(True)
plt.xticks(mes)
plt.legend()
plt.show()

# Gráfico 3 - Comparativo de Creme Facial com Limpeza Facial por mês - Barras
bar_width = 0.35
index = np.arange(len(mes))

plt.figure(figsize=(10, 6))
plt.bar(index, creme_facial, bar_width, label='Creme Facial')
plt.bar(index + bar_width, limpeza_facial, bar_width, label='Limpeza Facial')
plt.xlabel('Mês')
plt.ylabel('Quantidade de Produtos Vendidos')
plt.title('Comparativo Creme Facial x Limpeza Facial por Mês - Barras')
plt.xticks(index + bar_width / 2, mes)
plt.legend()
plt.show()

# Gráfico 4 - Histograma de quantidade de meses e faixas de produtos vendidos
plt.figure(figsize=(10, 6))
plt.hist([creme_facial, limpeza_facial, pasta_dentaria, sabonete, shampoo, hidratante], bins=range(1000, 15001, 1000), stacked=True, label=['Creme Facial', 'Limpeza Facial', 'Pasta Dentária', 'Sabonete', 'Shampoo', 'Hidratante'])
plt.xlabel('Faixas de Produtos Vendidos')
plt.ylabel('Número de Meses')
plt.title('Histograma de Produtos Vendidos por Faixa')
plt.legend()
plt.grid(True)
plt.show()

# Gráfico 5 - Pizza. % da quantidade de produtos vendidos no ano por produto
produtos_anuais = [creme_facial.sum(), limpeza_facial.sum(), pasta_dentaria.sum(), sabonete.sum(), shampoo.sum(), hidratante.sum()]
labels = ['Creme Facial', 'Limpeza Facial', 'Pasta Dentária', 'Sabonete', 'Shampoo', 'Hidratante']

plt.figure(figsize=(8, 8))
plt.pie(produtos_anuais, labels=labels, autopct='%1.1f%%', startangle=90, colors=plt.cm.Paired.colors)
plt.title('Porcentagem de Produtos Vendidos no Ano por Categoria')
plt.axis('equal')  # Equal aspect ratio ensures that pie is drawn as a circle.
plt.show()
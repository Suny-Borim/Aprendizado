<center>
<br>
<h2>
SEPARADA DA STRING DE A145
</h2>
<br>
=SPLIT(A145;"Praça";"")
<br>
<br>
=("'""id"": "&F492&", ""bairro"": """&C492&""", ""cidade"": { ""cidade"": ""CABREÚVA"", ""id"": 3508405, ""estado"": ""SP"" }, ""endereco"": """&H492&""", ""tipo"": ""LOGRADOURO"", ""tipoLogradouro"": { ""id"": "&I492&", ""descricao"": """&A492&"""',")
<br>
<br>
<h2>
varios ifs
</h2>
<br>
=SE(A492="Rodovia";"216";SE(A492="Rua";"220";SE(A492="Estrada";"145";SE(A492="Avenida";"85";SE(A492="Praça";"203";SE(A492="Via";"248";SE(A492="Travessa";"236";SE(A492="Alameda";"74";SE(A492="Área";80)))))))))
<Br>
<br>
<H2>
para colocar numeros em sequencia coloque 1
                                          2
                                          </H2>
                                          <Br>
Selecione as duas e puxe a bolinha azul
<br>
<br>
<H2>Para pular linha dentro da celula</H2>
alt+enter
<br>
<br>
payload
=("payload = json.dumps({ ""id"": '"&Q2&"', 
""bairro"": '"&N2&"', 
""cidade"": { ""cidade"": ""CABREÚVA"", ""id"": 3508405, ""estado"": ""SP"" }, 
""endereco"": '"&L2&"' '"&M2&"' '"&N2&"', 
""tipo"": ""LOGRADOURO"", 
""tipoLogradouro"": { ""id"": 220, ""descricao"": '"&L2&"', }")
<br>
<BR>
<h2>Transformar data em texto</h2>
<br>
<br>
=TEXTO(A2;"'dd/mm/yyy'")
=TEXTO(A2;"'dd/mm/yy'")
</center>
import re
from fastapi import FastAPI
from igdb.wrapper import IGDBWrapper
import json
from pydantic import BaseModel
import requests
from bs4 import BeautifulSoup
from urllib.request import Request, urlopen


#objeto(jogo) que vai ser enviado para a aplicação
class Jogo(BaseModel):
    nome: str
    id : int
    imagem : str
    rating : float
    rating_count : int
    summary : str
    follow : int

#objeto(requisitos) que vai ser enviado para a aplicação
class Requisitos(BaseModel):
    cpu: str
    ram: str
    gpu: str
    dx: str
    os: str
    storage: str

#objeto(noticia) que vai ser enviado para a aplicação
class Noticia(BaseModel):
    texto1 : str
    texto2:  str
    imagem : str
    link : str

#objeto(loja) que vai ser enviado para a aplicação
class Loja(BaseModel):
      nome: str
      link: str
      precoAntigo: float
      precoAtual: float
      desconto: float
      imagem: str


#keys e informação necessárias para aceder às APIs
keyPrices = ""
client_id = ""
client_secret = ""
acess_token = ""
wrapper = IGDBWrapper(client_id, acess_token)

#link base para oobter a imagem do jogo
linkBase = 'https://images.igdb.com/igdb/image/upload/t_cover_big/'
plataforma_pc = 6

#------------------------------Funcões de Pesquisa--------------------------------#

"""
Função para transformar os dados num objeto Jogo
    1ª linha : criar a lista de jogos  
    2ª linha : criar a variável que vai guardar a quantidade de jogos (só vai ser usada para os jogos melhores jogos e para os jogos mais seguidos)
    3ª linha : para cada linha na mensagem
    4ª linha :  verificar se a linha tem a palavra "platforms"
                verificar se a linha não tem a palavra "version_title" para remover casos de versões especiais
                verificar se a linha não tem a palavra "parent_game" para os casos de jogos que não são o jogo original (jogos que têm seasons e expansion packs)
                verificar se a linha não tem a palavra "Bundle" para remover os casos que são bundles
                verificar se a linha não tem a palavra "Edition" para remover casos qeu têm ex: Black Edition
                se for um DLC não vai conter a parte PLATFORMS, logo não vai ser adicionado a lista
    5ª linha : obter o id do jogo
    6ª linha : testar as opções de baixo. Se não tiver algum, não vai ser adicionado 
    7ª linha : obter a informação da cover do jogo´
    8ª linha : obter o id da imagem
    9ª linha : obter o nome do jogo
    10ª linha : obter o array de plataformas do jogo
    da linha 11 à linha 26 : tentar obter esses dados. Se eles não existirem colocar como 0 ou vazio
    27ª linha : remover os jogos que têm Bundle e Edition no nome
    28ª linha : se a cover não for vazia
    29ª linha : saber se é do modo 1 (pesquisa de jogos do utilizador) 
    30ª linha : obter o url da imagem
    31ª linha : criar o objeto jogo
    32ª linha : adicionar o objeto jogo à lista
    33ª linha : saber se é do modo 2 (melhores jogos e jogos mais seguidos)
    34ª linha : obter o url da imagem
    35ª linha : criar o objeto jogo
    36ª linha : adicionar o objeto jogo à lista
    37ª linha : incrementar a variável que vai guardar a quantidade de jogos
    39ª linha : continuar
    40ª linha : retornar a lista de jogos
"""
def reader(message, modo):
  lista = []     
  a = 0
  for linha in message:
    if 'platforms' in linha and 'Bundle' not in linha  and 'version_title' not in linha and 'parent_game' not in linha:  
          idd= linha['id']
          try:  
            coverr = linha['cover']
            idImagemFinall = coverr['image_id']
            nomee = linha['name']
            plataforma = linha['platforms']
            try:
              ratingg = linha['aggregated_rating']
            except:
              ratingg = 0.0
            try:
                ratinggcount = linha['aggregated_rating_count']
            except:
                ratinggcount = 0
            try:
              summaryy = linha['summary'].replace("’", "'").replace("“", '"').replace("”", '"').replace("‘", "'").replace("–", "") #substituir esses caracteres porque davam error na leitura
            except:
              summaryy = ''
            try:
              followw = linha['follows']
            except:
              followw = 0
            if 6 in plataforma and 'Bundle' not in nomee and 'Edition' not in nomee: 
              if(coverr != []): 
                if(modo == 1):
                  url = linkBase + idImagemFinall + '.png'
                  m = Jogo(nome=nomee, id=idd, imagem=url ,rating = ratingg, rating_count = ratinggcount, summary = summaryy, follow = followw)
                  lista.append(m)
                if(modo == 2 and a <10):
                  url = linkBase + idImagemFinall + '.png'
                  m = Jogo(nome=nomee, id=idd, imagem=url ,rating = ratingg, rating_count = ratinggcount, summary = summaryy, follow = followw)
                  lista.append(m)
                  a = a + 1
          except:
            continue 
  return lista 

'''
Função para remover os caracteres especiais dos requisitos
1ª linha : para cada caracter especial
2ª linha : se o caracter estiver na string
3ª linha : substituir o caracter pelo vazio
4ª linha : retornar a string
'''
def EliminarCharsEspeciais(string):
  for ch in ['®','™']:
    if ch in string:
      string=string.replace(ch,"")
  return string

'''
Função básica que retorna o numero na versão romana para ser usado na pesquisa da API
'''
def returnRomano(numero):
  if numero == 1:
    return 'i'
  elif numero == 2:
    return 'ii'
  elif numero == 3:
    return 'iii'
  elif numero == 4:
    return 'iv'
  elif numero == 5:
    return 'v'
  elif numero == 6:
    return 'vi' 
  elif numero == 7:
    return 'vii'
  elif numero == 8:
    return 'viii'
  elif numero == 9:
    return 'ix'

'''
Função que verifica se existe numero no nome do jogo
1ª linha : para cada caracter
2ª linha : se o caracter for um numero e for diferente de zero
3ª linha : substituir o caracter pela versão romana
4ª linha : retornar a string
'''
def existeNumero(string):
  for i in string:
    if ((i.isdigit()) == True and i != '0'):
      string = string.replace(i, returnRomano(int(i)))
  return string   

'''
Criar a API que vai ser usada para correr o codigo
Para executar o codigo basta : uvicorn main:app --port 8080 --host ipv4doComputador
'''     

app = FastAPI()

#Função que vai ser usada para enviar os dados e receber os pedidos da aplicação
@app.get("/")
async def root(tipo: int , nomeJogo: str): #receber o tipo e o nome do jogo
   
  if(tipo == 1):#obter jogos pela pesquisa do utilizador

      '''
      fazer 3 pedidos à base de dados porque? (porque há 3 maneiras de pesquisar pelo nome)
      1ªa = name~"' + nomeJogo + '"* (Nome do jogo no inicio começa da mesma maneira que a string começa, mas pode acabar de maneira diferente)
      2ªa = name~ *"' + nomeJogo + '" (Nome do jogo no inicio pode ser diferente da maneira que a string começa , mas pode acaba de maneira igual)
      3ªa = name~ *"' + nomeJogo + '"* (Nome do jogo no inicio e no final pode ser diferente, mas é igual à string no meio)
      O caracter ~ serve para dizer à base de dados que o nome é case insensitive
      name = obter o nome do jogo
      follows = quantidade de utilizadores que seguem o jogo
      cover.image_id = obter o id da imagem
      aggregated_rating = obter o rating do jogo
      aggregated_rating_count = obter a quantidade de utilizadores que o avaliaram
      platforms = obter as plataformas do jogo
      rating = obter o rating do jogo (para depois ordenarmos os jogos por rating, assim teremos sempre os jogos mais famosos e portanto mais pesquisados no inicio)
      version_title = obter titulo da versão do jogo
      summary = obter o resumo do jogo
      parent_game = obter o id do jogo principal se existir
      '''

      byte_arrayProcura1 = wrapper.api_request(
              'games',
              'fields name,summary,follows, cover.image_id, aggregated_rating, aggregated_rating_count, platforms, rating, version_title, parent_game; where name~"' + nomeJogo + '"*; sort rating desc;  limit 500;'
            )

      byte_arrayProcura2 = wrapper.api_request(
              'games',
              'fields name,summary,follows, cover.image_id, aggregated_rating, aggregated_rating_count,platforms, rating, version_title, parent_game; where name~ *"' + nomeJogo + '"; sort rating desc;  limit 500;'
            )

      byte_arrayProcura3 = wrapper.api_request(
              'games',
              'fields name,summary,follows, cover.image_id,aggregated_rating, aggregated_rating_count, platforms, rating, version_title, parent_game; where name~ *"' + nomeJogo + '"*; sort rating desc;  limit 500;'
            )

      #converter os dados de json para string
      message1 = json.loads(byte_arrayProcura1)
      message2 = json.loads(byte_arrayProcura2)
      message3 = json.loads(byte_arrayProcura3)
      #enviar os dados para o reader para transformar em objeto Jogo
      resultado1 = reader(message1,1)
      resultado2 = reader(message2,1)
      resultado3 = reader(message3,1)

      #juntar os jogos todos numa só lista evitando duplicados
      for i in resultado2:
        if (i not in resultado1):
          resultado1.append(i)

      for i in resultado3:
        if (i not in resultado1):
          resultado1.append(i)

      print(resultado1)
      #retornar a lista de jogos
      return resultado1

  if(tipo == 2): #obter os jogos populares


    #obter os jogos mais populares, ordenando-os pela quantidade de avaliações e tendo em conta o aggregated_rating ser maior que 1
    byte_arrayProcura1 = wrapper.api_request(
        'games',
        'fields name,summary,follows, aggregated_rating, aggregated_rating_count, cover.image_id, platforms, version_title, parent_game; where aggregated_rating > 1; sort aggregated_rating_count desc; limit 500;'
      )

    #converter os dados de json para string
    message1 = json.loads(byte_arrayProcura1)
    #ordenar os jogos por aggregated_rating
    message1.sort(key=lambda x: x["aggregated_rating"], reverse=True)
    #transformar os dados em objeto Jogo
    resultado2 = reader(message1,2)
    #retornar a lista de jogos
    return resultado2

  if(tipo == 3): #obter os requisitos do jogo
    #uma série de transformações para obter o nome do jogo na maneira correta que o website precisa que é (1palavra-2palavra-3palavra-etc)
    if('Edition' not in nomeJogo):
      nomeJogo = nomeJogo.replace("-", "_") #replace - por _
      nomeJogo = nomeJogo.replace(" ", "_") #replace espaço por _
      nomeJogo = nomeJogo.replace(" ", "-") #replace espaço por -
      nomeJogo = re.sub(r'[^\w]', ' ', nomeJogo) #substituir caracteres especiais por espaço
      nomeJogo = nomeJogo.replace(" ", "") #remove espaços
      nomeJogo = nomeJogo.replace("_", "-") #replace _ por -

      #obter o link onde está a informação do jogo
      base = "https://gamesystemrequirements.com/game/" + nomeJogo
      page = requests.get(base)
      soup = BeautifulSoup(page.content, "html.parser")

      results = soup.find_all("div", class_="gsr_row")
      resultstitulos = soup.find_all("div", class_="gsr_section")

      tipos = [] #lista com os conteudo das tags de h2 encontradas
      m = {} #dicionario requisitos minimos
      r = {} #dicionario requisitos recomendados
      listaDados = []  #lista com os titulos dos requisitos 

      #para cada j no resultstitulos
      #tentar encontrar o h2
      #se encontrar o h2 é adicionado a lista de tipos o conteudo
      for j in resultstitulos:
          tipo = j.find("h2")
          if "h2" in str(tipo):
            tipos.append(tipo.text.strip())

      #receber o tamanho da lista de results que tem todos os divs da class "gsr_row"
      count = results.__len__()

      #se não for par , quer dizer que ou os requisitos minimos ou os recomendados tem mais um valor
      #porque em principio deveriam ter o mesmo tamanho e daí serem par
      if(count % 2 != 0):
        count = count - 1

      #divide a lista de results
      res = str(results).split() 
      for ch in ['RES','ODD', 'NET', 'peripheral', 'NOTE']: #para cara string nessa lista (lista de requisitos inúteis)
        for i in res: #para cada elemento na lista res
            if ch in i: #se algum daqueles casos estiver no i retiramos 1 do tamanho count
              count = count - 1

      '''
      para cada i no results
            obter o titulo do requisitos: ex (CPU, GPU, etc)
            obter o conteudo do requisito: ex (Intel Core i7-8700K, NVIDIA GeForce GTX 1660 Ti, etc)
            se as condicoes do if forem verdadeiras
              e se já estivermos na segunda metade dos dados
                adicionar o conteudo do requisito ao dicionario de requisitos recomendados
                dar append à lista de titulos de requisitos
              se não estivermos na segunda metade dos dados
                adicionar o conteudo do requisito ao dicionario de requisitos minimos
                dar append à lista de titulos de requisitos
      '''
      count2 = 0
      for i in results:
          title_element = i.find("div", class_="gsr_label")
          title_content = i.find("div", class_="gsr_text")
          if "gsr_label" in str(title_element) and "gsr_text" in str(title_content) and "RES:" not in str(title_element) and "peripheral" not in str(title_element) and "NOTE" not in str(title_element) and "ODD" not in str(title_element) and "Sound" not in str(title_element) and "NET" not in str(title_element):
            if("Recommended system requirements:" in tipos):
              if(count2 >= count/2):
                r[title_element.text.strip()] = title_content.text.strip()
              else:
                m[title_element.text.strip()] = title_content.text.strip()
                listaDados.append(title_element.text.strip())
              count2 = count2 + 1
            else:
                m[title_element.text.strip()] = title_content.text.strip()
                listaDados.append(title_element.text.strip())
    
      resultado = [] #lista que vai ser retornada
      #inicializar os dois objetos Requirements
      min = Requisitos(cpu = "No info", gpu = "No info", ram = "No info", dx= "No info",  storage = "No info", os = "No info")
      max = Requisitos(cpu = "No info", gpu = "No info", ram = "No info", dx= "No info",  storage = "No info", os = "No info")

      '''
      Verificar se os requisitos recomendados estão na lista tipos
        Se sim, e os requisitos estiverem na listaDados
          vamos adicionar ao objeto min e max o conteudo(por vezes certas categorias como CPU, GPU etc nos requisitos recomendados vinham vazias, então decidi dar o mesmo valor da dos requisitos minimos caso falhe o try)
          Fazer isso para todos os requisitos e no final dar append do min e do max ao resultado
        Se não apenas vamos guardar os valores dos requisitos minimos, caso eles existam
      '''
      if("Recommended system requirements:" in tipos):
        if("CPU:" in listaDados):
          min.cpu = EliminarCharsEspeciais(m["CPU:"])
          try:
            max.cpu = EliminarCharsEspeciais(r["CPU:"])
          except:
            max.cpu = EliminarCharsEspeciais(m["CPU:"])

        if("RAM:" in listaDados):
          min.ram = EliminarCharsEspeciais(m["RAM:"])
          try:
            max.ram = EliminarCharsEspeciais(r["RAM:"])
          except:
            max.ram = EliminarCharsEspeciais(m["RAM:"])

        if("GPU:" in listaDados):
          min.gpu = EliminarCharsEspeciais(m["GPU:"])
          try:
            max.gpu = EliminarCharsEspeciais(r["GPU:"])
          except:
            max.gpu = EliminarCharsEspeciais(m["GPU:"])

        if("STO:" in listaDados):
          min.storage = EliminarCharsEspeciais(m["STO:"])
          try:
            max.storage = EliminarCharsEspeciais(r["STO:"])
          except:
            max.storage = EliminarCharsEspeciais(m["STO:"])

        if("OS:" in listaDados):
          min.os = EliminarCharsEspeciais(m["OS:"])
          try:
            max.os = EliminarCharsEspeciais(r["OS:"])
          except:
            max.os = EliminarCharsEspeciais(m["OS:"])

        if("DX:" in listaDados):
          min.dx = EliminarCharsEspeciais(m["DX:"])
          try:
            max.dx = EliminarCharsEspeciais(r["DX:"])
          except:
            max.dx = EliminarCharsEspeciais(m["DX:"])

        resultado.append(min)
        resultado.append(max)
      else:
        if("CPU:" in listaDados):
          min.cpu = EliminarCharsEspeciais(m["CPU:"])

        if("RAM:" in listaDados):
          min.ram = EliminarCharsEspeciais(m["RAM:"])

        if("GPU:" in listaDados):
          min.gpu = EliminarCharsEspeciais(m["GPU:"])

        if("STO:" in listaDados):
          min.storage = EliminarCharsEspeciais(m["STO:"])

        if("OS:" in listaDados):
          min.os = EliminarCharsEspeciais(m["OS:"])
        
        if("DX:" in listaDados):
          min.dx = EliminarCharsEspeciais(m["DX:"])

        resultado.append(min)
        resultado.append(max)
    else:
      resultado = []

    return resultado
    
  if(tipo == 4): #obter as noticias
      print("MODO PESQUISA NOTICIAS:")
      base = "https://www.rockpapershotgun.com/news"
      page = requests.get(base)
      soup = BeautifulSoup(page.content, "html.parser")

      results = soup.find_all("ul", class_="summary_list")

      lista = []
      listaTextoFinal = []
      listaImagensFinal = []
      listaLinksFinal = []
      for ul in results:
          for li in ul.findAll('p'):
              lista.append(li)

      for ul in results:
          for li in ul.findAll('img'):
              listaImagensFinal.append(li.get('src'))

      for li in lista:
        try:
          a = int(li.text.strip())
        except:
          listaTextoFinal.append(li.text.strip())
          for linka in li.findAll('a'):
            listaLinksFinal.append(linka.get('href'))

      k = 0
      resultadoNoticia = []
      for j in range(0 , len(listaTextoFinal), 2):
        primeiro = listaTextoFinal[j].replace("’", "'").replace("“", '"').replace("”", '"').replace("‘", "'")
        segundo = listaTextoFinal[j+1].replace("’", "'").replace("“", '"').replace("”", '"').replace("‘", "'")
        if((j + 2) % 2 == 0):
            m = Noticia(texto1=primeiro, texto2=segundo, imagem=listaImagensFinal[k], link = listaLinksFinal[k])
            if(k < 25):
              resultadoNoticia.append(m)
            k = k + 1

      return resultadoNoticia

  if(tipo == 5): #obter os jogos mais seguidos
    print("MODO PESQUISA DE JOGOS MAIS SEGUIDOS:")

    byte_arrayProcura3 = wrapper.api_request(
        'games',
        'fields name,summary, follows, aggregated_rating, aggregated_rating_count, cover.image_id, platforms, version_title, parent_game; where follows > 1; sort follows desc; limit 500;'
      )

    message1 = json.loads(byte_arrayProcura3)
    message1.sort(key=lambda x: x["follows"], reverse=True)
    resultado2 = reader(message1,2)
    return resultado2

  if(tipo == 6): #obter preço dos jogos

    #relacionar os icons das lojas com um link de uma imagem
    gogsymbol = "https://i.imgur.com/SG2VQ60.png"
    steamsymbol = "https://i.imgur.com/23hKCym.png"
    epicsymbol =  "https://i.imgur.com/YfcCHod.png"
    uplaysymbol =  "https://i.imgur.com/ImZbSKQ.png"
    originsymbol = "https://i.imgur.com/aydTLRq.png"
    humblesymbol = "https://i.imgur.com/PEvBuTJ.png"
    battlenetsymbol = "https://i.imgur.com/mPvCac7.png"
    dlgamersymbol = "https://i.imgur.com/xLvIfSK.png"
    gamebilletsymbol = "https://i.imgur.com/8XbJbfU.jpg"
    microsoftsymbol = "https://i.imgur.com/Ul7ilVn.png"
    dreamgamesymbol = "https://i.imgur.com/jlQuFLs.png"
    gamesplanetsymbol =  "https://i.imgur.com/fCgANCl.png"

    '''
    transformar o nome para lowerCase
    retirar o "the " do nome, pois a api não usa o "the "
    retirar os caracteres especiais
    depois verificar se existeNumero na string para depois transformar esse numero em romano
    '''
    if("Forza Horizon " in nomeJogo):
      nomeJogo = nomeJogo + " Standard Edition"

    nomeJogo = nomeJogo.lower()
    a = nomeJogo.replace("the ", "")
    a = re.sub('\W+',"", str(a))
    a = re.sub(r'[^\w]', '', str(a))
    a = existeNumero(a)   

    #website base para obter os preços
    request = Request(f'https://api.isthereanydeal.com/v01/game/prices/?key={keyPrices}&plains={a}&shops=gog%2Csteam%2Cepic%2Cuplay%2Corigin%2Chumblestore%2Cbattlenet%2Cdlgamer%2Cdirect2drive%2Cgamebillet%2Cmicrosoft%2Cdreamgame%2Cgamesplanetfr')

    #obter a informação da API
    response_body = urlopen(request).read()
    response_body = json.loads(response_body)

    #lista comque vai guardar lojas
    objs=[]

    #para cada linha da lista de informação
    #ver qual é a loja que está a vender
    #e associar a escolha ao icon da loja
    for i in response_body["data"][a]["list"]:        
        if(i["shop"]['id'] == "gog"):
            escolha = gogsymbol
        elif(i["shop"]['id'] == "steam"):
            escolha = steamsymbol
        elif(i["shop"]['id'] == "epic"):
            escolha = epicsymbol
        elif(i["shop"]['id'] == "uplay"):
            escolha = uplaysymbol
        elif(i["shop"]['id'] == "origin"):
            escolha = originsymbol
        elif(i["shop"]['id'] == "humblestore"):
            escolha = humblesymbol
        elif(i["shop"]['id'] == "battlenet"):
            escolha = battlenetsymbol
        elif(i["shop"]['id'] == "dlgamer"):
            escolha = dlgamersymbol
        elif(i["shop"]['id'] == "gamebillet"):
            escolha = gamebilletsymbol
        elif(i["shop"]['id'] == "microsoft"):
            escolha = microsoftsymbol
        elif(i["shop"]['id'] == "dreamgame"):
            escolha = dreamgamesymbol
        elif(i["shop"]['id'] == "gamesplanetfr"):
            escolha = gamesplanetsymbol
        
        if("switch_storefront" not in i["url"] ):#remover as lojas da humble bundle que contêm esse link uma vez que vão para a página inicial do site
          m = Loja(nome=i["shop"]['name'], link=i["url"], precoAntigo=float(i["price_old"]), precoAtual=float(i["price_new"]), desconto=float(i["price_cut"]), imagem=escolha) #criar um objeto para guardar as informações
          objs.append(m) #adicionar o objeto a lista
        
    print(objs)

    return objs

#import numpy as np


#anos = np.loadtxt("anos.txt")
#anosLen = len(anos)
#count = 0
#array = anos
#print(anos)
#while anosLen > count:
#   if(anos[count] > 1998 and anos[count]<2005): 
#    array = anos[count]
#   else: array[count].text = '0'
#   count +=1   
  
#print(array)

#--------------------------------------------------------

import scrapy
import pandas as pd


class PokemonScrapper(scrapy.Spider):
  name = 'pokemon_scrapper'
  domain = "https://pokemondb.net/"

  start_urls = ["https://pokemondb.net/pokedex/all"]

  def parse(self, response):
    pokemons = response.css('#pokedex > tbody > tr')
    for pokemon in pokemons:
      link = pokemon.css("td.cell-name > a::attr(href)").extract_first()
      yield response.follow(self.domain + link, self.parse_pokemon)

  def parse_pokemon(self, response):
    yield {
      'pokemon_name': response.css('#main > h1::text').get(),
      'next_evolution': response.css('#main > div.infocard-list-evo > div:nth-child(3) > span.infocard-lg-data.text-muted > a::text').get(),
      'pokemon_id': response.css('.vitals-table > tbody  > tr:nth-child(1) > td > strong::text').get(),
      'pokemon_height': response.css('.vitals-table > tbody  > tr:nth-child(4) > td::text').get(),
      'pokemon_weight': response.css('.vitals-table > tbody  > tr:nth-child(5) > td::text').get(),
      'pokemon_type_1': response.css('.vitals-table > tbody  > tr:nth-child(2) > td > a::text').get(),
    'pokemon_type_2': response.css('.vitals-table > tbody  > tr:nth-child(2) > td > a:nth-child(2)::text').get()}
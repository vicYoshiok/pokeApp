//
//  pokeService.swift
//  pokeApp
//
//  Created by Victor Garcia on 10/10/24.
//
import Foundation
import Alamofire
class pokeService {
    
    
    func getRandomPokemon( completion: @escaping (Pokemon?) -> Void) {
        let id = Int.random(in: 1...1000 )
         let url = "https://pokeapi.co/api/v2/pokemon/\(id)/"
         
         // Realizar la solicitud GET con Alamofire
         AF.request(url).responseData { response in
             switch response.result {
             case .success(let data):
                 do {
                     // Decodificar el JSON
                     let decoder = JSONDecoder()
                     let pokemonData = try decoder.decode(Pokemon.self, from: data)
                     completion(pokemonData) // Devolver el objeto pokemon a a la función del controlador anterior
                 } catch {
//                     manejo de errores
                     print("Error al decodificar el JSON: \(error)")
                     completion(nil)
                 }
             case .failure(let error):
//                 manejo de errores
                 print("error: \(error)")
                 completion(nil)
             }
         }
     }
    
    func getDescription(url: String, completion: @escaping (String?) -> Void) {
            // Realizar otra solicitud para obtener la descripción de la Pokédex
        print("get description poke service")
            AF.request(url).responseData { response in
                switch response.result {
                case .success(let data):
                    do {
                        let decoder = JSONDecoder()
                        let speciesData = try decoder.decode(Pokemon.PokemonSpecies.self, from: data)
                        let description = speciesData.flavor_text_entries.first(where: { $0.language.name == "en" })?.flavor_text.removingPercentEncoding?.replacingOccurrences(of: "\n", with: "")
                        completion(description)
                    } catch {
                        print("Error al decodificar la descripción: \(error)")
                        completion(nil)
                    }
                case .failure(let error):
                    print("Error en la solicitud de descripción: \(error)")
                    completion(nil)
                }
            }
        }

    
}

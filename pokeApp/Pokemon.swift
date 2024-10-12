//
//  Pokemon.swift
//  pokeApp
//
//  Created by Victor Garcia on 11/10/24.
//
import Foundation

// Modelo para almacenar información de Pokémon
struct Pokemon: Codable {
    let id: Int
    let name: String
    let height: Int
    let weight: Int
    let types: [PokemonType]
    let stats: [PokemonStat]
    let sprites: PokemonSprites
    let species: Species

    struct PokemonType: Codable {
        let type: Type
        struct `Type`: Codable {
            let name: String
        }
    }

    struct PokemonStat: Codable {
        let base_stat: Int
        let stat: Stat
        struct Stat: Codable {
            let name: String
        }
    }
    
    struct PokemonSprites: Codable {
        let front_default: String
    }
    
    struct Species: Codable {
        let url: String
    }
    struct PokemonSpecies: Codable {
        let flavor_text_entries: [FlavorTextEntry]
        
        struct FlavorTextEntry: Codable {
            let flavor_text: String
            let language: Language
            
            struct Language: Codable {
                let name: String
            }
        }
    }
}

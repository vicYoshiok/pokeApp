//
//  ViewController.swift
//  pokeApp
//
//  Created by Victor Garcia on 10/10/24.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var bannerView: UIView!
    @IBOutlet weak var displayView: UIView!
    @IBOutlet weak var statsView: UIView!
    @IBOutlet weak var getPokemon: UIButton!
//    banner
    @IBOutlet weak var light1: UIView!
    @IBOutlet weak var light2: UIView!
    
//    oulets de la información
    @IBOutlet weak var idLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var heightLabel: UILabel!
    @IBOutlet weak var weightLabel: UILabel!
    @IBOutlet weak var pokemonImageView: UIImageView!
//    ouleets para stats

    @IBOutlet weak var hpLabel: UILabel!
    @IBOutlet weak var speedLabel: UILabel!
    @IBOutlet weak var attackLabel: UILabel!
    @IBOutlet weak var defenseLabel: UILabel!
    @IBOutlet weak var specialAttackLabel: UILabel!
    @IBOutlet weak var specialDefenseLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    // MARK: funciones del ViewController
    var pokemon: Pokemon?
    var circulo2:circulo?
    override func viewDidLoad() {
//        preparación de la interface
        
        displayView.layer.cornerRadius  = 30
        displayView.layer.borderWidth = 15
        displayView.layer.borderColor = UIColor.lightGray.cgColor
        statsView.layer.cornerRadius = 20
        statsView.layer.borderColor = UIColor.darkGray.cgColor
        statsView.layer.borderWidth = 5
        let w = light1.layer.frame.size.width
        let h = light1.layer.frame.size.height
        var circulo1 = circulo(frame: CGRect(x: light1.layer.frame.origin.x,
                                             y: light1.layer.frame.origin.y,
                                             width: w + 5,
                                             height: h + 5))
        circulo1.backgroundColor = .clear
        circulo1.circleColor = .lightGray
        self.light1.addSubview(circulo1)
        
        let tamaño: CGFloat = 80
          circulo2 = circulo(frame: CGRect(x: light1.layer.frame.origin.x + (w + 5 - tamaño) / 2,
                                              y: light1.layer.frame.origin.y + (h + 5 - tamaño) / 2,
                                              width: tamaño,
                                              height: tamaño))
        circulo2!.backgroundColor = .clear
        circulo2!.circleColor = .systemBlue
        self.light1.addSubview(circulo2!)
        
//        rectangulo verde
        light2.layer.borderWidth = 5
        light2.layer.borderColor = UIColor.lightGray.cgColor
        light2.layer.cornerRadius = 20
        
        // Do any additional setup after loading the view.
//        animación rectangulo verde
        let colorAnimation = CABasicAnimation(keyPath: "backgroundColor")
        colorAnimation.fromValue = UIColor.green.cgColor
        colorAnimation.toValue = UIColor.yellow.cgColor
             colorAnimation.duration = 0.5
             colorAnimation.autoreverses = true
             colorAnimation.repeatCount = .infinity
            light2.layer.add(colorAnimation, forKey: "colorAnimation")
        DispatchQueue.main.async{
             let pokeTimer = Timer.scheduledTimer(timeInterval: 30,
                                                          target: self,
                                                  selector: #selector(self.getPokemonInfo),
                                                          userInfo: nil,
                                                          repeats: true)
            RunLoop.main.add(pokeTimer , forMode: RunLoop.Mode.common)
         }
    }
    

    @IBAction func getPokemonFunc(_ sender: Any) {
        self.getPokemonInfo()
    }
    
// MARK: funciones de interface
    
    func updateViews() {
//        función encargada de realizar la actualización de las vistas de la app
        let idString = String(pokemon!.id)
        idLabel.text = idString
        nameLabel.text = pokemon!.name
        heightLabel.text = "Height: \(pokemon!.height)"
        weightLabel.text = "Weight: \(pokemon!.weight)"
        print(pokemon?.stats ?? "no disponibles")
        let types = pokemon?.types.map { $0.type.name.capitalized }.joined(separator: ", ")
        print(types as Any)
        typeLabel.text = types
//        extraer los stats de la  estructura y convertirlos en un string para procesarlos en la función show stats
        let stats = pokemon!.stats.map { "\($0.stat.name): \($0.base_stat)" }.joined(separator: ", ")
        showStats(from: stats)
//        obtiene una dirección para hacer la petición de la descripción del pokemon y manda llamar la función getDescription del oobjeto pokeService
        print(pokemon?.species as Any)
        getPokemonDescription(for: (pokemon?.species.url)!)
//        realiza  descarga de la imagen del pokemon
        if let url = URL(string: pokemon!.sprites.front_default) {
                URLSession.shared.dataTask(with: url) { data, response, error in
                    if let data = data, let image = UIImage(data: data) {
                        DispatchQueue.main.async {
                            self.pokemonImageView.contentMode = .redraw
                            self.pokemonImageView.image = image
                        }
                    }
                }.resume()
            }
        }

    func showStats(from stats: String) {
        //    recibe la cadena de stats de la estructura pokemon, la convierte en un diccionadio [nombre: valor] y la despliega en los labels de la interfaz
            let statComponents = stats.components(separatedBy: ", ")
            var statsDictionary: [String: Int] = [:]
            for component in statComponents {
                let keyValue = component.components(separatedBy: ": ")
                if keyValue.count == 2,
                   let key = keyValue.first?.trimmingCharacters(in: .whitespaces),
                   let valueString = keyValue.last?.trimmingCharacters(in: .whitespaces),
                   let value = Int(valueString) {
                    statsDictionary[key] = value
                }
            }
        
            hpLabel.text = "HP: \(statsDictionary["hp"] ?? 0)"
            attackLabel.text = "Att: \(statsDictionary["attack"] ?? 0)"
            defenseLabel.text = "Def: \(statsDictionary["defense"] ?? 0)"
            specialAttackLabel.text = "Sp Att: \(statsDictionary["special-attack"] ?? 0)"
            specialDefenseLabel.text = "Sp Def: \(statsDictionary["special-defense"] ?? 0)"
            speedLabel.text = "Speed: \(statsDictionary["speed"] ?? 0)"
        }
    
    // MARK: funciones de backend
    @objc func getPokemonInfo(){   //    función qu ejecuta la petición de servicio, se manda llamar en el botón "show pokemon" y  cada 30 segundos con un timer
       
        let pokeservice = pokeService()
        pokeservice.getRandomPokemon() { [weak self] pokemonData in
                   guard let self = self, let pokemonData = pokemonData else { return }
                   self.pokemon = pokemonData // guardar el pokemon en el objeto debil pokemon data para mejoras de uso de memoria
                   // mostrar los datos del pokemon en la interfaz
                   DispatchQueue.main.async {
                       print("regrese al hilo del view controller")
                       self.updateViews()
                   }
               }
        
    }
    
    func getPokemonDescription(for url: String) {
        let pokeservice = pokeService()
        pokeservice.getDescription(url: url){  [weak self]  pokemon in
            guard pokemon != nil else { return }
                // Llamar a la funcion de obtener la descripción utilizando la URL de la especie
                pokeservice.getDescription(url: url) { description in
                    DispatchQueue.main.async {
                        print(description ?? "sin descripción")
                        self?.descriptionLabel.text = "Description : \n " + (description ?? "Description not aviable")
                    }
                }
            }
        }
    
}


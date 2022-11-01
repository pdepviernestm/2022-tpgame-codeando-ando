import wollok.game.*
object nave{
    var vida = 3
    var property position = game.at(25,5)
    
    method perderVida(){
        vida -= 1
        if(vida == 0) juego.terminar()
        contador.disminuir()
    }
    method disparar(a){
       //var a = new BalaNave(position = self.position().up(1).right(2))
       game.addVisual(a)
       a.moverse()
    }
    
    method image() = "img/naveEspacial.png"

}


class Corazon{
	var property position
	method image() = "img/corazon.png"
}
object contador{
	var corazon1 = new Corazon(position = game.at(5,45))
	var corazon2 = new Corazon(position = game.at(10,45))
	var corazon3 = new Corazon(position = game.at(15,45))
	const listaCorazones = [corazon1, corazon2, corazon3]
	var contadorVida = 3
	method disminuir(){
        contadorVida --
        game.removeVisual(listaCorazones.last())
		listaCorazones.remove(listaCorazones.last())
	}
	method crearVisual(){
		listaCorazones.forEach({unCorazon => game.addVisual(unCorazon)})
	}
    method perderVida(){}
    method recibirGolpe(){}
}

object puntos{
    var property puntos = 0
    var property position = game.at(45,45)


    method sumarPunto(){
        puntos = puntos + 10
        if(puntos > 40){
            juego.ganar()
        }
    }


}

class Bala{
    var property position 
   	method image() = "img/bala-removebg-preview.png"
}
class BalaNave{
  	var property position 
   	method image() = "img/bala-removebg-preview.png"
    method moverse(){
        game.onTick(10,"balaNave se mueve",{position = position.up(1)
        if(position.y() >= game.height()){game.removeVisual(self)
        		game.removeTickEvent("balaNave se mueve")
        	}
        })
        game.onCollideDo(self,{unInvasor =>
        	unInvasor.recibirGolpe()
            puntos.sumarPunto()
        	if(game.hasVisual(self)){game.removeVisual(self)}
            game.removeTickEvent("balaNave se mueve")
        })
    }
    
     method crear(){
        game.addVisual(self)
        self.moverse()
    }  
    method perderVida(){}
    method recibirGolpe(){}
    
}

class BalaInvader{
    var property position 
   	method image() = "img/bala-removebg-preview.png"
    method moverse(){
        game.onTick(700,"balaInvader se mueve",{position = position.down(1)
        if(position.y() <= 0){game.removeVisual(self)}
        })
        game.onCollideDo(self,{unaNave =>
        	unaNave.perderVida()
        	if(game.hasVisual(self)){game.removeVisual(self)}
        })
    }
    method recibirGolpe(){}
     method crear(){
        game.addVisual(self)
        self.moverse()
    }
}

class Invasor{
	var color  
    var property position
	var vida = color.vida()
   
    method recibirGolpe(){
        vida-- 
        if(vida == 0){self.desaparecer()}
    }
    method movimientoLateral(){
        position = position.left(5)
        position= position.left(5)
        position = position.right(5)
        position = position.right(5)
        position = position.right(5)
        position = position.right(5)
        position = position.left(5)
        position = position.left(5)
    }
    method crear(posicion){
        /*game.addVisual()*/
        
        game.onTick(3000,"invaderDispara",{new BalaInvader(position = posicion.down(1)).crear()
        									if(vida == 0){game.removeTickEvent("invaderDispara")}
        })
        
        
    }
    method perderVida(){}
    method desaparecer(){
       game.removeVisual(self)
    }
    method image() = color.imagen()
}

class Color {
    var property vida 
    var property position
    var property imagen
    method image() = imagen
}
object juego{
var background = game.sound("img/starWars.mp3")
    method iniciar(){
        game.width(50)
	    game.height(50)
	    game.cellSize(40)
	    game.title("Space Invaders")
        background.play()
        game.boardGround("img/pondo-Copy.png")
        keyboard.any().onPressDo({self.empezar()})
    }
    method empezar(){
	    game.addVisualCharacter(nave)
	    contador.crearVisual()
        game.boardGround("img/pondo.png")
	    
        self.agregarInvasores()
        
        keyboard.space().onPressDo({nave.disparar(new BalaNave(position = nave.position().up(1).right(2)))})
    }
    

    method agregarInvasores(){
        game.onTick(2000,"agregar invasores",{self.nuevoInvasor(new Invasor(position = game.at(0.randomUpTo(game.width()),40.randomUpTo(game.height())),color=azul))
                                              self.nuevoInvasor(new Invasor(position = game.at(0.randomUpTo(game.width()),40.randomUpTo(game.height())),color=negro))})
		game.schedule(15000,{game.removeTickEvent("agregar invasores")})
	}	
	
	method nuevoInvasor(invasor){
		game.addVisual(invasor)
		invasor.crear(invasor.position())
	}

    method terminar(){
        game.clear()
        game.addVisual(nave)
        game.say(nave, "Fuimos derrotados por nuestros invasores")
    }
    method ganar(){
        game.clear()
        game.addVisual(nave)
        game.say(nave, "GANAMOS")

    }
    
}
const negro = new Color(vida = 1, imagen = "img/invaderNegro.png", position = game.center())
const azul = new Color(vida = 2, imagen = "img/invaderCeleste.png" , position = game.center())








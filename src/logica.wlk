import wollok.game.*
object nave{
    var vida = 2
    var property position = game.at(25,5)
    
    method perderVida(){
        vida -= 1
        if(vida == 0) juego.terminar()
    }
    method disparar(){
       var a = new BalaNave(position = self.position().up(1).right(2))
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
	method disminuir(){contadorVida --
		if(listaCorazones.size() != 0){
		game.removeVisual(listaCorazones.last())
		listaCorazones.remove()
		}
	}
	method crearVisual(){
		listaCorazones.forEach({unCorazon => game.addVisual(unCorazon)})
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
    	if(position.y()>= 30){game.removeVisual(self)}
        game.onTick(10,"bala se mueve",{position = position.up(1)
        	if(position.y()>= game.height()){game.removeVisual(self)}
        })
        game.onCollideDo(self,{unInvasor =>
        	unInvasor.recibirGolpe()
        	game.removeVisual(self)
        })
    }
    
     method crear(){
        game.addVisual(self)
        self.moverse()
    }  
    
}

class BalaInvader{
    var property position 
   	method image() = "img/bala-removebg-preview.png"
    method moverse(){
        game.onTick(1000,"bala se mueve",{position = position.down(1)})
        game.onCollideDo(self,{unaNave =>
        	unaNave.perderVida()
        	game.removeVisual(self)
        })
    }
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
        game.onTick(3000,"invaderDispara",{new BalaInvader(position = posicion.down(1)).crear()})
    }
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
    method iniciar(){
        game.width(50)
	    game.height(50)
	    game.cellSize(40)
	    game.title("Space Invaders")
	    game.addVisualCharacter(nave)
	    contador.crearVisual()
	    
        self.agregarInvasores()
        
        keyboard.space().onPressDo({nave.disparar()})
    }
    

    method agregarInvasores(){
        game.onTick(2000,"agregar invasor azul",{self.nuevoInvasor(new Invasor(position = game.at(0.randomUpTo(game.width()),40.randomUpTo(game.height())),color=azul))})
        game.onTick(2000,"agregar invasor negro",{self.nuevoInvasor(new Invasor(position = game.at(0.randomUpTo(game.width()),40.randomUpTo(game.height())),color=negro))})
		game.schedule(10000,{game.removeTickEvent("agregar invasor azul")})
		game.schedule(10000,{game.removeTickEvent("agregar invasor negro")})
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








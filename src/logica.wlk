import wollok.game.*
object nave{
    var vida = 2
    var property position = game.at(25,5)
    
    method perderVida(){
        vida -= 1
        if(vida == 0) juego.terminar()
    }
    method disparar(){
       var a = new BalaNave(position = nave.position().up(1).right(2))
       game.addVisual(a)
       a.moverse()
    }
    
    method image() = "img/naveEspacial.png"

}
class Bala{
    var property position 
   	method image() = "img/bala-removebg-preview.png"
}
class BalaNave{
  	var property position 
   	method image() = "img/bala-removebg-preview.png"
    method moverse(){
        game.onTick(10,"bala se mueve",{position = position.up(1)})
        game.onCollideDo(self,{unInvasor =>
        	unInvasor.desaparecer()
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
        game.onTick(1000,"bala se mueve",{position.down(1)})
        game.onCollideDo(self,{nave => nave.perderVida()})
        game.onCollideDo(self, {game.removeVisual(self)})
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
    method crear(){
        /*game.addVisual()*/
        game.onTick(3000,"invaderDispara",{new BalaInvader().crear()})
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
	    
        self.agregarInvasores()
        
        keyboard.space().onPressDo({nave.disparar()})
    }
    

    method agregarInvasores(){
        game.onTick(2000,"agregar invasor azul",{game.addVisual(new Invasor(position = game.at(0.randomUpTo(game.width()),40.randomUpTo(game.height())),color=azul))})
        game.onTick(2000,"agregar invasor negro",{game.addVisual(new Invasor(position = game.at(0.randomUpTo(game.width()),40.randomUpTo(game.height())),color=negro))})
		game.schedule(15000,{game.removeTickEvent("agregar invasor azul")})
		game.schedule(15000,{game.removeTickEvent("agregar invasor negro")})
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








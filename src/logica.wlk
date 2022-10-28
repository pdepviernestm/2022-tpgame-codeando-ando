import wollok.game.*
object nave{
    var vida = 2
    var property position = game.at(25,5)
    
    method perderVida(){
        vida -= 1
        if(vida == 0) juego.terminar()
    }
    method disparar(){
       balaNave.crear()
    }

}
class Bala{
    var property position 
    var imagen = "img/bala-removebg-preview.png"
}
object balaNave inherits Bala(position = nave.position()) {
  
    method moverse(){
        game.onTick(1000,"bala se mueve",{position.up(1)})
        game.onCollideDo(self,{unInvasor =>unInvasor.desaparecer()})
        game.onCollideDo(self, {game.removeVisual(self)})
    }
     method crear(){
        game.addVisual(self)
        self.moverse()
    }  
}

object balaInvader inherits Bala(position=game.at(25,25)){
    
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
	var vida = color.vida()
    var position
   
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
        game.addVisual(color)
        game.onTick(3000,"invaderDispara",{balaInvader=>balaInvader.crear()})
    }
}

class Color {
    var property vida
    var property imagen 
}
object invasor{
    method desaparecer(){
        game.removeVisual(self)
    }
}

object juego{
    method iniciar(){
        game.width(200)
	    game.height(200)
	    game.cellSize(5)
	    game.title("Space Invaders")
	    game.addVisual(nave)
        self.agregarInvasores()
        
        keyboard.space().onPressDo({nave.disparar()})
    }
    

    method agregarInvasores(){
		const negro = new Color(vida = 1, imagen = "img/invaderNegro.png")
		const azul = new Color(vida = 2, imagen = "img/invaderCeleste.png")
        game.onTick(2000,"agregar invasor azul",{new Invasor(position = game.at(0.randomUpTo(game.width()),30.randomUpTo(game.height())),color=azul).crear()})
        game.onTick(2000,"agregar invasor negro",{new Invasor(position = game.at(0.randomUpTo(game.width()),30.randomUpTo(game.height())),color=negro).crear()})     
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


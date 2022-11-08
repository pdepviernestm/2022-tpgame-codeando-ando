import wollok.game.*

object nave{
    var vida = 3
    var property position = game.at(25,5)
    
    method perderVida(){
        vida -= 1
        if(vida == 0) {juego.terminar()}else{contador.disminuir()}        
    }
    method disparar(a){
       game.addVisual(a)
       a.moverse()
    }
    method recibirGolpeBalaInvader(bala){
        self.perderVida()
        if(game.hasVisual(bala)){game.removeVisual(bala)}
    }
    
    method image() = "img/naveEspacial.png"

}


class Corazon{
	var property position
	method image() = "img/corazon.png"
}
object contador{
	const corazon1 = new Corazon(position = game.at(1,45))
	const corazon2 = new Corazon(position = game.at(1,40))
	const corazon3 = new Corazon(position = game.at(1,35))
	const listaCorazones = [corazon1, corazon2, corazon3]
	var contadorVida = 3
	method disminuir(){
		if(listaCorazones.size() != 0){
        contadorVida --
        game.removeVisual(listaCorazones.last())
		listaCorazones.remove(listaCorazones.last())
	}
	}
	
	method crearVisual(){
		listaCorazones.forEach({unCorazon => game.addVisual(unCorazon)})
	}
    method perderVida(){}
    method recibirGolpeBalaNave(unaBalaNave){}
    method recibirGolpeBalaInvader(algo){}
}


class Bala{
    var property position 
   	method image() 
    method moverse()
     method crear(){
        game.addVisual(self)
        self.moverse()
    }  
}
class BalaNave inherits Bala{
    override method moverse(){
        game.onTick(10,"balaNave se mueve",{position = position.up(1)
        if(position.y() >= game.height() && game.hasVisual(self)){game.removeVisual(self)
        		game.removeTickEvent("balaNave se mueve")
        	}
        })
        game.onCollideDo(self,{algo =>
        	algo.recibirGolpeBalaNave(self)
        		 
        })
    }
    override method image() = "img/balaNave.png"
    
    method perderVida(){}
    method recibirGolpeBalaInvader(bala){}
    method recibirGolpeBalaNave(bala){}
    
}

class BalaInvader inherits Bala{
    override method moverse(){
        game.onTick(700,"balaInvader se mueve",{position = position.down(1)
        if(position.y() <= 0 && game.hasVisual(self)){game.removeVisual(self)}
        })
        game.onCollideDo(self,{algo =>
        	algo.recibirGolpeBalaInvader(self)
        })
    }
    
    override method image() = "img/balaInvader.png"
    method recibirGolpeBalaNave(alguien){}
    method recibirGolpeBalaInvader(alguien){}
}

class Invasor{
	var color  
    var property position
	var vida = color.vida()
   
    method recibirGolpe(){
        vida-- 
        if(vida == 0){self.desaparecer()}
    }
    method crear(posicion){
        
        game.onTick(3000,"invaderDispara",{new BalaInvader(position = posicion.down(1)).crear()
        									if(vida == 0){game.removeTickEvent("invaderDispara")}
        })
        
        
    }
    method recibirGolpeBalaNave(unaBalaNave){
        self.recibirGolpe()
        if(game.hasVisual(unaBalaNave)){game.removeVisual(unaBalaNave)
           game.removeTickEvent("balaNave se mueve")}
       
    }
    method recibirGolpeBalaInvader(unaBalaNave){}
    method perderVida(){}
    method desaparecer(){
       if(game.hasVisual(self)){game.removeVisual(self) score.sumarPunto()}
    }
    method image() = color.imagen()
}

object start{
    var property position = game.at(13,5)
    method image() = "img/start.png"
}

class Color {
    var property vida 
    var property position
    var property imagen
    method image() = imagen
}

object fondoInicial{
	var property position = game.at(15,25)
	method image() = "img/fondoInicial.png"
}

object juego{
    const intro = game.sound("img/starWars.mp3")
    const jueguito = game.sound("img/juego.mp3")
    const ganamosSound = game.sound("img/ganar.mp3")
    const perderSound = game.sound("img/perder.mp3")
    method confInicial(){
        game.width(50)
	    game.height(50)
	    game.cellSize(40)
	    game.title("Space Invaders")
	    game.boardGround("img/pondo.png")
        game.addVisual(fondoInicial)
        game.addVisual(start)
        keyboard.enter().onPressDo({game.clear() self.empezar()})
    }
    method iniciar(){
    	intro.play()
    	keyboard.enter().onPressDo({game.clear() intro.stop() self.empezar()})
    }
    method empezar(){
        jueguito.play()
        jueguito.volume(0.2)
	    game.addVisualCharacter(nave)
	    contador.crearVisual()
	    score.primeraVez()
        self.agregarInvasores()
        
        keyboard.space().onPressDo({nave.disparar(new BalaNave(position = nave.position().up(1)))})
    }
    

    method agregarInvasores(){
        game.onTick(2000,"agregar invasores",{self.nuevoInvasor(new Invasor(position = game.at(3.randomUpTo(game.width()),40.randomUpTo(game.height())),color=azul))
                                              self.nuevoInvasor(new Invasor(position = game.at(3.randomUpTo(game.width()),40.randomUpTo(game.height())),color=negro))})
		game.schedule(15000,{game.removeTickEvent("agregar invasores")})
	}	
	
	method nuevoInvasor(invasor){
		game.addVisual(invasor)
		invasor.crear(invasor.position())
	}

    method terminar(){
        game.clear()
        game.addVisual(nave)
        game.addVisual(perder)
        jueguito.stop()
        perderSound.play()
    }
    method ganar(){
        game.clear()
        game.addVisual(nave)
        game.addVisual(ganar)
        jueguito.stop()
        ganamosSound.play()
    }
    
}


object ganar{
	var property position = game.at(2,20)
	method image() = "img/ganamos.png"
}
object perder{
	var property position = game.at(2,20)
	method image() = "img/perdimos.png"
}

const negro = new Color(vida = 1, imagen = "img/invaderNegro.png", position = game.center())
const azul = new Color(vida = 2, imagen = "img/invaderCeleste.png" , position = game.center())



object score{
	const unidad = new Visual(position = game.at(1,20))
	const decena = new Visual(position = game.at(1,25))
	const centena = new Visual(position = game.at(1,30))

    method sumarPunto(){
    	game.removeVisual(unidad)
    	game.removeVisual(decena)
    	game.removeVisual(centena)
    	decena.number(decena.number()+1)
    	if(decena.number() == 10){
    		juego.ganar()
    		decena.number(0)
    		centena.number(1)
    	}
    	game.addVisual(unidad)
    	game.addVisual(decena)
		game.addVisual(centena)
    }
    
    
    method primeraVez(){
    	game.addVisual(unidad)
    	game.addVisual(decena)
		game.addVisual(centena)
    }
    
}


class Visual{
    var property position
    var property number = 0
    method image() = "img/numeros/num" + number + ".png"
}

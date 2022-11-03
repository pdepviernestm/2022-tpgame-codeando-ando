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
    method recibirGolpeBalaInvader(bala){
        self.perderVida()
        game.removeTickEvent("balaNave se mueve")
        game.removeVisual(bala)}
    
    
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
        contadorVida --
        game.removeVisual(listaCorazones.last())
		listaCorazones.remove(listaCorazones.last())
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
   	method image() = "img/bala-removebg-preview.png"
    method moverse()
     method crear(){
        game.addVisual(self)
        self.moverse()
    }  
}
class BalaNave inherits Bala{
    override method moverse(){
        game.onTick(10,"balaNave se mueve",{position = position.up(1)
        if(position.y() >= game.height()){game.removeVisual(self)
        		game.removeTickEvent("balaNave se mueve")
        	}
        })
        game.onCollideDo(self,{algo =>
        	algo.recibirGolpeBalaNave(self)
        	// if(game.hasVisual(self)){game.removeVisual(self)
            // game.removeTickEvent("balaNave se mueve")}
        		 
        })
    }
    
    method perderVida(){}
    method recibirGolpeBalaInvader(bala){}
    method recibirGolpeBalaNave(bala){}
    //method recibirGolpe(){}
    
}

class BalaInvader inherits Bala{
    override method moverse(){
        game.onTick(700,"balaInvader se mueve",{position = position.down(1)
        if(position.y() <= 0){game.removeVisual(self)}
        })
        game.onCollideDo(self,{algo =>
        	algo.recibirGolpeBalaInvader(self)
        	//if(game.hasVisual(self)){game.removeVisual(self)}
        })
    }
    method recibirGolpeBalaNave(alguien){}
    method recibirGolpeBalaInvader(alguien){}
}

class Invasor{
	var color  
    var property position
	var vida = color.vida()
   
    method recibirGolpe(){
        score.sumarPunto()
        vida-- 
        if(vida == 0){self.desaparecer()}
    }
    method crear(posicion){
        /*game.addVisual()*/
        
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
       game.removeVisual(self)
    }
    method image() = color.imagen()
}

object start{
    var property position = game.at(20,5)
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
    method iniciar(){
        game.width(50)
	    game.height(50)
	    game.cellSize(40)
	    game.title("Space Invaders")
	    game.boardGround("img/pondo.png")
        game.addVisual(fondoInicial)
        game.addVisual(start)
        keyboard.enter().onPressDo({game.clear() self.empezar()})
    }
    method empezar(){
        intro.play()
        intro.volume(0.2)
	    game.addVisualCharacter(nave)
	    contador.crearVisual()
	    score.imprimirPuntaje()
        self.agregarInvasores()
        
        keyboard.space().onPressDo({nave.disparar(new BalaNave(position = nave.position().up(1).right(2)))})
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



object score{
    var puntaje = [0,0,0]
    var n = 30
    var eliminada 
    
    method imprimirPuntaje(){
        puntaje.forEach{valor => self.dibujar(valor)}
    }
    method dibujar(objeto){
        game.addVisual(convertirNumero.getNumberImage(objeto,game.at(1,n)))
        n -= 5
    }
    method sumarPunto(){
        if(puntaje.get(1) == 9){
            puntaje = [1,0,0]
            self.imprimirPuntaje()
            juego.ganar()
        }
        var nuevoScore = [puntaje.head(),puntaje.get(1)+1,puntaje.last()]
        puntaje = nuevoScore
        eliminada  = puntaje.get(1)
        self.imprimirPuntaje()
    }
    
}

object convertirNumero{
    var property aEliminar
    var property coleccionAEliminar=[]
    method getNumberImage(number, posicion){
        aEliminar = new Visual(imagen= "img/numeros/num" + number + ".png", position = posicion)
        coleccionAEliminar.add(aEliminar)
    	return aEliminar
    }
}

class Visual{
    var property position
    var property imagen
    method image() = imagen
}

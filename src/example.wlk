import wollok.game.*
import logica.*
object juego {

	method comenzar(){
		game.width(50)
	game.height(50)
	game.cellSize(5)
	game.title("Space Invaders")
	game.start()

	}
	method agregarInvasores(){
		const negro = new Color(vida = 1, imagen = "img/invaderNegro.png")
		const azul = new Color(vida = 2, imagen = "img/invaderCeleste.png")
		new Invasor(posicionX = 15, posicionY = 40, color = negro)  
		new Invasor(posicionX = 20, posicionY = 40, color = negro)  
		new Invasor(posicionX = 25, posicionY = 40, color = negro)  
		new Invasor(posicionX = 30, posicionY = 40, color = negro)  
		new Invasor(posicionX = 35, posicionY = 40, color = negro)
		new Invasor(posicionX = 15, posicionY = 45, color = azul)    
		new Invasor(posicionX = 20, posicionY = 45, color = azul)    
		new Invasor(posicionX = 25, posicionY = 45, color = azul)    
		new Invasor(posicionX = 30, posicionY = 45, color = azul)    
		new Invasor(posicionX = 35, posicionY = 45, color = azul)    

	}	
}



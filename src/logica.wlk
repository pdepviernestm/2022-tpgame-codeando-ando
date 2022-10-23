import wollok.game.*
class Invasor{
	var vida = color.vida()
    var posicionX
    var posicionY 
    var color
    method recibirGolpe(){
        vida-- 
    }
    method movimientoLateral(){
        posicionX = posicionX.left(5)
        posicionX= posicionX.left(5)
        posicionX = posicionX.right(5)
        posicionX = posicionX.right(5)
        posicionX = posicionX.right(5)
        posicionX = posicionX.right(5)
        posicionX = posicionX.left(5)
        posicionX = posicionX.left(5)
    }
    method position(){

    }
}


class Color {
    var vida
    var imagen 
}
object pantalla{
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



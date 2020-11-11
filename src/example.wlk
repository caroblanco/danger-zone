class Empleado{
	var salud
	const habilidades =[]
	var puesto
	
	method estaIncapacitado() = salud < puesto.saludCritica()
	
	method saludCritica()
	
	method puedeUsarHabilidad(unaH) = not self.estaIncapacitado() && self.tieneHabilidad(unaH)
	
	method tieneHabilidad(unaH) = habilidades.contains(unaH) 
	
	method recibirDanio(cant){
		salud -=cant
	}
	
	method registrarMision(mision){
		if(self.sobrevivio()){
			self.completarMision(mision)
		}
	}
	
	method completarMision(mision){
		puesto.consecuenciaMision(mision,self)
	}
	
	method sobrevivio() = salud > 0
	
	method agregarHab(unaH){
		habilidades.add(unaH)
	}
	
	method cambiarPuestoA(nuevoP){
		puesto = nuevoP
	}
}

class Equipo{
	const integrantes = []
	
	method puedeUsarHabilidad(unaH) = integrantes.any({unE => unE.puedeUsarHabilidad(unaH)})
	
	method recibirDanio(cant){
		integrantes.forEach({unI => unI.recibirDanio(cant*0.3)})
	}
	
	method registrarMision(mision){
		integrantes.forEach({unI => unI.registrarMision(mision)})
	}
}

class Jefe inherits Empleado{
	const subordinados = []
	
	override method tieneHabilidad(unaH) = super(unaH) || self.algunSubordinadoLaTiene(unaH)
	
	method algunSubordinadoLaTiene(unaH) = subordinados.any({unS => unS.tieneHabilidad(unaH)})
}

object espia{
	method saludCritica() = 15
	
	method consecuenciaMision(mision,quien){
		mision.enseniarHabilidades(quien)
	}	
}

class Oficinista{
	var estrellas
	
	method saludCritica() = 40 - 5*estrellas
	
	method agregarEstrella(quien){
		estrellas ++
		if(estrellas == 3){
			quien.cambiarPuestoA(espia)
		}
	}
	
	method consecuenciaMision(mision,quien){
		self.agregarEstrella(quien)
	}
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////

class Mision{
	const habRequeridas = []
	const peligrosidad 
	
	method realizarMision(alguien){
		self.poseeTodasLasHabilidades(alguien)
		alguien.recibirDanio(peligrosidad)
		alguien.registrarMision(self)
	}
	
	method poseeTodasLasHabilidades(alguien){
		if(not habRequeridas.all({unaH => alguien.tieneHabilidad(unaH)}))
			self.error("NO POSEE HABILIDADES")
		}
		
	method enseniarHabilidades(quien){
		self.habQueNoPosee(quien).forEach({unaH => quien.agregarHab(unaH)})
	}
	
	method habQueNoPosee(quien) = habRequeridas.filter({unaH => not quien.tieneHabilidad(unaH)})
	
}
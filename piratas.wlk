class Barco{
  var property mision
  const property capacidad
  const property tripulacion = #{}
  
  method anadirPirata(unPirata) {
    if (unPirata.esApto(mision)){
      tripulacion.add(unPirata)
    }
  }

  method echarPirata(unPirata) {
    tripulacion.remove(unPirata)
  }

  method anclar(unaCiudad) {
    tripulacion.forEach({p => p.tomarUnTrago() p.restarMonedas(1)})
    self.echarPirata(tripulacion.max({p => p.nivelDeEbriedad()}))
    unaCiudad.poblacion(unaCiudad.poblacion() + 1)
  }

  method invitarAlBarcoConPirata(pirataInvitador, pirataInvitado) {
    if(tripulacion.contains(pirataInvitador) and pirataInvitado.esApto(mision)){
      self.anadirPirata(pirataInvitado)
      pirataInvitador.tripulantesInvitados(pirataInvitador.tripulantesInvitados() + 1)
      pirataInvitado.invitadoPor(pirataInvitador)
    }
  }


  method tripulanteQueMasGenteInvito() = tripulacion.max({p => p.tripulantesInvitados()})
  method ocupacion() = (tripulacion.size() * 100) / capacidad
}

class Pirata{
  var property items
  var property nivelDeEbriedad = 0
  var property monedas = 0
  var property invitadoPor = "nadie"
  var property tripulantesInvitados = 0
  
  method puedeSaquear(unObjetivo) = (unObjetivo == "barco pirata" and nivelDeEbriedad >= 90) or 
    (unObjetivo == "ciudad costera" and nivelDeEbriedad >= 50 )

  method pasadoDeGrog() = nivelDeEbriedad >= 90 and !items.contains("permiso de la corona")
  method esApto(unaMision) = unaMision.puedeParticipar(self)

  method tomarUnTrago() {
    nivelDeEbriedad = (nivelDeEbriedad + 5).min(100)
  }

  method restarMonedas(cantidad) {
    monedas = (monedas - cantidad).max(0)
  }
}


class Ciudad{
  var property habitantes = 0
  var property esVulnerable 
}

class Mision{  
  method puedeCompletar(unBarco) = unBarco.ocupacion() >= 90
  
}

class BusquedaDelTesoro inherits Mision{
  // const itemsUtiles = ["brujula", "mapa", "grogXD"]
  method puedeParticipar(unPirata) = unPirata.monedas() <= 5 and 
  (unPirata.items().contains("brujula") or 
  unPirata.items().contains("mapa") or 
  unPirata.items().contains("grogxD"))

  override method puedeCompletar(unBarco) =  super(unBarco) and 
    unBarco.tripulacion().all({p => self.puedeParticipar(p)}) and
    unBarco.tripulacion().any({p => p.items().contains("llaveCofre")})
}

class ConvertirseEnLeyenda inherits Mision{
  const property itemLegendario

  method puedeParticipar(unPirata) = unPirata.items().size() >= 10 and unPirata.items().contains(itemLegendario)

  override method puedeCompletar(unBarco) = super(unBarco) and 
  unBarco.tripulacion().all({p => self.puedeParticipar(p)})
}

class Saqueo inherits Mision{
  const property objetivo
  var property monedasRequeridas

  method puedeParticipar(unPirata) = unPirata.monedas() < monedasRequeridas and unPirata.puedeSaquear(objetivo)

  override method puedeCompletar(unBarco) = super(unBarco) and 
    unBarco.tripulacion().all({p => self.puedeParticipar(p)})
  
}


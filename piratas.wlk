class Barco{
  var property mision
  const property capacidad
  const property tripulacion = #{}
  
  method anadirPirata(unPirata) {
    if (unPirata.esApto(mision) && tripulacion.size() < capacidad){
      tripulacion.add(unPirata)
    }
  }


  //method piratasInaptos(unaMision) = tripulacion.filter({p => !p.esApto(unaMision)})
  method cambiarMision(unaMision) {
    mision = unaMision
    const piratasInaptos = tripulacion.filter({p => !p.esApto(unaMision)})
    tripulacion.removeAll(piratasInaptos)
  }


   

  method echarPirata(unPirata) {
    tripulacion.remove(unPirata)
  }

  method anclar(unaCiudad) {
    tripulacion.forEach({p => p.tomarUnTrago()})
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
  method esVulnerableABarco(unBarco) = self.tripulacion().size() >= unBarco.tripulacion().size() * 0.5 and unBarco.tripulacion().all({p => p.pasadoDeGrog()})
  method esVulnerableAPirata(unPirata) = unPirata.pasadoDeGrog()

  method tripulantesPasadosDeGrog() = tripulacion.filter({p => p.pasadoDeGrog()})
  method cantidadDeTripulantesPasadosDeGrog() = self.tripulantesPasadosDeGrog().size()
  method tripulantePasadoDeGrogConMasDinero() = self.tripulantesPasadosDeGrog().max({p => p.monedas()})
  method cantidadDeItemsPasadosDeGrogEnElBarco() = self.itemsPiratasPasadosDeGrog().size()
  method itemsPiratasPasadosDeGrog() = self.tripulantesPasadosDeGrog().map({p => p.items()}).flatten().asSet()
}

class Pirata{
  var property items
  var property nivelDeEbriedad = 0
  var property monedas = 0
  var property invitadoPor = "nadie"
  var property tripulantesInvitados = 0
  
  method puedeSaquear(unObjetivo) = unObjetivo.esVulnerableAPirata(self)
  method pasadoDeGrog() = nivelDeEbriedad >= 90 and !items.contains("permiso de la corona")
  method esApto(unaMision) = unaMision.puedeParticipar(self)

  method tomarUnTrago() {
    nivelDeEbriedad = (nivelDeEbriedad + 5).min(100)
    monedas = (monedas - 1).max(0)
  }
}



class Mision{  
  method puedeCompletar(unBarco) = unBarco.ocupacion() >= 90
  
}

class BusquedaDelTesoro inherits Mision{
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

  method puedeParticipar(unPirata) = unPirata.items().size() >= 10 and unPirata.items().contains(itemLegendario) //esUtil(unPirata)

  override method puedeCompletar(unBarco) = super(unBarco) and 
  unBarco.tripulacion().all({p => self.puedeParticipar(p)})
}

class Saqueo inherits Mision{
  const property objetivo
  const monedasRequeridas = monedasRequeridasSaqueo.valor()

  method puedeParticipar(unPirata) = unPirata.monedas() < monedasRequeridas and unPirata.puedeSaquear(objetivo)

  override method puedeCompletar(unBarco) = super(unBarco) and 
    unBarco.tripulacion().all({p => self.puedeParticipar(p)})
  
}

object monedasRequeridasSaqueo {
  var property valor = 5
}

class Ciudad{
  var property habitantes

  method esVulnerableABarcoBarco(unBarco) = unBarco.tripulacion().size() >= habitantes * 0.4 or
    unBarco.tripulacion().all({p => p.nivelDeEbriedad() >= 50})
  method esVulnerableAPirata(unPirata) = unPirata.nivelDeEbriedad() >= 50
}
class Barco{
  var property mision
  const property capacidad
  const property tripulacion = []
  
  method anadirPirata(unPirata) {
    if (unPirata.esApto(mision)){
      tripulacion.add(unPirata)
    }
  }

  method ocupacion() = (tripulacion.size() * 100) / capacidad
}

class Pirata{
  var property items
  var property nivelDeEbriedad = 0
  var property monedas = 0
  var property invitadoPor = "nadie"
  var property tripulantesInvitados = #{}


  method pasadoDeGrog() = nivelDeEbriedad >= 90 and !items.contains("permiso de la corona")
  method esApto(unaMision) = unaMision.puedeParticipar(self)

  method tomarUnTrago() {
    nivelDeEbriedad = (nivelDeEbriedad + 5).min(100)
  }

  method sumarMonedas(cantidad) {
    monedas += cantidad
  }
  
  method restarMonedas(cantidad) {
    monedas = (monedas - cantidad).max(0)
  }
}


class Ciudad{

}

class Mision{
  //lalalala
  // var property itemsUtiles
  
  method puedeCompletar(unBarco) = unBarco.ocupacion() >= 90
  
}

class BusquedaDelTesoro inherits Mision{
  // const itemsUtiles = ["brujula", "mapa", "grogXD"]
  override method puedeCompletar(unBarco) =  super(unBarco) and 
    unBarco.tripulacion().all({p => p.monedas() <= 5}) and
    unBarco.tripulacion().all({p => p.items().contains("brujula") or p.items().contains("mapa") or p.items().contains("grogXD")}) and
    unBarco.tripulacion().any({p => p.items().contains("llaveCofre")})
}

class ConvertirseEnLeyenda inherits Mision{
  const property itemLegendario 
  override method puedeCompletar(unBarco) = super()
}

class Saqueo inherits Mision{
  override method puedeCompletar(unBarco) = super()
}
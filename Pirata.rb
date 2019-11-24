class Pirata
    attr_accessor :items
    attr_accessor :invitante
    attr_accessor :nivelEbriedad
    attr_accessor :cantidadMonedas
    def initialize(items, invitante = "nadie", nivelEbriedad, cantidadMonedas)
        @items = items
        @invitante = invitante
        @nivelEbriedad = nivelEbriedad
        @cantidadMonedas = cantidadMonedas
    end
    def tiene?(unItem)
        return @items.include?(unItem)
    end

    def cantidadItems()
        return @items.length
    end

    def pasadoDeGrog()
        return @nivelEbriedad >= 90
    end

    def tomarGrog()
        @nivelEbriedad += 5
        self.gastarMoneda
    end

    def gastarMoneda()
        self.validarGastarMonedas()
        @cantidadMonedas-= 1
    end


    def validarGastarMonedas()
        if(@cantidadMonedas == 0)
            raise "Monedas insuficientes"
        end
    end

    def podesSaquear(unaVictima)
        return unaVictima.sosSaqueablePor(self)
    end


    def fuisteInvitadoPor(unTripulante)
        return unTripulante == @invitante
    end
end

class EspiaDeLaCorona < Pirata
    def pasadoDeGrog
        return false
    end
end


class Barco
    def initialize(capacidad,tripulantes,mision)
        @mision = mision
        @Capacidad = capacidad
        @Tripulantes= tripulantes
    end
    def sosSaqueablePor(unPirata)
        return unPirata.pasadoDeGrog
    end
    def esVulnerableA(otroBarco)
        return self.cantidadTripulantes <= otroBarco.cantidadTripulantes
    end
    def cantidadTripulantes()
        return @Tripulantes.length
    end
    def todosPasadosDeGrog?()
        return @Tripulantes.all? {|tripulante| tripulante.pasadoDeGrog}
    end
    def puedeUnirse?(unPirata)
        return self.hayLugar? && @mision.esUtil(unPirata)
    end

    def hayLugar?()
        return self.cantidadTripulantes < @Capacidad
    end

    def agregar(unTripulante)
        if(self.puedeUnirse?(unTripulante))
            @Tripulantes.push(unTripulante)
            puts("agregado")
        end
    end
    def mostrarTripulantes()
        @Tripulantes.each do |tripulante|
            puts (tripulante)
        end
    end

    def cambiarMision!(unaMision)
        @Tripulantes.select!() {|tripulante| unaMision.esUtil(tripulante) }
        @mision = unaMision
    end

    def pirataMasEbrio()
        return @Tripulantes.max {|tripulante| tripulante.nivelEbriedad}
    end

    def anclarEn(unaCiudad)
        self.todosTomanGrog!()
        self.perderMasEbrioEn!(unaCiudad)
    end

    def todosTomanGrog!()
        @Tripulantes.each {|tripulante| tripulante.tomarGrog()}
    end

    def perderMasEbrioEn!(unaCiudad)
        @Tripulantes.delete(self.pirataMasEbrio())
        unaCiudad.sumarHabitante()
    end

    def esTemible()
        @mision.esRealizablePor(self)
    end
    def tieneSuficienteTripulacion()
        return self.cantidadTripulantes >= @Capacidad * 0.9
    end

    def tiene?(unItem)
        return @Tripulantes.any? {|tripulante| tripulante.tiene?(unItem)}
    end

end

class CiudadCostera
    attr_accessor :cantidadHabitantes
    def initialize (cantidadHabitantes = 0)
        @cantidadHabitantes = cantidadHabitantes
    end
    def sosSaqueablePor(unPirata)
        return unPirata.nivelEbriedad() >= 50
    end
    def esVulnerableA(otroBarco)
        otroBarco.cantidadTripulantes() >= @cantidadHabitantes *0.4 || otroBarco.todosPasadosDeGrog?()
    end
    def sumarHabitante
        @cantidadHabitantes += 1
    end
end


class Mision
    def esRealizablePor(unBarco)
        return unBarco.tieneSuficienteTripulacion
    end
end

class BusquedaDelTesoro < Mision
    def esUtil(unPirata)
        return self.tieneAlgunItemObligatorio(unPirata) && unPirata.cantidadMonedas() <=5
    end
    def tieneAlgunItemObligatorio(unPirata)
        return ["brujula","mapa","grogXD"].any? {|item| unPirata.tiene?(item)}
    end
end

if __FILE__ == $0
    busqueda = BusquedaDelTesoro.new()
    pirata = Pirata.new(["a","s","d","mapa"],100,5)
    puts ("Pruebas pirata: ")
    a = pirata.tiene?("s")
    puts(a)
    puts(pirata.cantidadItems())
    puts(pirata.pasadoDeGrog())
    pirata.tomarGrog
    puts(pirata.cantidadMonedas)
    puts(pirata.nivelEbriedad)
    puts(pirata.fuisteInvitadoPor("we"))
    puts(pirata.fuisteInvitadoPor("nadie"))
    espia = EspiaDeLaCorona.new(["a","d"], "yo", 999,20)
    puts("Pruebas espia: ")
    puts(espia.pasadoDeGrog)
    puts("Pruebas barco: ")
    barquito = Barco.new(20,[pirata], busqueda)
    barcote = Barco.new(20,[pirata,pirata,espia],busqueda)
    puts(barquito.sosSaqueablePor(pirata))
    puts(barquito.cantidadTripulantes)
    puts(barquito.esVulnerableA(barcote))
    puts(barcote.todosPasadosDeGrog?())
    puts(barcote.pirataMasEbrio)
    barquito.agregar(pirata)
    puts(barquito.cantidadTripulantes)
    puts ("pruebas mision: ")
    puts(busqueda.esUtil(pirata))
    puts(busqueda.esUtil(espia))
    gets()

end
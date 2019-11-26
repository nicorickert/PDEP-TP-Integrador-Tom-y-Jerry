require_relative "Mision.rb"
require_relative "CiudadCostera.rb"
require_relative "Barco.rb"

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
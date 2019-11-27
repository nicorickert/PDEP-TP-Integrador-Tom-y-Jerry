require_relative "Mision.rb"
require_relative "CiudadCostera.rb"
require_relative "Barco.rb"

class Pirata
    attr_accessor :items
    attr_accessor :invitante
    attr_accessor :nivelEbriedad
    attr_accessor :cantidadMonedas
    
    def initialize(items: [], invitante: "nadie", nivelEbriedad: 0, cantidadMonedas: 0)  # Keyboard Arguments = Named parameters
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

    def cantidadInvitadosPara(unBarco)
        return unBarco.cantidadInvitadosPor(self)
    end

    def fuisteInvitadoPor(unTripulante)
        return unTripulante == @invitante
    end
end

class EspiaDeLaCorona < Pirata
    def pasadoDeGrog
        return false
    end

    def podesSaquear(unaVictima) 
        return super && self.tiene('permiso de la corona')
    end
end
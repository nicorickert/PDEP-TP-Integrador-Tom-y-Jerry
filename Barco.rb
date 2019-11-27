require_relative 'Pirata.rb'
require_relative 'Mision.rb'
require_relative 'CiudadCostera.rb'

class Barco
    def initialize(capacidad: 0,tripulantes: [],mision: BusquedaDelTesoro.new)
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

    def tripulantesPasadosDeGrog()
        return @Tripulantes.select {|tripulante| tripulante.pasadoDeGrog()}
    end

    def cantidadTripulantesPasadosDeGrog()
        return self.tripulantesPasadosDeGrog().length()
    end

    def cantidadItemsDistintosEntreTripulantesPasadosDeGrog()
        return self.tripulantesPasadosDeGrog().flat_map {|tripulante| tripulante.items()}.uniq.length
    end

    def tripulantePasadosDeGrogConMasMonedas()
        return self.tripulantesPasadosDeGrog().max {|tripulante| tripulante.cantidadMonedas()}
    end 

    def tripulanteMasInvitador() 
        return @Tripulantes.max {|tripulante| tripulante.cantidadInvitadosPara(self)}
    end

    def cantidadInvitadosPor(unTripulante)
        return @Tripulantes.count {|tripulante| tripulante.fuisteInvitadoPor(unTripulante)}
    end
end

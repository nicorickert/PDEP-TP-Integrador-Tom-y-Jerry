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
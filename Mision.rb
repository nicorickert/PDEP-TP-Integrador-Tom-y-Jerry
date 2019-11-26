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

    def esRealizablePor(unBarco)                            # Si no le paso parametros al super, le va a pasar todos los paramentros que reciba el metodo 
        return super && unBarco.tiene("llave de cofre")
    end
end

class ConvertirseEnLeyenda < Mision
    def initialize(itemObligatorio)
        @itemObligatorio = itemObligatorio
    end

    def esUtil(unPirata)
        return unPirata.cantidadItems >= 10 && unPirata.tiene(itemObligatorio)
    end
end

class Saqueo < Mision
    @@limiteMonedas = 0             # Variable de clase, es la misma para cada instancia de esta clase, y se puede cambiar directamente. No hace falta crear el objeto monedasParaSaquear
    
    def initialize(victima)
        @victima = victima
    end

    def esUtil(unPirata)
        return unPirata.cantidadMonedas < @@limiteMonedas && @victima.esVulnerableA(unPirata)
    end

    def esRealizablePor(unBarco)
        return super && victima.esVulnerableA(unBarco)
    end

end

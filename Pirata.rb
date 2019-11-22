class Pirata
    attr_accessor :items
    attr_accessor :invitante
    attr_accessor :nivelEbriedad
    attr_accessor :cantidadMonedas

    def initialize(items, invitante, nivelEbriedad, cantidadMonedas)
        @items = items
        @invitante = invitante
        @nivelEbriedad = nivelEbriedad
        @cantidadMonedas = cantidadMonedas
    end
    def tiene(unItem)
        return @items.include?(unItem)
    end

    def cantidadItems()
        return @items.length
    end

    def pasadoDeGrog()
        return @nivelEbriedad >= 90
    end
    
end


if __FILE__ == $0
    puts("asd")
    pirata = Pirata.new(["a","s","d","f"],"b",100,"d")
    a = pirata.tiene("s")
    puts(a)
    puts(pirata.cantidadItems())
    puts(pirata.pasadoDeGrog())
    gets()

end
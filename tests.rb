require "minitest/autorun"
require_relative 'Pirata.rb'
require_relative 'Mision.rb'
require_relative 'CiudadCostera.rb'
require_relative 'Barco.rb'


class YaarTest < Minitest::Test
    
    def setup  # Fixture
        @barbaNegra = Pirata.new(
            items: ["brújula","cuchillo","cuchillo","diente de oro", "grogXD", "grogXD", "grogXD", "llave de cofre", "pistola", "flex tape"],
            nivelEbriedad: 60,
            cantidadMonedas: 5
        )
        @espia = EspiaDeLaCorona.new(
            items: ["permiso de la corona", "bola de cañon", "desodorante de ambiente", "cuchillo"],
            nivelEbriedad: 55,
            cantidadMonedas: 0
        )
        @barbaRoja = Pirata.new(
            items: ["tuco marolio", "cuchillo", "cuchillo"],
            nivelEbriedad: 90,
            cantidadMonedas: 2,
            invitante: @espia
        )
        
        @busquedaDelTesoro = BusquedaDelTesoro.new
        @maestroDeLaCinta = ConvertirseEnLeyenda.new(itemObligatorio: 'flex tape')
        
        @barcoSaqueable = Barco.new(capacidad: 1, tripulantes: [@barbaNegra], mision: @busquedaDelTesoro)
        @barcoSaqueador = Barco.new(capacidad: 3, tripulantes: [@espia, @barbaRoja], mision: @maestroDeLaCinta)
        
        @lasBahamas = CiudadCostera.new(cantidadHabitantes: 1)
        
        @saqueoALasBahamas = Saqueo.new(victima: @lasBahamas)
        @saqueoAlBarquito = Saqueo.new(victima: @barcoSaqueable)
    end
# Punto 1 - Saber si un pirata es útil para una misión
        
    def test_cantidad_items_barba_negra
        assert_equal 10, @barbaNegra.cantidadItems
    end
    
    def test_es_util_busqueda_tesoro
        assert @busquedaDelTesoro.esUtil(@barbaNegra)
        refute @busquedaDelTesoro.esUtil(@barbaRoja)
    end
    
    def test_es_util_convertirse_en_leyenda
        assert @maestroDeLaCinta.esUtil(@barbaNegra)
        refute @maestroDeLaCinta.esUtil(@espia)
    end
    
    def test_es_util_saqueo
        assert @saqueoALasBahamas.esUtil(@barbaNegra)
        refute @saqueoAlBarquito.esUtil(@barbaNegra)
        assert @saqueoAlBarquito.esUtil(@barbaRoja)
        assert @saqueoALasBahamas.esUtil(@espia)
    end
    
# Punto 2
# a) Saber si un pirata puede formar parte de la tripulacion de un barco

    def test_puede_entrar_al_barco
        refute @barcoSaqueable.puedeUnirse?(@barbaNegra)
        refute @barcoSaqueable.puedeUnirse?(@barbaRoja)
        assert @barcoSaqueador.puedeUnirse?(@barbaNegra)
    end

# b) unir a un pirata a la tripulacion

    def test_unir_pirata_a_barco
        @barcoSaqueador.agregar(@barbaNegra)
        assert_equal 3, @barcoSaqueador.cantidadTripulantes
        @barcoSaqueable.agregar(@barbaRoja)
        assert_equal 1, @barcoSaqueable.cantidadTripulantes
    end

# c) Cambiar de mision un barco

    def test_cambiar_mision
        @barcoSaqueador.cambiarMision!(@busquedaDelTesoro)
        assert_equal 0, @barcoSaqueador.cantidadTripulantes
    end

# Punto 3
# a) Saber quien es el pirata mas ebrio del barco

    def test_pirata_mas_ebrio
        assert_equal @barbaRoja, @barcoSaqueador.pirataMasEbrio
    end

# b) Anclar barco en ciudad

    def test_anclar_en_ciudad
        assert_raises("Monedas insuficientes") do
            @barcoSaqueador.anclarEn(@lasBahamas)
        end
        @barcoSaqueable.anclarEn(@lasBahamas)
        assert_equal 0, @barcoSaqueable.cantidadTripulantes
    end

# Punto 4
# a) Saber si un barco es temible

    def test_barco_temible
        assert @barcoSaqueable.esTemible
        refute @barcoSaqueador.esTemible
    end

# b) Espias de la corona

    def test_espias_corona
        espia2 = EspiaDeLaCorona.new(
            nivelEbriedad: 50000
        )
        refute espia2.pasadoDeGrog
        refute @saqueoAlBarquito.esUtil(espia2)
    end

# Punto 5
# a) Cuantos tripulantes estan pasados

    def test_tripulantes_pasados
        assert_equal 1, @barcoSaqueador.cantidadTripulantesPasadosDeGrog
    end

# b) Items sin repetidos de los pasados

    def test_items_de_los_pasados
        assert_equal 2, @barcoSaqueador.cantidadItemsDistintosEntreTripulantesPasadosDeGrog
    end

#c) Tripulante pasado con mas dinero

    def test_tripulante_pasado_con_mas_dinero
        assert_equal @barbaRoja, @barcoSaqueador.tripulantePasadosDeGrogConMasMonedas
    end

# Punto 6 - Saber que tripulante invito a mas satisfactoriamente

    def test_mas_invitador
        assert_equal @espia, @barcoSaqueador.tripulanteMasInvitador
        refute_equal @barbaRoja, @barcoSaqueador.tripulanteMasInvitador
    end
end
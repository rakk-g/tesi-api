# Animazione per la tesis. Eclosion del modello di Khoury et al. 2011

from manimlib import *

class eclosion( Scene ):
    """ Tasso di schiusa nel modello di sez.3.1 """

    def construct(self):
        axes = Axes(
            x_range=(0, 40000, 10000),
            y_range=(0, 2100, 500),
            height=6,
            width=10,
            # Axes is made of two NumberLine mobjects.  You can specify
            # their configuration with axis_config
            axis_config={
                "stroke_color": GREY_A,
                "stroke_width": 2,
            },
            # Alternatively, you can specify configuration for just one
            # of them, like this.
            # y_axis_config={
            #     "include_tip": False,
            # }
        )
        # Keyword arguments of add_coordinate_labels can be used to
        # configure the DecimalNumber mobjects which it creates and
        # adds to the axes
        axes.add_coordinate_labels(
            font_size=20,
            num_decimal_places=1,
        )
        self.add(axes)
        # qui sembra esserci un autowait?
        # SPACEBAR1

        # eclosion social modulation
        L = 2000 # queen's laying rate
        w1 = 4000
        w2 = 10000
        w3 = 27000
        e1 = lambda N : L*N/(w1+N)
        e2 = lambda N : L*N/(w2+N)
        e3 = lambda N : L*N/(w3+N)
        e1Gra = axes.get_graph( e1, color=PURPLE )
        e2Gra = axes.get_graph( e2, color=GREEN )
        e3Gra = axes.get_graph( e3, color=BLUE )
        asympt = axes.get_graph( lambda N : L )
        da = DashedVMobject(asympt) # I want it dashed
        self.play( ShowCreation(e1Gra), ShowCreation(e2Gra) )
        self.play( ShowCreation(e3Gra), ShowCreation(da)    )
        self.wait()
        # SPACEBAR2

        # Focus on w
        semiMax = DashedVMobject( axes.get_graph( lambda N : L/2 ) )
        self.play( ShowCreation(semiMax) )

        dash1 = DashedLine(
            start=axes.c2p(w1, 0),
            end=axes.c2p(w1, L/2),
            color=PURPLE
        )
        p1 = Dot(axes.c2p(w1, L/2), color=PURPLE) # TODO colore?
        l1 = Tex("w=%d" %w1, color=PURPLE).next_to(axes.c2p(w1, L/2), UP, buff=0.2)
        dash3 = DashedLine(start=axes.c2p(w3, 0), end=axes.c2p(w3, L/2), color=BLUE )
        p3 = Dot(axes.c2p(w3, L/2), color=BLUE) # TODO colore?
        l3 = Tex("w=%d" %w3, color=PURPLE).next_to(axes.c2p(w3, L/2), UP, buff=0.2)

        self.play( ShowCreation(dash1), FadeIn(p1), Write(l1) )
        self.play( ShowCreation(dash3), FadeIn(p3), Write(l3) )
        # # Creazione del testo dell'etichetta

        # # Creazione di un puntino per evidenziare il punto sul grafico
        # # Animazione per aggiungere etichetta e puntino
        # self.play(FadeIn(point), Write(label)) # TODO colore?
        # self.wait()
        # labelA = Tex("w=27000", color=BLUE).next_to(axes.c2p(27000, 1000), DR, buff=0.2)
        # pointA = Dot(axes.c2p(27000, 1000), color=BLUE) # TODO colore?
        # self.play(FadeIn(pointA), Write(labelA)) # TODO colore?

        self.wait()
        # SPACEBAR3

        # omotetia
        newAxes= Axes(
            x_range=(0, 140000, 35000),
            y_range=(0, 2100, 500),
            height=6,
            width=10,
            axis_config={"stroke_color": GREY_A, "stroke_width": 2 }
        )
        # ci riplotto tutto
        new1Gra= newAxes.get_graph(e1, color=PURPLE)
        new2Gra= newAxes.get_graph(e2, color=GREEN)
        new3Gra= newAxes.get_graph(e3, color=BLUE)
        newDa = DashedVMobject( newAxes.get_graph( lambda N : L ) )
        newAxes.add_coordinate_labels() # add axes values again

        self.play(
            Transform(axes,newAxes),
            Transform( e1Gra,new1Gra ),
            Transform( e2Gra,new2Gra ),
            Transform( e3Gra,new3Gra ),
            Transform( da,newDa )
        )



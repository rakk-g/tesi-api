# Animazione per la tesis. Eclosion del modello di Khoury et al. 2011

from manimlib import *

class eclosion( Scene ):
    """ Tasso di schiusa nel modello di sez.3.1 """

    def construct(self):
        axes = Axes( # first one
            x_range=(0, 40000, 10000),
            y_range=(0, 2300, 500),
            height=6,
            width=10,
            # Axes is made of two NumberLine mobjects.  You can specify
            # their configuration with axis_config
            axis_config={
                "stroke_color": GREY_A,
                "stroke_width": 2,
                "include_tip" : True
            },
            y_axis_config={
                "include_ticks"  : False,
                "include_numbers": False
            },
            x_axis_config={"include_numbers": True}

        )
        self.add(axes)
        labia=axes.get_axis_labels("N", "E")
        self.add(axes,labia)
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
        self.play( ShowCreation(e1Gra) )
        self.play( ShowCreation(e2Gra) )
        self.play( ShowCreation(e3Gra) )
        self.play( ShowCreation(da)    )
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
        l1 = Tex("w=%d" %w1, color=PURPLE, font_size=20).next_to(axes.c2p(w1,0), DOWN, buff=0.2)
        dash3 = DashedLine(start=axes.c2p(w3, 0), end=axes.c2p(w3, L/2), color=BLUE )
        p3 = Dot(axes.c2p(w3, L/2), color=BLUE) # TODO colore?
        l3 = Tex("w=%d" %w3, color=PURPLE, font_size=20).next_to(axes.c2p(w3, 0), DOWN, buff=0.2)

        self.play( ShowCreation(dash1), FadeIn(p1), Write(l1) )
        self.play( ShowCreation(dash3), FadeIn(p3), Write(l3) )
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
        np1 = Dot(newAxes.c2p(w1, L/2), color=PURPLE) # TODO colore?
        np3 = Dot(newAxes.c2p(w3, L/2), color=BLUE) # TODO colore?

        self.remove(dash1,dash3,l1,l3)
        self.play(
            Transform(axes,newAxes),
            Transform( e1Gra,new1Gra ),
            Transform( e2Gra,new2Gra ),
            Transform( e3Gra,new3Gra ),
            Transform( da,newDa ),
            Transform( p1,np1 ),
            Transform( p3,np3 )
        )



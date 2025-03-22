from migen import *

from litex.soc.interconnect.csr import *
from litex.gen import *

class PwmModule(LiteXModule):
    def __init__(self, pad_POS, pad_NEG, clock_domain="sys"):
        
        self.enable = CSRStorage(size=1, reset=0, description="Enable the PWM peripheral")
        self.period = CSRStorage(size=16, reset=0)
        self.duty = CSRStorage(size=16, reset=0)

        self.counter = Signal(16, reset=0)

        self.specials += Instance( "motor_pwm_phase",
                                   i_i_clk = ClockSignal(clock_domain),
                                   i_i_reset = ResetSignal(clock_domain),
                                   i_i_enable = 1, #self.enable.storage,
                                   i_i_period = 1000, #self.period.storage,
                                   i_i_duty = 500, #self.duty.storage,
                                   i_i_deadband = 0,
                                   i_i_counter = self.counter,
                                   o_o_padPOS = pad_POS,
                                   o_o_padNEG = pad_NEG )

        #self.divider = CSRStorage(size=16, reset=0, description="Clock divider")
        #self.maxCount = CSRStorage(size=16, reset=0, description="Max count for the PWM counter")
        #self.dutycycle = CSRStorage(size=16, reset=0, description="IO dutycycle value")
        
        #divcounter = Signal(16, reset=0)
        #pwmcounter = Signal(16, reset=0)
        
        sync = getattr(self.sync, clock_domain)
        
        #sync += [
        #    If(self.enable.storage,
        #        divcounter.eq(divcounter + 1),
        #            If(divcounter >= self.divider.storage,
        #                divcounter.eq(0),
        #                pwmcounter.eq(pwmcounter + 1),
        #                If(pwmcounter >= self.maxCount.storage,
        #                    pwmcounter.eq(0),
        #                ),
        #            )
        #        )
        #    ]
        #            
        #sync += pad.eq(self.enable.storage & (pwmcounter < self.dutycycle.storage))

        sync += [
            self.counter.eq( self.counter + 1 ),

            If( self.counter >= 1000,
                self.counter.eq( 0 )
            )
            ]
        

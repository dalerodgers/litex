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
                                   i_iCLK = ClockSignal(clock_domain),
                                   i_iRESET = ResetSignal(clock_domain),
                                   i_iENABLE = 1, #self.enable.storage,
                                   i_iPERIOD = 1000, #self.period.storage,
                                   i_iDUTY = 500, #self.duty.storage,
                                   i_iDEADBAND = 0,
                                   i_iCOUNTER = self.counter,
                                   o_oPAD_P = pad_POS,
                                   o_oPAD_N = pad_NEG )
        
        sync = getattr(self.sync, clock_domain)

        sync += [
            self.counter.eq( self.counter + 1 ),

            If( self.counter >= 1000,
                self.counter.eq( 0 )
            )
            ]

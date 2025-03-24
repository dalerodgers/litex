from migen import *

from litex.soc.interconnect.csr import *
from litex.gen import *

class PwmModule(LiteXModule):
    def __init__( self,
                  PA_P, PA_N,
                  PB_P, PB_N,
                  PC_P, PC_N,
                  clock_domain="sys" ):
        
        self.enable = CSRStorage(size=1, reset=1, description="Enable the PWM peripheral")
        self.period = CSRStorage(size=16, reset=1000, description="Period (in counts)")
        self.deadband = CSRStorage(size=16, reset=20, description="Deadband time (in counts)")
        
        self.dutyA = CSRStorage(size=16, reset=500, description="Phase A duty time (in counts)")
        self.dutyB = CSRStorage(size=16, reset=200,description="Phase A duty time (in counts)")
        self.dutyC = CSRStorage(size=16, reset=100,description="Phase A duty time (in counts)")

        self.specials += Instance( "motor_pwm",
                                   i_iCLK = ClockSignal(clock_domain),
                                   i_iENABLE = self.enable.storage,
                                   i_iPERIOD = self.period.storage,
                                   i_iDEADBAND = self.deadband.storage,
                                   i_iDUTY_A = self.dutyA.storage,
                                   i_iDUTY_B = self.dutyB.storage,
                                   i_iDUTY_C = self.dutyC.storage,
                                   o_oPAD_AP = PA_P,
                                   o_oPAD_AN = PA_N,
                                   o_oPAD_BP = PB_P,
                                   o_oPAD_BN = PB_N,
                                   o_oPAD_CP = PC_P,
                                   o_oPAD_CN = PC_N )


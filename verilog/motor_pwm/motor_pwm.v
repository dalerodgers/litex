`include "motor_pwm_phase.v"

module motor_pwm #(parameter SIZE=16)(
                    iCLK, iENABLE,
                    iPERIOD, iDEADBAND,
                    iDUTY_A, iDUTY_B, iDUTY_C,
                    oPAD_AP, oPAD_AN,
                    oPAD_BP, oPAD_BN,
                    oPAD_CP, oPAD_CN );
  
  // .....................................................
  
  input iCLK, iENABLE;
  input [SIZE-1:0] iPERIOD, iDEADBAND;
  input [SIZE-1:0] iDUTY_A, iDUTY_B, iDUTY_C;
  output oPAD_AP, oPAD_AN;
  output oPAD_BP, oPAD_BN;
  output oPAD_CP, oPAD_CN;

  reg [SIZE-1:0] counter;

  motor_pwm_phase phaseA ( iCLK, iENABLE,
                           iPERIOD, iDUTY_A, iDEADBAND,
                           counter,
                           oPAD_AP, oPAD_AN );

  motor_pwm_phase phaseB ( iCLK, iENABLE,
                           iPERIOD, iDUTY_B, iDEADBAND,
                           counter,
                           oPAD_BP, oPAD_BN );

  motor_pwm_phase phaseC ( iCLK, iENABLE,
                           iPERIOD, iDUTY_C, iDEADBAND,
                           counter,
                           oPAD_CP, oPAD_CN );
  
  // .....................................................
  
  initial begin
    counter = 0;
  end
  
  // .....................................................
  
  always @( posedge iCLK or negedge iENABLE )
  begin
    if( !iENABLE ) begin

      counter <= 16'hFFFF;

    end else begin

      counter <= counter + 1;

      if( counter >= iPERIOD ) begin
        counter <= 0;
      end

    end
  end
  
  // .....................................................
  
endmodule

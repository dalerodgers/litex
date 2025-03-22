module motor_pwm_phase #(parameter SIZE=16)( i_clk, i_reset, i_enable,
                        i_period, i_duty, i_deadband,
                        i_counter,
                        o_padPOS, o_padNEG );
  
  // .....................................................
  
  input i_clk, i_reset, i_enable;
  input [SIZE-1:0] i_period, i_duty, i_deadband, i_counter;
  output o_padPOS, o_padNEG;
  
  reg [SIZE-1:0] A, B, C, D;
  reg padPOS, padNEG;
  
  // .....................................................
  
  initial begin
    padPOS <= 0;
    padNEG <= 1;
  end
  
  // .....................................................
  
  always @(negedge i_clk or posedge i_reset)
  begin
    if( i_reset || !i_enable ) begin
      padPOS <= 0;
      padNEG <= 1;
    end else begin
      if( i_counter == 0 ) begin
        A = ( i_period - i_duty ) >> 1;
        B = A + i_deadband;
        C = A + i_duty;
        D = C + i_deadband;
      end
      
      if( ( i_counter < A ) || ( i_counter > D ) ) begin
        padNEG <= 1;
      end else begin
        padNEG <= 0;
      end
      
      if( ( i_counter < B ) || ( i_counter > C ) ) begin
        padPOS <= 0;
      end else begin
        padPOS <= 1;
      end
    end
  end
  
  // .....................................................
  
  assign o_padPOS = padPOS;
  assign o_padNEG = padNEG;
  
  // .....................................................
  
endmodule

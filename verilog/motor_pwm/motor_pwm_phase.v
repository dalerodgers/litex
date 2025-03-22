module motor_pwm_phase #(parameter SIZE=16)(
                        iCLK, iENABLE,
                        iPERIOD, iDUTY, iDEADBAND,
                        iCOUNTER,
                        oPAD_P, oPAD_N );
  
  // .....................................................
  
  input iCLK, iENABLE;
  input [SIZE-1:0] iPERIOD, iDUTY, iDEADBAND, iCOUNTER;
  output oPAD_P, oPAD_N;
  
  reg [SIZE-1:0] A, B, C, D;
  reg pad_p, pad_n;
  
  // .....................................................
  
  initial begin
    pad_p <= 0;
    pad_n <= 1;

    A = -16'd1;
    B = -16'd1;
    C = 0;
    D = 0;
  end
  
  // .....................................................
  
  always @( negedge iCLK or negedge iENABLE )
  begin
    if( !iENABLE ) begin

      pad_p <= 0;
      pad_n <= 1;

      A = -16'd1;
      B = -16'd1;
      C = 0;
      D = 0;

    end else begin
      if( iCOUNTER == 0 ) begin
        A = ( iPERIOD - iDUTY ) >> 1;
        B = A + iDEADBAND;
        C = A + iDUTY;
        D = C + iDEADBAND;
      end
  
      if( ( iCOUNTER < A ) || ( iCOUNTER > D ) ) begin
        pad_n <= 1;
      end else begin
        pad_n <= 0;
      end
      
      if( ( iCOUNTER < B ) || ( iCOUNTER > C ) ) begin
        pad_p <= 0;
      end else begin
        pad_p <= 1;
      end

    end
  end
  
  // .....................................................
  
  assign oPAD_P = pad_p;
  assign oPAD_N = pad_n;
  
  // .....................................................
  
endmodule

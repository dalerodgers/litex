//`include "jeff.v"

// Testbench
module test;

  localparam SIZE = 16;
  
  reg clk, enable;
  reg [SIZE-1:0] period, duty, deadband, counter;
  wire padPOS, padNEG;
  
  // .....................................................
  
  motor_pwm_phase DUT( clk, enable,
                       period, duty, deadband,
                       counter,
                       padPOS, padNEG );
  
  initial begin
    clk = 0;
    forever begin
      #1 clk = 1;
      #0 counter++;
      if( counter >= period ) begin
        counter = 0;
      end
      #1 clk = 0;
    end
  end
  
  initial begin  
    $display("Reset"); 
    enable = 1;
    period = 1000;
    duty = 500;
    deadband = 33;
    counter = 0;
    
    #20
    counter = 0;
    #1 enable = 1;
    
    #30
    #1 enable = 0;
    #3000

    #0 enable = 1;
    #0 duty = 250;
    #3000
    
    $finish;
  end
  
  initial begin
    $dumpfile("test.vcd");
    $dumpvars(1, test);
  end

endmodule
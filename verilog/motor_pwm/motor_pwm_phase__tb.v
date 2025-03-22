//`include "jeff.v"

// Testbench
module test;

  localparam SIZE = 16;
  
  reg clk, reset, enable;
  reg [SIZE-1:0] period, duty, deadband, counter;
  wire padPOS, padNEG;
  
  // .....................................................
  
  motor_pwm_phase DUT( clk, reset, enable,
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
    reset = 0;
    enable = 0;
    period = 1000;
    duty = 500;
    deadband = 33;
    counter = 0;
    
    #20
    
    counter = 0;
    enable = 1;
    
    #3000
    enable = 0;
    #3000
    
    $finish;
  end
  
  initial begin
    $dumpfile("test.vcd");
    $dumpvars(0, test);
  end
  
  //reg clk;
  //reg reset;
  //reg d;
  //wire q;
  //wire qb;
  
  // Instantiate design under test
  //motor_pwm_phase DFF(.clk(clk), .reset(reset),
  //        .d(d), .q(q), .qb(qb));
  //        
  //initial begin
    // Dump waves
  //  $dumpfile("dump.vcd");
  //  $dumpvars(1);
    
  //  $display("Reset flop.");
  //  clk = 0;
  //  reset = 1;
  //  d = 1'bx;
  //  display;
    
  //  $display("Release reset.");
  //  d = 1;
  //  reset = 0;
  //  display;

  //  $display("Toggle clk.");
  //  clk = 1;
  //  display;
  //end
  
  //task display;
  //  #1 $display("d:%0h, q:%0h, qb:%0h",
  //    d, q, qb);
  //endtask
  
  

endmodule
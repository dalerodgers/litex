// Testbench
module test;

  localparam SIZE = 16;
  
  reg clk, enable;
  reg [SIZE-1:0] period, deadband, duty_A, duty_B, duty_C;
  wire PAD_AP, PAD_AN;
  wire PAD_BP, PAD_BN;
  wire PAD_CP, PAD_CN;
  
  // .....................................................
  
  motor_pwm DUT( clk, enable,
                 period, deadband,
                 duty_A, duty_B, duty_C,
                 PAD_AP, PAD_AN,
                 PAD_BP, PAD_BN,
                 PAD_CP, PAD_CN );
  
  initial begin
    clk = 0;
    forever begin
      #1 clk = 1;
      #1 clk = 0;
    end
  end
  
  initial begin  
    $display("Reset"); 
    enable = 0;
    period = 1000;
    duty_A = 500;
    duty_B = 300;
    duty_C = 200;
    deadband = 33;
    
    #20
    #1 enable = 1;
    
    #30
    #1 enable = 0;
    #3000

    #0 enable = 1;
    #3000
    
    $finish;
  end
  
  initial begin
    $dumpfile("test.vcd");
    $dumpvars(0, test);
  end

endmodule
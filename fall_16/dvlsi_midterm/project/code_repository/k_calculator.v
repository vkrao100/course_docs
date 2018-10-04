//################################################################################################################
//Project  : Bitcoin Hashing
//Course   : ECE6710 FALL 2016
//Group    : 5710_12
//Author(s): Vikas Rao, Yomi Karthik Rupesh, Rajath Bindigan, Sreejita Saha
//Module   : k calculator 
//description: this module performs k value calculations that are required for the SHA-256 expansion stage
//             The k values are 64 32-bit constants that are initialized to the first 32 bits of the fractional
//             parts of the cube roots of the first 64 prime numbers
//			   All the operations are on 32 bit Dword registers.
//################################################################################################################



module k_calculator(
                          input wire  [5 : 0] address_input,
                          output wire [31 : 0] output_k
                         );

  //-------------------------------------------------------------------
  //Register
  //-------------------------------------------------------------------
  reg [31 : 0] K_slot;


  //-------------------------------------------------------------------
  // Concurrent connectivity for ports etc.
  //-------------------------------------------------------------------
  assign output_k = K_slot;


  //-------------------------------------------------------------------
  // address mux. Puts in the k values into the 32-bit K_slot register
  //-------------------------------------------------------------------
  always @*
    begin : addr_mux
      case(address_input)
        00: K_slot = 32'h428a2f98;
        01: K_slot = 32'h71374491;
        02: K_slot = 32'hb5c0fbcf;
        03: K_slot = 32'he9b5dba5;
        04: K_slot = 32'h3956c25b;
        05: K_slot = 32'h59f111f1;
        06: K_slot = 32'h923f82a4;
        07: K_slot = 32'hab1c5ed5;
        08: K_slot = 32'hd807aa98;
        09: K_slot = 32'h12835b01;
        10: K_slot = 32'h243185be;
        11: K_slot = 32'h550c7dc3;
        12: K_slot = 32'h72be5d74;
        13: K_slot = 32'h80deb1fe;
        14: K_slot = 32'h9bdc06a7;
        15: K_slot = 32'hc19bf174;
        16: K_slot = 32'he49b69c1;
        17: K_slot = 32'hefbe4786;
        18: K_slot = 32'h0fc19dc6;
        19: K_slot = 32'h240ca1cc;
        20: K_slot = 32'h2de92c6f;
        21: K_slot = 32'h4a7484aa;
        22: K_slot = 32'h5cb0a9dc;
        23: K_slot = 32'h76f988da;
        24: K_slot = 32'h983e5152;
        25: K_slot = 32'ha831c66d;
        26: K_slot = 32'hb00327c8;
        27: K_slot = 32'hbf597fc7;
        28: K_slot = 32'hc6e00bf3;
        29: K_slot = 32'hd5a79147;
        30: K_slot = 32'h06ca6351;
        31: K_slot = 32'h14292967;
        32: K_slot = 32'h27b70a85;
        33: K_slot = 32'h2e1b2138;
        34: K_slot = 32'h4d2c6dfc;
        35: K_slot = 32'h53380d13;
        36: K_slot = 32'h650a7354;
        37: K_slot = 32'h766a0abb;
        38: K_slot = 32'h81c2c92e;
        39: K_slot = 32'h92722c85;
        40: K_slot = 32'ha2bfe8a1;
        41: K_slot = 32'ha81a664b;
        42: K_slot = 32'hc24b8b70;
        43: K_slot = 32'hc76c51a3;
        44: K_slot = 32'hd192e819;
        45: K_slot = 32'hd6990624;
        46: K_slot = 32'hf40e3585;
        47: K_slot = 32'h106aa070;
        48: K_slot = 32'h19a4c116;
        49: K_slot = 32'h1e376c08;
        50: K_slot = 32'h2748774c;
        51: K_slot = 32'h34b0bcb5;
        52: K_slot = 32'h391c0cb3;
        53: K_slot = 32'h4ed8aa4a;
        54: K_slot = 32'h5b9cca4f;
        55: K_slot = 32'h682e6ff3;
        56: K_slot = 32'h748f82ee;
        57: K_slot = 32'h78a5636f;
        58: K_slot = 32'h84c87814;
        59: K_slot = 32'h8cc70208;
        60: K_slot = 32'h90befffa;
        61: K_slot = 32'ha4506ceb;
        62: K_slot = 32'hbef9a3f7;
        63: K_slot = 32'hc67178f2;
      endcase 
    end //addr_mux
endmodule 

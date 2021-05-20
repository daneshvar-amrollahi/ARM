module TB();

	reg clk = 1'b0, rst = 1'b0, frwrd_mode = 1'b1;

	ARM ARM(.clk(clk), .rst(rst), .frwrd_mode(frwrd_mode));

	initial begin
	  	#200
		clk = 1'b0;
		repeat(2000) begin
		  	clk = ~clk;
			#100;
		end
	end

	
	initial begin
		#10
		rst = 1'b1;
		#140
		rst = 1'b0;
	end

endmodule
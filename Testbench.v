module TB();

	reg clk = 1'b0, rst = 1'b0;

	ARM ARM(.clk(clk), .rst(rst));

	initial begin
	  	#200
		clk = 1'b0;
		repeat(1000) begin
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
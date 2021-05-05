`include "defines.v"
`include "inst_defs.v"

module ControlUnit(
		mode, opcode, s,
		exe_cmd, mem_read, mem_write,
		wb_enable, branch_taken, status_write_enable
		);

	input[`MODE_LEN - 1 : 0] mode;
	input[`OPCODE_LEN - 1 : 0] opcode;
	input s;
	output reg[`EXECUTE_COMMAND_LEN - 1 : 0] exe_cmd;
	output reg mem_read, mem_write, wb_enable,
			branch_taken, status_write_enable;


	always @(mode, opcode, s) begin
		exe_cmd = 0; mem_read = 0;
		mem_write = 0; wb_enable = 0;
		branch_taken = 0;
		status_write_enable = 0;

		case (mode)
			`ARITHMETHIC_TYPE : begin
				case (opcode) 
					`MOV : begin
						wb_enable = 1'b1;
						status_write_enable = s;
						exe_cmd = `MOV;
					end
					
					`MVN : begin
						wb_enable = 1'b1;
						status_write_enable = s;
						exe_cmd = `MVN;
					end
					
					`ADD : begin
						wb_enable = 1'b1;
						status_write_enable = s;
						exe_cmd = `ADD;
					end
					
					`ADC : begin
						wb_enable = 1'b1;
						status_write_enable = s;
						exe_cmd = `ADC;
					end
					
					`SUB : begin
						wb_enable = 1'b1;
						status_write_enable = s;
						exe_cmd = `SUB;
					end		
					
					`SBC : begin
						wb_enable = 1'b1;
						status_write_enable = s;
						exe_cmd = `SBC;
					end
					
					`AND : begin
						wb_enable = 1'b1;
						status_write_enable = s;
						exe_cmd = `AND;
					end
					
					`ORR : begin
						wb_enable = 1'b1;
						status_write_enable = s;
						exe_cmd = `ORR;
					end

					`EOR : begin
						wb_enable = 1'b1;
						status_write_enable = s;
						exe_cmd = `EOR;
					end
					
					`CMP : begin
						wb_enable = 1'b0;
						status_write_enable = 1'b1;
						exe_cmd = `CMP;
					end

					`TST: begin
						wb_enable = 1'b0;
						status_write_enable = 1'b1;
						exe_cmd = `TST;
					end

				endcase
			end

			`MEMORY_TYPE : begin
				case (s) 
					`S_LDR: begin
						wb_enable = 1'b1;
						status_write_enable = 1'b1;
						exe_cmd = `LDR;
						mem_read = 1'b1;
					end

					`S_STR: begin
						wb_enable = 1'b0;
						status_write_enable = 1'b0;
						exe_cmd = `STR;
						mem_write = 1'b1;
					end
				endcase
			end

			`BRANCH_TYPE : begin
				branch_taken = 1'b1;
			end
		endcase

	end
	
endmodule
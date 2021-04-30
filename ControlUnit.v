`include "defines.v"
`include "inst_defs.v"

module ControlUnit(
		mode, opcode, s,
		exe_cmd, mem_read, mem_write,
		wb_enable, branch_taken, status_write_enable,
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
						exe_cmd = `MOV_EXE;
					end
					
					`MVN : begin
						wb_enable = 1'b1;
						status_write_enable = s;
						exe_cmd = `MOVN_EXE;
					end
					
					`ADD : begin
						wb_enable = 1'b1;
						status_write_enable = s;
						exe_cmd = `ADD_EXE;
					end
					
					`ADC : begin
						wb_enable = 1'b1;
						status_write_enable = s;
						exe_cmd = `ADC_EXE;
					end
					
					`SUB : begin
						wb_enable = 1'b1;
						status_write_enable = s;
						exe_cmd = `SUB_EXE;
					end		
					
					`SBC : begin
						wb_enable = 1'b1;
						status_write_enable = s;
						exe_cmd = `SBC_EXE;
					end
					
					`AND : begin
						wb_enable = 1'b1;
						status_write_enable = s;
						exe_cmd = `AND_EXE;
					end
					
					`ORR : begin
						wb_enable = 1'b1;
						status_write_enable = s;
						exe_cmd = `ORR_EXE;
					end

					`EOR : begin
						wb_enable = 1'b1;
						status_write_enable = s;
						exe_cmd = `EOR_EXE;
					end
					
					`CMP : begin
						wb_enable = 1'b0;
						status_write_enable = 1'b1;
						exe_cmd = `CMP_EXE;
					end

					`TST: begin
						wb_enable = 1'b0;
						status_write_enable = 1'b1;
						exe_cmd = `TST_EXE;
					end

					// `LDR : begin end

					// `STR : begin end
				endcase
			end

			`MEMORY_TYPE : begin
				case (s) 
					`S_LDR: begin
						wb_enable = 1'b1;
						status_write_enable = 1'b1;
						exe_cmd = `LDR_EXE;
						mem_read = 1'b1;
					end

					`S_STR: begin
						wb_enable = 1'b0;
						status_write_enable = 1'b0;
						exe_cmd = `STR_EXE;
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
`include "defines.v"
`include "inst_defs.v"

module ControlUnit(
		mode, opcode, s,
		execute_command, mem_read, mem_write,
		wb_enable, immediate,
		branch_taken, status_write_enable
		);

	input[`MODE_LEN - 1 : 0] mode; 
	input[`OPCODE_LEN - 1 : 0] opcode;
	input s;
	output wire[`EXECUTE_COMMAND_LEN - 1 : 0] exe_cmd;
	output wire mem_read, mem_write, wb_enable,
			branch_taken, status_write_enable;

	reg mem_read_reg, mem_write_reg,
			wb_enable_reg, branch_taken_reg, status_wrt_en_reg;

	always @(mode, opcode, s) begin
		exe_cmd_reg = 0; mem_read_reg = 0;
		mem_write_reg = 0; wb_enable_reg = 0;
		branch_taken_reg = 0;
		status_wrt_en_reg = 0;

		case (mode)
			`ARITHMETHIC_TYPE : begin
				case (opcode) begin
					`MOV : begin
						wb_enable_reg = 1'b1;
						status_wrt_en_reg = s;
						exe_cmd_reg = `MOV_EXE;
					end
					
					`MVN : begin
						wb_enable_reg = 1'b1;
						status_wrt_en_reg = s;
						exe_cmd_reg = `MOVN_EXE;
					end
					
					`ADD : begin
						wb_enable_reg = 1'b1;
						status_wrt_en_reg = s;
						exe_cmd_reg = `ADD_EXE;
					end
					
					`ADC : begin
						wb_enable_reg = 1'b1;
						status_wrt_en_reg = s;
						exe_cmd_reg = `ADC_EXE;
					end
					
					`SUB : begin
						wb_enable_reg = 1'b1;
						status_wrt_en_reg = s;
						exe_cmd_reg = `SUB_EXE;
					end		
					
					`SBC : begin
						wb_enable_reg = 1'b1;
						status_wrt_en_reg = s;
						exe_cmd_reg = `SBC_EXE;
					end
					
					`AND : begin
						wb_enable_reg = 1'b1;
						status_wrt_en_reg = s;
						exe_cmd_reg = `AND_EXE;
					end
					
					`ORR : begin
						wb_enable_reg = 1'b1;
						status_wrt_en_reg = s;
						exe_cmd_reg = `ORR_EXE;
					end

					`EOR : begin
						wb_enable_reg = 1'b1;
						status_wrt_en_reg = s;
						exe_cmd_reg = `EOR_EXE;
					end
					
					`CMP : begin
						wb_enable_reg = 1'b0;
						status_wrt_en_reg = 1'b1;
						exe_cmd_reg = `CMP_EXE;
					end

					`TST: begin
						wb_enable_reg = 1'b0;
						status_wrt_en_reg = 1'b1;
						exe_cmd_reg = `TST_EXE;
					end

					// `LDR : begin end

					// `STR : begin end
				end
			end

			`MEMORY_TYPE : begin
				case (s) begin
					`S_LDR: begin
						wb_enable_reg = 1'b1;
						status_wrt_en_reg = 1'b0;
						exe_cmd_reg = `LDR_EXE;
					end

					`S_STR: begin
						wb_enable_reg = 1'b0;
						status_wrt_en_reg = 1'b0;
						exe_cmd_reg = `STR_EXE;
					end
				end
			end

			`BRANCH_TYPE : begin
				branch_taken_reg = 1'b1;
			end
		end

	// assign immediate = immediate_reg;
	assign exe_cmd = exe_cmd_reg;
	assign mem_read = mem_read_reg;
	assign mem_write = mem_write_reg;
	assign wb_enable = wb_enable_reg;
	assign branch_taken = branch_taken_reg;
	assign status_write_enable = status_wrt_en_reg;

endmodule
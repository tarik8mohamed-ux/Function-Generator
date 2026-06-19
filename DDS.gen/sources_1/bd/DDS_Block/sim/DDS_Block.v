//Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
//Copyright 2022-2025 Advanced Micro Devices, Inc. All Rights Reserved.
//--------------------------------------------------------------------------------
//Tool Version: Vivado v.2025.2 (win64) Build 6299465 Fri Nov 14 19:35:11 GMT 2025
//Date        : Fri Jun 19 14:41:14 2026
//Host        : Tarik running 64-bit major release  (build 9200)
//Command     : generate_target DDS_Block.bd
//Design      : DDS_Block
//Purpose     : IP block netlist
//--------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* CORE_GENERATION_INFO = "DDS_Block,IP_Integrator,{x_ipVendor=xilinx.com,x_ipLibrary=BlockDiagram,x_ipName=DDS_Block,x_ipVersion=1.00.a,x_ipLanguage=VERILOG,numBlks=13,numReposBlks=13,numNonXlnxBlks=0,numHierBlks=0,maxHierDepth=0,numSysgenBlks=0,numHlsBlks=0,numHdlrefBlks=3,numPkgbdBlks=0,bdsource=USER,synth_mode=Hierarchical}" *) (* HW_HANDOFF = "DDS_Block.hwdef" *) 
module DDS_Block
   (ABS_FFT,
    enable_0,
    frame_size_0,
    tuning_word_0);
  (* X_INTERFACE_INFO = "xilinx.com:signal:data:1.0 DATA.ABS_FFT DATA" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME DATA.ABS_FFT, LAYERED_METADATA xilinx.com:interface:datatypes:1.0 {DATA {datatype {name {attribs {resolve_type immediate dependency {} format string minimum {} maximum {}} value data} bitwidth {attribs {resolve_type generated dependency bitwidth format long minimum {} maximum {}} value 32} bitoffset {attribs {resolve_type immediate dependency {} format long minimum {} maximum {}} value 0} integer {signed {attribs {resolve_type generated dependency signed format bool minimum {} maximum {}} value TRUE}}}} DATA_WIDTH 32}" *) output [31:0]ABS_FFT;
  input enable_0;
  input [15:0]frame_size_0;
  input [15:0]tuning_word_0;

  wire [31:0]ABS_FFT;
  wire enable_0;
  wire [15:0]frame_size_0;
  wire [7:0]full_wave_axis_0_m_axis_tdata;
  wire full_wave_axis_0_m_axis_tlast;
  wire full_wave_axis_0_m_axis_tvalid;
  wire [31:0]mult_gen_0_P;
  wire [31:0]mult_gen_1_P;
  wire [6:0]phase_accumulator_0_addr;
  wire phase_accumulator_0_half_cycle;
  wire reset_0_1;
  wire sim_clk_gen_0_clk;
  wire [6:0]sine_table_0_sine_val;
  wire [15:0]tuning_word_0;
  wire [31:0]xfft_0_m_axis_data_tdata;
  wire xfft_0_s_axis_data_tready;
  wire [31:0]xlconcat_0_dout;
  wire [15:0]xlconstant_0_dout;
  wire [7:0]xlconstant_1_dout;
  wire [15:0]xlslice_0_Dout;
  wire [15:0]xlslice_1_Dout;

  DDS_Block_c_addsub_0_0 c_addsub_0
       (.A(mult_gen_0_P),
        .B(mult_gen_1_P),
        .CLK(sim_clk_gen_0_clk),
        .S(ABS_FFT));
  DDS_Block_full_wave_axis_0_0 full_wave_axis_0
       (.clk(sim_clk_gen_0_clk),
        .frame_size(frame_size_0),
        .half_cycle(phase_accumulator_0_half_cycle),
        .m_axis_tdata(full_wave_axis_0_m_axis_tdata),
        .m_axis_tlast(full_wave_axis_0_m_axis_tlast),
        .m_axis_tready(xfft_0_s_axis_data_tready),
        .m_axis_tvalid(full_wave_axis_0_m_axis_tvalid),
        .reset(reset_0_1),
        .sine_val(sine_table_0_sine_val));
  DDS_Block_mult_gen_0_0 mult_gen_0
       (.A(xlslice_0_Dout),
        .B(xlslice_0_Dout),
        .CLK(sim_clk_gen_0_clk),
        .P(mult_gen_0_P));
  DDS_Block_mult_gen_0_1 mult_gen_1
       (.A(xlslice_1_Dout),
        .B(xlslice_1_Dout),
        .CLK(sim_clk_gen_0_clk),
        .P(mult_gen_1_P));
  DDS_Block_phase_accumulator_0_0 phase_accumulator_0
       (.addr(phase_accumulator_0_addr),
        .clk(sim_clk_gen_0_clk),
        .enable(enable_0),
        .half_cycle(phase_accumulator_0_half_cycle),
        .reset(reset_0_1),
        .tuning_word(tuning_word_0));
  DDS_Block_sim_clk_gen_0_0 sim_clk_gen_0
       (.clk(sim_clk_gen_0_clk),
        .sync_rst(reset_0_1));
  DDS_Block_sine_table_0_0 sine_table_0
       (.addr(phase_accumulator_0_addr),
        .sine_val(sine_table_0_sine_val));
  DDS_Block_xfft_0_0 xfft_0
       (.aclk(sim_clk_gen_0_clk),
        .m_axis_data_tdata(xfft_0_m_axis_data_tdata),
        .m_axis_data_tready(1'b1),
        .s_axis_config_tdata({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .s_axis_config_tvalid(1'b0),
        .s_axis_data_tdata(xlconcat_0_dout),
        .s_axis_data_tlast(full_wave_axis_0_m_axis_tlast),
        .s_axis_data_tready(xfft_0_s_axis_data_tready),
        .s_axis_data_tvalid(full_wave_axis_0_m_axis_tvalid));
  DDS_Block_xlconcat_0_0 xlconcat_0
       (.In0(full_wave_axis_0_m_axis_tdata),
        .In1(xlconstant_1_dout),
        .In2(xlconstant_0_dout),
        .dout(xlconcat_0_dout));
  DDS_Block_xlconstant_0_0 xlconstant_0
       (.dout(xlconstant_0_dout));
  DDS_Block_xlconstant_0_1 xlconstant_1
       (.dout(xlconstant_1_dout));
  DDS_Block_xlslice_0_2 xlslice_0
       (.Din(xfft_0_m_axis_data_tdata),
        .Dout(xlslice_0_Dout));
  DDS_Block_xlslice_1_0 xlslice_1
       (.Din(xfft_0_m_axis_data_tdata),
        .Dout(xlslice_1_Dout));
endmodule

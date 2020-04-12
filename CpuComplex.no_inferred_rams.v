// Generator : SpinalHDL v1.3.8    git head : 57d97088b91271a094cebad32ed86479199955df
// Date      : 11/04/2020, 22:54:10
// Component : CpuComplex


`define AluCtrlEnum_defaultEncoding_type [1:0]
`define AluCtrlEnum_defaultEncoding_ADD_SUB 2'b00
`define AluCtrlEnum_defaultEncoding_SLT_SLTU 2'b01
`define AluCtrlEnum_defaultEncoding_BITWISE 2'b10

`define AluBitwiseCtrlEnum_defaultEncoding_type [1:0]
`define AluBitwiseCtrlEnum_defaultEncoding_XOR_1 2'b00
`define AluBitwiseCtrlEnum_defaultEncoding_OR_1 2'b01
`define AluBitwiseCtrlEnum_defaultEncoding_AND_1 2'b10

`define ShiftCtrlEnum_defaultEncoding_type [1:0]
`define ShiftCtrlEnum_defaultEncoding_DISABLE_1 2'b00
`define ShiftCtrlEnum_defaultEncoding_SLL_1 2'b01
`define ShiftCtrlEnum_defaultEncoding_SRL_1 2'b10
`define ShiftCtrlEnum_defaultEncoding_SRA_1 2'b11

`define BranchCtrlEnum_defaultEncoding_type [1:0]
`define BranchCtrlEnum_defaultEncoding_INC 2'b00
`define BranchCtrlEnum_defaultEncoding_B 2'b01
`define BranchCtrlEnum_defaultEncoding_JAL 2'b10
`define BranchCtrlEnum_defaultEncoding_JALR 2'b11

`define EnvCtrlEnum_defaultEncoding_type [0:0]
`define EnvCtrlEnum_defaultEncoding_NONE 1'b0
`define EnvCtrlEnum_defaultEncoding_XRET 1'b1

`define Src2CtrlEnum_defaultEncoding_type [1:0]
`define Src2CtrlEnum_defaultEncoding_RS 2'b00
`define Src2CtrlEnum_defaultEncoding_IMI 2'b01
`define Src2CtrlEnum_defaultEncoding_IMS 2'b10
`define Src2CtrlEnum_defaultEncoding_PC 2'b11

`define Src1CtrlEnum_defaultEncoding_type [1:0]
`define Src1CtrlEnum_defaultEncoding_RS 2'b00
`define Src1CtrlEnum_defaultEncoding_IMU 2'b01
`define Src1CtrlEnum_defaultEncoding_PC_INCREMENT 2'b10
`define Src1CtrlEnum_defaultEncoding_URS1 2'b11

module StreamFifoLowLatency (
      input   io_push_valid,
      output  io_push_ready,
      input   io_push_payload_error,
      input  [31:0] io_push_payload_inst,
      output reg  io_pop_valid,
      input   io_pop_ready,
      output reg  io_pop_payload_error,
      output reg [31:0] io_pop_payload_inst,
      input   io_flush,
      output [0:0] io_occupancy,
      input   clk,
      input   reset);
  wire  _zz_StreamFifoLowLatency_4_;
  wire [0:0] _zz_StreamFifoLowLatency_5_;
  reg  _zz_StreamFifoLowLatency_1_;
  reg  pushPtr_willIncrement;
  reg  pushPtr_willClear;
  wire  pushPtr_willOverflowIfInc;
  wire  pushPtr_willOverflow;
  reg  popPtr_willIncrement;
  reg  popPtr_willClear;
  wire  popPtr_willOverflowIfInc;
  wire  popPtr_willOverflow;
  wire  ptrMatch;
  reg  risingOccupancy;
  wire  empty;
  wire  full;
  wire  pushing;
  wire  popping;
  wire [32:0] _zz_StreamFifoLowLatency_2_;
  reg [32:0] _zz_StreamFifoLowLatency_3_;
  assign _zz_StreamFifoLowLatency_4_ = (! empty);
  assign _zz_StreamFifoLowLatency_5_ = _zz_StreamFifoLowLatency_2_[0 : 0];
  always @ (*) begin
    _zz_StreamFifoLowLatency_1_ = 1'b0;
    if(pushing)begin
      _zz_StreamFifoLowLatency_1_ = 1'b1;
    end
  end

  always @ (*) begin
    pushPtr_willIncrement = 1'b0;
    if(pushing)begin
      pushPtr_willIncrement = 1'b1;
    end
  end

  always @ (*) begin
    pushPtr_willClear = 1'b0;
    if(io_flush)begin
      pushPtr_willClear = 1'b1;
    end
  end

  assign pushPtr_willOverflowIfInc = 1'b1;
  assign pushPtr_willOverflow = (pushPtr_willOverflowIfInc && pushPtr_willIncrement);
  always @ (*) begin
    popPtr_willIncrement = 1'b0;
    if(popping)begin
      popPtr_willIncrement = 1'b1;
    end
  end

  always @ (*) begin
    popPtr_willClear = 1'b0;
    if(io_flush)begin
      popPtr_willClear = 1'b1;
    end
  end

  assign popPtr_willOverflowIfInc = 1'b1;
  assign popPtr_willOverflow = (popPtr_willOverflowIfInc && popPtr_willIncrement);
  assign ptrMatch = 1'b1;
  assign empty = (ptrMatch && (! risingOccupancy));
  assign full = (ptrMatch && risingOccupancy);
  assign pushing = (io_push_valid && io_push_ready);
  assign popping = (io_pop_valid && io_pop_ready);
  assign io_push_ready = (! full);
  always @ (*) begin
    if(_zz_StreamFifoLowLatency_4_)begin
      io_pop_valid = 1'b1;
    end else begin
      io_pop_valid = io_push_valid;
    end
  end

  assign _zz_StreamFifoLowLatency_2_ = _zz_StreamFifoLowLatency_3_;
  always @ (*) begin
    if(_zz_StreamFifoLowLatency_4_)begin
      io_pop_payload_error = _zz_StreamFifoLowLatency_5_[0];
    end else begin
      io_pop_payload_error = io_push_payload_error;
    end
  end

  always @ (*) begin
    if(_zz_StreamFifoLowLatency_4_)begin
      io_pop_payload_inst = _zz_StreamFifoLowLatency_2_[32 : 1];
    end else begin
      io_pop_payload_inst = io_push_payload_inst;
    end
  end

  assign io_occupancy = (risingOccupancy && ptrMatch);
  always @ (posedge clk or posedge reset) begin
    if (reset) begin
      risingOccupancy <= 1'b0;
    end else begin
      if((pushing != popping))begin
        risingOccupancy <= pushing;
      end
      if(io_flush)begin
        risingOccupancy <= 1'b0;
      end
    end
  end

  always @ (posedge clk) begin
    if(_zz_StreamFifoLowLatency_1_)begin
      _zz_StreamFifoLowLatency_3_ <= {io_push_payload_inst,io_push_payload_error};
    end
  end

endmodule

module CCMasterArbiter (
      input   io_iBus_cmd_valid,
      output reg  io_iBus_cmd_ready,
      input  [31:0] io_iBus_cmd_payload_pc,
      output  io_iBus_rsp_valid,
      output  io_iBus_rsp_payload_error,
      output [31:0] io_iBus_rsp_payload_inst,
      input   io_dBus_cmd_valid,
      output reg  io_dBus_cmd_ready,
      input   io_dBus_cmd_payload_wr,
      input  [31:0] io_dBus_cmd_payload_address,
      input  [31:0] io_dBus_cmd_payload_data,
      input  [1:0] io_dBus_cmd_payload_size,
      output  io_dBus_rsp_ready,
      output  io_dBus_rsp_error,
      output [31:0] io_dBus_rsp_data,
      output reg  io_masterBus_cmd_valid,
      input   io_masterBus_cmd_ready,
      output  io_masterBus_cmd_payload_write,
      output [31:0] io_masterBus_cmd_payload_address,
      output [31:0] io_masterBus_cmd_payload_data,
      output [3:0] io_masterBus_cmd_payload_mask,
      input   io_masterBus_rsp_valid,
      input  [31:0] io_masterBus_rsp_payload_data,
      input   clk,
      input   reset);
  wire  _zz_CCMasterArbiter_2_;
  reg [3:0] _zz_CCMasterArbiter_1_;
  reg  rspPending;
  reg  rspTarget;
  assign _zz_CCMasterArbiter_2_ = (rspPending && (! io_masterBus_rsp_valid));
  always @ (*) begin
    io_masterBus_cmd_valid = (io_iBus_cmd_valid || io_dBus_cmd_valid);
    if(_zz_CCMasterArbiter_2_)begin
      io_masterBus_cmd_valid = 1'b0;
    end
  end

  assign io_masterBus_cmd_payload_write = (io_dBus_cmd_valid && io_dBus_cmd_payload_wr);
  assign io_masterBus_cmd_payload_address = (io_dBus_cmd_valid ? io_dBus_cmd_payload_address : io_iBus_cmd_payload_pc);
  assign io_masterBus_cmd_payload_data = io_dBus_cmd_payload_data;
  always @ (*) begin
    case(io_dBus_cmd_payload_size)
      2'b00 : begin
        _zz_CCMasterArbiter_1_ = (4'b0001);
      end
      2'b01 : begin
        _zz_CCMasterArbiter_1_ = (4'b0011);
      end
      default : begin
        _zz_CCMasterArbiter_1_ = (4'b1111);
      end
    endcase
  end

  assign io_masterBus_cmd_payload_mask = (_zz_CCMasterArbiter_1_ <<< io_dBus_cmd_payload_address[1 : 0]);
  always @ (*) begin
    io_iBus_cmd_ready = (io_masterBus_cmd_ready && (! io_dBus_cmd_valid));
    if(_zz_CCMasterArbiter_2_)begin
      io_iBus_cmd_ready = 1'b0;
    end
  end

  always @ (*) begin
    io_dBus_cmd_ready = io_masterBus_cmd_ready;
    if(_zz_CCMasterArbiter_2_)begin
      io_dBus_cmd_ready = 1'b0;
    end
  end

  assign io_iBus_rsp_valid = (io_masterBus_rsp_valid && (! rspTarget));
  assign io_iBus_rsp_payload_inst = io_masterBus_rsp_payload_data;
  assign io_iBus_rsp_payload_error = 1'b0;
  assign io_dBus_rsp_ready = (io_masterBus_rsp_valid && rspTarget);
  assign io_dBus_rsp_data = io_masterBus_rsp_payload_data;
  assign io_dBus_rsp_error = 1'b0;
  always @ (posedge clk or posedge reset) begin
    if (reset) begin
      rspPending <= 1'b0;
      rspTarget <= 1'b0;
    end else begin
      if(io_masterBus_rsp_valid)begin
        rspPending <= 1'b0;
      end
      if(((io_masterBus_cmd_valid && io_masterBus_cmd_ready) && (! io_masterBus_cmd_payload_write)))begin
        rspTarget <= io_dBus_cmd_valid;
        rspPending <= 1'b1;
      end
    end
  end

endmodule

module VexRiscv (
      output  iBus_cmd_valid,
      input   iBus_cmd_ready,
      output [31:0] iBus_cmd_payload_pc,
      input   iBus_rsp_valid,
      input   iBus_rsp_payload_error,
      input  [31:0] iBus_rsp_payload_inst,
      input   timerInterrupt,
      input   externalInterrupt,
      input   softwareInterrupt,
      output  dBus_cmd_valid,
      input   dBus_cmd_ready,
      output  dBus_cmd_payload_wr,
      output [31:0] dBus_cmd_payload_address,
      output [31:0] dBus_cmd_payload_data,
      output [1:0] dBus_cmd_payload_size,
      input   dBus_rsp_ready,
      input   dBus_rsp_error,
      input  [31:0] dBus_rsp_data,
      input   clk,
      input   reset);
  reg [31:0] _zz_VexRiscv_154_;
  reg [31:0] _zz_VexRiscv_155_;
  reg [31:0] _zz_VexRiscv_156_;
  wire  IBusSimplePlugin_rspJoin_rspBuffer_c_io_push_ready;
  wire  IBusSimplePlugin_rspJoin_rspBuffer_c_io_pop_valid;
  wire  IBusSimplePlugin_rspJoin_rspBuffer_c_io_pop_payload_error;
  wire [31:0] IBusSimplePlugin_rspJoin_rspBuffer_c_io_pop_payload_inst;
  wire [0:0] IBusSimplePlugin_rspJoin_rspBuffer_c_io_occupancy;
  wire  _zz_VexRiscv_157_;
  wire  _zz_VexRiscv_158_;
  wire  _zz_VexRiscv_159_;
  wire  _zz_VexRiscv_160_;
  wire  _zz_VexRiscv_161_;
  wire  _zz_VexRiscv_162_;
  wire  _zz_VexRiscv_163_;
  wire [1:0] _zz_VexRiscv_164_;
  wire  _zz_VexRiscv_165_;
  wire  _zz_VexRiscv_166_;
  wire [1:0] _zz_VexRiscv_167_;
  wire  _zz_VexRiscv_168_;
  wire  _zz_VexRiscv_169_;
  wire  _zz_VexRiscv_170_;
  wire  _zz_VexRiscv_171_;
  wire  _zz_VexRiscv_172_;
  wire  _zz_VexRiscv_173_;
  wire  _zz_VexRiscv_174_;
  wire  _zz_VexRiscv_175_;
  wire  _zz_VexRiscv_176_;
  wire  _zz_VexRiscv_177_;
  wire [4:0] _zz_VexRiscv_178_;
  wire [1:0] _zz_VexRiscv_179_;
  wire [1:0] _zz_VexRiscv_180_;
  wire [1:0] _zz_VexRiscv_181_;
  wire  _zz_VexRiscv_182_;
  wire [1:0] _zz_VexRiscv_183_;
  wire [0:0] _zz_VexRiscv_184_;
  wire [2:0] _zz_VexRiscv_185_;
  wire [31:0] _zz_VexRiscv_186_;
  wire [51:0] _zz_VexRiscv_187_;
  wire [51:0] _zz_VexRiscv_188_;
  wire [51:0] _zz_VexRiscv_189_;
  wire [32:0] _zz_VexRiscv_190_;
  wire [51:0] _zz_VexRiscv_191_;
  wire [49:0] _zz_VexRiscv_192_;
  wire [51:0] _zz_VexRiscv_193_;
  wire [49:0] _zz_VexRiscv_194_;
  wire [51:0] _zz_VexRiscv_195_;
  wire [0:0] _zz_VexRiscv_196_;
  wire [0:0] _zz_VexRiscv_197_;
  wire [0:0] _zz_VexRiscv_198_;
  wire [32:0] _zz_VexRiscv_199_;
  wire [31:0] _zz_VexRiscv_200_;
  wire [32:0] _zz_VexRiscv_201_;
  wire [0:0] _zz_VexRiscv_202_;
  wire [0:0] _zz_VexRiscv_203_;
  wire [0:0] _zz_VexRiscv_204_;
  wire [0:0] _zz_VexRiscv_205_;
  wire [0:0] _zz_VexRiscv_206_;
  wire [0:0] _zz_VexRiscv_207_;
  wire [0:0] _zz_VexRiscv_208_;
  wire [0:0] _zz_VexRiscv_209_;
  wire [2:0] _zz_VexRiscv_210_;
  wire [2:0] _zz_VexRiscv_211_;
  wire [31:0] _zz_VexRiscv_212_;
  wire [2:0] _zz_VexRiscv_213_;
  wire [31:0] _zz_VexRiscv_214_;
  wire [31:0] _zz_VexRiscv_215_;
  wire [11:0] _zz_VexRiscv_216_;
  wire [11:0] _zz_VexRiscv_217_;
  wire [11:0] _zz_VexRiscv_218_;
  wire [31:0] _zz_VexRiscv_219_;
  wire [19:0] _zz_VexRiscv_220_;
  wire [11:0] _zz_VexRiscv_221_;
  wire [2:0] _zz_VexRiscv_222_;
  wire [0:0] _zz_VexRiscv_223_;
  wire [2:0] _zz_VexRiscv_224_;
  wire [0:0] _zz_VexRiscv_225_;
  wire [2:0] _zz_VexRiscv_226_;
  wire [0:0] _zz_VexRiscv_227_;
  wire [2:0] _zz_VexRiscv_228_;
  wire [0:0] _zz_VexRiscv_229_;
  wire [65:0] _zz_VexRiscv_230_;
  wire [65:0] _zz_VexRiscv_231_;
  wire [31:0] _zz_VexRiscv_232_;
  wire [31:0] _zz_VexRiscv_233_;
  wire [2:0] _zz_VexRiscv_234_;
  wire [4:0] _zz_VexRiscv_235_;
  wire [11:0] _zz_VexRiscv_236_;
  wire [11:0] _zz_VexRiscv_237_;
  wire [31:0] _zz_VexRiscv_238_;
  wire [31:0] _zz_VexRiscv_239_;
  wire [31:0] _zz_VexRiscv_240_;
  wire [31:0] _zz_VexRiscv_241_;
  wire [31:0] _zz_VexRiscv_242_;
  wire [31:0] _zz_VexRiscv_243_;
  wire [31:0] _zz_VexRiscv_244_;
  wire [11:0] _zz_VexRiscv_245_;
  wire [19:0] _zz_VexRiscv_246_;
  wire [11:0] _zz_VexRiscv_247_;
  wire [2:0] _zz_VexRiscv_248_;
  wire [0:0] _zz_VexRiscv_249_;
  wire [0:0] _zz_VexRiscv_250_;
  wire [0:0] _zz_VexRiscv_251_;
  wire [0:0] _zz_VexRiscv_252_;
  wire [0:0] _zz_VexRiscv_253_;
  wire [0:0] _zz_VexRiscv_254_;
  wire  _zz_VexRiscv_255_;
  wire  _zz_VexRiscv_256_;
  wire [1:0] _zz_VexRiscv_257_;
  wire  _zz_VexRiscv_258_;
  wire  _zz_VexRiscv_259_;
  wire [6:0] _zz_VexRiscv_260_;
  wire [4:0] _zz_VexRiscv_261_;
  wire  _zz_VexRiscv_262_;
  wire [4:0] _zz_VexRiscv_263_;
  wire [0:0] _zz_VexRiscv_264_;
  wire [7:0] _zz_VexRiscv_265_;
  wire  _zz_VexRiscv_266_;
  wire [0:0] _zz_VexRiscv_267_;
  wire [0:0] _zz_VexRiscv_268_;
  wire [31:0] _zz_VexRiscv_269_;
  wire  _zz_VexRiscv_270_;
  wire [0:0] _zz_VexRiscv_271_;
  wire [0:0] _zz_VexRiscv_272_;
  wire [0:0] _zz_VexRiscv_273_;
  wire [2:0] _zz_VexRiscv_274_;
  wire [1:0] _zz_VexRiscv_275_;
  wire [1:0] _zz_VexRiscv_276_;
  wire  _zz_VexRiscv_277_;
  wire [0:0] _zz_VexRiscv_278_;
  wire [19:0] _zz_VexRiscv_279_;
  wire [31:0] _zz_VexRiscv_280_;
  wire [31:0] _zz_VexRiscv_281_;
  wire [31:0] _zz_VexRiscv_282_;
  wire [31:0] _zz_VexRiscv_283_;
  wire [31:0] _zz_VexRiscv_284_;
  wire [31:0] _zz_VexRiscv_285_;
  wire [31:0] _zz_VexRiscv_286_;
  wire [0:0] _zz_VexRiscv_287_;
  wire [0:0] _zz_VexRiscv_288_;
  wire  _zz_VexRiscv_289_;
  wire  _zz_VexRiscv_290_;
  wire  _zz_VexRiscv_291_;
  wire [0:0] _zz_VexRiscv_292_;
  wire [0:0] _zz_VexRiscv_293_;
  wire  _zz_VexRiscv_294_;
  wire [0:0] _zz_VexRiscv_295_;
  wire [17:0] _zz_VexRiscv_296_;
  wire [31:0] _zz_VexRiscv_297_;
  wire [31:0] _zz_VexRiscv_298_;
  wire [31:0] _zz_VexRiscv_299_;
  wire [31:0] _zz_VexRiscv_300_;
  wire [31:0] _zz_VexRiscv_301_;
  wire [31:0] _zz_VexRiscv_302_;
  wire [31:0] _zz_VexRiscv_303_;
  wire [31:0] _zz_VexRiscv_304_;
  wire [31:0] _zz_VexRiscv_305_;
  wire [0:0] _zz_VexRiscv_306_;
  wire [3:0] _zz_VexRiscv_307_;
  wire [1:0] _zz_VexRiscv_308_;
  wire [1:0] _zz_VexRiscv_309_;
  wire  _zz_VexRiscv_310_;
  wire [0:0] _zz_VexRiscv_311_;
  wire [15:0] _zz_VexRiscv_312_;
  wire [31:0] _zz_VexRiscv_313_;
  wire [31:0] _zz_VexRiscv_314_;
  wire  _zz_VexRiscv_315_;
  wire [0:0] _zz_VexRiscv_316_;
  wire [0:0] _zz_VexRiscv_317_;
  wire [31:0] _zz_VexRiscv_318_;
  wire [31:0] _zz_VexRiscv_319_;
  wire [31:0] _zz_VexRiscv_320_;
  wire [31:0] _zz_VexRiscv_321_;
  wire [0:0] _zz_VexRiscv_322_;
  wire [0:0] _zz_VexRiscv_323_;
  wire [1:0] _zz_VexRiscv_324_;
  wire [1:0] _zz_VexRiscv_325_;
  wire  _zz_VexRiscv_326_;
  wire [0:0] _zz_VexRiscv_327_;
  wire [12:0] _zz_VexRiscv_328_;
  wire [31:0] _zz_VexRiscv_329_;
  wire [31:0] _zz_VexRiscv_330_;
  wire [31:0] _zz_VexRiscv_331_;
  wire [31:0] _zz_VexRiscv_332_;
  wire [31:0] _zz_VexRiscv_333_;
  wire [31:0] _zz_VexRiscv_334_;
  wire [31:0] _zz_VexRiscv_335_;
  wire  _zz_VexRiscv_336_;
  wire [0:0] _zz_VexRiscv_337_;
  wire [0:0] _zz_VexRiscv_338_;
  wire [0:0] _zz_VexRiscv_339_;
  wire [0:0] _zz_VexRiscv_340_;
  wire  _zz_VexRiscv_341_;
  wire [0:0] _zz_VexRiscv_342_;
  wire [10:0] _zz_VexRiscv_343_;
  wire [31:0] _zz_VexRiscv_344_;
  wire [31:0] _zz_VexRiscv_345_;
  wire [31:0] _zz_VexRiscv_346_;
  wire [31:0] _zz_VexRiscv_347_;
  wire [31:0] _zz_VexRiscv_348_;
  wire  _zz_VexRiscv_349_;
  wire [1:0] _zz_VexRiscv_350_;
  wire [1:0] _zz_VexRiscv_351_;
  wire  _zz_VexRiscv_352_;
  wire [0:0] _zz_VexRiscv_353_;
  wire [7:0] _zz_VexRiscv_354_;
  wire [31:0] _zz_VexRiscv_355_;
  wire [31:0] _zz_VexRiscv_356_;
  wire [31:0] _zz_VexRiscv_357_;
  wire  _zz_VexRiscv_358_;
  wire  _zz_VexRiscv_359_;
  wire [0:0] _zz_VexRiscv_360_;
  wire [0:0] _zz_VexRiscv_361_;
  wire [0:0] _zz_VexRiscv_362_;
  wire [0:0] _zz_VexRiscv_363_;
  wire  _zz_VexRiscv_364_;
  wire [0:0] _zz_VexRiscv_365_;
  wire [3:0] _zz_VexRiscv_366_;
  wire [31:0] _zz_VexRiscv_367_;
  wire [31:0] _zz_VexRiscv_368_;
  wire [31:0] _zz_VexRiscv_369_;
  wire [31:0] _zz_VexRiscv_370_;
  wire [31:0] _zz_VexRiscv_371_;
  wire [0:0] _zz_VexRiscv_372_;
  wire [4:0] _zz_VexRiscv_373_;
  wire [0:0] _zz_VexRiscv_374_;
  wire [0:0] _zz_VexRiscv_375_;
  wire  _zz_VexRiscv_376_;
  wire [0:0] _zz_VexRiscv_377_;
  wire [0:0] _zz_VexRiscv_378_;
  wire [31:0] _zz_VexRiscv_379_;
  wire [31:0] _zz_VexRiscv_380_;
  wire [31:0] _zz_VexRiscv_381_;
  wire  _zz_VexRiscv_382_;
  wire [0:0] _zz_VexRiscv_383_;
  wire [0:0] _zz_VexRiscv_384_;
  wire  _zz_VexRiscv_385_;
  wire [0:0] _zz_VexRiscv_386_;
  wire [0:0] _zz_VexRiscv_387_;
  wire  _zz_VexRiscv_388_;
  wire [0:0] _zz_VexRiscv_389_;
  wire [1:0] _zz_VexRiscv_390_;
  wire [31:0] _zz_VexRiscv_391_;
  wire [31:0] _zz_VexRiscv_392_;
  wire [31:0] _zz_VexRiscv_393_;
  wire [31:0] _zz_VexRiscv_394_;
  wire [31:0] _zz_VexRiscv_395_;
  wire [31:0] _zz_VexRiscv_396_;
  wire [31:0] _zz_VexRiscv_397_;
  wire  _zz_VexRiscv_398_;
  wire  _zz_VexRiscv_399_;
  wire  _zz_VexRiscv_400_;
  wire  decode_BYPASSABLE_EXECUTE_STAGE;
  wire  decode_PREDICTION_HAD_BRANCHED2;
  wire [31:0] writeBack_FORMAL_PC_NEXT;
  wire [31:0] memory_FORMAL_PC_NEXT;
  wire [31:0] execute_FORMAL_PC_NEXT;
  wire [31:0] decode_FORMAL_PC_NEXT;
  wire `AluCtrlEnum_defaultEncoding_type decode_ALU_CTRL;
  wire `AluCtrlEnum_defaultEncoding_type _zz_VexRiscv_1_;
  wire `AluCtrlEnum_defaultEncoding_type _zz_VexRiscv_2_;
  wire `AluCtrlEnum_defaultEncoding_type _zz_VexRiscv_3_;
  wire `AluBitwiseCtrlEnum_defaultEncoding_type decode_ALU_BITWISE_CTRL;
  wire `AluBitwiseCtrlEnum_defaultEncoding_type _zz_VexRiscv_4_;
  wire `AluBitwiseCtrlEnum_defaultEncoding_type _zz_VexRiscv_5_;
  wire `AluBitwiseCtrlEnum_defaultEncoding_type _zz_VexRiscv_6_;
  wire [33:0] execute_MUL_LH;
  wire  decode_CSR_READ_OPCODE;
  wire  execute_BRANCH_DO;
  wire [33:0] execute_MUL_HL;
  wire [31:0] execute_BRANCH_CALC;
  wire [31:0] decode_SRC1;
  wire [31:0] memory_PC;
  wire [1:0] memory_MEMORY_ADDRESS_LOW;
  wire [1:0] execute_MEMORY_ADDRESS_LOW;
  wire `ShiftCtrlEnum_defaultEncoding_type _zz_VexRiscv_7_;
  wire `ShiftCtrlEnum_defaultEncoding_type _zz_VexRiscv_8_;
  wire `ShiftCtrlEnum_defaultEncoding_type decode_SHIFT_CTRL;
  wire `ShiftCtrlEnum_defaultEncoding_type _zz_VexRiscv_9_;
  wire `ShiftCtrlEnum_defaultEncoding_type _zz_VexRiscv_10_;
  wire `ShiftCtrlEnum_defaultEncoding_type _zz_VexRiscv_11_;
  wire [33:0] memory_MUL_HH;
  wire [33:0] execute_MUL_HH;
  wire `BranchCtrlEnum_defaultEncoding_type _zz_VexRiscv_12_;
  wire `BranchCtrlEnum_defaultEncoding_type _zz_VexRiscv_13_;
  wire [31:0] writeBack_REGFILE_WRITE_DATA;
  wire [31:0] memory_REGFILE_WRITE_DATA;
  wire [31:0] execute_REGFILE_WRITE_DATA;
  wire `EnvCtrlEnum_defaultEncoding_type _zz_VexRiscv_14_;
  wire `EnvCtrlEnum_defaultEncoding_type _zz_VexRiscv_15_;
  wire `EnvCtrlEnum_defaultEncoding_type _zz_VexRiscv_16_;
  wire `EnvCtrlEnum_defaultEncoding_type _zz_VexRiscv_17_;
  wire `EnvCtrlEnum_defaultEncoding_type decode_ENV_CTRL;
  wire `EnvCtrlEnum_defaultEncoding_type _zz_VexRiscv_18_;
  wire `EnvCtrlEnum_defaultEncoding_type _zz_VexRiscv_19_;
  wire `EnvCtrlEnum_defaultEncoding_type _zz_VexRiscv_20_;
  wire [51:0] memory_MUL_LOW;
  wire  decode_SRC2_FORCE_ZERO;
  wire  execute_BYPASSABLE_MEMORY_STAGE;
  wire  decode_BYPASSABLE_MEMORY_STAGE;
  wire [31:0] memory_MEMORY_READ_DATA;
  wire  decode_MEMORY_ENABLE;
  wire  memory_IS_MUL;
  wire  execute_IS_MUL;
  wire  decode_IS_MUL;
  wire  decode_CSR_WRITE_OPCODE;
  wire [31:0] execute_MUL_LL;
  wire [31:0] execute_SHIFT_RIGHT;
  wire  decode_SRC_LESS_UNSIGNED;
  wire  decode_IS_CSR;
  wire  decode_MEMORY_STORE;
  wire [31:0] decode_SRC2;
  wire [31:0] memory_BRANCH_CALC;
  wire  memory_BRANCH_DO;
  wire  execute_IS_RVC;
  wire [31:0] execute_PC;
  wire  execute_BRANCH_COND_RESULT;
  wire  execute_PREDICTION_HAD_BRANCHED2;
  wire `BranchCtrlEnum_defaultEncoding_type execute_BRANCH_CTRL;
  wire `BranchCtrlEnum_defaultEncoding_type _zz_VexRiscv_21_;
  wire  decode_RS2_USE;
  wire  decode_RS1_USE;
  wire  execute_REGFILE_WRITE_VALID;
  wire  execute_BYPASSABLE_EXECUTE_STAGE;
  wire  memory_REGFILE_WRITE_VALID;
  wire [31:0] memory_INSTRUCTION;
  wire  memory_BYPASSABLE_MEMORY_STAGE;
  wire  writeBack_REGFILE_WRITE_VALID;
  reg [31:0] decode_RS2;
  reg [31:0] decode_RS1;
  wire [31:0] memory_SHIFT_RIGHT;
  reg [31:0] _zz_VexRiscv_22_;
  wire `ShiftCtrlEnum_defaultEncoding_type memory_SHIFT_CTRL;
  wire `ShiftCtrlEnum_defaultEncoding_type _zz_VexRiscv_23_;
  wire `ShiftCtrlEnum_defaultEncoding_type execute_SHIFT_CTRL;
  wire `ShiftCtrlEnum_defaultEncoding_type _zz_VexRiscv_24_;
  wire  execute_SRC_LESS_UNSIGNED;
  wire  execute_SRC2_FORCE_ZERO;
  wire  execute_SRC_USE_SUB_LESS;
  wire [31:0] _zz_VexRiscv_25_;
  wire [31:0] _zz_VexRiscv_26_;
  wire `Src2CtrlEnum_defaultEncoding_type decode_SRC2_CTRL;
  wire `Src2CtrlEnum_defaultEncoding_type _zz_VexRiscv_27_;
  wire [31:0] _zz_VexRiscv_28_;
  wire `Src1CtrlEnum_defaultEncoding_type decode_SRC1_CTRL;
  wire `Src1CtrlEnum_defaultEncoding_type _zz_VexRiscv_29_;
  wire  decode_SRC_USE_SUB_LESS;
  wire  decode_SRC_ADD_ZERO;
  wire  writeBack_IS_MUL;
  wire [33:0] writeBack_MUL_HH;
  wire [51:0] writeBack_MUL_LOW;
  wire [33:0] memory_MUL_HL;
  wire [33:0] memory_MUL_LH;
  wire [31:0] memory_MUL_LL;
  wire [31:0] execute_RS1;
  wire [31:0] execute_SRC_ADD_SUB;
  wire  execute_SRC_LESS;
  wire `AluCtrlEnum_defaultEncoding_type execute_ALU_CTRL;
  wire `AluCtrlEnum_defaultEncoding_type _zz_VexRiscv_30_;
  wire [31:0] execute_SRC2;
  wire `AluBitwiseCtrlEnum_defaultEncoding_type execute_ALU_BITWISE_CTRL;
  wire `AluBitwiseCtrlEnum_defaultEncoding_type _zz_VexRiscv_31_;
  wire [31:0] _zz_VexRiscv_32_;
  wire  _zz_VexRiscv_33_;
  reg  _zz_VexRiscv_34_;
  wire [31:0] decode_INSTRUCTION_ANTICIPATED;
  reg  decode_REGFILE_WRITE_VALID;
  wire `ShiftCtrlEnum_defaultEncoding_type _zz_VexRiscv_35_;
  wire `AluBitwiseCtrlEnum_defaultEncoding_type _zz_VexRiscv_36_;
  wire `BranchCtrlEnum_defaultEncoding_type _zz_VexRiscv_37_;
  wire `Src1CtrlEnum_defaultEncoding_type _zz_VexRiscv_38_;
  wire `Src2CtrlEnum_defaultEncoding_type _zz_VexRiscv_39_;
  wire `EnvCtrlEnum_defaultEncoding_type _zz_VexRiscv_40_;
  wire `AluCtrlEnum_defaultEncoding_type _zz_VexRiscv_41_;
  reg [31:0] _zz_VexRiscv_42_;
  wire [31:0] execute_SRC1;
  wire  execute_CSR_READ_OPCODE;
  wire  execute_CSR_WRITE_OPCODE;
  wire  execute_IS_CSR;
  wire `EnvCtrlEnum_defaultEncoding_type memory_ENV_CTRL;
  wire `EnvCtrlEnum_defaultEncoding_type _zz_VexRiscv_43_;
  wire `EnvCtrlEnum_defaultEncoding_type execute_ENV_CTRL;
  wire `EnvCtrlEnum_defaultEncoding_type _zz_VexRiscv_44_;
  wire `EnvCtrlEnum_defaultEncoding_type writeBack_ENV_CTRL;
  wire `EnvCtrlEnum_defaultEncoding_type _zz_VexRiscv_45_;
  wire  writeBack_MEMORY_STORE;
  reg [31:0] _zz_VexRiscv_46_;
  wire  writeBack_MEMORY_ENABLE;
  wire [1:0] writeBack_MEMORY_ADDRESS_LOW;
  wire [31:0] writeBack_MEMORY_READ_DATA;
  wire  memory_MEMORY_STORE;
  wire  memory_MEMORY_ENABLE;
  wire [31:0] execute_SRC_ADD;
  wire [31:0] execute_RS2;
  wire [31:0] execute_INSTRUCTION;
  wire  execute_MEMORY_STORE;
  wire  execute_MEMORY_ENABLE;
  wire  execute_ALIGNEMENT_FAULT;
  wire `BranchCtrlEnum_defaultEncoding_type decode_BRANCH_CTRL;
  wire `BranchCtrlEnum_defaultEncoding_type _zz_VexRiscv_47_;
  reg [31:0] _zz_VexRiscv_48_;
  reg [31:0] _zz_VexRiscv_49_;
  wire [31:0] decode_PC;
  wire [31:0] decode_INSTRUCTION;
  wire  decode_IS_RVC;
  wire [31:0] writeBack_PC;
  wire [31:0] writeBack_INSTRUCTION;
  wire  decode_arbitration_haltItself;
  reg  decode_arbitration_haltByOther;
  reg  decode_arbitration_removeIt;
  wire  decode_arbitration_flushIt;
  wire  decode_arbitration_flushNext;
  wire  decode_arbitration_isValid;
  wire  decode_arbitration_isStuck;
  wire  decode_arbitration_isStuckByOthers;
  wire  decode_arbitration_isFlushed;
  wire  decode_arbitration_isMoving;
  wire  decode_arbitration_isFiring;
  reg  execute_arbitration_haltItself;
  wire  execute_arbitration_haltByOther;
  reg  execute_arbitration_removeIt;
  wire  execute_arbitration_flushIt;
  wire  execute_arbitration_flushNext;
  reg  execute_arbitration_isValid;
  wire  execute_arbitration_isStuck;
  wire  execute_arbitration_isStuckByOthers;
  wire  execute_arbitration_isFlushed;
  wire  execute_arbitration_isMoving;
  wire  execute_arbitration_isFiring;
  reg  memory_arbitration_haltItself;
  wire  memory_arbitration_haltByOther;
  reg  memory_arbitration_removeIt;
  wire  memory_arbitration_flushIt;
  reg  memory_arbitration_flushNext;
  reg  memory_arbitration_isValid;
  wire  memory_arbitration_isStuck;
  wire  memory_arbitration_isStuckByOthers;
  wire  memory_arbitration_isFlushed;
  wire  memory_arbitration_isMoving;
  wire  memory_arbitration_isFiring;
  wire  writeBack_arbitration_haltItself;
  wire  writeBack_arbitration_haltByOther;
  reg  writeBack_arbitration_removeIt;
  wire  writeBack_arbitration_flushIt;
  reg  writeBack_arbitration_flushNext;
  reg  writeBack_arbitration_isValid;
  wire  writeBack_arbitration_isStuck;
  wire  writeBack_arbitration_isStuckByOthers;
  wire  writeBack_arbitration_isFlushed;
  wire  writeBack_arbitration_isMoving;
  wire  writeBack_arbitration_isFiring;
  wire [31:0] lastStageInstruction /* verilator public */ ;
  wire [31:0] lastStagePc /* verilator public */ ;
  wire  lastStageIsValid /* verilator public */ ;
  wire  lastStageIsFiring /* verilator public */ ;
  reg  IBusSimplePlugin_fetcherHalt;
  reg  IBusSimplePlugin_fetcherflushIt;
  reg  IBusSimplePlugin_incomingInstruction;
  wire  IBusSimplePlugin_predictionJumpInterface_valid;
  (* syn_keep , keep *) wire [31:0] IBusSimplePlugin_predictionJumpInterface_payload /* synthesis syn_keep = 1 */ ;
  wire  IBusSimplePlugin_decodePrediction_cmd_hadBranch;
  wire  IBusSimplePlugin_decodePrediction_rsp_wasWrong;
  wire  IBusSimplePlugin_pcValids_0;
  wire  IBusSimplePlugin_pcValids_1;
  wire  IBusSimplePlugin_pcValids_2;
  wire  IBusSimplePlugin_pcValids_3;
  wire  CsrPlugin_inWfi /* verilator public */ ;
  wire  CsrPlugin_thirdPartyWake;
  reg  CsrPlugin_jumpInterface_valid;
  reg [31:0] CsrPlugin_jumpInterface_payload;
  wire  CsrPlugin_exceptionPendings_0;
  wire  CsrPlugin_exceptionPendings_1;
  wire  CsrPlugin_exceptionPendings_2;
  wire  CsrPlugin_exceptionPendings_3;
  wire  contextSwitching;
  reg [1:0] CsrPlugin_privilege;
  wire  CsrPlugin_forceMachineWire;
  wire  CsrPlugin_allowInterrupts;
  wire  CsrPlugin_allowException;
  wire  BranchPlugin_jumpInterface_valid;
  wire [31:0] BranchPlugin_jumpInterface_payload;
  wire  IBusSimplePlugin_jump_pcLoad_valid;
  wire [31:0] IBusSimplePlugin_jump_pcLoad_payload;
  wire [2:0] _zz_VexRiscv_50_;
  wire [2:0] _zz_VexRiscv_51_;
  wire  _zz_VexRiscv_52_;
  wire  _zz_VexRiscv_53_;
  wire  IBusSimplePlugin_fetchPc_output_valid;
  wire  IBusSimplePlugin_fetchPc_output_ready;
  wire [31:0] IBusSimplePlugin_fetchPc_output_payload;
  reg [31:0] IBusSimplePlugin_fetchPc_pcReg /* verilator public */ ;
  reg  IBusSimplePlugin_fetchPc_corrected;
  reg  IBusSimplePlugin_fetchPc_pcRegPropagate;
  reg  IBusSimplePlugin_fetchPc_booted;
  reg  IBusSimplePlugin_fetchPc_inc;
  reg [31:0] IBusSimplePlugin_fetchPc_pc;
  reg [31:0] IBusSimplePlugin_decodePc_pcReg /* verilator public */ ;
  wire [31:0] IBusSimplePlugin_decodePc_pcPlus;
  wire  IBusSimplePlugin_decodePc_injectedDecode;
  wire  IBusSimplePlugin_iBusRsp_stages_0_input_valid;
  wire  IBusSimplePlugin_iBusRsp_stages_0_input_ready;
  wire [31:0] IBusSimplePlugin_iBusRsp_stages_0_input_payload;
  wire  IBusSimplePlugin_iBusRsp_stages_0_output_valid;
  wire  IBusSimplePlugin_iBusRsp_stages_0_output_ready;
  wire [31:0] IBusSimplePlugin_iBusRsp_stages_0_output_payload;
  wire  IBusSimplePlugin_iBusRsp_stages_0_halt;
  wire  IBusSimplePlugin_iBusRsp_stages_0_inputSample;
  wire  IBusSimplePlugin_iBusRsp_stages_1_input_valid;
  wire  IBusSimplePlugin_iBusRsp_stages_1_input_ready;
  wire [31:0] IBusSimplePlugin_iBusRsp_stages_1_input_payload;
  wire  IBusSimplePlugin_iBusRsp_stages_1_output_valid;
  wire  IBusSimplePlugin_iBusRsp_stages_1_output_ready;
  wire [31:0] IBusSimplePlugin_iBusRsp_stages_1_output_payload;
  reg  IBusSimplePlugin_iBusRsp_stages_1_halt;
  wire  IBusSimplePlugin_iBusRsp_stages_1_inputSample;
  wire  IBusSimplePlugin_iBusRsp_stages_2_input_valid;
  wire  IBusSimplePlugin_iBusRsp_stages_2_input_ready;
  wire [31:0] IBusSimplePlugin_iBusRsp_stages_2_input_payload;
  wire  IBusSimplePlugin_iBusRsp_stages_2_output_valid;
  wire  IBusSimplePlugin_iBusRsp_stages_2_output_ready;
  wire [31:0] IBusSimplePlugin_iBusRsp_stages_2_output_payload;
  wire  IBusSimplePlugin_iBusRsp_stages_2_halt;
  wire  IBusSimplePlugin_iBusRsp_stages_2_inputSample;
  wire  _zz_VexRiscv_54_;
  wire  _zz_VexRiscv_55_;
  wire  _zz_VexRiscv_56_;
  wire  _zz_VexRiscv_57_;
  wire  _zz_VexRiscv_58_;
  reg  _zz_VexRiscv_59_;
  wire  _zz_VexRiscv_60_;
  reg  _zz_VexRiscv_61_;
  reg [31:0] _zz_VexRiscv_62_;
  reg  IBusSimplePlugin_iBusRsp_readyForError;
  wire  IBusSimplePlugin_iBusRsp_output_valid;
  wire  IBusSimplePlugin_iBusRsp_output_ready;
  wire [31:0] IBusSimplePlugin_iBusRsp_output_payload_pc;
  wire  IBusSimplePlugin_iBusRsp_output_payload_rsp_error;
  wire [31:0] IBusSimplePlugin_iBusRsp_output_payload_rsp_inst;
  wire  IBusSimplePlugin_iBusRsp_output_payload_isRvc;
  wire  IBusSimplePlugin_decompressor_output_valid;
  wire  IBusSimplePlugin_decompressor_output_ready;
  wire [31:0] IBusSimplePlugin_decompressor_output_payload_pc;
  wire  IBusSimplePlugin_decompressor_output_payload_rsp_error;
  wire [31:0] IBusSimplePlugin_decompressor_output_payload_rsp_inst;
  wire  IBusSimplePlugin_decompressor_output_payload_isRvc;
  reg  IBusSimplePlugin_decompressor_bufferValid;
  reg [15:0] IBusSimplePlugin_decompressor_bufferData;
  wire [31:0] IBusSimplePlugin_decompressor_raw;
  wire  IBusSimplePlugin_decompressor_isRvc;
  wire [15:0] _zz_VexRiscv_63_;
  reg [31:0] IBusSimplePlugin_decompressor_decompressed;
  wire [4:0] _zz_VexRiscv_64_;
  wire [4:0] _zz_VexRiscv_65_;
  wire [11:0] _zz_VexRiscv_66_;
  wire  _zz_VexRiscv_67_;
  reg [11:0] _zz_VexRiscv_68_;
  wire  _zz_VexRiscv_69_;
  reg [9:0] _zz_VexRiscv_70_;
  wire [20:0] _zz_VexRiscv_71_;
  wire  _zz_VexRiscv_72_;
  reg [14:0] _zz_VexRiscv_73_;
  wire  _zz_VexRiscv_74_;
  reg [2:0] _zz_VexRiscv_75_;
  wire  _zz_VexRiscv_76_;
  reg [9:0] _zz_VexRiscv_77_;
  wire [20:0] _zz_VexRiscv_78_;
  wire  _zz_VexRiscv_79_;
  reg [4:0] _zz_VexRiscv_80_;
  wire [12:0] _zz_VexRiscv_81_;
  wire [4:0] _zz_VexRiscv_82_;
  wire [4:0] _zz_VexRiscv_83_;
  wire [4:0] _zz_VexRiscv_84_;
  wire  _zz_VexRiscv_85_;
  reg [2:0] _zz_VexRiscv_86_;
  reg [2:0] _zz_VexRiscv_87_;
  wire  _zz_VexRiscv_88_;
  reg [6:0] _zz_VexRiscv_89_;
  reg  IBusSimplePlugin_decompressor_bufferFill;
  wire  IBusSimplePlugin_injector_decodeInput_valid;
  wire  IBusSimplePlugin_injector_decodeInput_ready;
  wire [31:0] IBusSimplePlugin_injector_decodeInput_payload_pc;
  wire  IBusSimplePlugin_injector_decodeInput_payload_rsp_error;
  wire [31:0] IBusSimplePlugin_injector_decodeInput_payload_rsp_inst;
  wire  IBusSimplePlugin_injector_decodeInput_payload_isRvc;
  reg  _zz_VexRiscv_90_;
  reg [31:0] _zz_VexRiscv_91_;
  reg  _zz_VexRiscv_92_;
  reg [31:0] _zz_VexRiscv_93_;
  reg  _zz_VexRiscv_94_;
  reg  IBusSimplePlugin_injector_nextPcCalc_valids_0;
  reg  IBusSimplePlugin_injector_nextPcCalc_valids_1;
  reg  IBusSimplePlugin_injector_nextPcCalc_valids_2;
  reg  IBusSimplePlugin_injector_nextPcCalc_valids_3;
  reg  IBusSimplePlugin_injector_decodeRemoved;
  reg [31:0] IBusSimplePlugin_injector_formal_rawInDecode;
  wire  _zz_VexRiscv_95_;
  reg [18:0] _zz_VexRiscv_96_;
  wire  _zz_VexRiscv_97_;
  reg [10:0] _zz_VexRiscv_98_;
  wire  _zz_VexRiscv_99_;
  reg [18:0] _zz_VexRiscv_100_;
  wire  IBusSimplePlugin_cmd_valid;
  wire  IBusSimplePlugin_cmd_ready;
  wire [31:0] IBusSimplePlugin_cmd_payload_pc;
  reg [2:0] IBusSimplePlugin_pendingCmd;
  wire [2:0] IBusSimplePlugin_pendingCmdNext;
  reg [2:0] IBusSimplePlugin_rspJoin_discardCounter;
  wire  IBusSimplePlugin_rspJoin_rspBufferOutput_valid;
  wire  IBusSimplePlugin_rspJoin_rspBufferOutput_ready;
  wire  IBusSimplePlugin_rspJoin_rspBufferOutput_payload_error;
  wire [31:0] IBusSimplePlugin_rspJoin_rspBufferOutput_payload_inst;
  wire  iBus_rsp_takeWhen_valid;
  wire  iBus_rsp_takeWhen_payload_error;
  wire [31:0] iBus_rsp_takeWhen_payload_inst;
  wire [31:0] IBusSimplePlugin_rspJoin_fetchRsp_pc;
  reg  IBusSimplePlugin_rspJoin_fetchRsp_rsp_error;
  wire [31:0] IBusSimplePlugin_rspJoin_fetchRsp_rsp_inst;
  wire  IBusSimplePlugin_rspJoin_fetchRsp_isRvc;
  wire  IBusSimplePlugin_rspJoin_join_valid;
  wire  IBusSimplePlugin_rspJoin_join_ready;
  wire [31:0] IBusSimplePlugin_rspJoin_join_payload_pc;
  wire  IBusSimplePlugin_rspJoin_join_payload_rsp_error;
  wire [31:0] IBusSimplePlugin_rspJoin_join_payload_rsp_inst;
  wire  IBusSimplePlugin_rspJoin_join_payload_isRvc;
  wire  IBusSimplePlugin_rspJoin_exceptionDetected;
  wire  IBusSimplePlugin_rspJoin_redoRequired;
  wire  _zz_VexRiscv_101_;
  wire  _zz_VexRiscv_102_;
  reg  execute_DBusSimplePlugin_skipCmd;
  reg [31:0] _zz_VexRiscv_103_;
  reg [3:0] _zz_VexRiscv_104_;
  wire [3:0] execute_DBusSimplePlugin_formalMask;
  reg [31:0] writeBack_DBusSimplePlugin_rspShifted;
  wire  _zz_VexRiscv_105_;
  reg [31:0] _zz_VexRiscv_106_;
  wire  _zz_VexRiscv_107_;
  reg [31:0] _zz_VexRiscv_108_;
  reg [31:0] writeBack_DBusSimplePlugin_rspFormated;
  wire [1:0] CsrPlugin_misa_base;
  wire [25:0] CsrPlugin_misa_extensions;
  wire [1:0] CsrPlugin_mtvec_mode;
  wire [29:0] CsrPlugin_mtvec_base;
  reg [31:0] CsrPlugin_mepc;
  reg  CsrPlugin_mstatus_MIE;
  reg  CsrPlugin_mstatus_MPIE;
  reg [1:0] CsrPlugin_mstatus_MPP;
  reg  CsrPlugin_mip_MEIP;
  reg  CsrPlugin_mip_MTIP;
  reg  CsrPlugin_mip_MSIP;
  reg  CsrPlugin_mie_MEIE;
  reg  CsrPlugin_mie_MTIE;
  reg  CsrPlugin_mie_MSIE;
  reg [31:0] CsrPlugin_mscratch;
  reg  CsrPlugin_mcause_interrupt;
  reg [3:0] CsrPlugin_mcause_exceptionCode;
  reg [31:0] CsrPlugin_mtval;
  reg [63:0] CsrPlugin_mcycle = 64'b0000000000000000000000000000000000000000000000000000000000000000;
  reg [63:0] CsrPlugin_minstret = 64'b0000000000000000000000000000000000000000000000000000000000000000;
  wire  _zz_VexRiscv_109_;
  wire  _zz_VexRiscv_110_;
  wire  _zz_VexRiscv_111_;
  reg  CsrPlugin_interrupt_valid;
  reg [3:0] CsrPlugin_interrupt_code /* verilator public */ ;
  reg [1:0] CsrPlugin_interrupt_targetPrivilege;
  wire  CsrPlugin_exception;
  wire  CsrPlugin_lastStageWasWfi;
  reg  CsrPlugin_pipelineLiberator_done;
  wire  CsrPlugin_interruptJump /* verilator public */ ;
  reg  CsrPlugin_hadException;
  wire [1:0] CsrPlugin_targetPrivilege;
  wire [3:0] CsrPlugin_trapCause;
  reg [1:0] CsrPlugin_xtvec_mode;
  reg [29:0] CsrPlugin_xtvec_base;
  reg  execute_CsrPlugin_wfiWake;
  wire  execute_CsrPlugin_blockedBySideEffects;
  reg  execute_CsrPlugin_illegalAccess;
  reg  execute_CsrPlugin_illegalInstruction;
  reg [31:0] execute_CsrPlugin_readData;
  wire  execute_CsrPlugin_writeInstruction;
  wire  execute_CsrPlugin_readInstruction;
  wire  execute_CsrPlugin_writeEnable;
  wire  execute_CsrPlugin_readEnable;
  wire [31:0] execute_CsrPlugin_readToWriteData;
  reg [31:0] execute_CsrPlugin_writeData;
  wire [11:0] execute_CsrPlugin_csrAddress;
  wire [25:0] _zz_VexRiscv_112_;
  wire  _zz_VexRiscv_113_;
  wire  _zz_VexRiscv_114_;
  wire  _zz_VexRiscv_115_;
  wire  _zz_VexRiscv_116_;
  wire `AluCtrlEnum_defaultEncoding_type _zz_VexRiscv_117_;
  wire `EnvCtrlEnum_defaultEncoding_type _zz_VexRiscv_118_;
  wire `Src2CtrlEnum_defaultEncoding_type _zz_VexRiscv_119_;
  wire `Src1CtrlEnum_defaultEncoding_type _zz_VexRiscv_120_;
  wire `BranchCtrlEnum_defaultEncoding_type _zz_VexRiscv_121_;
  wire `AluBitwiseCtrlEnum_defaultEncoding_type _zz_VexRiscv_122_;
  wire `ShiftCtrlEnum_defaultEncoding_type _zz_VexRiscv_123_;
  wire [4:0] decode_RegFilePlugin_regFileReadAddress1;
  wire [4:0] decode_RegFilePlugin_regFileReadAddress2;
  wire [31:0] decode_RegFilePlugin_rs1Data;
  wire [31:0] decode_RegFilePlugin_rs2Data;
  reg  lastStageRegFileWrite_valid /* verilator public */ ;
  wire [4:0] lastStageRegFileWrite_payload_address /* verilator public */ ;
  wire [31:0] lastStageRegFileWrite_payload_data /* verilator public */ ;
  reg  _zz_VexRiscv_124_;
  reg [31:0] execute_IntAluPlugin_bitwise;
  reg [31:0] _zz_VexRiscv_125_;
  reg  execute_MulPlugin_aSigned;
  reg  execute_MulPlugin_bSigned;
  wire [31:0] execute_MulPlugin_a;
  wire [31:0] execute_MulPlugin_b;
  wire [15:0] execute_MulPlugin_aULow;
  wire [15:0] execute_MulPlugin_bULow;
  wire [16:0] execute_MulPlugin_aSLow;
  wire [16:0] execute_MulPlugin_bSLow;
  wire [16:0] execute_MulPlugin_aHigh;
  wire [16:0] execute_MulPlugin_bHigh;
  wire [65:0] writeBack_MulPlugin_result;
  reg [31:0] _zz_VexRiscv_126_;
  wire  _zz_VexRiscv_127_;
  reg [19:0] _zz_VexRiscv_128_;
  wire  _zz_VexRiscv_129_;
  reg [19:0] _zz_VexRiscv_130_;
  reg [31:0] _zz_VexRiscv_131_;
  reg [31:0] execute_SrcPlugin_addSub;
  wire  execute_SrcPlugin_less;
  wire [4:0] execute_FullBarrelShifterPlugin_amplitude;
  reg [31:0] _zz_VexRiscv_132_;
  wire [31:0] execute_FullBarrelShifterPlugin_reversed;
  reg [31:0] _zz_VexRiscv_133_;
  reg  _zz_VexRiscv_134_;
  reg  _zz_VexRiscv_135_;
  reg  _zz_VexRiscv_136_;
  reg [4:0] _zz_VexRiscv_137_;
  reg [31:0] _zz_VexRiscv_138_;
  wire  _zz_VexRiscv_139_;
  wire  _zz_VexRiscv_140_;
  wire  _zz_VexRiscv_141_;
  wire  _zz_VexRiscv_142_;
  wire  _zz_VexRiscv_143_;
  wire  _zz_VexRiscv_144_;
  wire  execute_BranchPlugin_eq;
  wire [2:0] _zz_VexRiscv_145_;
  reg  _zz_VexRiscv_146_;
  reg  _zz_VexRiscv_147_;
  wire  execute_BranchPlugin_missAlignedTarget;
  reg [31:0] execute_BranchPlugin_branch_src1;
  reg [31:0] execute_BranchPlugin_branch_src2;
  wire  _zz_VexRiscv_148_;
  reg [19:0] _zz_VexRiscv_149_;
  wire  _zz_VexRiscv_150_;
  reg [10:0] _zz_VexRiscv_151_;
  wire  _zz_VexRiscv_152_;
  reg [18:0] _zz_VexRiscv_153_;
  wire [31:0] execute_BranchPlugin_branchAdder;
  reg [31:0] decode_to_execute_SRC2;
  reg  decode_to_execute_MEMORY_STORE;
  reg  execute_to_memory_MEMORY_STORE;
  reg  memory_to_writeBack_MEMORY_STORE;
  reg  decode_to_execute_IS_CSR;
  reg  decode_to_execute_SRC_LESS_UNSIGNED;
  reg [31:0] execute_to_memory_SHIFT_RIGHT;
  reg [31:0] execute_to_memory_MUL_LL;
  reg  decode_to_execute_CSR_WRITE_OPCODE;
  reg  decode_to_execute_IS_RVC;
  reg  decode_to_execute_IS_MUL;
  reg  execute_to_memory_IS_MUL;
  reg  memory_to_writeBack_IS_MUL;
  reg  decode_to_execute_MEMORY_ENABLE;
  reg  execute_to_memory_MEMORY_ENABLE;
  reg  memory_to_writeBack_MEMORY_ENABLE;
  reg [31:0] decode_to_execute_INSTRUCTION;
  reg [31:0] execute_to_memory_INSTRUCTION;
  reg [31:0] memory_to_writeBack_INSTRUCTION;
  reg [31:0] memory_to_writeBack_MEMORY_READ_DATA;
  reg  decode_to_execute_BYPASSABLE_MEMORY_STAGE;
  reg  execute_to_memory_BYPASSABLE_MEMORY_STAGE;
  reg  decode_to_execute_SRC2_FORCE_ZERO;
  reg [51:0] memory_to_writeBack_MUL_LOW;
  reg `EnvCtrlEnum_defaultEncoding_type decode_to_execute_ENV_CTRL;
  reg `EnvCtrlEnum_defaultEncoding_type execute_to_memory_ENV_CTRL;
  reg `EnvCtrlEnum_defaultEncoding_type memory_to_writeBack_ENV_CTRL;
  reg [31:0] execute_to_memory_REGFILE_WRITE_DATA;
  reg [31:0] memory_to_writeBack_REGFILE_WRITE_DATA;
  reg `BranchCtrlEnum_defaultEncoding_type decode_to_execute_BRANCH_CTRL;
  reg [33:0] execute_to_memory_MUL_HH;
  reg [33:0] memory_to_writeBack_MUL_HH;
  reg `ShiftCtrlEnum_defaultEncoding_type decode_to_execute_SHIFT_CTRL;
  reg `ShiftCtrlEnum_defaultEncoding_type execute_to_memory_SHIFT_CTRL;
  reg [31:0] decode_to_execute_RS2;
  reg [1:0] execute_to_memory_MEMORY_ADDRESS_LOW;
  reg [1:0] memory_to_writeBack_MEMORY_ADDRESS_LOW;
  reg [31:0] decode_to_execute_PC;
  reg [31:0] execute_to_memory_PC;
  reg [31:0] memory_to_writeBack_PC;
  reg  decode_to_execute_REGFILE_WRITE_VALID;
  reg  execute_to_memory_REGFILE_WRITE_VALID;
  reg  memory_to_writeBack_REGFILE_WRITE_VALID;
  reg  decode_to_execute_SRC_USE_SUB_LESS;
  reg [31:0] decode_to_execute_SRC1;
  reg [31:0] execute_to_memory_BRANCH_CALC;
  reg [31:0] decode_to_execute_RS1;
  reg [33:0] execute_to_memory_MUL_HL;
  reg  execute_to_memory_BRANCH_DO;
  reg  decode_to_execute_CSR_READ_OPCODE;
  reg [33:0] execute_to_memory_MUL_LH;
  reg `AluBitwiseCtrlEnum_defaultEncoding_type decode_to_execute_ALU_BITWISE_CTRL;
  reg `AluCtrlEnum_defaultEncoding_type decode_to_execute_ALU_CTRL;
  reg [31:0] decode_to_execute_FORMAL_PC_NEXT;
  reg [31:0] execute_to_memory_FORMAL_PC_NEXT;
  reg [31:0] memory_to_writeBack_FORMAL_PC_NEXT;
  reg  decode_to_execute_PREDICTION_HAD_BRANCHED2;
  reg  decode_to_execute_BYPASSABLE_EXECUTE_STAGE;
  `ifndef SYNTHESIS
  reg [63:0] decode_ALU_CTRL_string;
  reg [63:0] _zz_VexRiscv_1__string;
  reg [63:0] _zz_VexRiscv_2__string;
  reg [63:0] _zz_VexRiscv_3__string;
  reg [39:0] decode_ALU_BITWISE_CTRL_string;
  reg [39:0] _zz_VexRiscv_4__string;
  reg [39:0] _zz_VexRiscv_5__string;
  reg [39:0] _zz_VexRiscv_6__string;
  reg [71:0] _zz_VexRiscv_7__string;
  reg [71:0] _zz_VexRiscv_8__string;
  reg [71:0] decode_SHIFT_CTRL_string;
  reg [71:0] _zz_VexRiscv_9__string;
  reg [71:0] _zz_VexRiscv_10__string;
  reg [71:0] _zz_VexRiscv_11__string;
  reg [31:0] _zz_VexRiscv_12__string;
  reg [31:0] _zz_VexRiscv_13__string;
  reg [31:0] _zz_VexRiscv_14__string;
  reg [31:0] _zz_VexRiscv_15__string;
  reg [31:0] _zz_VexRiscv_16__string;
  reg [31:0] _zz_VexRiscv_17__string;
  reg [31:0] decode_ENV_CTRL_string;
  reg [31:0] _zz_VexRiscv_18__string;
  reg [31:0] _zz_VexRiscv_19__string;
  reg [31:0] _zz_VexRiscv_20__string;
  reg [31:0] execute_BRANCH_CTRL_string;
  reg [31:0] _zz_VexRiscv_21__string;
  reg [71:0] memory_SHIFT_CTRL_string;
  reg [71:0] _zz_VexRiscv_23__string;
  reg [71:0] execute_SHIFT_CTRL_string;
  reg [71:0] _zz_VexRiscv_24__string;
  reg [23:0] decode_SRC2_CTRL_string;
  reg [23:0] _zz_VexRiscv_27__string;
  reg [95:0] decode_SRC1_CTRL_string;
  reg [95:0] _zz_VexRiscv_29__string;
  reg [63:0] execute_ALU_CTRL_string;
  reg [63:0] _zz_VexRiscv_30__string;
  reg [39:0] execute_ALU_BITWISE_CTRL_string;
  reg [39:0] _zz_VexRiscv_31__string;
  reg [71:0] _zz_VexRiscv_35__string;
  reg [39:0] _zz_VexRiscv_36__string;
  reg [31:0] _zz_VexRiscv_37__string;
  reg [95:0] _zz_VexRiscv_38__string;
  reg [23:0] _zz_VexRiscv_39__string;
  reg [31:0] _zz_VexRiscv_40__string;
  reg [63:0] _zz_VexRiscv_41__string;
  reg [31:0] memory_ENV_CTRL_string;
  reg [31:0] _zz_VexRiscv_43__string;
  reg [31:0] execute_ENV_CTRL_string;
  reg [31:0] _zz_VexRiscv_44__string;
  reg [31:0] writeBack_ENV_CTRL_string;
  reg [31:0] _zz_VexRiscv_45__string;
  reg [31:0] decode_BRANCH_CTRL_string;
  reg [31:0] _zz_VexRiscv_47__string;
  reg [63:0] _zz_VexRiscv_117__string;
  reg [31:0] _zz_VexRiscv_118__string;
  reg [23:0] _zz_VexRiscv_119__string;
  reg [95:0] _zz_VexRiscv_120__string;
  reg [31:0] _zz_VexRiscv_121__string;
  reg [39:0] _zz_VexRiscv_122__string;
  reg [71:0] _zz_VexRiscv_123__string;
  reg [31:0] decode_to_execute_ENV_CTRL_string;
  reg [31:0] execute_to_memory_ENV_CTRL_string;
  reg [31:0] memory_to_writeBack_ENV_CTRL_string;
  reg [31:0] decode_to_execute_BRANCH_CTRL_string;
  reg [71:0] decode_to_execute_SHIFT_CTRL_string;
  reg [71:0] execute_to_memory_SHIFT_CTRL_string;
  reg [39:0] decode_to_execute_ALU_BITWISE_CTRL_string;
  reg [63:0] decode_to_execute_ALU_CTRL_string;
  `endif

  assign _zz_VexRiscv_157_ = (writeBack_arbitration_isValid && writeBack_REGFILE_WRITE_VALID);
  assign _zz_VexRiscv_158_ = 1'b1;
  assign _zz_VexRiscv_159_ = (memory_arbitration_isValid && memory_REGFILE_WRITE_VALID);
  assign _zz_VexRiscv_160_ = (execute_arbitration_isValid && execute_REGFILE_WRITE_VALID);
  assign _zz_VexRiscv_161_ = (execute_arbitration_isValid && execute_IS_CSR);
  assign _zz_VexRiscv_162_ = (CsrPlugin_hadException || CsrPlugin_interruptJump);
  assign _zz_VexRiscv_163_ = (writeBack_arbitration_isValid && (writeBack_ENV_CTRL == `EnvCtrlEnum_defaultEncoding_XRET));
  assign _zz_VexRiscv_164_ = writeBack_INSTRUCTION[29 : 28];
  assign _zz_VexRiscv_165_ = (IBusSimplePlugin_iBusRsp_output_valid && IBusSimplePlugin_iBusRsp_output_ready);
  assign _zz_VexRiscv_166_ = ((! (((! IBusSimplePlugin_decompressor_isRvc) && (! IBusSimplePlugin_iBusRsp_output_payload_pc[1])) && (! IBusSimplePlugin_decompressor_bufferValid))) && (! ((IBusSimplePlugin_decompressor_isRvc && IBusSimplePlugin_iBusRsp_output_payload_pc[1]) && IBusSimplePlugin_decompressor_output_ready)));
  assign _zz_VexRiscv_167_ = execute_INSTRUCTION[13 : 12];
  assign _zz_VexRiscv_168_ = (writeBack_arbitration_isValid && writeBack_REGFILE_WRITE_VALID);
  assign _zz_VexRiscv_169_ = (1'b0 || (! 1'b1));
  assign _zz_VexRiscv_170_ = (memory_arbitration_isValid && memory_REGFILE_WRITE_VALID);
  assign _zz_VexRiscv_171_ = (1'b0 || (! memory_BYPASSABLE_MEMORY_STAGE));
  assign _zz_VexRiscv_172_ = (execute_arbitration_isValid && execute_REGFILE_WRITE_VALID);
  assign _zz_VexRiscv_173_ = (1'b0 || (! execute_BYPASSABLE_EXECUTE_STAGE));
  assign _zz_VexRiscv_174_ = (CsrPlugin_mstatus_MIE || (CsrPlugin_privilege < (2'b11)));
  assign _zz_VexRiscv_175_ = ((_zz_VexRiscv_109_ && 1'b1) && (! 1'b0));
  assign _zz_VexRiscv_176_ = ((_zz_VexRiscv_110_ && 1'b1) && (! 1'b0));
  assign _zz_VexRiscv_177_ = ((_zz_VexRiscv_111_ && 1'b1) && (! 1'b0));
  assign _zz_VexRiscv_178_ = {_zz_VexRiscv_63_[1 : 0],_zz_VexRiscv_63_[15 : 13]};
  assign _zz_VexRiscv_179_ = _zz_VexRiscv_63_[6 : 5];
  assign _zz_VexRiscv_180_ = _zz_VexRiscv_63_[11 : 10];
  assign _zz_VexRiscv_181_ = writeBack_INSTRUCTION[13 : 12];
  assign _zz_VexRiscv_182_ = execute_INSTRUCTION[13];
  assign _zz_VexRiscv_183_ = writeBack_INSTRUCTION[13 : 12];
  assign _zz_VexRiscv_184_ = _zz_VexRiscv_112_[19 : 19];
  assign _zz_VexRiscv_185_ = (decode_IS_RVC ? (3'b010) : (3'b100));
  assign _zz_VexRiscv_186_ = {29'd0, _zz_VexRiscv_185_};
  assign _zz_VexRiscv_187_ = ($signed(_zz_VexRiscv_188_) + $signed(_zz_VexRiscv_193_));
  assign _zz_VexRiscv_188_ = ($signed(_zz_VexRiscv_189_) + $signed(_zz_VexRiscv_191_));
  assign _zz_VexRiscv_189_ = (52'b0000000000000000000000000000000000000000000000000000);
  assign _zz_VexRiscv_190_ = {1'b0,memory_MUL_LL};
  assign _zz_VexRiscv_191_ = {{19{_zz_VexRiscv_190_[32]}}, _zz_VexRiscv_190_};
  assign _zz_VexRiscv_192_ = ({16'd0,memory_MUL_LH} <<< 16);
  assign _zz_VexRiscv_193_ = {{2{_zz_VexRiscv_192_[49]}}, _zz_VexRiscv_192_};
  assign _zz_VexRiscv_194_ = ({16'd0,memory_MUL_HL} <<< 16);
  assign _zz_VexRiscv_195_ = {{2{_zz_VexRiscv_194_[49]}}, _zz_VexRiscv_194_};
  assign _zz_VexRiscv_196_ = _zz_VexRiscv_112_[23 : 23];
  assign _zz_VexRiscv_197_ = _zz_VexRiscv_112_[13 : 13];
  assign _zz_VexRiscv_198_ = _zz_VexRiscv_112_[6 : 6];
  assign _zz_VexRiscv_199_ = ($signed(_zz_VexRiscv_201_) >>> execute_FullBarrelShifterPlugin_amplitude);
  assign _zz_VexRiscv_200_ = _zz_VexRiscv_199_[31 : 0];
  assign _zz_VexRiscv_201_ = {((execute_SHIFT_CTRL == `ShiftCtrlEnum_defaultEncoding_SRA_1) && execute_FullBarrelShifterPlugin_reversed[31]),execute_FullBarrelShifterPlugin_reversed};
  assign _zz_VexRiscv_202_ = _zz_VexRiscv_112_[14 : 14];
  assign _zz_VexRiscv_203_ = _zz_VexRiscv_112_[8 : 8];
  assign _zz_VexRiscv_204_ = _zz_VexRiscv_112_[11 : 11];
  assign _zz_VexRiscv_205_ = _zz_VexRiscv_112_[22 : 22];
  assign _zz_VexRiscv_206_ = _zz_VexRiscv_112_[0 : 0];
  assign _zz_VexRiscv_207_ = _zz_VexRiscv_112_[1 : 1];
  assign _zz_VexRiscv_208_ = _zz_VexRiscv_112_[12 : 12];
  assign _zz_VexRiscv_209_ = _zz_VexRiscv_112_[4 : 4];
  assign _zz_VexRiscv_210_ = (_zz_VexRiscv_50_ - (3'b001));
  assign _zz_VexRiscv_211_ = {IBusSimplePlugin_fetchPc_inc,(2'b00)};
  assign _zz_VexRiscv_212_ = {29'd0, _zz_VexRiscv_211_};
  assign _zz_VexRiscv_213_ = (decode_IS_RVC ? (3'b010) : (3'b100));
  assign _zz_VexRiscv_214_ = {29'd0, _zz_VexRiscv_213_};
  assign _zz_VexRiscv_215_ = {{_zz_VexRiscv_73_,_zz_VexRiscv_63_[6 : 2]},(12'b000000000000)};
  assign _zz_VexRiscv_216_ = {{{(4'b0000),_zz_VexRiscv_63_[8 : 7]},_zz_VexRiscv_63_[12 : 9]},(2'b00)};
  assign _zz_VexRiscv_217_ = {{{(4'b0000),_zz_VexRiscv_63_[8 : 7]},_zz_VexRiscv_63_[12 : 9]},(2'b00)};
  assign _zz_VexRiscv_218_ = {{{decode_INSTRUCTION[31],decode_INSTRUCTION[7]},decode_INSTRUCTION[30 : 25]},decode_INSTRUCTION[11 : 8]};
  assign _zz_VexRiscv_219_ = {{_zz_VexRiscv_96_,{{{decode_INSTRUCTION[31],decode_INSTRUCTION[7]},decode_INSTRUCTION[30 : 25]},decode_INSTRUCTION[11 : 8]}},1'b0};
  assign _zz_VexRiscv_220_ = {{{decode_INSTRUCTION[31],decode_INSTRUCTION[19 : 12]},decode_INSTRUCTION[20]},decode_INSTRUCTION[30 : 21]};
  assign _zz_VexRiscv_221_ = {{{decode_INSTRUCTION[31],decode_INSTRUCTION[7]},decode_INSTRUCTION[30 : 25]},decode_INSTRUCTION[11 : 8]};
  assign _zz_VexRiscv_222_ = (IBusSimplePlugin_pendingCmd + _zz_VexRiscv_224_);
  assign _zz_VexRiscv_223_ = (IBusSimplePlugin_cmd_valid && IBusSimplePlugin_cmd_ready);
  assign _zz_VexRiscv_224_ = {2'd0, _zz_VexRiscv_223_};
  assign _zz_VexRiscv_225_ = iBus_rsp_valid;
  assign _zz_VexRiscv_226_ = {2'd0, _zz_VexRiscv_225_};
  assign _zz_VexRiscv_227_ = (iBus_rsp_valid && (IBusSimplePlugin_rspJoin_discardCounter != (3'b000)));
  assign _zz_VexRiscv_228_ = {2'd0, _zz_VexRiscv_227_};
  assign _zz_VexRiscv_229_ = execute_SRC_LESS;
  assign _zz_VexRiscv_230_ = {{14{writeBack_MUL_LOW[51]}}, writeBack_MUL_LOW};
  assign _zz_VexRiscv_231_ = ({32'd0,writeBack_MUL_HH} <<< 32);
  assign _zz_VexRiscv_232_ = writeBack_MUL_LOW[31 : 0];
  assign _zz_VexRiscv_233_ = writeBack_MulPlugin_result[63 : 32];
  assign _zz_VexRiscv_234_ = (decode_IS_RVC ? (3'b010) : (3'b100));
  assign _zz_VexRiscv_235_ = decode_INSTRUCTION[19 : 15];
  assign _zz_VexRiscv_236_ = decode_INSTRUCTION[31 : 20];
  assign _zz_VexRiscv_237_ = {decode_INSTRUCTION[31 : 25],decode_INSTRUCTION[11 : 7]};
  assign _zz_VexRiscv_238_ = ($signed(_zz_VexRiscv_239_) + $signed(_zz_VexRiscv_242_));
  assign _zz_VexRiscv_239_ = ($signed(_zz_VexRiscv_240_) + $signed(_zz_VexRiscv_241_));
  assign _zz_VexRiscv_240_ = execute_SRC1;
  assign _zz_VexRiscv_241_ = (execute_SRC_USE_SUB_LESS ? (~ execute_SRC2) : execute_SRC2);
  assign _zz_VexRiscv_242_ = (execute_SRC_USE_SUB_LESS ? _zz_VexRiscv_243_ : _zz_VexRiscv_244_);
  assign _zz_VexRiscv_243_ = (32'b00000000000000000000000000000001);
  assign _zz_VexRiscv_244_ = (32'b00000000000000000000000000000000);
  assign _zz_VexRiscv_245_ = execute_INSTRUCTION[31 : 20];
  assign _zz_VexRiscv_246_ = {{{execute_INSTRUCTION[31],execute_INSTRUCTION[19 : 12]},execute_INSTRUCTION[20]},execute_INSTRUCTION[30 : 21]};
  assign _zz_VexRiscv_247_ = {{{execute_INSTRUCTION[31],execute_INSTRUCTION[7]},execute_INSTRUCTION[30 : 25]},execute_INSTRUCTION[11 : 8]};
  assign _zz_VexRiscv_248_ = (execute_IS_RVC ? (3'b010) : (3'b100));
  assign _zz_VexRiscv_249_ = execute_CsrPlugin_writeData[7 : 7];
  assign _zz_VexRiscv_250_ = execute_CsrPlugin_writeData[3 : 3];
  assign _zz_VexRiscv_251_ = execute_CsrPlugin_writeData[3 : 3];
  assign _zz_VexRiscv_252_ = execute_CsrPlugin_writeData[11 : 11];
  assign _zz_VexRiscv_253_ = execute_CsrPlugin_writeData[7 : 7];
  assign _zz_VexRiscv_254_ = execute_CsrPlugin_writeData[3 : 3];
  assign _zz_VexRiscv_255_ = 1'b1;
  assign _zz_VexRiscv_256_ = 1'b1;
  assign _zz_VexRiscv_257_ = {_zz_VexRiscv_53_,_zz_VexRiscv_52_};
  assign _zz_VexRiscv_258_ = (_zz_VexRiscv_63_[11 : 10] == (2'b01));
  assign _zz_VexRiscv_259_ = ((_zz_VexRiscv_63_[11 : 10] == (2'b11)) && (_zz_VexRiscv_63_[6 : 5] == (2'b00)));
  assign _zz_VexRiscv_260_ = (7'b0000000);
  assign _zz_VexRiscv_261_ = _zz_VexRiscv_63_[6 : 2];
  assign _zz_VexRiscv_262_ = _zz_VexRiscv_63_[12];
  assign _zz_VexRiscv_263_ = _zz_VexRiscv_63_[11 : 7];
  assign _zz_VexRiscv_264_ = decode_INSTRUCTION[31];
  assign _zz_VexRiscv_265_ = decode_INSTRUCTION[19 : 12];
  assign _zz_VexRiscv_266_ = decode_INSTRUCTION[20];
  assign _zz_VexRiscv_267_ = decode_INSTRUCTION[31];
  assign _zz_VexRiscv_268_ = decode_INSTRUCTION[7];
  assign _zz_VexRiscv_269_ = (32'b00000000000000000111000001010100);
  assign _zz_VexRiscv_270_ = ((decode_INSTRUCTION & _zz_VexRiscv_280_) == (32'b01000000000000000001000000010000));
  assign _zz_VexRiscv_271_ = (_zz_VexRiscv_281_ == _zz_VexRiscv_282_);
  assign _zz_VexRiscv_272_ = (_zz_VexRiscv_283_ == _zz_VexRiscv_284_);
  assign _zz_VexRiscv_273_ = (_zz_VexRiscv_285_ == _zz_VexRiscv_286_);
  assign _zz_VexRiscv_274_ = {_zz_VexRiscv_115_,{_zz_VexRiscv_287_,_zz_VexRiscv_288_}};
  assign _zz_VexRiscv_275_ = {_zz_VexRiscv_289_,_zz_VexRiscv_290_};
  assign _zz_VexRiscv_276_ = (2'b00);
  assign _zz_VexRiscv_277_ = (_zz_VexRiscv_291_ != (1'b0));
  assign _zz_VexRiscv_278_ = (_zz_VexRiscv_292_ != _zz_VexRiscv_293_);
  assign _zz_VexRiscv_279_ = {_zz_VexRiscv_294_,{_zz_VexRiscv_295_,_zz_VexRiscv_296_}};
  assign _zz_VexRiscv_280_ = (32'b01000000000000000011000001010100);
  assign _zz_VexRiscv_281_ = (decode_INSTRUCTION & (32'b00000000000000000111000000110100));
  assign _zz_VexRiscv_282_ = (32'b00000000000000000001000000010000);
  assign _zz_VexRiscv_283_ = (decode_INSTRUCTION & (32'b00000010000000000111000001010100));
  assign _zz_VexRiscv_284_ = (32'b00000000000000000001000000010000);
  assign _zz_VexRiscv_285_ = (decode_INSTRUCTION & (32'b00000000000000000000000001000000));
  assign _zz_VexRiscv_286_ = (32'b00000000000000000000000001000000);
  assign _zz_VexRiscv_287_ = (_zz_VexRiscv_297_ == _zz_VexRiscv_298_);
  assign _zz_VexRiscv_288_ = (_zz_VexRiscv_299_ == _zz_VexRiscv_300_);
  assign _zz_VexRiscv_289_ = ((decode_INSTRUCTION & _zz_VexRiscv_301_) == (32'b00000000000000000000000000100000));
  assign _zz_VexRiscv_290_ = ((decode_INSTRUCTION & _zz_VexRiscv_302_) == (32'b00000000000000000000000000100000));
  assign _zz_VexRiscv_291_ = ((decode_INSTRUCTION & _zz_VexRiscv_303_) == (32'b00000000000000000001000000000000));
  assign _zz_VexRiscv_292_ = (_zz_VexRiscv_304_ == _zz_VexRiscv_305_);
  assign _zz_VexRiscv_293_ = (1'b0);
  assign _zz_VexRiscv_294_ = ({_zz_VexRiscv_306_,_zz_VexRiscv_307_} != (5'b00000));
  assign _zz_VexRiscv_295_ = (_zz_VexRiscv_308_ != _zz_VexRiscv_309_);
  assign _zz_VexRiscv_296_ = {_zz_VexRiscv_310_,{_zz_VexRiscv_311_,_zz_VexRiscv_312_}};
  assign _zz_VexRiscv_297_ = (decode_INSTRUCTION & (32'b00000000000000000000000000110000));
  assign _zz_VexRiscv_298_ = (32'b00000000000000000000000000010000);
  assign _zz_VexRiscv_299_ = (decode_INSTRUCTION & (32'b00000010000000000000000000100000));
  assign _zz_VexRiscv_300_ = (32'b00000000000000000000000000100000);
  assign _zz_VexRiscv_301_ = (32'b00000000000000000000000000110100);
  assign _zz_VexRiscv_302_ = (32'b00000000000000000000000001100100);
  assign _zz_VexRiscv_303_ = (32'b00000000000000000001000000000000);
  assign _zz_VexRiscv_304_ = (decode_INSTRUCTION & (32'b00000000000000000011000000000000));
  assign _zz_VexRiscv_305_ = (32'b00000000000000000010000000000000);
  assign _zz_VexRiscv_306_ = _zz_VexRiscv_115_;
  assign _zz_VexRiscv_307_ = {(_zz_VexRiscv_313_ == _zz_VexRiscv_314_),{_zz_VexRiscv_315_,{_zz_VexRiscv_316_,_zz_VexRiscv_317_}}};
  assign _zz_VexRiscv_308_ = {_zz_VexRiscv_114_,(_zz_VexRiscv_318_ == _zz_VexRiscv_319_)};
  assign _zz_VexRiscv_309_ = (2'b00);
  assign _zz_VexRiscv_310_ = ((_zz_VexRiscv_320_ == _zz_VexRiscv_321_) != (1'b0));
  assign _zz_VexRiscv_311_ = ({_zz_VexRiscv_322_,_zz_VexRiscv_323_} != (2'b00));
  assign _zz_VexRiscv_312_ = {(_zz_VexRiscv_324_ != _zz_VexRiscv_325_),{_zz_VexRiscv_326_,{_zz_VexRiscv_327_,_zz_VexRiscv_328_}}};
  assign _zz_VexRiscv_313_ = (decode_INSTRUCTION & (32'b00000000000000000010000000110000));
  assign _zz_VexRiscv_314_ = (32'b00000000000000000010000000010000);
  assign _zz_VexRiscv_315_ = ((decode_INSTRUCTION & _zz_VexRiscv_329_) == (32'b00000000000000000000000000010000));
  assign _zz_VexRiscv_316_ = (_zz_VexRiscv_330_ == _zz_VexRiscv_331_);
  assign _zz_VexRiscv_317_ = (_zz_VexRiscv_332_ == _zz_VexRiscv_333_);
  assign _zz_VexRiscv_318_ = (decode_INSTRUCTION & (32'b00000000000000000000000000011100));
  assign _zz_VexRiscv_319_ = (32'b00000000000000000000000000000100);
  assign _zz_VexRiscv_320_ = (decode_INSTRUCTION & (32'b00000000000000000000000001011000));
  assign _zz_VexRiscv_321_ = (32'b00000000000000000000000001000000);
  assign _zz_VexRiscv_322_ = (_zz_VexRiscv_334_ == _zz_VexRiscv_335_);
  assign _zz_VexRiscv_323_ = _zz_VexRiscv_116_;
  assign _zz_VexRiscv_324_ = {_zz_VexRiscv_336_,_zz_VexRiscv_116_};
  assign _zz_VexRiscv_325_ = (2'b00);
  assign _zz_VexRiscv_326_ = ({_zz_VexRiscv_337_,_zz_VexRiscv_338_} != (2'b00));
  assign _zz_VexRiscv_327_ = (_zz_VexRiscv_339_ != _zz_VexRiscv_340_);
  assign _zz_VexRiscv_328_ = {_zz_VexRiscv_341_,{_zz_VexRiscv_342_,_zz_VexRiscv_343_}};
  assign _zz_VexRiscv_329_ = (32'b00000000000000000001000000110000);
  assign _zz_VexRiscv_330_ = (decode_INSTRUCTION & (32'b00000010000000000010000001100000));
  assign _zz_VexRiscv_331_ = (32'b00000000000000000010000000100000);
  assign _zz_VexRiscv_332_ = (decode_INSTRUCTION & (32'b00000010000000000011000000100000));
  assign _zz_VexRiscv_333_ = (32'b00000000000000000000000000100000);
  assign _zz_VexRiscv_334_ = (decode_INSTRUCTION & (32'b00000000000000000000000000010100));
  assign _zz_VexRiscv_335_ = (32'b00000000000000000000000000000100);
  assign _zz_VexRiscv_336_ = ((decode_INSTRUCTION & (32'b00000000000000000000000001000100)) == (32'b00000000000000000000000000000100));
  assign _zz_VexRiscv_337_ = ((decode_INSTRUCTION & _zz_VexRiscv_344_) == (32'b00000000000000000010000000000000));
  assign _zz_VexRiscv_338_ = ((decode_INSTRUCTION & _zz_VexRiscv_345_) == (32'b00000000000000000001000000000000));
  assign _zz_VexRiscv_339_ = ((decode_INSTRUCTION & _zz_VexRiscv_346_) == (32'b00000000000000000000000000000000));
  assign _zz_VexRiscv_340_ = (1'b0);
  assign _zz_VexRiscv_341_ = ((_zz_VexRiscv_347_ == _zz_VexRiscv_348_) != (1'b0));
  assign _zz_VexRiscv_342_ = (_zz_VexRiscv_349_ != (1'b0));
  assign _zz_VexRiscv_343_ = {(_zz_VexRiscv_350_ != _zz_VexRiscv_351_),{_zz_VexRiscv_352_,{_zz_VexRiscv_353_,_zz_VexRiscv_354_}}};
  assign _zz_VexRiscv_344_ = (32'b00000000000000000010000000010000);
  assign _zz_VexRiscv_345_ = (32'b00000000000000000101000000000000);
  assign _zz_VexRiscv_346_ = (32'b00000000000000000000000001011000);
  assign _zz_VexRiscv_347_ = (decode_INSTRUCTION & (32'b00000000000000000000000001100100));
  assign _zz_VexRiscv_348_ = (32'b00000000000000000000000000100100);
  assign _zz_VexRiscv_349_ = ((decode_INSTRUCTION & (32'b00000000000000000000000000100000)) == (32'b00000000000000000000000000100000));
  assign _zz_VexRiscv_350_ = {_zz_VexRiscv_115_,((decode_INSTRUCTION & _zz_VexRiscv_355_) == (32'b00000000000000000000000000100000))};
  assign _zz_VexRiscv_351_ = (2'b00);
  assign _zz_VexRiscv_352_ = ({_zz_VexRiscv_115_,(_zz_VexRiscv_356_ == _zz_VexRiscv_357_)} != (2'b00));
  assign _zz_VexRiscv_353_ = ({_zz_VexRiscv_358_,_zz_VexRiscv_359_} != (2'b00));
  assign _zz_VexRiscv_354_ = {({_zz_VexRiscv_360_,_zz_VexRiscv_361_} != (2'b00)),{(_zz_VexRiscv_362_ != _zz_VexRiscv_363_),{_zz_VexRiscv_364_,{_zz_VexRiscv_365_,_zz_VexRiscv_366_}}}};
  assign _zz_VexRiscv_355_ = (32'b00000000000000000000000001110000);
  assign _zz_VexRiscv_356_ = (decode_INSTRUCTION & (32'b00000000000000000000000000100000));
  assign _zz_VexRiscv_357_ = (32'b00000000000000000000000000000000);
  assign _zz_VexRiscv_358_ = ((decode_INSTRUCTION & (32'b00000000000000000001000001010000)) == (32'b00000000000000000001000001010000));
  assign _zz_VexRiscv_359_ = ((decode_INSTRUCTION & (32'b00000000000000000010000001010000)) == (32'b00000000000000000010000001010000));
  assign _zz_VexRiscv_360_ = ((decode_INSTRUCTION & _zz_VexRiscv_367_) == (32'b00000000000000000000000001000000));
  assign _zz_VexRiscv_361_ = ((decode_INSTRUCTION & _zz_VexRiscv_368_) == (32'b00000000000000000000000001000000));
  assign _zz_VexRiscv_362_ = ((decode_INSTRUCTION & _zz_VexRiscv_369_) == (32'b00000010000000000000000000110000));
  assign _zz_VexRiscv_363_ = (1'b0);
  assign _zz_VexRiscv_364_ = ((_zz_VexRiscv_370_ == _zz_VexRiscv_371_) != (1'b0));
  assign _zz_VexRiscv_365_ = ({_zz_VexRiscv_372_,_zz_VexRiscv_373_} != (6'b000000));
  assign _zz_VexRiscv_366_ = {(_zz_VexRiscv_374_ != _zz_VexRiscv_375_),{_zz_VexRiscv_376_,{_zz_VexRiscv_377_,_zz_VexRiscv_378_}}};
  assign _zz_VexRiscv_367_ = (32'b00000000000000000000000001010000);
  assign _zz_VexRiscv_368_ = (32'b00000000000000000011000001000000);
  assign _zz_VexRiscv_369_ = (32'b00000010000000000000000001110100);
  assign _zz_VexRiscv_370_ = (decode_INSTRUCTION & (32'b00000000000000000011000001010000));
  assign _zz_VexRiscv_371_ = (32'b00000000000000000000000001010000);
  assign _zz_VexRiscv_372_ = _zz_VexRiscv_114_;
  assign _zz_VexRiscv_373_ = {((decode_INSTRUCTION & _zz_VexRiscv_379_) == (32'b00000000000000000001000000010000)),{(_zz_VexRiscv_380_ == _zz_VexRiscv_381_),{_zz_VexRiscv_382_,{_zz_VexRiscv_383_,_zz_VexRiscv_384_}}}};
  assign _zz_VexRiscv_374_ = ((decode_INSTRUCTION & (32'b00000000000000000100000000000100)) == (32'b00000000000000000100000000000000));
  assign _zz_VexRiscv_375_ = (1'b0);
  assign _zz_VexRiscv_376_ = (_zz_VexRiscv_113_ != (1'b0));
  assign _zz_VexRiscv_377_ = ({_zz_VexRiscv_385_,{_zz_VexRiscv_386_,_zz_VexRiscv_387_}} != (3'b000));
  assign _zz_VexRiscv_378_ = ({_zz_VexRiscv_388_,{_zz_VexRiscv_389_,_zz_VexRiscv_390_}} != (4'b0000));
  assign _zz_VexRiscv_379_ = (32'b00000000000000000001000000010000);
  assign _zz_VexRiscv_380_ = (decode_INSTRUCTION & (32'b00000000000000000010000000010000));
  assign _zz_VexRiscv_381_ = (32'b00000000000000000010000000010000);
  assign _zz_VexRiscv_382_ = ((decode_INSTRUCTION & (32'b00000000000000000000000001010000)) == (32'b00000000000000000000000000010000));
  assign _zz_VexRiscv_383_ = ((decode_INSTRUCTION & _zz_VexRiscv_391_) == (32'b00000000000000000000000000000100));
  assign _zz_VexRiscv_384_ = ((decode_INSTRUCTION & _zz_VexRiscv_392_) == (32'b00000000000000000000000000000000));
  assign _zz_VexRiscv_385_ = ((decode_INSTRUCTION & (32'b00000000000000000000000001000100)) == (32'b00000000000000000000000001000000));
  assign _zz_VexRiscv_386_ = ((decode_INSTRUCTION & _zz_VexRiscv_393_) == (32'b00000000000000000010000000010000));
  assign _zz_VexRiscv_387_ = ((decode_INSTRUCTION & _zz_VexRiscv_394_) == (32'b01000000000000000000000000110000));
  assign _zz_VexRiscv_388_ = ((decode_INSTRUCTION & (32'b00000000000000000000000001000100)) == (32'b00000000000000000000000000000000));
  assign _zz_VexRiscv_389_ = ((decode_INSTRUCTION & _zz_VexRiscv_395_) == (32'b00000000000000000000000000000000));
  assign _zz_VexRiscv_390_ = {_zz_VexRiscv_113_,(_zz_VexRiscv_396_ == _zz_VexRiscv_397_)};
  assign _zz_VexRiscv_391_ = (32'b00000000000000000000000000001100);
  assign _zz_VexRiscv_392_ = (32'b00000000000000000000000000101000);
  assign _zz_VexRiscv_393_ = (32'b00000000000000000010000000010100);
  assign _zz_VexRiscv_394_ = (32'b01000000000000000000000000110100);
  assign _zz_VexRiscv_395_ = (32'b00000000000000000000000000011000);
  assign _zz_VexRiscv_396_ = (decode_INSTRUCTION & (32'b00000000000000000101000000000100));
  assign _zz_VexRiscv_397_ = (32'b00000000000000000001000000000000);
  assign _zz_VexRiscv_398_ = execute_INSTRUCTION[31];
  assign _zz_VexRiscv_399_ = execute_INSTRUCTION[31];
  assign _zz_VexRiscv_400_ = execute_INSTRUCTION[7];
  always @ (posedge clk) begin
    if(_zz_VexRiscv_255_) begin
      _zz_VexRiscv_154_ <= 0;
    end
  end

  always @ (posedge clk) begin
    if(_zz_VexRiscv_256_) begin
      _zz_VexRiscv_155_ <= 0;
    end
  end

  always @ (posedge clk) begin
    if(_zz_VexRiscv_34_) begin
    end
  end

  StreamFifoLowLatency IBusSimplePlugin_rspJoin_rspBuffer_c ( 
    .io_push_valid(iBus_rsp_takeWhen_valid),
    .io_push_ready(IBusSimplePlugin_rspJoin_rspBuffer_c_io_push_ready),
    .io_push_payload_error(iBus_rsp_takeWhen_payload_error),
    .io_push_payload_inst(iBus_rsp_takeWhen_payload_inst),
    .io_pop_valid(IBusSimplePlugin_rspJoin_rspBuffer_c_io_pop_valid),
    .io_pop_ready(IBusSimplePlugin_rspJoin_rspBufferOutput_ready),
    .io_pop_payload_error(IBusSimplePlugin_rspJoin_rspBuffer_c_io_pop_payload_error),
    .io_pop_payload_inst(IBusSimplePlugin_rspJoin_rspBuffer_c_io_pop_payload_inst),
    .io_flush(IBusSimplePlugin_fetcherflushIt),
    .io_occupancy(IBusSimplePlugin_rspJoin_rspBuffer_c_io_occupancy),
    .clk(clk),
    .reset(reset) 
  );
  always @(*) begin
    case(_zz_VexRiscv_257_)
      2'b00 : begin
        _zz_VexRiscv_156_ = CsrPlugin_jumpInterface_payload;
      end
      2'b01 : begin
        _zz_VexRiscv_156_ = BranchPlugin_jumpInterface_payload;
      end
      default : begin
        _zz_VexRiscv_156_ = IBusSimplePlugin_predictionJumpInterface_payload;
      end
    endcase
  end

  `ifndef SYNTHESIS
  always @(*) begin
    case(decode_ALU_CTRL)
      `AluCtrlEnum_defaultEncoding_ADD_SUB : decode_ALU_CTRL_string = "ADD_SUB ";
      `AluCtrlEnum_defaultEncoding_SLT_SLTU : decode_ALU_CTRL_string = "SLT_SLTU";
      `AluCtrlEnum_defaultEncoding_BITWISE : decode_ALU_CTRL_string = "BITWISE ";
      default : decode_ALU_CTRL_string = "????????";
    endcase
  end
  always @(*) begin
    case(_zz_VexRiscv_1_)
      `AluCtrlEnum_defaultEncoding_ADD_SUB : _zz_VexRiscv_1__string = "ADD_SUB ";
      `AluCtrlEnum_defaultEncoding_SLT_SLTU : _zz_VexRiscv_1__string = "SLT_SLTU";
      `AluCtrlEnum_defaultEncoding_BITWISE : _zz_VexRiscv_1__string = "BITWISE ";
      default : _zz_VexRiscv_1__string = "????????";
    endcase
  end
  always @(*) begin
    case(_zz_VexRiscv_2_)
      `AluCtrlEnum_defaultEncoding_ADD_SUB : _zz_VexRiscv_2__string = "ADD_SUB ";
      `AluCtrlEnum_defaultEncoding_SLT_SLTU : _zz_VexRiscv_2__string = "SLT_SLTU";
      `AluCtrlEnum_defaultEncoding_BITWISE : _zz_VexRiscv_2__string = "BITWISE ";
      default : _zz_VexRiscv_2__string = "????????";
    endcase
  end
  always @(*) begin
    case(_zz_VexRiscv_3_)
      `AluCtrlEnum_defaultEncoding_ADD_SUB : _zz_VexRiscv_3__string = "ADD_SUB ";
      `AluCtrlEnum_defaultEncoding_SLT_SLTU : _zz_VexRiscv_3__string = "SLT_SLTU";
      `AluCtrlEnum_defaultEncoding_BITWISE : _zz_VexRiscv_3__string = "BITWISE ";
      default : _zz_VexRiscv_3__string = "????????";
    endcase
  end
  always @(*) begin
    case(decode_ALU_BITWISE_CTRL)
      `AluBitwiseCtrlEnum_defaultEncoding_XOR_1 : decode_ALU_BITWISE_CTRL_string = "XOR_1";
      `AluBitwiseCtrlEnum_defaultEncoding_OR_1 : decode_ALU_BITWISE_CTRL_string = "OR_1 ";
      `AluBitwiseCtrlEnum_defaultEncoding_AND_1 : decode_ALU_BITWISE_CTRL_string = "AND_1";
      default : decode_ALU_BITWISE_CTRL_string = "?????";
    endcase
  end
  always @(*) begin
    case(_zz_VexRiscv_4_)
      `AluBitwiseCtrlEnum_defaultEncoding_XOR_1 : _zz_VexRiscv_4__string = "XOR_1";
      `AluBitwiseCtrlEnum_defaultEncoding_OR_1 : _zz_VexRiscv_4__string = "OR_1 ";
      `AluBitwiseCtrlEnum_defaultEncoding_AND_1 : _zz_VexRiscv_4__string = "AND_1";
      default : _zz_VexRiscv_4__string = "?????";
    endcase
  end
  always @(*) begin
    case(_zz_VexRiscv_5_)
      `AluBitwiseCtrlEnum_defaultEncoding_XOR_1 : _zz_VexRiscv_5__string = "XOR_1";
      `AluBitwiseCtrlEnum_defaultEncoding_OR_1 : _zz_VexRiscv_5__string = "OR_1 ";
      `AluBitwiseCtrlEnum_defaultEncoding_AND_1 : _zz_VexRiscv_5__string = "AND_1";
      default : _zz_VexRiscv_5__string = "?????";
    endcase
  end
  always @(*) begin
    case(_zz_VexRiscv_6_)
      `AluBitwiseCtrlEnum_defaultEncoding_XOR_1 : _zz_VexRiscv_6__string = "XOR_1";
      `AluBitwiseCtrlEnum_defaultEncoding_OR_1 : _zz_VexRiscv_6__string = "OR_1 ";
      `AluBitwiseCtrlEnum_defaultEncoding_AND_1 : _zz_VexRiscv_6__string = "AND_1";
      default : _zz_VexRiscv_6__string = "?????";
    endcase
  end
  always @(*) begin
    case(_zz_VexRiscv_7_)
      `ShiftCtrlEnum_defaultEncoding_DISABLE_1 : _zz_VexRiscv_7__string = "DISABLE_1";
      `ShiftCtrlEnum_defaultEncoding_SLL_1 : _zz_VexRiscv_7__string = "SLL_1    ";
      `ShiftCtrlEnum_defaultEncoding_SRL_1 : _zz_VexRiscv_7__string = "SRL_1    ";
      `ShiftCtrlEnum_defaultEncoding_SRA_1 : _zz_VexRiscv_7__string = "SRA_1    ";
      default : _zz_VexRiscv_7__string = "?????????";
    endcase
  end
  always @(*) begin
    case(_zz_VexRiscv_8_)
      `ShiftCtrlEnum_defaultEncoding_DISABLE_1 : _zz_VexRiscv_8__string = "DISABLE_1";
      `ShiftCtrlEnum_defaultEncoding_SLL_1 : _zz_VexRiscv_8__string = "SLL_1    ";
      `ShiftCtrlEnum_defaultEncoding_SRL_1 : _zz_VexRiscv_8__string = "SRL_1    ";
      `ShiftCtrlEnum_defaultEncoding_SRA_1 : _zz_VexRiscv_8__string = "SRA_1    ";
      default : _zz_VexRiscv_8__string = "?????????";
    endcase
  end
  always @(*) begin
    case(decode_SHIFT_CTRL)
      `ShiftCtrlEnum_defaultEncoding_DISABLE_1 : decode_SHIFT_CTRL_string = "DISABLE_1";
      `ShiftCtrlEnum_defaultEncoding_SLL_1 : decode_SHIFT_CTRL_string = "SLL_1    ";
      `ShiftCtrlEnum_defaultEncoding_SRL_1 : decode_SHIFT_CTRL_string = "SRL_1    ";
      `ShiftCtrlEnum_defaultEncoding_SRA_1 : decode_SHIFT_CTRL_string = "SRA_1    ";
      default : decode_SHIFT_CTRL_string = "?????????";
    endcase
  end
  always @(*) begin
    case(_zz_VexRiscv_9_)
      `ShiftCtrlEnum_defaultEncoding_DISABLE_1 : _zz_VexRiscv_9__string = "DISABLE_1";
      `ShiftCtrlEnum_defaultEncoding_SLL_1 : _zz_VexRiscv_9__string = "SLL_1    ";
      `ShiftCtrlEnum_defaultEncoding_SRL_1 : _zz_VexRiscv_9__string = "SRL_1    ";
      `ShiftCtrlEnum_defaultEncoding_SRA_1 : _zz_VexRiscv_9__string = "SRA_1    ";
      default : _zz_VexRiscv_9__string = "?????????";
    endcase
  end
  always @(*) begin
    case(_zz_VexRiscv_10_)
      `ShiftCtrlEnum_defaultEncoding_DISABLE_1 : _zz_VexRiscv_10__string = "DISABLE_1";
      `ShiftCtrlEnum_defaultEncoding_SLL_1 : _zz_VexRiscv_10__string = "SLL_1    ";
      `ShiftCtrlEnum_defaultEncoding_SRL_1 : _zz_VexRiscv_10__string = "SRL_1    ";
      `ShiftCtrlEnum_defaultEncoding_SRA_1 : _zz_VexRiscv_10__string = "SRA_1    ";
      default : _zz_VexRiscv_10__string = "?????????";
    endcase
  end
  always @(*) begin
    case(_zz_VexRiscv_11_)
      `ShiftCtrlEnum_defaultEncoding_DISABLE_1 : _zz_VexRiscv_11__string = "DISABLE_1";
      `ShiftCtrlEnum_defaultEncoding_SLL_1 : _zz_VexRiscv_11__string = "SLL_1    ";
      `ShiftCtrlEnum_defaultEncoding_SRL_1 : _zz_VexRiscv_11__string = "SRL_1    ";
      `ShiftCtrlEnum_defaultEncoding_SRA_1 : _zz_VexRiscv_11__string = "SRA_1    ";
      default : _zz_VexRiscv_11__string = "?????????";
    endcase
  end
  always @(*) begin
    case(_zz_VexRiscv_12_)
      `BranchCtrlEnum_defaultEncoding_INC : _zz_VexRiscv_12__string = "INC ";
      `BranchCtrlEnum_defaultEncoding_B : _zz_VexRiscv_12__string = "B   ";
      `BranchCtrlEnum_defaultEncoding_JAL : _zz_VexRiscv_12__string = "JAL ";
      `BranchCtrlEnum_defaultEncoding_JALR : _zz_VexRiscv_12__string = "JALR";
      default : _zz_VexRiscv_12__string = "????";
    endcase
  end
  always @(*) begin
    case(_zz_VexRiscv_13_)
      `BranchCtrlEnum_defaultEncoding_INC : _zz_VexRiscv_13__string = "INC ";
      `BranchCtrlEnum_defaultEncoding_B : _zz_VexRiscv_13__string = "B   ";
      `BranchCtrlEnum_defaultEncoding_JAL : _zz_VexRiscv_13__string = "JAL ";
      `BranchCtrlEnum_defaultEncoding_JALR : _zz_VexRiscv_13__string = "JALR";
      default : _zz_VexRiscv_13__string = "????";
    endcase
  end
  always @(*) begin
    case(_zz_VexRiscv_14_)
      `EnvCtrlEnum_defaultEncoding_NONE : _zz_VexRiscv_14__string = "NONE";
      `EnvCtrlEnum_defaultEncoding_XRET : _zz_VexRiscv_14__string = "XRET";
      default : _zz_VexRiscv_14__string = "????";
    endcase
  end
  always @(*) begin
    case(_zz_VexRiscv_15_)
      `EnvCtrlEnum_defaultEncoding_NONE : _zz_VexRiscv_15__string = "NONE";
      `EnvCtrlEnum_defaultEncoding_XRET : _zz_VexRiscv_15__string = "XRET";
      default : _zz_VexRiscv_15__string = "????";
    endcase
  end
  always @(*) begin
    case(_zz_VexRiscv_16_)
      `EnvCtrlEnum_defaultEncoding_NONE : _zz_VexRiscv_16__string = "NONE";
      `EnvCtrlEnum_defaultEncoding_XRET : _zz_VexRiscv_16__string = "XRET";
      default : _zz_VexRiscv_16__string = "????";
    endcase
  end
  always @(*) begin
    case(_zz_VexRiscv_17_)
      `EnvCtrlEnum_defaultEncoding_NONE : _zz_VexRiscv_17__string = "NONE";
      `EnvCtrlEnum_defaultEncoding_XRET : _zz_VexRiscv_17__string = "XRET";
      default : _zz_VexRiscv_17__string = "????";
    endcase
  end
  always @(*) begin
    case(decode_ENV_CTRL)
      `EnvCtrlEnum_defaultEncoding_NONE : decode_ENV_CTRL_string = "NONE";
      `EnvCtrlEnum_defaultEncoding_XRET : decode_ENV_CTRL_string = "XRET";
      default : decode_ENV_CTRL_string = "????";
    endcase
  end
  always @(*) begin
    case(_zz_VexRiscv_18_)
      `EnvCtrlEnum_defaultEncoding_NONE : _zz_VexRiscv_18__string = "NONE";
      `EnvCtrlEnum_defaultEncoding_XRET : _zz_VexRiscv_18__string = "XRET";
      default : _zz_VexRiscv_18__string = "????";
    endcase
  end
  always @(*) begin
    case(_zz_VexRiscv_19_)
      `EnvCtrlEnum_defaultEncoding_NONE : _zz_VexRiscv_19__string = "NONE";
      `EnvCtrlEnum_defaultEncoding_XRET : _zz_VexRiscv_19__string = "XRET";
      default : _zz_VexRiscv_19__string = "????";
    endcase
  end
  always @(*) begin
    case(_zz_VexRiscv_20_)
      `EnvCtrlEnum_defaultEncoding_NONE : _zz_VexRiscv_20__string = "NONE";
      `EnvCtrlEnum_defaultEncoding_XRET : _zz_VexRiscv_20__string = "XRET";
      default : _zz_VexRiscv_20__string = "????";
    endcase
  end
  always @(*) begin
    case(execute_BRANCH_CTRL)
      `BranchCtrlEnum_defaultEncoding_INC : execute_BRANCH_CTRL_string = "INC ";
      `BranchCtrlEnum_defaultEncoding_B : execute_BRANCH_CTRL_string = "B   ";
      `BranchCtrlEnum_defaultEncoding_JAL : execute_BRANCH_CTRL_string = "JAL ";
      `BranchCtrlEnum_defaultEncoding_JALR : execute_BRANCH_CTRL_string = "JALR";
      default : execute_BRANCH_CTRL_string = "????";
    endcase
  end
  always @(*) begin
    case(_zz_VexRiscv_21_)
      `BranchCtrlEnum_defaultEncoding_INC : _zz_VexRiscv_21__string = "INC ";
      `BranchCtrlEnum_defaultEncoding_B : _zz_VexRiscv_21__string = "B   ";
      `BranchCtrlEnum_defaultEncoding_JAL : _zz_VexRiscv_21__string = "JAL ";
      `BranchCtrlEnum_defaultEncoding_JALR : _zz_VexRiscv_21__string = "JALR";
      default : _zz_VexRiscv_21__string = "????";
    endcase
  end
  always @(*) begin
    case(memory_SHIFT_CTRL)
      `ShiftCtrlEnum_defaultEncoding_DISABLE_1 : memory_SHIFT_CTRL_string = "DISABLE_1";
      `ShiftCtrlEnum_defaultEncoding_SLL_1 : memory_SHIFT_CTRL_string = "SLL_1    ";
      `ShiftCtrlEnum_defaultEncoding_SRL_1 : memory_SHIFT_CTRL_string = "SRL_1    ";
      `ShiftCtrlEnum_defaultEncoding_SRA_1 : memory_SHIFT_CTRL_string = "SRA_1    ";
      default : memory_SHIFT_CTRL_string = "?????????";
    endcase
  end
  always @(*) begin
    case(_zz_VexRiscv_23_)
      `ShiftCtrlEnum_defaultEncoding_DISABLE_1 : _zz_VexRiscv_23__string = "DISABLE_1";
      `ShiftCtrlEnum_defaultEncoding_SLL_1 : _zz_VexRiscv_23__string = "SLL_1    ";
      `ShiftCtrlEnum_defaultEncoding_SRL_1 : _zz_VexRiscv_23__string = "SRL_1    ";
      `ShiftCtrlEnum_defaultEncoding_SRA_1 : _zz_VexRiscv_23__string = "SRA_1    ";
      default : _zz_VexRiscv_23__string = "?????????";
    endcase
  end
  always @(*) begin
    case(execute_SHIFT_CTRL)
      `ShiftCtrlEnum_defaultEncoding_DISABLE_1 : execute_SHIFT_CTRL_string = "DISABLE_1";
      `ShiftCtrlEnum_defaultEncoding_SLL_1 : execute_SHIFT_CTRL_string = "SLL_1    ";
      `ShiftCtrlEnum_defaultEncoding_SRL_1 : execute_SHIFT_CTRL_string = "SRL_1    ";
      `ShiftCtrlEnum_defaultEncoding_SRA_1 : execute_SHIFT_CTRL_string = "SRA_1    ";
      default : execute_SHIFT_CTRL_string = "?????????";
    endcase
  end
  always @(*) begin
    case(_zz_VexRiscv_24_)
      `ShiftCtrlEnum_defaultEncoding_DISABLE_1 : _zz_VexRiscv_24__string = "DISABLE_1";
      `ShiftCtrlEnum_defaultEncoding_SLL_1 : _zz_VexRiscv_24__string = "SLL_1    ";
      `ShiftCtrlEnum_defaultEncoding_SRL_1 : _zz_VexRiscv_24__string = "SRL_1    ";
      `ShiftCtrlEnum_defaultEncoding_SRA_1 : _zz_VexRiscv_24__string = "SRA_1    ";
      default : _zz_VexRiscv_24__string = "?????????";
    endcase
  end
  always @(*) begin
    case(decode_SRC2_CTRL)
      `Src2CtrlEnum_defaultEncoding_RS : decode_SRC2_CTRL_string = "RS ";
      `Src2CtrlEnum_defaultEncoding_IMI : decode_SRC2_CTRL_string = "IMI";
      `Src2CtrlEnum_defaultEncoding_IMS : decode_SRC2_CTRL_string = "IMS";
      `Src2CtrlEnum_defaultEncoding_PC : decode_SRC2_CTRL_string = "PC ";
      default : decode_SRC2_CTRL_string = "???";
    endcase
  end
  always @(*) begin
    case(_zz_VexRiscv_27_)
      `Src2CtrlEnum_defaultEncoding_RS : _zz_VexRiscv_27__string = "RS ";
      `Src2CtrlEnum_defaultEncoding_IMI : _zz_VexRiscv_27__string = "IMI";
      `Src2CtrlEnum_defaultEncoding_IMS : _zz_VexRiscv_27__string = "IMS";
      `Src2CtrlEnum_defaultEncoding_PC : _zz_VexRiscv_27__string = "PC ";
      default : _zz_VexRiscv_27__string = "???";
    endcase
  end
  always @(*) begin
    case(decode_SRC1_CTRL)
      `Src1CtrlEnum_defaultEncoding_RS : decode_SRC1_CTRL_string = "RS          ";
      `Src1CtrlEnum_defaultEncoding_IMU : decode_SRC1_CTRL_string = "IMU         ";
      `Src1CtrlEnum_defaultEncoding_PC_INCREMENT : decode_SRC1_CTRL_string = "PC_INCREMENT";
      `Src1CtrlEnum_defaultEncoding_URS1 : decode_SRC1_CTRL_string = "URS1        ";
      default : decode_SRC1_CTRL_string = "????????????";
    endcase
  end
  always @(*) begin
    case(_zz_VexRiscv_29_)
      `Src1CtrlEnum_defaultEncoding_RS : _zz_VexRiscv_29__string = "RS          ";
      `Src1CtrlEnum_defaultEncoding_IMU : _zz_VexRiscv_29__string = "IMU         ";
      `Src1CtrlEnum_defaultEncoding_PC_INCREMENT : _zz_VexRiscv_29__string = "PC_INCREMENT";
      `Src1CtrlEnum_defaultEncoding_URS1 : _zz_VexRiscv_29__string = "URS1        ";
      default : _zz_VexRiscv_29__string = "????????????";
    endcase
  end
  always @(*) begin
    case(execute_ALU_CTRL)
      `AluCtrlEnum_defaultEncoding_ADD_SUB : execute_ALU_CTRL_string = "ADD_SUB ";
      `AluCtrlEnum_defaultEncoding_SLT_SLTU : execute_ALU_CTRL_string = "SLT_SLTU";
      `AluCtrlEnum_defaultEncoding_BITWISE : execute_ALU_CTRL_string = "BITWISE ";
      default : execute_ALU_CTRL_string = "????????";
    endcase
  end
  always @(*) begin
    case(_zz_VexRiscv_30_)
      `AluCtrlEnum_defaultEncoding_ADD_SUB : _zz_VexRiscv_30__string = "ADD_SUB ";
      `AluCtrlEnum_defaultEncoding_SLT_SLTU : _zz_VexRiscv_30__string = "SLT_SLTU";
      `AluCtrlEnum_defaultEncoding_BITWISE : _zz_VexRiscv_30__string = "BITWISE ";
      default : _zz_VexRiscv_30__string = "????????";
    endcase
  end
  always @(*) begin
    case(execute_ALU_BITWISE_CTRL)
      `AluBitwiseCtrlEnum_defaultEncoding_XOR_1 : execute_ALU_BITWISE_CTRL_string = "XOR_1";
      `AluBitwiseCtrlEnum_defaultEncoding_OR_1 : execute_ALU_BITWISE_CTRL_string = "OR_1 ";
      `AluBitwiseCtrlEnum_defaultEncoding_AND_1 : execute_ALU_BITWISE_CTRL_string = "AND_1";
      default : execute_ALU_BITWISE_CTRL_string = "?????";
    endcase
  end
  always @(*) begin
    case(_zz_VexRiscv_31_)
      `AluBitwiseCtrlEnum_defaultEncoding_XOR_1 : _zz_VexRiscv_31__string = "XOR_1";
      `AluBitwiseCtrlEnum_defaultEncoding_OR_1 : _zz_VexRiscv_31__string = "OR_1 ";
      `AluBitwiseCtrlEnum_defaultEncoding_AND_1 : _zz_VexRiscv_31__string = "AND_1";
      default : _zz_VexRiscv_31__string = "?????";
    endcase
  end
  always @(*) begin
    case(_zz_VexRiscv_35_)
      `ShiftCtrlEnum_defaultEncoding_DISABLE_1 : _zz_VexRiscv_35__string = "DISABLE_1";
      `ShiftCtrlEnum_defaultEncoding_SLL_1 : _zz_VexRiscv_35__string = "SLL_1    ";
      `ShiftCtrlEnum_defaultEncoding_SRL_1 : _zz_VexRiscv_35__string = "SRL_1    ";
      `ShiftCtrlEnum_defaultEncoding_SRA_1 : _zz_VexRiscv_35__string = "SRA_1    ";
      default : _zz_VexRiscv_35__string = "?????????";
    endcase
  end
  always @(*) begin
    case(_zz_VexRiscv_36_)
      `AluBitwiseCtrlEnum_defaultEncoding_XOR_1 : _zz_VexRiscv_36__string = "XOR_1";
      `AluBitwiseCtrlEnum_defaultEncoding_OR_1 : _zz_VexRiscv_36__string = "OR_1 ";
      `AluBitwiseCtrlEnum_defaultEncoding_AND_1 : _zz_VexRiscv_36__string = "AND_1";
      default : _zz_VexRiscv_36__string = "?????";
    endcase
  end
  always @(*) begin
    case(_zz_VexRiscv_37_)
      `BranchCtrlEnum_defaultEncoding_INC : _zz_VexRiscv_37__string = "INC ";
      `BranchCtrlEnum_defaultEncoding_B : _zz_VexRiscv_37__string = "B   ";
      `BranchCtrlEnum_defaultEncoding_JAL : _zz_VexRiscv_37__string = "JAL ";
      `BranchCtrlEnum_defaultEncoding_JALR : _zz_VexRiscv_37__string = "JALR";
      default : _zz_VexRiscv_37__string = "????";
    endcase
  end
  always @(*) begin
    case(_zz_VexRiscv_38_)
      `Src1CtrlEnum_defaultEncoding_RS : _zz_VexRiscv_38__string = "RS          ";
      `Src1CtrlEnum_defaultEncoding_IMU : _zz_VexRiscv_38__string = "IMU         ";
      `Src1CtrlEnum_defaultEncoding_PC_INCREMENT : _zz_VexRiscv_38__string = "PC_INCREMENT";
      `Src1CtrlEnum_defaultEncoding_URS1 : _zz_VexRiscv_38__string = "URS1        ";
      default : _zz_VexRiscv_38__string = "????????????";
    endcase
  end
  always @(*) begin
    case(_zz_VexRiscv_39_)
      `Src2CtrlEnum_defaultEncoding_RS : _zz_VexRiscv_39__string = "RS ";
      `Src2CtrlEnum_defaultEncoding_IMI : _zz_VexRiscv_39__string = "IMI";
      `Src2CtrlEnum_defaultEncoding_IMS : _zz_VexRiscv_39__string = "IMS";
      `Src2CtrlEnum_defaultEncoding_PC : _zz_VexRiscv_39__string = "PC ";
      default : _zz_VexRiscv_39__string = "???";
    endcase
  end
  always @(*) begin
    case(_zz_VexRiscv_40_)
      `EnvCtrlEnum_defaultEncoding_NONE : _zz_VexRiscv_40__string = "NONE";
      `EnvCtrlEnum_defaultEncoding_XRET : _zz_VexRiscv_40__string = "XRET";
      default : _zz_VexRiscv_40__string = "????";
    endcase
  end
  always @(*) begin
    case(_zz_VexRiscv_41_)
      `AluCtrlEnum_defaultEncoding_ADD_SUB : _zz_VexRiscv_41__string = "ADD_SUB ";
      `AluCtrlEnum_defaultEncoding_SLT_SLTU : _zz_VexRiscv_41__string = "SLT_SLTU";
      `AluCtrlEnum_defaultEncoding_BITWISE : _zz_VexRiscv_41__string = "BITWISE ";
      default : _zz_VexRiscv_41__string = "????????";
    endcase
  end
  always @(*) begin
    case(memory_ENV_CTRL)
      `EnvCtrlEnum_defaultEncoding_NONE : memory_ENV_CTRL_string = "NONE";
      `EnvCtrlEnum_defaultEncoding_XRET : memory_ENV_CTRL_string = "XRET";
      default : memory_ENV_CTRL_string = "????";
    endcase
  end
  always @(*) begin
    case(_zz_VexRiscv_43_)
      `EnvCtrlEnum_defaultEncoding_NONE : _zz_VexRiscv_43__string = "NONE";
      `EnvCtrlEnum_defaultEncoding_XRET : _zz_VexRiscv_43__string = "XRET";
      default : _zz_VexRiscv_43__string = "????";
    endcase
  end
  always @(*) begin
    case(execute_ENV_CTRL)
      `EnvCtrlEnum_defaultEncoding_NONE : execute_ENV_CTRL_string = "NONE";
      `EnvCtrlEnum_defaultEncoding_XRET : execute_ENV_CTRL_string = "XRET";
      default : execute_ENV_CTRL_string = "????";
    endcase
  end
  always @(*) begin
    case(_zz_VexRiscv_44_)
      `EnvCtrlEnum_defaultEncoding_NONE : _zz_VexRiscv_44__string = "NONE";
      `EnvCtrlEnum_defaultEncoding_XRET : _zz_VexRiscv_44__string = "XRET";
      default : _zz_VexRiscv_44__string = "????";
    endcase
  end
  always @(*) begin
    case(writeBack_ENV_CTRL)
      `EnvCtrlEnum_defaultEncoding_NONE : writeBack_ENV_CTRL_string = "NONE";
      `EnvCtrlEnum_defaultEncoding_XRET : writeBack_ENV_CTRL_string = "XRET";
      default : writeBack_ENV_CTRL_string = "????";
    endcase
  end
  always @(*) begin
    case(_zz_VexRiscv_45_)
      `EnvCtrlEnum_defaultEncoding_NONE : _zz_VexRiscv_45__string = "NONE";
      `EnvCtrlEnum_defaultEncoding_XRET : _zz_VexRiscv_45__string = "XRET";
      default : _zz_VexRiscv_45__string = "????";
    endcase
  end
  always @(*) begin
    case(decode_BRANCH_CTRL)
      `BranchCtrlEnum_defaultEncoding_INC : decode_BRANCH_CTRL_string = "INC ";
      `BranchCtrlEnum_defaultEncoding_B : decode_BRANCH_CTRL_string = "B   ";
      `BranchCtrlEnum_defaultEncoding_JAL : decode_BRANCH_CTRL_string = "JAL ";
      `BranchCtrlEnum_defaultEncoding_JALR : decode_BRANCH_CTRL_string = "JALR";
      default : decode_BRANCH_CTRL_string = "????";
    endcase
  end
  always @(*) begin
    case(_zz_VexRiscv_47_)
      `BranchCtrlEnum_defaultEncoding_INC : _zz_VexRiscv_47__string = "INC ";
      `BranchCtrlEnum_defaultEncoding_B : _zz_VexRiscv_47__string = "B   ";
      `BranchCtrlEnum_defaultEncoding_JAL : _zz_VexRiscv_47__string = "JAL ";
      `BranchCtrlEnum_defaultEncoding_JALR : _zz_VexRiscv_47__string = "JALR";
      default : _zz_VexRiscv_47__string = "????";
    endcase
  end
  always @(*) begin
    case(_zz_VexRiscv_117_)
      `AluCtrlEnum_defaultEncoding_ADD_SUB : _zz_VexRiscv_117__string = "ADD_SUB ";
      `AluCtrlEnum_defaultEncoding_SLT_SLTU : _zz_VexRiscv_117__string = "SLT_SLTU";
      `AluCtrlEnum_defaultEncoding_BITWISE : _zz_VexRiscv_117__string = "BITWISE ";
      default : _zz_VexRiscv_117__string = "????????";
    endcase
  end
  always @(*) begin
    case(_zz_VexRiscv_118_)
      `EnvCtrlEnum_defaultEncoding_NONE : _zz_VexRiscv_118__string = "NONE";
      `EnvCtrlEnum_defaultEncoding_XRET : _zz_VexRiscv_118__string = "XRET";
      default : _zz_VexRiscv_118__string = "????";
    endcase
  end
  always @(*) begin
    case(_zz_VexRiscv_119_)
      `Src2CtrlEnum_defaultEncoding_RS : _zz_VexRiscv_119__string = "RS ";
      `Src2CtrlEnum_defaultEncoding_IMI : _zz_VexRiscv_119__string = "IMI";
      `Src2CtrlEnum_defaultEncoding_IMS : _zz_VexRiscv_119__string = "IMS";
      `Src2CtrlEnum_defaultEncoding_PC : _zz_VexRiscv_119__string = "PC ";
      default : _zz_VexRiscv_119__string = "???";
    endcase
  end
  always @(*) begin
    case(_zz_VexRiscv_120_)
      `Src1CtrlEnum_defaultEncoding_RS : _zz_VexRiscv_120__string = "RS          ";
      `Src1CtrlEnum_defaultEncoding_IMU : _zz_VexRiscv_120__string = "IMU         ";
      `Src1CtrlEnum_defaultEncoding_PC_INCREMENT : _zz_VexRiscv_120__string = "PC_INCREMENT";
      `Src1CtrlEnum_defaultEncoding_URS1 : _zz_VexRiscv_120__string = "URS1        ";
      default : _zz_VexRiscv_120__string = "????????????";
    endcase
  end
  always @(*) begin
    case(_zz_VexRiscv_121_)
      `BranchCtrlEnum_defaultEncoding_INC : _zz_VexRiscv_121__string = "INC ";
      `BranchCtrlEnum_defaultEncoding_B : _zz_VexRiscv_121__string = "B   ";
      `BranchCtrlEnum_defaultEncoding_JAL : _zz_VexRiscv_121__string = "JAL ";
      `BranchCtrlEnum_defaultEncoding_JALR : _zz_VexRiscv_121__string = "JALR";
      default : _zz_VexRiscv_121__string = "????";
    endcase
  end
  always @(*) begin
    case(_zz_VexRiscv_122_)
      `AluBitwiseCtrlEnum_defaultEncoding_XOR_1 : _zz_VexRiscv_122__string = "XOR_1";
      `AluBitwiseCtrlEnum_defaultEncoding_OR_1 : _zz_VexRiscv_122__string = "OR_1 ";
      `AluBitwiseCtrlEnum_defaultEncoding_AND_1 : _zz_VexRiscv_122__string = "AND_1";
      default : _zz_VexRiscv_122__string = "?????";
    endcase
  end
  always @(*) begin
    case(_zz_VexRiscv_123_)
      `ShiftCtrlEnum_defaultEncoding_DISABLE_1 : _zz_VexRiscv_123__string = "DISABLE_1";
      `ShiftCtrlEnum_defaultEncoding_SLL_1 : _zz_VexRiscv_123__string = "SLL_1    ";
      `ShiftCtrlEnum_defaultEncoding_SRL_1 : _zz_VexRiscv_123__string = "SRL_1    ";
      `ShiftCtrlEnum_defaultEncoding_SRA_1 : _zz_VexRiscv_123__string = "SRA_1    ";
      default : _zz_VexRiscv_123__string = "?????????";
    endcase
  end
  always @(*) begin
    case(decode_to_execute_ENV_CTRL)
      `EnvCtrlEnum_defaultEncoding_NONE : decode_to_execute_ENV_CTRL_string = "NONE";
      `EnvCtrlEnum_defaultEncoding_XRET : decode_to_execute_ENV_CTRL_string = "XRET";
      default : decode_to_execute_ENV_CTRL_string = "????";
    endcase
  end
  always @(*) begin
    case(execute_to_memory_ENV_CTRL)
      `EnvCtrlEnum_defaultEncoding_NONE : execute_to_memory_ENV_CTRL_string = "NONE";
      `EnvCtrlEnum_defaultEncoding_XRET : execute_to_memory_ENV_CTRL_string = "XRET";
      default : execute_to_memory_ENV_CTRL_string = "????";
    endcase
  end
  always @(*) begin
    case(memory_to_writeBack_ENV_CTRL)
      `EnvCtrlEnum_defaultEncoding_NONE : memory_to_writeBack_ENV_CTRL_string = "NONE";
      `EnvCtrlEnum_defaultEncoding_XRET : memory_to_writeBack_ENV_CTRL_string = "XRET";
      default : memory_to_writeBack_ENV_CTRL_string = "????";
    endcase
  end
  always @(*) begin
    case(decode_to_execute_BRANCH_CTRL)
      `BranchCtrlEnum_defaultEncoding_INC : decode_to_execute_BRANCH_CTRL_string = "INC ";
      `BranchCtrlEnum_defaultEncoding_B : decode_to_execute_BRANCH_CTRL_string = "B   ";
      `BranchCtrlEnum_defaultEncoding_JAL : decode_to_execute_BRANCH_CTRL_string = "JAL ";
      `BranchCtrlEnum_defaultEncoding_JALR : decode_to_execute_BRANCH_CTRL_string = "JALR";
      default : decode_to_execute_BRANCH_CTRL_string = "????";
    endcase
  end
  always @(*) begin
    case(decode_to_execute_SHIFT_CTRL)
      `ShiftCtrlEnum_defaultEncoding_DISABLE_1 : decode_to_execute_SHIFT_CTRL_string = "DISABLE_1";
      `ShiftCtrlEnum_defaultEncoding_SLL_1 : decode_to_execute_SHIFT_CTRL_string = "SLL_1    ";
      `ShiftCtrlEnum_defaultEncoding_SRL_1 : decode_to_execute_SHIFT_CTRL_string = "SRL_1    ";
      `ShiftCtrlEnum_defaultEncoding_SRA_1 : decode_to_execute_SHIFT_CTRL_string = "SRA_1    ";
      default : decode_to_execute_SHIFT_CTRL_string = "?????????";
    endcase
  end
  always @(*) begin
    case(execute_to_memory_SHIFT_CTRL)
      `ShiftCtrlEnum_defaultEncoding_DISABLE_1 : execute_to_memory_SHIFT_CTRL_string = "DISABLE_1";
      `ShiftCtrlEnum_defaultEncoding_SLL_1 : execute_to_memory_SHIFT_CTRL_string = "SLL_1    ";
      `ShiftCtrlEnum_defaultEncoding_SRL_1 : execute_to_memory_SHIFT_CTRL_string = "SRL_1    ";
      `ShiftCtrlEnum_defaultEncoding_SRA_1 : execute_to_memory_SHIFT_CTRL_string = "SRA_1    ";
      default : execute_to_memory_SHIFT_CTRL_string = "?????????";
    endcase
  end
  always @(*) begin
    case(decode_to_execute_ALU_BITWISE_CTRL)
      `AluBitwiseCtrlEnum_defaultEncoding_XOR_1 : decode_to_execute_ALU_BITWISE_CTRL_string = "XOR_1";
      `AluBitwiseCtrlEnum_defaultEncoding_OR_1 : decode_to_execute_ALU_BITWISE_CTRL_string = "OR_1 ";
      `AluBitwiseCtrlEnum_defaultEncoding_AND_1 : decode_to_execute_ALU_BITWISE_CTRL_string = "AND_1";
      default : decode_to_execute_ALU_BITWISE_CTRL_string = "?????";
    endcase
  end
  always @(*) begin
    case(decode_to_execute_ALU_CTRL)
      `AluCtrlEnum_defaultEncoding_ADD_SUB : decode_to_execute_ALU_CTRL_string = "ADD_SUB ";
      `AluCtrlEnum_defaultEncoding_SLT_SLTU : decode_to_execute_ALU_CTRL_string = "SLT_SLTU";
      `AluCtrlEnum_defaultEncoding_BITWISE : decode_to_execute_ALU_CTRL_string = "BITWISE ";
      default : decode_to_execute_ALU_CTRL_string = "????????";
    endcase
  end
  `endif

  assign decode_BYPASSABLE_EXECUTE_STAGE = _zz_VexRiscv_184_[0];
  assign decode_PREDICTION_HAD_BRANCHED2 = IBusSimplePlugin_decodePrediction_cmd_hadBranch;
  assign writeBack_FORMAL_PC_NEXT = memory_to_writeBack_FORMAL_PC_NEXT;
  assign memory_FORMAL_PC_NEXT = execute_to_memory_FORMAL_PC_NEXT;
  assign execute_FORMAL_PC_NEXT = decode_to_execute_FORMAL_PC_NEXT;
  assign decode_FORMAL_PC_NEXT = (decode_PC + _zz_VexRiscv_186_);
  assign decode_ALU_CTRL = _zz_VexRiscv_1_;
  assign _zz_VexRiscv_2_ = _zz_VexRiscv_3_;
  assign decode_ALU_BITWISE_CTRL = _zz_VexRiscv_4_;
  assign _zz_VexRiscv_5_ = _zz_VexRiscv_6_;
  assign execute_MUL_LH = ($signed(execute_MulPlugin_aSLow) * $signed(execute_MulPlugin_bHigh));
  assign decode_CSR_READ_OPCODE = (decode_INSTRUCTION[13 : 7] != (7'b0100000));
  assign execute_BRANCH_DO = ((execute_PREDICTION_HAD_BRANCHED2 != execute_BRANCH_COND_RESULT) || execute_BranchPlugin_missAlignedTarget);
  assign execute_MUL_HL = ($signed(execute_MulPlugin_aHigh) * $signed(execute_MulPlugin_bSLow));
  assign execute_BRANCH_CALC = {execute_BranchPlugin_branchAdder[31 : 1],(1'b0)};
  assign decode_SRC1 = _zz_VexRiscv_126_;
  assign memory_PC = execute_to_memory_PC;
  assign memory_MEMORY_ADDRESS_LOW = execute_to_memory_MEMORY_ADDRESS_LOW;
  assign execute_MEMORY_ADDRESS_LOW = dBus_cmd_payload_address[1 : 0];
  assign _zz_VexRiscv_7_ = _zz_VexRiscv_8_;
  assign decode_SHIFT_CTRL = _zz_VexRiscv_9_;
  assign _zz_VexRiscv_10_ = _zz_VexRiscv_11_;
  assign memory_MUL_HH = execute_to_memory_MUL_HH;
  assign execute_MUL_HH = ($signed(execute_MulPlugin_aHigh) * $signed(execute_MulPlugin_bHigh));
  assign _zz_VexRiscv_12_ = _zz_VexRiscv_13_;
  assign writeBack_REGFILE_WRITE_DATA = memory_to_writeBack_REGFILE_WRITE_DATA;
  assign memory_REGFILE_WRITE_DATA = execute_to_memory_REGFILE_WRITE_DATA;
  assign execute_REGFILE_WRITE_DATA = _zz_VexRiscv_125_;
  assign _zz_VexRiscv_14_ = _zz_VexRiscv_15_;
  assign _zz_VexRiscv_16_ = _zz_VexRiscv_17_;
  assign decode_ENV_CTRL = _zz_VexRiscv_18_;
  assign _zz_VexRiscv_19_ = _zz_VexRiscv_20_;
  assign memory_MUL_LOW = ($signed(_zz_VexRiscv_187_) + $signed(_zz_VexRiscv_195_));
  assign decode_SRC2_FORCE_ZERO = (decode_SRC_ADD_ZERO && (! decode_SRC_USE_SUB_LESS));
  assign execute_BYPASSABLE_MEMORY_STAGE = decode_to_execute_BYPASSABLE_MEMORY_STAGE;
  assign decode_BYPASSABLE_MEMORY_STAGE = _zz_VexRiscv_196_[0];
  assign memory_MEMORY_READ_DATA = dBus_rsp_data;
  assign decode_MEMORY_ENABLE = _zz_VexRiscv_197_[0];
  assign memory_IS_MUL = execute_to_memory_IS_MUL;
  assign execute_IS_MUL = decode_to_execute_IS_MUL;
  assign decode_IS_MUL = _zz_VexRiscv_198_[0];
  assign decode_CSR_WRITE_OPCODE = (! (((decode_INSTRUCTION[14 : 13] == (2'b01)) && (decode_INSTRUCTION[19 : 15] == (5'b00000))) || ((decode_INSTRUCTION[14 : 13] == (2'b11)) && (decode_INSTRUCTION[19 : 15] == (5'b00000)))));
  assign execute_MUL_LL = (execute_MulPlugin_aULow * execute_MulPlugin_bULow);
  assign execute_SHIFT_RIGHT = _zz_VexRiscv_200_;
  assign decode_SRC_LESS_UNSIGNED = _zz_VexRiscv_202_[0];
  assign decode_IS_CSR = _zz_VexRiscv_203_[0];
  assign decode_MEMORY_STORE = _zz_VexRiscv_204_[0];
  assign decode_SRC2 = _zz_VexRiscv_131_;
  assign memory_BRANCH_CALC = execute_to_memory_BRANCH_CALC;
  assign memory_BRANCH_DO = execute_to_memory_BRANCH_DO;
  assign execute_IS_RVC = decode_to_execute_IS_RVC;
  assign execute_PC = decode_to_execute_PC;
  assign execute_BRANCH_COND_RESULT = _zz_VexRiscv_147_;
  assign execute_PREDICTION_HAD_BRANCHED2 = decode_to_execute_PREDICTION_HAD_BRANCHED2;
  assign execute_BRANCH_CTRL = _zz_VexRiscv_21_;
  assign decode_RS2_USE = _zz_VexRiscv_205_[0];
  assign decode_RS1_USE = _zz_VexRiscv_206_[0];
  assign execute_REGFILE_WRITE_VALID = decode_to_execute_REGFILE_WRITE_VALID;
  assign execute_BYPASSABLE_EXECUTE_STAGE = decode_to_execute_BYPASSABLE_EXECUTE_STAGE;
  assign memory_REGFILE_WRITE_VALID = execute_to_memory_REGFILE_WRITE_VALID;
  assign memory_INSTRUCTION = execute_to_memory_INSTRUCTION;
  assign memory_BYPASSABLE_MEMORY_STAGE = execute_to_memory_BYPASSABLE_MEMORY_STAGE;
  assign writeBack_REGFILE_WRITE_VALID = memory_to_writeBack_REGFILE_WRITE_VALID;
  always @ (*) begin
    decode_RS2 = decode_RegFilePlugin_rs2Data;
    if(_zz_VexRiscv_136_)begin
      if((_zz_VexRiscv_137_ == decode_INSTRUCTION[24 : 20]))begin
        decode_RS2 = _zz_VexRiscv_138_;
      end
    end
    if(_zz_VexRiscv_157_)begin
      if(_zz_VexRiscv_158_)begin
        if(_zz_VexRiscv_140_)begin
          decode_RS2 = _zz_VexRiscv_46_;
        end
      end
    end
    if(_zz_VexRiscv_159_)begin
      if(memory_BYPASSABLE_MEMORY_STAGE)begin
        if(_zz_VexRiscv_142_)begin
          decode_RS2 = _zz_VexRiscv_22_;
        end
      end
    end
    if(_zz_VexRiscv_160_)begin
      if(execute_BYPASSABLE_EXECUTE_STAGE)begin
        if(_zz_VexRiscv_144_)begin
          decode_RS2 = _zz_VexRiscv_42_;
        end
      end
    end
  end

  always @ (*) begin
    decode_RS1 = decode_RegFilePlugin_rs1Data;
    if(_zz_VexRiscv_136_)begin
      if((_zz_VexRiscv_137_ == decode_INSTRUCTION[19 : 15]))begin
        decode_RS1 = _zz_VexRiscv_138_;
      end
    end
    if(_zz_VexRiscv_157_)begin
      if(_zz_VexRiscv_158_)begin
        if(_zz_VexRiscv_139_)begin
          decode_RS1 = _zz_VexRiscv_46_;
        end
      end
    end
    if(_zz_VexRiscv_159_)begin
      if(memory_BYPASSABLE_MEMORY_STAGE)begin
        if(_zz_VexRiscv_141_)begin
          decode_RS1 = _zz_VexRiscv_22_;
        end
      end
    end
    if(_zz_VexRiscv_160_)begin
      if(execute_BYPASSABLE_EXECUTE_STAGE)begin
        if(_zz_VexRiscv_143_)begin
          decode_RS1 = _zz_VexRiscv_42_;
        end
      end
    end
  end

  assign memory_SHIFT_RIGHT = execute_to_memory_SHIFT_RIGHT;
  always @ (*) begin
    _zz_VexRiscv_22_ = memory_REGFILE_WRITE_DATA;
    if(memory_arbitration_isValid)begin
      case(memory_SHIFT_CTRL)
        `ShiftCtrlEnum_defaultEncoding_SLL_1 : begin
          _zz_VexRiscv_22_ = _zz_VexRiscv_133_;
        end
        `ShiftCtrlEnum_defaultEncoding_SRL_1, `ShiftCtrlEnum_defaultEncoding_SRA_1 : begin
          _zz_VexRiscv_22_ = memory_SHIFT_RIGHT;
        end
        default : begin
        end
      endcase
    end
  end

  assign memory_SHIFT_CTRL = _zz_VexRiscv_23_;
  assign execute_SHIFT_CTRL = _zz_VexRiscv_24_;
  assign execute_SRC_LESS_UNSIGNED = decode_to_execute_SRC_LESS_UNSIGNED;
  assign execute_SRC2_FORCE_ZERO = decode_to_execute_SRC2_FORCE_ZERO;
  assign execute_SRC_USE_SUB_LESS = decode_to_execute_SRC_USE_SUB_LESS;
  assign _zz_VexRiscv_25_ = decode_PC;
  assign _zz_VexRiscv_26_ = decode_RS2;
  assign decode_SRC2_CTRL = _zz_VexRiscv_27_;
  assign _zz_VexRiscv_28_ = decode_RS1;
  assign decode_SRC1_CTRL = _zz_VexRiscv_29_;
  assign decode_SRC_USE_SUB_LESS = _zz_VexRiscv_207_[0];
  assign decode_SRC_ADD_ZERO = _zz_VexRiscv_208_[0];
  assign writeBack_IS_MUL = memory_to_writeBack_IS_MUL;
  assign writeBack_MUL_HH = memory_to_writeBack_MUL_HH;
  assign writeBack_MUL_LOW = memory_to_writeBack_MUL_LOW;
  assign memory_MUL_HL = execute_to_memory_MUL_HL;
  assign memory_MUL_LH = execute_to_memory_MUL_LH;
  assign memory_MUL_LL = execute_to_memory_MUL_LL;
  assign execute_RS1 = decode_to_execute_RS1;
  assign execute_SRC_ADD_SUB = execute_SrcPlugin_addSub;
  assign execute_SRC_LESS = execute_SrcPlugin_less;
  assign execute_ALU_CTRL = _zz_VexRiscv_30_;
  assign execute_SRC2 = decode_to_execute_SRC2;
  assign execute_ALU_BITWISE_CTRL = _zz_VexRiscv_31_;
  assign _zz_VexRiscv_32_ = writeBack_INSTRUCTION;
  assign _zz_VexRiscv_33_ = writeBack_REGFILE_WRITE_VALID;
  always @ (*) begin
    _zz_VexRiscv_34_ = 1'b0;
    if(lastStageRegFileWrite_valid)begin
      _zz_VexRiscv_34_ = 1'b1;
    end
  end

  assign decode_INSTRUCTION_ANTICIPATED = (decode_arbitration_isStuck ? decode_INSTRUCTION : IBusSimplePlugin_decompressor_output_payload_rsp_inst);
  always @ (*) begin
    decode_REGFILE_WRITE_VALID = _zz_VexRiscv_209_[0];
    if((decode_INSTRUCTION[11 : 7] == (5'b00000)))begin
      decode_REGFILE_WRITE_VALID = 1'b0;
    end
  end

  always @ (*) begin
    _zz_VexRiscv_42_ = execute_REGFILE_WRITE_DATA;
    if(_zz_VexRiscv_161_)begin
      _zz_VexRiscv_42_ = execute_CsrPlugin_readData;
    end
  end

  assign execute_SRC1 = decode_to_execute_SRC1;
  assign execute_CSR_READ_OPCODE = decode_to_execute_CSR_READ_OPCODE;
  assign execute_CSR_WRITE_OPCODE = decode_to_execute_CSR_WRITE_OPCODE;
  assign execute_IS_CSR = decode_to_execute_IS_CSR;
  assign memory_ENV_CTRL = _zz_VexRiscv_43_;
  assign execute_ENV_CTRL = _zz_VexRiscv_44_;
  assign writeBack_ENV_CTRL = _zz_VexRiscv_45_;
  assign writeBack_MEMORY_STORE = memory_to_writeBack_MEMORY_STORE;
  always @ (*) begin
    _zz_VexRiscv_46_ = writeBack_REGFILE_WRITE_DATA;
    if((writeBack_arbitration_isValid && writeBack_MEMORY_ENABLE))begin
      _zz_VexRiscv_46_ = writeBack_DBusSimplePlugin_rspFormated;
    end
    if((writeBack_arbitration_isValid && writeBack_IS_MUL))begin
      case(_zz_VexRiscv_183_)
        2'b00 : begin
          _zz_VexRiscv_46_ = _zz_VexRiscv_232_;
        end
        default : begin
          _zz_VexRiscv_46_ = _zz_VexRiscv_233_;
        end
      endcase
    end
  end

  assign writeBack_MEMORY_ENABLE = memory_to_writeBack_MEMORY_ENABLE;
  assign writeBack_MEMORY_ADDRESS_LOW = memory_to_writeBack_MEMORY_ADDRESS_LOW;
  assign writeBack_MEMORY_READ_DATA = memory_to_writeBack_MEMORY_READ_DATA;
  assign memory_MEMORY_STORE = execute_to_memory_MEMORY_STORE;
  assign memory_MEMORY_ENABLE = execute_to_memory_MEMORY_ENABLE;
  assign execute_SRC_ADD = execute_SrcPlugin_addSub;
  assign execute_RS2 = decode_to_execute_RS2;
  assign execute_INSTRUCTION = decode_to_execute_INSTRUCTION;
  assign execute_MEMORY_STORE = decode_to_execute_MEMORY_STORE;
  assign execute_MEMORY_ENABLE = decode_to_execute_MEMORY_ENABLE;
  assign execute_ALIGNEMENT_FAULT = 1'b0;
  assign decode_BRANCH_CTRL = _zz_VexRiscv_47_;
  always @ (*) begin
    _zz_VexRiscv_48_ = memory_FORMAL_PC_NEXT;
    if(BranchPlugin_jumpInterface_valid)begin
      _zz_VexRiscv_48_ = BranchPlugin_jumpInterface_payload;
    end
  end

  always @ (*) begin
    _zz_VexRiscv_49_ = decode_FORMAL_PC_NEXT;
    if(IBusSimplePlugin_predictionJumpInterface_valid)begin
      _zz_VexRiscv_49_ = IBusSimplePlugin_predictionJumpInterface_payload;
    end
  end

  assign decode_PC = IBusSimplePlugin_decodePc_pcReg;
  assign decode_INSTRUCTION = IBusSimplePlugin_injector_decodeInput_payload_rsp_inst;
  assign decode_IS_RVC = IBusSimplePlugin_injector_decodeInput_payload_isRvc;
  assign writeBack_PC = memory_to_writeBack_PC;
  assign writeBack_INSTRUCTION = memory_to_writeBack_INSTRUCTION;
  assign decode_arbitration_haltItself = 1'b0;
  always @ (*) begin
    decode_arbitration_haltByOther = 1'b0;
    if((CsrPlugin_interrupt_valid && CsrPlugin_allowInterrupts))begin
      decode_arbitration_haltByOther = decode_arbitration_isValid;
    end
    if(({(writeBack_arbitration_isValid && (writeBack_ENV_CTRL == `EnvCtrlEnum_defaultEncoding_XRET)),{(memory_arbitration_isValid && (memory_ENV_CTRL == `EnvCtrlEnum_defaultEncoding_XRET)),(execute_arbitration_isValid && (execute_ENV_CTRL == `EnvCtrlEnum_defaultEncoding_XRET))}} != (3'b000)))begin
      decode_arbitration_haltByOther = 1'b1;
    end
    if((decode_arbitration_isValid && (_zz_VexRiscv_134_ || _zz_VexRiscv_135_)))begin
      decode_arbitration_haltByOther = 1'b1;
    end
  end

  always @ (*) begin
    decode_arbitration_removeIt = 1'b0;
    if(decode_arbitration_isFlushed)begin
      decode_arbitration_removeIt = 1'b1;
    end
  end

  assign decode_arbitration_flushIt = 1'b0;
  assign decode_arbitration_flushNext = 1'b0;
  always @ (*) begin
    execute_arbitration_haltItself = 1'b0;
    if(((((execute_arbitration_isValid && execute_MEMORY_ENABLE) && (! dBus_cmd_ready)) && (! execute_DBusSimplePlugin_skipCmd)) && (! _zz_VexRiscv_102_)))begin
      execute_arbitration_haltItself = 1'b1;
    end
    if(_zz_VexRiscv_161_)begin
      if(execute_CsrPlugin_blockedBySideEffects)begin
        execute_arbitration_haltItself = 1'b1;
      end
    end
  end

  assign execute_arbitration_haltByOther = 1'b0;
  always @ (*) begin
    execute_arbitration_removeIt = 1'b0;
    if(execute_arbitration_isFlushed)begin
      execute_arbitration_removeIt = 1'b1;
    end
  end

  assign execute_arbitration_flushIt = 1'b0;
  assign execute_arbitration_flushNext = 1'b0;
  always @ (*) begin
    memory_arbitration_haltItself = 1'b0;
    if((((memory_arbitration_isValid && memory_MEMORY_ENABLE) && (! memory_MEMORY_STORE)) && ((! dBus_rsp_ready) || 1'b0)))begin
      memory_arbitration_haltItself = 1'b1;
    end
  end

  assign memory_arbitration_haltByOther = 1'b0;
  always @ (*) begin
    memory_arbitration_removeIt = 1'b0;
    if(memory_arbitration_isFlushed)begin
      memory_arbitration_removeIt = 1'b1;
    end
  end

  assign memory_arbitration_flushIt = 1'b0;
  always @ (*) begin
    memory_arbitration_flushNext = 1'b0;
    if(BranchPlugin_jumpInterface_valid)begin
      memory_arbitration_flushNext = 1'b1;
    end
  end

  assign writeBack_arbitration_haltItself = 1'b0;
  assign writeBack_arbitration_haltByOther = 1'b0;
  always @ (*) begin
    writeBack_arbitration_removeIt = 1'b0;
    if(writeBack_arbitration_isFlushed)begin
      writeBack_arbitration_removeIt = 1'b1;
    end
  end

  assign writeBack_arbitration_flushIt = 1'b0;
  always @ (*) begin
    writeBack_arbitration_flushNext = 1'b0;
    if(_zz_VexRiscv_162_)begin
      writeBack_arbitration_flushNext = 1'b1;
    end
    if(_zz_VexRiscv_163_)begin
      writeBack_arbitration_flushNext = 1'b1;
    end
  end

  assign lastStageInstruction = writeBack_INSTRUCTION;
  assign lastStagePc = writeBack_PC;
  assign lastStageIsValid = writeBack_arbitration_isValid;
  assign lastStageIsFiring = writeBack_arbitration_isFiring;
  always @ (*) begin
    IBusSimplePlugin_fetcherHalt = 1'b0;
    if(_zz_VexRiscv_162_)begin
      IBusSimplePlugin_fetcherHalt = 1'b1;
    end
    if(_zz_VexRiscv_163_)begin
      IBusSimplePlugin_fetcherHalt = 1'b1;
    end
  end

  always @ (*) begin
    IBusSimplePlugin_fetcherflushIt = 1'b0;
    if(({writeBack_arbitration_flushNext,{memory_arbitration_flushNext,{execute_arbitration_flushNext,decode_arbitration_flushNext}}} != (4'b0000)))begin
      IBusSimplePlugin_fetcherflushIt = 1'b1;
    end
    if((IBusSimplePlugin_predictionJumpInterface_valid && decode_arbitration_isFiring))begin
      IBusSimplePlugin_fetcherflushIt = 1'b1;
    end
  end

  always @ (*) begin
    IBusSimplePlugin_incomingInstruction = 1'b0;
    if((IBusSimplePlugin_iBusRsp_stages_1_input_valid || IBusSimplePlugin_iBusRsp_stages_2_input_valid))begin
      IBusSimplePlugin_incomingInstruction = 1'b1;
    end
    if((IBusSimplePlugin_decompressor_bufferValid && (IBusSimplePlugin_decompressor_bufferData[1 : 0] != (2'b11))))begin
      IBusSimplePlugin_incomingInstruction = 1'b1;
    end
    if(IBusSimplePlugin_injector_decodeInput_valid)begin
      IBusSimplePlugin_incomingInstruction = 1'b1;
    end
  end

  assign CsrPlugin_inWfi = 1'b0;
  assign CsrPlugin_thirdPartyWake = 1'b0;
  always @ (*) begin
    CsrPlugin_jumpInterface_valid = 1'b0;
    if(_zz_VexRiscv_162_)begin
      CsrPlugin_jumpInterface_valid = 1'b1;
    end
    if(_zz_VexRiscv_163_)begin
      CsrPlugin_jumpInterface_valid = 1'b1;
    end
  end

  always @ (*) begin
    CsrPlugin_jumpInterface_payload = (32'bxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx);
    if(_zz_VexRiscv_162_)begin
      CsrPlugin_jumpInterface_payload = {CsrPlugin_xtvec_base,(2'b00)};
    end
    if(_zz_VexRiscv_163_)begin
      case(_zz_VexRiscv_164_)
        2'b11 : begin
          CsrPlugin_jumpInterface_payload = CsrPlugin_mepc;
        end
        default : begin
        end
      endcase
    end
  end

  assign CsrPlugin_forceMachineWire = 1'b0;
  assign CsrPlugin_allowInterrupts = 1'b1;
  assign CsrPlugin_allowException = 1'b1;
  assign IBusSimplePlugin_jump_pcLoad_valid = ({BranchPlugin_jumpInterface_valid,{CsrPlugin_jumpInterface_valid,IBusSimplePlugin_predictionJumpInterface_valid}} != (3'b000));
  assign _zz_VexRiscv_50_ = {IBusSimplePlugin_predictionJumpInterface_valid,{BranchPlugin_jumpInterface_valid,CsrPlugin_jumpInterface_valid}};
  assign _zz_VexRiscv_51_ = (_zz_VexRiscv_50_ & (~ _zz_VexRiscv_210_));
  assign _zz_VexRiscv_52_ = _zz_VexRiscv_51_[1];
  assign _zz_VexRiscv_53_ = _zz_VexRiscv_51_[2];
  assign IBusSimplePlugin_jump_pcLoad_payload = _zz_VexRiscv_156_;
  always @ (*) begin
    IBusSimplePlugin_fetchPc_corrected = 1'b0;
    if(IBusSimplePlugin_jump_pcLoad_valid)begin
      IBusSimplePlugin_fetchPc_corrected = 1'b1;
    end
  end

  always @ (*) begin
    IBusSimplePlugin_fetchPc_pcRegPropagate = 1'b0;
    if(IBusSimplePlugin_iBusRsp_stages_1_input_ready)begin
      IBusSimplePlugin_fetchPc_pcRegPropagate = 1'b1;
    end
  end

  always @ (*) begin
    IBusSimplePlugin_fetchPc_pc = (IBusSimplePlugin_fetchPc_pcReg + _zz_VexRiscv_212_);
    if(IBusSimplePlugin_fetchPc_inc)begin
      IBusSimplePlugin_fetchPc_pc[1] = 1'b0;
    end
    if(IBusSimplePlugin_jump_pcLoad_valid)begin
      IBusSimplePlugin_fetchPc_pc = IBusSimplePlugin_jump_pcLoad_payload;
    end
    IBusSimplePlugin_fetchPc_pc[0] = 1'b0;
  end

  assign IBusSimplePlugin_fetchPc_output_valid = ((! IBusSimplePlugin_fetcherHalt) && IBusSimplePlugin_fetchPc_booted);
  assign IBusSimplePlugin_fetchPc_output_payload = IBusSimplePlugin_fetchPc_pc;
  assign IBusSimplePlugin_decodePc_pcPlus = (IBusSimplePlugin_decodePc_pcReg + _zz_VexRiscv_214_);
  assign IBusSimplePlugin_decodePc_injectedDecode = 1'b0;
  assign IBusSimplePlugin_iBusRsp_stages_0_input_valid = IBusSimplePlugin_fetchPc_output_valid;
  assign IBusSimplePlugin_fetchPc_output_ready = IBusSimplePlugin_iBusRsp_stages_0_input_ready;
  assign IBusSimplePlugin_iBusRsp_stages_0_input_payload = IBusSimplePlugin_fetchPc_output_payload;
  assign IBusSimplePlugin_iBusRsp_stages_0_inputSample = 1'b1;
  assign IBusSimplePlugin_iBusRsp_stages_0_halt = 1'b0;
  assign _zz_VexRiscv_54_ = (! IBusSimplePlugin_iBusRsp_stages_0_halt);
  assign IBusSimplePlugin_iBusRsp_stages_0_input_ready = (IBusSimplePlugin_iBusRsp_stages_0_output_ready && _zz_VexRiscv_54_);
  assign IBusSimplePlugin_iBusRsp_stages_0_output_valid = (IBusSimplePlugin_iBusRsp_stages_0_input_valid && _zz_VexRiscv_54_);
  assign IBusSimplePlugin_iBusRsp_stages_0_output_payload = IBusSimplePlugin_iBusRsp_stages_0_input_payload;
  always @ (*) begin
    IBusSimplePlugin_iBusRsp_stages_1_halt = 1'b0;
    if((IBusSimplePlugin_iBusRsp_stages_1_input_valid && ((! IBusSimplePlugin_cmd_valid) || (! IBusSimplePlugin_cmd_ready))))begin
      IBusSimplePlugin_iBusRsp_stages_1_halt = 1'b1;
    end
  end

  assign _zz_VexRiscv_55_ = (! IBusSimplePlugin_iBusRsp_stages_1_halt);
  assign IBusSimplePlugin_iBusRsp_stages_1_input_ready = (IBusSimplePlugin_iBusRsp_stages_1_output_ready && _zz_VexRiscv_55_);
  assign IBusSimplePlugin_iBusRsp_stages_1_output_valid = (IBusSimplePlugin_iBusRsp_stages_1_input_valid && _zz_VexRiscv_55_);
  assign IBusSimplePlugin_iBusRsp_stages_1_output_payload = IBusSimplePlugin_iBusRsp_stages_1_input_payload;
  assign IBusSimplePlugin_iBusRsp_stages_2_halt = 1'b0;
  assign _zz_VexRiscv_56_ = (! IBusSimplePlugin_iBusRsp_stages_2_halt);
  assign IBusSimplePlugin_iBusRsp_stages_2_input_ready = (IBusSimplePlugin_iBusRsp_stages_2_output_ready && _zz_VexRiscv_56_);
  assign IBusSimplePlugin_iBusRsp_stages_2_output_valid = (IBusSimplePlugin_iBusRsp_stages_2_input_valid && _zz_VexRiscv_56_);
  assign IBusSimplePlugin_iBusRsp_stages_2_output_payload = IBusSimplePlugin_iBusRsp_stages_2_input_payload;
  assign IBusSimplePlugin_iBusRsp_stages_0_output_ready = _zz_VexRiscv_57_;
  assign _zz_VexRiscv_57_ = ((1'b0 && (! _zz_VexRiscv_58_)) || IBusSimplePlugin_iBusRsp_stages_1_input_ready);
  assign _zz_VexRiscv_58_ = _zz_VexRiscv_59_;
  assign IBusSimplePlugin_iBusRsp_stages_1_input_valid = _zz_VexRiscv_58_;
  assign IBusSimplePlugin_iBusRsp_stages_1_input_payload = IBusSimplePlugin_fetchPc_pcReg;
  assign IBusSimplePlugin_iBusRsp_stages_1_output_ready = ((1'b0 && (! _zz_VexRiscv_60_)) || IBusSimplePlugin_iBusRsp_stages_2_input_ready);
  assign _zz_VexRiscv_60_ = _zz_VexRiscv_61_;
  assign IBusSimplePlugin_iBusRsp_stages_2_input_valid = _zz_VexRiscv_60_;
  assign IBusSimplePlugin_iBusRsp_stages_2_input_payload = _zz_VexRiscv_62_;
  always @ (*) begin
    IBusSimplePlugin_iBusRsp_readyForError = 1'b1;
    if((IBusSimplePlugin_decompressor_bufferValid && IBusSimplePlugin_decompressor_isRvc))begin
      IBusSimplePlugin_iBusRsp_readyForError = 1'b0;
    end
    if(IBusSimplePlugin_injector_decodeInput_valid)begin
      IBusSimplePlugin_iBusRsp_readyForError = 1'b0;
    end
  end

  assign IBusSimplePlugin_decompressor_raw = (IBusSimplePlugin_decompressor_bufferValid ? {IBusSimplePlugin_iBusRsp_output_payload_rsp_inst[15 : 0],IBusSimplePlugin_decompressor_bufferData} : {IBusSimplePlugin_iBusRsp_output_payload_rsp_inst[31 : 16],(IBusSimplePlugin_iBusRsp_output_payload_pc[1] ? IBusSimplePlugin_iBusRsp_output_payload_rsp_inst[31 : 16] : IBusSimplePlugin_iBusRsp_output_payload_rsp_inst[15 : 0])});
  assign IBusSimplePlugin_decompressor_isRvc = (IBusSimplePlugin_decompressor_raw[1 : 0] != (2'b11));
  assign _zz_VexRiscv_63_ = IBusSimplePlugin_decompressor_raw[15 : 0];
  always @ (*) begin
    IBusSimplePlugin_decompressor_decompressed = (32'bxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx);
    case(_zz_VexRiscv_178_)
      5'b00000 : begin
        IBusSimplePlugin_decompressor_decompressed = {{{{{{{{{(2'b00),_zz_VexRiscv_63_[10 : 7]},_zz_VexRiscv_63_[12 : 11]},_zz_VexRiscv_63_[5]},_zz_VexRiscv_63_[6]},(2'b00)},(5'b00010)},(3'b000)},_zz_VexRiscv_65_},(7'b0010011)};
      end
      5'b00010 : begin
        IBusSimplePlugin_decompressor_decompressed = {{{{_zz_VexRiscv_66_,_zz_VexRiscv_64_},(3'b010)},_zz_VexRiscv_65_},(7'b0000011)};
      end
      5'b00110 : begin
        IBusSimplePlugin_decompressor_decompressed = {{{{{_zz_VexRiscv_66_[11 : 5],_zz_VexRiscv_65_},_zz_VexRiscv_64_},(3'b010)},_zz_VexRiscv_66_[4 : 0]},(7'b0100011)};
      end
      5'b01000 : begin
        IBusSimplePlugin_decompressor_decompressed = {{{{_zz_VexRiscv_68_,_zz_VexRiscv_63_[11 : 7]},(3'b000)},_zz_VexRiscv_63_[11 : 7]},(7'b0010011)};
      end
      5'b01001 : begin
        IBusSimplePlugin_decompressor_decompressed = {{{{{_zz_VexRiscv_71_[20],_zz_VexRiscv_71_[10 : 1]},_zz_VexRiscv_71_[11]},_zz_VexRiscv_71_[19 : 12]},_zz_VexRiscv_83_},(7'b1101111)};
      end
      5'b01010 : begin
        IBusSimplePlugin_decompressor_decompressed = {{{{_zz_VexRiscv_68_,(5'b00000)},(3'b000)},_zz_VexRiscv_63_[11 : 7]},(7'b0010011)};
      end
      5'b01011 : begin
        IBusSimplePlugin_decompressor_decompressed = ((_zz_VexRiscv_63_[11 : 7] == (5'b00010)) ? {{{{{{{{{_zz_VexRiscv_75_,_zz_VexRiscv_63_[4 : 3]},_zz_VexRiscv_63_[5]},_zz_VexRiscv_63_[2]},_zz_VexRiscv_63_[6]},(4'b0000)},_zz_VexRiscv_63_[11 : 7]},(3'b000)},_zz_VexRiscv_63_[11 : 7]},(7'b0010011)} : {{_zz_VexRiscv_215_[31 : 12],_zz_VexRiscv_63_[11 : 7]},(7'b0110111)});
      end
      5'b01100 : begin
        IBusSimplePlugin_decompressor_decompressed = {{{{{((_zz_VexRiscv_63_[11 : 10] == (2'b10)) ? _zz_VexRiscv_89_ : {{(1'b0),(_zz_VexRiscv_258_ || _zz_VexRiscv_259_)},(5'b00000)}),(((! _zz_VexRiscv_63_[11]) || _zz_VexRiscv_85_) ? _zz_VexRiscv_63_[6 : 2] : _zz_VexRiscv_65_)},_zz_VexRiscv_64_},_zz_VexRiscv_87_},_zz_VexRiscv_64_},(_zz_VexRiscv_85_ ? (7'b0010011) : (7'b0110011))};
      end
      5'b01101 : begin
        IBusSimplePlugin_decompressor_decompressed = {{{{{_zz_VexRiscv_78_[20],_zz_VexRiscv_78_[10 : 1]},_zz_VexRiscv_78_[11]},_zz_VexRiscv_78_[19 : 12]},_zz_VexRiscv_82_},(7'b1101111)};
      end
      5'b01110 : begin
        IBusSimplePlugin_decompressor_decompressed = {{{{{{{_zz_VexRiscv_81_[12],_zz_VexRiscv_81_[10 : 5]},_zz_VexRiscv_82_},_zz_VexRiscv_64_},(3'b000)},_zz_VexRiscv_81_[4 : 1]},_zz_VexRiscv_81_[11]},(7'b1100011)};
      end
      5'b01111 : begin
        IBusSimplePlugin_decompressor_decompressed = {{{{{{{_zz_VexRiscv_81_[12],_zz_VexRiscv_81_[10 : 5]},_zz_VexRiscv_82_},_zz_VexRiscv_64_},(3'b001)},_zz_VexRiscv_81_[4 : 1]},_zz_VexRiscv_81_[11]},(7'b1100011)};
      end
      5'b10000 : begin
        IBusSimplePlugin_decompressor_decompressed = {{{{{(7'b0000000),_zz_VexRiscv_63_[6 : 2]},_zz_VexRiscv_63_[11 : 7]},(3'b001)},_zz_VexRiscv_63_[11 : 7]},(7'b0010011)};
      end
      5'b10010 : begin
        IBusSimplePlugin_decompressor_decompressed = {{{{{{{{(4'b0000),_zz_VexRiscv_63_[3 : 2]},_zz_VexRiscv_63_[12]},_zz_VexRiscv_63_[6 : 4]},(2'b00)},_zz_VexRiscv_84_},(3'b010)},_zz_VexRiscv_63_[11 : 7]},(7'b0000011)};
      end
      5'b10100 : begin
        IBusSimplePlugin_decompressor_decompressed = ((_zz_VexRiscv_63_[12 : 2] == (11'b10000000000)) ? (32'b00000000000100000000000001110011) : ((_zz_VexRiscv_63_[6 : 2] == (5'b00000)) ? {{{{(12'b000000000000),_zz_VexRiscv_63_[11 : 7]},(3'b000)},(_zz_VexRiscv_63_[12] ? _zz_VexRiscv_83_ : _zz_VexRiscv_82_)},(7'b1100111)} : {{{{{_zz_VexRiscv_260_,_zz_VexRiscv_261_},(_zz_VexRiscv_262_ ? _zz_VexRiscv_263_ : _zz_VexRiscv_82_)},(3'b000)},_zz_VexRiscv_63_[11 : 7]},(7'b0110011)}));
      end
      5'b10110 : begin
        IBusSimplePlugin_decompressor_decompressed = {{{{{_zz_VexRiscv_216_[11 : 5],_zz_VexRiscv_63_[6 : 2]},_zz_VexRiscv_84_},(3'b010)},_zz_VexRiscv_217_[4 : 0]},(7'b0100011)};
      end
      default : begin
      end
    endcase
  end

  assign _zz_VexRiscv_64_ = {(2'b01),_zz_VexRiscv_63_[9 : 7]};
  assign _zz_VexRiscv_65_ = {(2'b01),_zz_VexRiscv_63_[4 : 2]};
  assign _zz_VexRiscv_66_ = {{{{(5'b00000),_zz_VexRiscv_63_[5]},_zz_VexRiscv_63_[12 : 10]},_zz_VexRiscv_63_[6]},(2'b00)};
  assign _zz_VexRiscv_67_ = _zz_VexRiscv_63_[12];
  always @ (*) begin
    _zz_VexRiscv_68_[11] = _zz_VexRiscv_67_;
    _zz_VexRiscv_68_[10] = _zz_VexRiscv_67_;
    _zz_VexRiscv_68_[9] = _zz_VexRiscv_67_;
    _zz_VexRiscv_68_[8] = _zz_VexRiscv_67_;
    _zz_VexRiscv_68_[7] = _zz_VexRiscv_67_;
    _zz_VexRiscv_68_[6] = _zz_VexRiscv_67_;
    _zz_VexRiscv_68_[5] = _zz_VexRiscv_67_;
    _zz_VexRiscv_68_[4 : 0] = _zz_VexRiscv_63_[6 : 2];
  end

  assign _zz_VexRiscv_69_ = _zz_VexRiscv_63_[12];
  always @ (*) begin
    _zz_VexRiscv_70_[9] = _zz_VexRiscv_69_;
    _zz_VexRiscv_70_[8] = _zz_VexRiscv_69_;
    _zz_VexRiscv_70_[7] = _zz_VexRiscv_69_;
    _zz_VexRiscv_70_[6] = _zz_VexRiscv_69_;
    _zz_VexRiscv_70_[5] = _zz_VexRiscv_69_;
    _zz_VexRiscv_70_[4] = _zz_VexRiscv_69_;
    _zz_VexRiscv_70_[3] = _zz_VexRiscv_69_;
    _zz_VexRiscv_70_[2] = _zz_VexRiscv_69_;
    _zz_VexRiscv_70_[1] = _zz_VexRiscv_69_;
    _zz_VexRiscv_70_[0] = _zz_VexRiscv_69_;
  end

  assign _zz_VexRiscv_71_ = {{{{{{{{_zz_VexRiscv_70_,_zz_VexRiscv_63_[8]},_zz_VexRiscv_63_[10 : 9]},_zz_VexRiscv_63_[6]},_zz_VexRiscv_63_[7]},_zz_VexRiscv_63_[2]},_zz_VexRiscv_63_[11]},_zz_VexRiscv_63_[5 : 3]},(1'b0)};
  assign _zz_VexRiscv_72_ = _zz_VexRiscv_63_[12];
  always @ (*) begin
    _zz_VexRiscv_73_[14] = _zz_VexRiscv_72_;
    _zz_VexRiscv_73_[13] = _zz_VexRiscv_72_;
    _zz_VexRiscv_73_[12] = _zz_VexRiscv_72_;
    _zz_VexRiscv_73_[11] = _zz_VexRiscv_72_;
    _zz_VexRiscv_73_[10] = _zz_VexRiscv_72_;
    _zz_VexRiscv_73_[9] = _zz_VexRiscv_72_;
    _zz_VexRiscv_73_[8] = _zz_VexRiscv_72_;
    _zz_VexRiscv_73_[7] = _zz_VexRiscv_72_;
    _zz_VexRiscv_73_[6] = _zz_VexRiscv_72_;
    _zz_VexRiscv_73_[5] = _zz_VexRiscv_72_;
    _zz_VexRiscv_73_[4] = _zz_VexRiscv_72_;
    _zz_VexRiscv_73_[3] = _zz_VexRiscv_72_;
    _zz_VexRiscv_73_[2] = _zz_VexRiscv_72_;
    _zz_VexRiscv_73_[1] = _zz_VexRiscv_72_;
    _zz_VexRiscv_73_[0] = _zz_VexRiscv_72_;
  end

  assign _zz_VexRiscv_74_ = _zz_VexRiscv_63_[12];
  always @ (*) begin
    _zz_VexRiscv_75_[2] = _zz_VexRiscv_74_;
    _zz_VexRiscv_75_[1] = _zz_VexRiscv_74_;
    _zz_VexRiscv_75_[0] = _zz_VexRiscv_74_;
  end

  assign _zz_VexRiscv_76_ = _zz_VexRiscv_63_[12];
  always @ (*) begin
    _zz_VexRiscv_77_[9] = _zz_VexRiscv_76_;
    _zz_VexRiscv_77_[8] = _zz_VexRiscv_76_;
    _zz_VexRiscv_77_[7] = _zz_VexRiscv_76_;
    _zz_VexRiscv_77_[6] = _zz_VexRiscv_76_;
    _zz_VexRiscv_77_[5] = _zz_VexRiscv_76_;
    _zz_VexRiscv_77_[4] = _zz_VexRiscv_76_;
    _zz_VexRiscv_77_[3] = _zz_VexRiscv_76_;
    _zz_VexRiscv_77_[2] = _zz_VexRiscv_76_;
    _zz_VexRiscv_77_[1] = _zz_VexRiscv_76_;
    _zz_VexRiscv_77_[0] = _zz_VexRiscv_76_;
  end

  assign _zz_VexRiscv_78_ = {{{{{{{{_zz_VexRiscv_77_,_zz_VexRiscv_63_[8]},_zz_VexRiscv_63_[10 : 9]},_zz_VexRiscv_63_[6]},_zz_VexRiscv_63_[7]},_zz_VexRiscv_63_[2]},_zz_VexRiscv_63_[11]},_zz_VexRiscv_63_[5 : 3]},(1'b0)};
  assign _zz_VexRiscv_79_ = _zz_VexRiscv_63_[12];
  always @ (*) begin
    _zz_VexRiscv_80_[4] = _zz_VexRiscv_79_;
    _zz_VexRiscv_80_[3] = _zz_VexRiscv_79_;
    _zz_VexRiscv_80_[2] = _zz_VexRiscv_79_;
    _zz_VexRiscv_80_[1] = _zz_VexRiscv_79_;
    _zz_VexRiscv_80_[0] = _zz_VexRiscv_79_;
  end

  assign _zz_VexRiscv_81_ = {{{{{_zz_VexRiscv_80_,_zz_VexRiscv_63_[6 : 5]},_zz_VexRiscv_63_[2]},_zz_VexRiscv_63_[11 : 10]},_zz_VexRiscv_63_[4 : 3]},(1'b0)};
  assign _zz_VexRiscv_82_ = (5'b00000);
  assign _zz_VexRiscv_83_ = (5'b00001);
  assign _zz_VexRiscv_84_ = (5'b00010);
  assign _zz_VexRiscv_85_ = (_zz_VexRiscv_63_[11 : 10] != (2'b11));
  always @ (*) begin
    case(_zz_VexRiscv_179_)
      2'b00 : begin
        _zz_VexRiscv_86_ = (3'b000);
      end
      2'b01 : begin
        _zz_VexRiscv_86_ = (3'b100);
      end
      2'b10 : begin
        _zz_VexRiscv_86_ = (3'b110);
      end
      default : begin
        _zz_VexRiscv_86_ = (3'b111);
      end
    endcase
  end

  always @ (*) begin
    case(_zz_VexRiscv_180_)
      2'b00 : begin
        _zz_VexRiscv_87_ = (3'b101);
      end
      2'b01 : begin
        _zz_VexRiscv_87_ = (3'b101);
      end
      2'b10 : begin
        _zz_VexRiscv_87_ = (3'b111);
      end
      default : begin
        _zz_VexRiscv_87_ = _zz_VexRiscv_86_;
      end
    endcase
  end

  assign _zz_VexRiscv_88_ = _zz_VexRiscv_63_[12];
  always @ (*) begin
    _zz_VexRiscv_89_[6] = _zz_VexRiscv_88_;
    _zz_VexRiscv_89_[5] = _zz_VexRiscv_88_;
    _zz_VexRiscv_89_[4] = _zz_VexRiscv_88_;
    _zz_VexRiscv_89_[3] = _zz_VexRiscv_88_;
    _zz_VexRiscv_89_[2] = _zz_VexRiscv_88_;
    _zz_VexRiscv_89_[1] = _zz_VexRiscv_88_;
    _zz_VexRiscv_89_[0] = _zz_VexRiscv_88_;
  end

  assign IBusSimplePlugin_decompressor_output_valid = (IBusSimplePlugin_decompressor_isRvc ? (IBusSimplePlugin_decompressor_bufferValid || IBusSimplePlugin_iBusRsp_output_valid) : (IBusSimplePlugin_iBusRsp_output_valid && (IBusSimplePlugin_decompressor_bufferValid || (! IBusSimplePlugin_iBusRsp_output_payload_pc[1]))));
  assign IBusSimplePlugin_decompressor_output_payload_pc = IBusSimplePlugin_iBusRsp_output_payload_pc;
  assign IBusSimplePlugin_decompressor_output_payload_isRvc = IBusSimplePlugin_decompressor_isRvc;
  assign IBusSimplePlugin_decompressor_output_payload_rsp_inst = (IBusSimplePlugin_decompressor_isRvc ? IBusSimplePlugin_decompressor_decompressed : IBusSimplePlugin_decompressor_raw);
  assign IBusSimplePlugin_iBusRsp_output_ready = ((! IBusSimplePlugin_decompressor_output_valid) || (! (((! IBusSimplePlugin_decompressor_output_ready) || ((IBusSimplePlugin_decompressor_isRvc && (! IBusSimplePlugin_iBusRsp_output_payload_pc[1])) && (IBusSimplePlugin_iBusRsp_output_payload_rsp_inst[17 : 16] != (2'b11)))) || (((! IBusSimplePlugin_decompressor_isRvc) && IBusSimplePlugin_decompressor_bufferValid) && (IBusSimplePlugin_iBusRsp_output_payload_rsp_inst[17 : 16] != (2'b11))))));
  always @ (*) begin
    IBusSimplePlugin_decompressor_bufferFill = 1'b0;
    if(_zz_VexRiscv_165_)begin
      if(_zz_VexRiscv_166_)begin
        IBusSimplePlugin_decompressor_bufferFill = 1'b1;
      end
    end
  end

  assign IBusSimplePlugin_decompressor_output_ready = ((1'b0 && (! IBusSimplePlugin_injector_decodeInput_valid)) || IBusSimplePlugin_injector_decodeInput_ready);
  assign IBusSimplePlugin_injector_decodeInput_valid = _zz_VexRiscv_90_;
  assign IBusSimplePlugin_injector_decodeInput_payload_pc = _zz_VexRiscv_91_;
  assign IBusSimplePlugin_injector_decodeInput_payload_rsp_error = _zz_VexRiscv_92_;
  assign IBusSimplePlugin_injector_decodeInput_payload_rsp_inst = _zz_VexRiscv_93_;
  assign IBusSimplePlugin_injector_decodeInput_payload_isRvc = _zz_VexRiscv_94_;
  assign IBusSimplePlugin_pcValids_0 = IBusSimplePlugin_injector_nextPcCalc_valids_0;
  assign IBusSimplePlugin_pcValids_1 = IBusSimplePlugin_injector_nextPcCalc_valids_1;
  assign IBusSimplePlugin_pcValids_2 = IBusSimplePlugin_injector_nextPcCalc_valids_2;
  assign IBusSimplePlugin_pcValids_3 = IBusSimplePlugin_injector_nextPcCalc_valids_3;
  assign IBusSimplePlugin_injector_decodeInput_ready = (! decode_arbitration_isStuck);
  assign decode_arbitration_isValid = (IBusSimplePlugin_injector_decodeInput_valid && (! IBusSimplePlugin_injector_decodeRemoved));
  assign _zz_VexRiscv_95_ = _zz_VexRiscv_218_[11];
  always @ (*) begin
    _zz_VexRiscv_96_[18] = _zz_VexRiscv_95_;
    _zz_VexRiscv_96_[17] = _zz_VexRiscv_95_;
    _zz_VexRiscv_96_[16] = _zz_VexRiscv_95_;
    _zz_VexRiscv_96_[15] = _zz_VexRiscv_95_;
    _zz_VexRiscv_96_[14] = _zz_VexRiscv_95_;
    _zz_VexRiscv_96_[13] = _zz_VexRiscv_95_;
    _zz_VexRiscv_96_[12] = _zz_VexRiscv_95_;
    _zz_VexRiscv_96_[11] = _zz_VexRiscv_95_;
    _zz_VexRiscv_96_[10] = _zz_VexRiscv_95_;
    _zz_VexRiscv_96_[9] = _zz_VexRiscv_95_;
    _zz_VexRiscv_96_[8] = _zz_VexRiscv_95_;
    _zz_VexRiscv_96_[7] = _zz_VexRiscv_95_;
    _zz_VexRiscv_96_[6] = _zz_VexRiscv_95_;
    _zz_VexRiscv_96_[5] = _zz_VexRiscv_95_;
    _zz_VexRiscv_96_[4] = _zz_VexRiscv_95_;
    _zz_VexRiscv_96_[3] = _zz_VexRiscv_95_;
    _zz_VexRiscv_96_[2] = _zz_VexRiscv_95_;
    _zz_VexRiscv_96_[1] = _zz_VexRiscv_95_;
    _zz_VexRiscv_96_[0] = _zz_VexRiscv_95_;
  end

  assign IBusSimplePlugin_decodePrediction_cmd_hadBranch = ((decode_BRANCH_CTRL == `BranchCtrlEnum_defaultEncoding_JAL) || ((decode_BRANCH_CTRL == `BranchCtrlEnum_defaultEncoding_B) && _zz_VexRiscv_219_[31]));
  assign IBusSimplePlugin_predictionJumpInterface_valid = (decode_arbitration_isValid && IBusSimplePlugin_decodePrediction_cmd_hadBranch);
  assign _zz_VexRiscv_97_ = _zz_VexRiscv_220_[19];
  always @ (*) begin
    _zz_VexRiscv_98_[10] = _zz_VexRiscv_97_;
    _zz_VexRiscv_98_[9] = _zz_VexRiscv_97_;
    _zz_VexRiscv_98_[8] = _zz_VexRiscv_97_;
    _zz_VexRiscv_98_[7] = _zz_VexRiscv_97_;
    _zz_VexRiscv_98_[6] = _zz_VexRiscv_97_;
    _zz_VexRiscv_98_[5] = _zz_VexRiscv_97_;
    _zz_VexRiscv_98_[4] = _zz_VexRiscv_97_;
    _zz_VexRiscv_98_[3] = _zz_VexRiscv_97_;
    _zz_VexRiscv_98_[2] = _zz_VexRiscv_97_;
    _zz_VexRiscv_98_[1] = _zz_VexRiscv_97_;
    _zz_VexRiscv_98_[0] = _zz_VexRiscv_97_;
  end

  assign _zz_VexRiscv_99_ = _zz_VexRiscv_221_[11];
  always @ (*) begin
    _zz_VexRiscv_100_[18] = _zz_VexRiscv_99_;
    _zz_VexRiscv_100_[17] = _zz_VexRiscv_99_;
    _zz_VexRiscv_100_[16] = _zz_VexRiscv_99_;
    _zz_VexRiscv_100_[15] = _zz_VexRiscv_99_;
    _zz_VexRiscv_100_[14] = _zz_VexRiscv_99_;
    _zz_VexRiscv_100_[13] = _zz_VexRiscv_99_;
    _zz_VexRiscv_100_[12] = _zz_VexRiscv_99_;
    _zz_VexRiscv_100_[11] = _zz_VexRiscv_99_;
    _zz_VexRiscv_100_[10] = _zz_VexRiscv_99_;
    _zz_VexRiscv_100_[9] = _zz_VexRiscv_99_;
    _zz_VexRiscv_100_[8] = _zz_VexRiscv_99_;
    _zz_VexRiscv_100_[7] = _zz_VexRiscv_99_;
    _zz_VexRiscv_100_[6] = _zz_VexRiscv_99_;
    _zz_VexRiscv_100_[5] = _zz_VexRiscv_99_;
    _zz_VexRiscv_100_[4] = _zz_VexRiscv_99_;
    _zz_VexRiscv_100_[3] = _zz_VexRiscv_99_;
    _zz_VexRiscv_100_[2] = _zz_VexRiscv_99_;
    _zz_VexRiscv_100_[1] = _zz_VexRiscv_99_;
    _zz_VexRiscv_100_[0] = _zz_VexRiscv_99_;
  end

  assign IBusSimplePlugin_predictionJumpInterface_payload = (decode_PC + ((decode_BRANCH_CTRL == `BranchCtrlEnum_defaultEncoding_JAL) ? {{_zz_VexRiscv_98_,{{{_zz_VexRiscv_264_,_zz_VexRiscv_265_},_zz_VexRiscv_266_},decode_INSTRUCTION[30 : 21]}},1'b0} : {{_zz_VexRiscv_100_,{{{_zz_VexRiscv_267_,_zz_VexRiscv_268_},decode_INSTRUCTION[30 : 25]},decode_INSTRUCTION[11 : 8]}},1'b0}));
  assign iBus_cmd_valid = IBusSimplePlugin_cmd_valid;
  assign IBusSimplePlugin_cmd_ready = iBus_cmd_ready;
  assign iBus_cmd_payload_pc = IBusSimplePlugin_cmd_payload_pc;
  assign IBusSimplePlugin_pendingCmdNext = (_zz_VexRiscv_222_ - _zz_VexRiscv_226_);
  assign IBusSimplePlugin_cmd_valid = ((IBusSimplePlugin_iBusRsp_stages_1_input_valid && IBusSimplePlugin_iBusRsp_stages_1_output_ready) && (IBusSimplePlugin_pendingCmd != (3'b111)));
  assign IBusSimplePlugin_cmd_payload_pc = {IBusSimplePlugin_iBusRsp_stages_1_input_payload[31 : 2],(2'b00)};
  assign iBus_rsp_takeWhen_valid = (iBus_rsp_valid && (! (IBusSimplePlugin_rspJoin_discardCounter != (3'b000))));
  assign iBus_rsp_takeWhen_payload_error = iBus_rsp_payload_error;
  assign iBus_rsp_takeWhen_payload_inst = iBus_rsp_payload_inst;
  assign IBusSimplePlugin_rspJoin_rspBufferOutput_valid = IBusSimplePlugin_rspJoin_rspBuffer_c_io_pop_valid;
  assign IBusSimplePlugin_rspJoin_rspBufferOutput_payload_error = IBusSimplePlugin_rspJoin_rspBuffer_c_io_pop_payload_error;
  assign IBusSimplePlugin_rspJoin_rspBufferOutput_payload_inst = IBusSimplePlugin_rspJoin_rspBuffer_c_io_pop_payload_inst;
  assign IBusSimplePlugin_rspJoin_fetchRsp_pc = IBusSimplePlugin_iBusRsp_stages_2_output_payload;
  always @ (*) begin
    IBusSimplePlugin_rspJoin_fetchRsp_rsp_error = IBusSimplePlugin_rspJoin_rspBufferOutput_payload_error;
    if((! IBusSimplePlugin_rspJoin_rspBufferOutput_valid))begin
      IBusSimplePlugin_rspJoin_fetchRsp_rsp_error = 1'b0;
    end
  end

  assign IBusSimplePlugin_rspJoin_fetchRsp_rsp_inst = IBusSimplePlugin_rspJoin_rspBufferOutput_payload_inst;
  assign IBusSimplePlugin_rspJoin_exceptionDetected = 1'b0;
  assign IBusSimplePlugin_rspJoin_redoRequired = 1'b0;
  assign IBusSimplePlugin_rspJoin_join_valid = (IBusSimplePlugin_iBusRsp_stages_2_output_valid && IBusSimplePlugin_rspJoin_rspBufferOutput_valid);
  assign IBusSimplePlugin_rspJoin_join_payload_pc = IBusSimplePlugin_rspJoin_fetchRsp_pc;
  assign IBusSimplePlugin_rspJoin_join_payload_rsp_error = IBusSimplePlugin_rspJoin_fetchRsp_rsp_error;
  assign IBusSimplePlugin_rspJoin_join_payload_rsp_inst = IBusSimplePlugin_rspJoin_fetchRsp_rsp_inst;
  assign IBusSimplePlugin_rspJoin_join_payload_isRvc = IBusSimplePlugin_rspJoin_fetchRsp_isRvc;
  assign IBusSimplePlugin_iBusRsp_stages_2_output_ready = (IBusSimplePlugin_iBusRsp_stages_2_output_valid ? (IBusSimplePlugin_rspJoin_join_valid && IBusSimplePlugin_rspJoin_join_ready) : IBusSimplePlugin_rspJoin_join_ready);
  assign IBusSimplePlugin_rspJoin_rspBufferOutput_ready = (IBusSimplePlugin_rspJoin_join_valid && IBusSimplePlugin_rspJoin_join_ready);
  assign _zz_VexRiscv_101_ = (! (IBusSimplePlugin_rspJoin_exceptionDetected || IBusSimplePlugin_rspJoin_redoRequired));
  assign IBusSimplePlugin_rspJoin_join_ready = (IBusSimplePlugin_iBusRsp_output_ready && _zz_VexRiscv_101_);
  assign IBusSimplePlugin_iBusRsp_output_valid = (IBusSimplePlugin_rspJoin_join_valid && _zz_VexRiscv_101_);
  assign IBusSimplePlugin_iBusRsp_output_payload_pc = IBusSimplePlugin_rspJoin_join_payload_pc;
  assign IBusSimplePlugin_iBusRsp_output_payload_rsp_error = IBusSimplePlugin_rspJoin_join_payload_rsp_error;
  assign IBusSimplePlugin_iBusRsp_output_payload_rsp_inst = IBusSimplePlugin_rspJoin_join_payload_rsp_inst;
  assign IBusSimplePlugin_iBusRsp_output_payload_isRvc = IBusSimplePlugin_rspJoin_join_payload_isRvc;
  assign _zz_VexRiscv_102_ = 1'b0;
  always @ (*) begin
    execute_DBusSimplePlugin_skipCmd = 1'b0;
    if(execute_ALIGNEMENT_FAULT)begin
      execute_DBusSimplePlugin_skipCmd = 1'b1;
    end
  end

  assign dBus_cmd_valid = (((((execute_arbitration_isValid && execute_MEMORY_ENABLE) && (! execute_arbitration_isStuckByOthers)) && (! execute_arbitration_isFlushed)) && (! execute_DBusSimplePlugin_skipCmd)) && (! _zz_VexRiscv_102_));
  assign dBus_cmd_payload_wr = execute_MEMORY_STORE;
  assign dBus_cmd_payload_size = execute_INSTRUCTION[13 : 12];
  always @ (*) begin
    case(dBus_cmd_payload_size)
      2'b00 : begin
        _zz_VexRiscv_103_ = {{{execute_RS2[7 : 0],execute_RS2[7 : 0]},execute_RS2[7 : 0]},execute_RS2[7 : 0]};
      end
      2'b01 : begin
        _zz_VexRiscv_103_ = {execute_RS2[15 : 0],execute_RS2[15 : 0]};
      end
      default : begin
        _zz_VexRiscv_103_ = execute_RS2[31 : 0];
      end
    endcase
  end

  assign dBus_cmd_payload_data = _zz_VexRiscv_103_;
  always @ (*) begin
    case(dBus_cmd_payload_size)
      2'b00 : begin
        _zz_VexRiscv_104_ = (4'b0001);
      end
      2'b01 : begin
        _zz_VexRiscv_104_ = (4'b0011);
      end
      default : begin
        _zz_VexRiscv_104_ = (4'b1111);
      end
    endcase
  end

  assign execute_DBusSimplePlugin_formalMask = (_zz_VexRiscv_104_ <<< dBus_cmd_payload_address[1 : 0]);
  assign dBus_cmd_payload_address = execute_SRC_ADD;
  always @ (*) begin
    writeBack_DBusSimplePlugin_rspShifted = writeBack_MEMORY_READ_DATA;
    case(writeBack_MEMORY_ADDRESS_LOW)
      2'b01 : begin
        writeBack_DBusSimplePlugin_rspShifted[7 : 0] = writeBack_MEMORY_READ_DATA[15 : 8];
      end
      2'b10 : begin
        writeBack_DBusSimplePlugin_rspShifted[15 : 0] = writeBack_MEMORY_READ_DATA[31 : 16];
      end
      2'b11 : begin
        writeBack_DBusSimplePlugin_rspShifted[7 : 0] = writeBack_MEMORY_READ_DATA[31 : 24];
      end
      default : begin
      end
    endcase
  end

  assign _zz_VexRiscv_105_ = (writeBack_DBusSimplePlugin_rspShifted[7] && (! writeBack_INSTRUCTION[14]));
  always @ (*) begin
    _zz_VexRiscv_106_[31] = _zz_VexRiscv_105_;
    _zz_VexRiscv_106_[30] = _zz_VexRiscv_105_;
    _zz_VexRiscv_106_[29] = _zz_VexRiscv_105_;
    _zz_VexRiscv_106_[28] = _zz_VexRiscv_105_;
    _zz_VexRiscv_106_[27] = _zz_VexRiscv_105_;
    _zz_VexRiscv_106_[26] = _zz_VexRiscv_105_;
    _zz_VexRiscv_106_[25] = _zz_VexRiscv_105_;
    _zz_VexRiscv_106_[24] = _zz_VexRiscv_105_;
    _zz_VexRiscv_106_[23] = _zz_VexRiscv_105_;
    _zz_VexRiscv_106_[22] = _zz_VexRiscv_105_;
    _zz_VexRiscv_106_[21] = _zz_VexRiscv_105_;
    _zz_VexRiscv_106_[20] = _zz_VexRiscv_105_;
    _zz_VexRiscv_106_[19] = _zz_VexRiscv_105_;
    _zz_VexRiscv_106_[18] = _zz_VexRiscv_105_;
    _zz_VexRiscv_106_[17] = _zz_VexRiscv_105_;
    _zz_VexRiscv_106_[16] = _zz_VexRiscv_105_;
    _zz_VexRiscv_106_[15] = _zz_VexRiscv_105_;
    _zz_VexRiscv_106_[14] = _zz_VexRiscv_105_;
    _zz_VexRiscv_106_[13] = _zz_VexRiscv_105_;
    _zz_VexRiscv_106_[12] = _zz_VexRiscv_105_;
    _zz_VexRiscv_106_[11] = _zz_VexRiscv_105_;
    _zz_VexRiscv_106_[10] = _zz_VexRiscv_105_;
    _zz_VexRiscv_106_[9] = _zz_VexRiscv_105_;
    _zz_VexRiscv_106_[8] = _zz_VexRiscv_105_;
    _zz_VexRiscv_106_[7 : 0] = writeBack_DBusSimplePlugin_rspShifted[7 : 0];
  end

  assign _zz_VexRiscv_107_ = (writeBack_DBusSimplePlugin_rspShifted[15] && (! writeBack_INSTRUCTION[14]));
  always @ (*) begin
    _zz_VexRiscv_108_[31] = _zz_VexRiscv_107_;
    _zz_VexRiscv_108_[30] = _zz_VexRiscv_107_;
    _zz_VexRiscv_108_[29] = _zz_VexRiscv_107_;
    _zz_VexRiscv_108_[28] = _zz_VexRiscv_107_;
    _zz_VexRiscv_108_[27] = _zz_VexRiscv_107_;
    _zz_VexRiscv_108_[26] = _zz_VexRiscv_107_;
    _zz_VexRiscv_108_[25] = _zz_VexRiscv_107_;
    _zz_VexRiscv_108_[24] = _zz_VexRiscv_107_;
    _zz_VexRiscv_108_[23] = _zz_VexRiscv_107_;
    _zz_VexRiscv_108_[22] = _zz_VexRiscv_107_;
    _zz_VexRiscv_108_[21] = _zz_VexRiscv_107_;
    _zz_VexRiscv_108_[20] = _zz_VexRiscv_107_;
    _zz_VexRiscv_108_[19] = _zz_VexRiscv_107_;
    _zz_VexRiscv_108_[18] = _zz_VexRiscv_107_;
    _zz_VexRiscv_108_[17] = _zz_VexRiscv_107_;
    _zz_VexRiscv_108_[16] = _zz_VexRiscv_107_;
    _zz_VexRiscv_108_[15 : 0] = writeBack_DBusSimplePlugin_rspShifted[15 : 0];
  end

  always @ (*) begin
    case(_zz_VexRiscv_181_)
      2'b00 : begin
        writeBack_DBusSimplePlugin_rspFormated = _zz_VexRiscv_106_;
      end
      2'b01 : begin
        writeBack_DBusSimplePlugin_rspFormated = _zz_VexRiscv_108_;
      end
      default : begin
        writeBack_DBusSimplePlugin_rspFormated = writeBack_DBusSimplePlugin_rspShifted;
      end
    endcase
  end

  always @ (*) begin
    CsrPlugin_privilege = (2'b11);
    if(CsrPlugin_forceMachineWire)begin
      CsrPlugin_privilege = (2'b11);
    end
  end

  assign CsrPlugin_misa_base = (2'b01);
  assign CsrPlugin_misa_extensions = (26'b00000000000000000000000000);
  assign CsrPlugin_mtvec_mode = (2'b00);
  assign CsrPlugin_mtvec_base = (30'b000000000000000000000000001000);
  assign _zz_VexRiscv_109_ = (CsrPlugin_mip_MTIP && CsrPlugin_mie_MTIE);
  assign _zz_VexRiscv_110_ = (CsrPlugin_mip_MSIP && CsrPlugin_mie_MSIE);
  assign _zz_VexRiscv_111_ = (CsrPlugin_mip_MEIP && CsrPlugin_mie_MEIE);
  assign CsrPlugin_exception = 1'b0;
  assign CsrPlugin_lastStageWasWfi = 1'b0;
  always @ (*) begin
    CsrPlugin_pipelineLiberator_done = ((! ({writeBack_arbitration_isValid,{memory_arbitration_isValid,execute_arbitration_isValid}} != (3'b000))) && IBusSimplePlugin_pcValids_0);
    if(CsrPlugin_hadException)begin
      CsrPlugin_pipelineLiberator_done = 1'b0;
    end
  end

  assign CsrPlugin_interruptJump = ((CsrPlugin_interrupt_valid && CsrPlugin_pipelineLiberator_done) && CsrPlugin_allowInterrupts);
  assign CsrPlugin_targetPrivilege = CsrPlugin_interrupt_targetPrivilege;
  assign CsrPlugin_trapCause = CsrPlugin_interrupt_code;
  always @ (*) begin
    CsrPlugin_xtvec_mode = (2'bxx);
    case(CsrPlugin_targetPrivilege)
      2'b11 : begin
        CsrPlugin_xtvec_mode = CsrPlugin_mtvec_mode;
      end
      default : begin
      end
    endcase
  end

  always @ (*) begin
    CsrPlugin_xtvec_base = (30'bxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx);
    case(CsrPlugin_targetPrivilege)
      2'b11 : begin
        CsrPlugin_xtvec_base = CsrPlugin_mtvec_base;
      end
      default : begin
      end
    endcase
  end

  assign contextSwitching = CsrPlugin_jumpInterface_valid;
  assign execute_CsrPlugin_blockedBySideEffects = ({writeBack_arbitration_isValid,memory_arbitration_isValid} != (2'b00));
  always @ (*) begin
    execute_CsrPlugin_illegalAccess = 1'b1;
    case(execute_CsrPlugin_csrAddress)
      12'b001100000000 : begin
        execute_CsrPlugin_illegalAccess = 1'b0;
      end
      12'b001101000100 : begin
        execute_CsrPlugin_illegalAccess = 1'b0;
      end
      12'b110000000000 : begin
        if(execute_CSR_READ_OPCODE)begin
          execute_CsrPlugin_illegalAccess = 1'b0;
        end
      end
      12'b001101000000 : begin
        execute_CsrPlugin_illegalAccess = 1'b0;
      end
      12'b001100000100 : begin
        execute_CsrPlugin_illegalAccess = 1'b0;
      end
      12'b110010000000 : begin
        if(execute_CSR_READ_OPCODE)begin
          execute_CsrPlugin_illegalAccess = 1'b0;
        end
      end
      default : begin
      end
    endcase
    if((CsrPlugin_privilege < execute_CsrPlugin_csrAddress[9 : 8]))begin
      execute_CsrPlugin_illegalAccess = 1'b1;
    end
    if(((! execute_arbitration_isValid) || (! execute_IS_CSR)))begin
      execute_CsrPlugin_illegalAccess = 1'b0;
    end
  end

  always @ (*) begin
    execute_CsrPlugin_illegalInstruction = 1'b0;
    if((execute_arbitration_isValid && (execute_ENV_CTRL == `EnvCtrlEnum_defaultEncoding_XRET)))begin
      if((CsrPlugin_privilege < execute_INSTRUCTION[29 : 28]))begin
        execute_CsrPlugin_illegalInstruction = 1'b1;
      end
    end
  end

  always @ (*) begin
    execute_CsrPlugin_readData = (32'b00000000000000000000000000000000);
    case(execute_CsrPlugin_csrAddress)
      12'b001100000000 : begin
        execute_CsrPlugin_readData[12 : 11] = CsrPlugin_mstatus_MPP;
        execute_CsrPlugin_readData[7 : 7] = CsrPlugin_mstatus_MPIE;
        execute_CsrPlugin_readData[3 : 3] = CsrPlugin_mstatus_MIE;
      end
      12'b001101000100 : begin
        execute_CsrPlugin_readData[11 : 11] = CsrPlugin_mip_MEIP;
        execute_CsrPlugin_readData[7 : 7] = CsrPlugin_mip_MTIP;
        execute_CsrPlugin_readData[3 : 3] = CsrPlugin_mip_MSIP;
      end
      12'b110000000000 : begin
        execute_CsrPlugin_readData[31 : 0] = CsrPlugin_mcycle[31 : 0];
      end
      12'b001101000000 : begin
        execute_CsrPlugin_readData[31 : 0] = CsrPlugin_mscratch;
      end
      12'b001100000100 : begin
        execute_CsrPlugin_readData[11 : 11] = CsrPlugin_mie_MEIE;
        execute_CsrPlugin_readData[7 : 7] = CsrPlugin_mie_MTIE;
        execute_CsrPlugin_readData[3 : 3] = CsrPlugin_mie_MSIE;
      end
      12'b110010000000 : begin
        execute_CsrPlugin_readData[31 : 0] = CsrPlugin_mcycle[63 : 32];
      end
      default : begin
      end
    endcase
  end

  assign execute_CsrPlugin_writeInstruction = ((execute_arbitration_isValid && execute_IS_CSR) && execute_CSR_WRITE_OPCODE);
  assign execute_CsrPlugin_readInstruction = ((execute_arbitration_isValid && execute_IS_CSR) && execute_CSR_READ_OPCODE);
  assign execute_CsrPlugin_writeEnable = ((execute_CsrPlugin_writeInstruction && (! execute_CsrPlugin_blockedBySideEffects)) && (! execute_arbitration_isStuckByOthers));
  assign execute_CsrPlugin_readEnable = ((execute_CsrPlugin_readInstruction && (! execute_CsrPlugin_blockedBySideEffects)) && (! execute_arbitration_isStuckByOthers));
  assign execute_CsrPlugin_readToWriteData = execute_CsrPlugin_readData;
  always @ (*) begin
    case(_zz_VexRiscv_182_)
      1'b0 : begin
        execute_CsrPlugin_writeData = execute_SRC1;
      end
      default : begin
        execute_CsrPlugin_writeData = (execute_INSTRUCTION[12] ? (execute_CsrPlugin_readToWriteData & (~ execute_SRC1)) : (execute_CsrPlugin_readToWriteData | execute_SRC1));
      end
    endcase
  end

  assign execute_CsrPlugin_csrAddress = execute_INSTRUCTION[31 : 20];
  assign _zz_VexRiscv_113_ = ((decode_INSTRUCTION & (32'b00000000000000000110000000000100)) == (32'b00000000000000000010000000000000));
  assign _zz_VexRiscv_114_ = ((decode_INSTRUCTION & (32'b00000000000000000000000001001000)) == (32'b00000000000000000000000001001000));
  assign _zz_VexRiscv_115_ = ((decode_INSTRUCTION & (32'b00000000000000000000000000000100)) == (32'b00000000000000000000000000000100));
  assign _zz_VexRiscv_116_ = ((decode_INSTRUCTION & (32'b00000000000000000100000001010000)) == (32'b00000000000000000100000001010000));
  assign _zz_VexRiscv_112_ = {(((decode_INSTRUCTION & _zz_VexRiscv_269_) == (32'b00000000000000000101000000010000)) != (1'b0)),{({_zz_VexRiscv_270_,{_zz_VexRiscv_271_,_zz_VexRiscv_272_}} != (3'b000)),{({_zz_VexRiscv_273_,_zz_VexRiscv_274_} != (4'b0000)),{(_zz_VexRiscv_275_ != _zz_VexRiscv_276_),{_zz_VexRiscv_277_,{_zz_VexRiscv_278_,_zz_VexRiscv_279_}}}}}};
  assign _zz_VexRiscv_117_ = _zz_VexRiscv_112_[3 : 2];
  assign _zz_VexRiscv_41_ = _zz_VexRiscv_117_;
  assign _zz_VexRiscv_118_ = _zz_VexRiscv_112_[5 : 5];
  assign _zz_VexRiscv_40_ = _zz_VexRiscv_118_;
  assign _zz_VexRiscv_119_ = _zz_VexRiscv_112_[10 : 9];
  assign _zz_VexRiscv_39_ = _zz_VexRiscv_119_;
  assign _zz_VexRiscv_120_ = _zz_VexRiscv_112_[16 : 15];
  assign _zz_VexRiscv_38_ = _zz_VexRiscv_120_;
  assign _zz_VexRiscv_121_ = _zz_VexRiscv_112_[18 : 17];
  assign _zz_VexRiscv_37_ = _zz_VexRiscv_121_;
  assign _zz_VexRiscv_122_ = _zz_VexRiscv_112_[21 : 20];
  assign _zz_VexRiscv_36_ = _zz_VexRiscv_122_;
  assign _zz_VexRiscv_123_ = _zz_VexRiscv_112_[25 : 24];
  assign _zz_VexRiscv_35_ = _zz_VexRiscv_123_;
  assign decode_RegFilePlugin_regFileReadAddress1 = decode_INSTRUCTION_ANTICIPATED[19 : 15];
  assign decode_RegFilePlugin_regFileReadAddress2 = decode_INSTRUCTION_ANTICIPATED[24 : 20];
  assign decode_RegFilePlugin_rs1Data = _zz_VexRiscv_154_;
  assign decode_RegFilePlugin_rs2Data = _zz_VexRiscv_155_;
  always @ (*) begin
    lastStageRegFileWrite_valid = (_zz_VexRiscv_33_ && writeBack_arbitration_isFiring);
    if(_zz_VexRiscv_124_)begin
      lastStageRegFileWrite_valid = 1'b1;
    end
  end

  assign lastStageRegFileWrite_payload_address = _zz_VexRiscv_32_[11 : 7];
  assign lastStageRegFileWrite_payload_data = _zz_VexRiscv_46_;
  always @ (*) begin
    case(execute_ALU_BITWISE_CTRL)
      `AluBitwiseCtrlEnum_defaultEncoding_AND_1 : begin
        execute_IntAluPlugin_bitwise = (execute_SRC1 & execute_SRC2);
      end
      `AluBitwiseCtrlEnum_defaultEncoding_OR_1 : begin
        execute_IntAluPlugin_bitwise = (execute_SRC1 | execute_SRC2);
      end
      default : begin
        execute_IntAluPlugin_bitwise = (execute_SRC1 ^ execute_SRC2);
      end
    endcase
  end

  always @ (*) begin
    case(execute_ALU_CTRL)
      `AluCtrlEnum_defaultEncoding_BITWISE : begin
        _zz_VexRiscv_125_ = execute_IntAluPlugin_bitwise;
      end
      `AluCtrlEnum_defaultEncoding_SLT_SLTU : begin
        _zz_VexRiscv_125_ = {31'd0, _zz_VexRiscv_229_};
      end
      default : begin
        _zz_VexRiscv_125_ = execute_SRC_ADD_SUB;
      end
    endcase
  end

  assign execute_MulPlugin_a = execute_RS1;
  assign execute_MulPlugin_b = execute_RS2;
  always @ (*) begin
    case(_zz_VexRiscv_167_)
      2'b01 : begin
        execute_MulPlugin_aSigned = 1'b1;
      end
      2'b10 : begin
        execute_MulPlugin_aSigned = 1'b1;
      end
      default : begin
        execute_MulPlugin_aSigned = 1'b0;
      end
    endcase
  end

  always @ (*) begin
    case(_zz_VexRiscv_167_)
      2'b01 : begin
        execute_MulPlugin_bSigned = 1'b1;
      end
      2'b10 : begin
        execute_MulPlugin_bSigned = 1'b0;
      end
      default : begin
        execute_MulPlugin_bSigned = 1'b0;
      end
    endcase
  end

  assign execute_MulPlugin_aULow = execute_MulPlugin_a[15 : 0];
  assign execute_MulPlugin_bULow = execute_MulPlugin_b[15 : 0];
  assign execute_MulPlugin_aSLow = {1'b0,execute_MulPlugin_a[15 : 0]};
  assign execute_MulPlugin_bSLow = {1'b0,execute_MulPlugin_b[15 : 0]};
  assign execute_MulPlugin_aHigh = {(execute_MulPlugin_aSigned && execute_MulPlugin_a[31]),execute_MulPlugin_a[31 : 16]};
  assign execute_MulPlugin_bHigh = {(execute_MulPlugin_bSigned && execute_MulPlugin_b[31]),execute_MulPlugin_b[31 : 16]};
  assign writeBack_MulPlugin_result = ($signed(_zz_VexRiscv_230_) + $signed(_zz_VexRiscv_231_));
  always @ (*) begin
    case(decode_SRC1_CTRL)
      `Src1CtrlEnum_defaultEncoding_RS : begin
        _zz_VexRiscv_126_ = _zz_VexRiscv_28_;
      end
      `Src1CtrlEnum_defaultEncoding_PC_INCREMENT : begin
        _zz_VexRiscv_126_ = {29'd0, _zz_VexRiscv_234_};
      end
      `Src1CtrlEnum_defaultEncoding_IMU : begin
        _zz_VexRiscv_126_ = {decode_INSTRUCTION[31 : 12],(12'b000000000000)};
      end
      default : begin
        _zz_VexRiscv_126_ = {27'd0, _zz_VexRiscv_235_};
      end
    endcase
  end

  assign _zz_VexRiscv_127_ = _zz_VexRiscv_236_[11];
  always @ (*) begin
    _zz_VexRiscv_128_[19] = _zz_VexRiscv_127_;
    _zz_VexRiscv_128_[18] = _zz_VexRiscv_127_;
    _zz_VexRiscv_128_[17] = _zz_VexRiscv_127_;
    _zz_VexRiscv_128_[16] = _zz_VexRiscv_127_;
    _zz_VexRiscv_128_[15] = _zz_VexRiscv_127_;
    _zz_VexRiscv_128_[14] = _zz_VexRiscv_127_;
    _zz_VexRiscv_128_[13] = _zz_VexRiscv_127_;
    _zz_VexRiscv_128_[12] = _zz_VexRiscv_127_;
    _zz_VexRiscv_128_[11] = _zz_VexRiscv_127_;
    _zz_VexRiscv_128_[10] = _zz_VexRiscv_127_;
    _zz_VexRiscv_128_[9] = _zz_VexRiscv_127_;
    _zz_VexRiscv_128_[8] = _zz_VexRiscv_127_;
    _zz_VexRiscv_128_[7] = _zz_VexRiscv_127_;
    _zz_VexRiscv_128_[6] = _zz_VexRiscv_127_;
    _zz_VexRiscv_128_[5] = _zz_VexRiscv_127_;
    _zz_VexRiscv_128_[4] = _zz_VexRiscv_127_;
    _zz_VexRiscv_128_[3] = _zz_VexRiscv_127_;
    _zz_VexRiscv_128_[2] = _zz_VexRiscv_127_;
    _zz_VexRiscv_128_[1] = _zz_VexRiscv_127_;
    _zz_VexRiscv_128_[0] = _zz_VexRiscv_127_;
  end

  assign _zz_VexRiscv_129_ = _zz_VexRiscv_237_[11];
  always @ (*) begin
    _zz_VexRiscv_130_[19] = _zz_VexRiscv_129_;
    _zz_VexRiscv_130_[18] = _zz_VexRiscv_129_;
    _zz_VexRiscv_130_[17] = _zz_VexRiscv_129_;
    _zz_VexRiscv_130_[16] = _zz_VexRiscv_129_;
    _zz_VexRiscv_130_[15] = _zz_VexRiscv_129_;
    _zz_VexRiscv_130_[14] = _zz_VexRiscv_129_;
    _zz_VexRiscv_130_[13] = _zz_VexRiscv_129_;
    _zz_VexRiscv_130_[12] = _zz_VexRiscv_129_;
    _zz_VexRiscv_130_[11] = _zz_VexRiscv_129_;
    _zz_VexRiscv_130_[10] = _zz_VexRiscv_129_;
    _zz_VexRiscv_130_[9] = _zz_VexRiscv_129_;
    _zz_VexRiscv_130_[8] = _zz_VexRiscv_129_;
    _zz_VexRiscv_130_[7] = _zz_VexRiscv_129_;
    _zz_VexRiscv_130_[6] = _zz_VexRiscv_129_;
    _zz_VexRiscv_130_[5] = _zz_VexRiscv_129_;
    _zz_VexRiscv_130_[4] = _zz_VexRiscv_129_;
    _zz_VexRiscv_130_[3] = _zz_VexRiscv_129_;
    _zz_VexRiscv_130_[2] = _zz_VexRiscv_129_;
    _zz_VexRiscv_130_[1] = _zz_VexRiscv_129_;
    _zz_VexRiscv_130_[0] = _zz_VexRiscv_129_;
  end

  always @ (*) begin
    case(decode_SRC2_CTRL)
      `Src2CtrlEnum_defaultEncoding_RS : begin
        _zz_VexRiscv_131_ = _zz_VexRiscv_26_;
      end
      `Src2CtrlEnum_defaultEncoding_IMI : begin
        _zz_VexRiscv_131_ = {_zz_VexRiscv_128_,decode_INSTRUCTION[31 : 20]};
      end
      `Src2CtrlEnum_defaultEncoding_IMS : begin
        _zz_VexRiscv_131_ = {_zz_VexRiscv_130_,{decode_INSTRUCTION[31 : 25],decode_INSTRUCTION[11 : 7]}};
      end
      default : begin
        _zz_VexRiscv_131_ = _zz_VexRiscv_25_;
      end
    endcase
  end

  always @ (*) begin
    execute_SrcPlugin_addSub = _zz_VexRiscv_238_;
    if(execute_SRC2_FORCE_ZERO)begin
      execute_SrcPlugin_addSub = execute_SRC1;
    end
  end

  assign execute_SrcPlugin_less = ((execute_SRC1[31] == execute_SRC2[31]) ? execute_SrcPlugin_addSub[31] : (execute_SRC_LESS_UNSIGNED ? execute_SRC2[31] : execute_SRC1[31]));
  assign execute_FullBarrelShifterPlugin_amplitude = execute_SRC2[4 : 0];
  always @ (*) begin
    _zz_VexRiscv_132_[0] = execute_SRC1[31];
    _zz_VexRiscv_132_[1] = execute_SRC1[30];
    _zz_VexRiscv_132_[2] = execute_SRC1[29];
    _zz_VexRiscv_132_[3] = execute_SRC1[28];
    _zz_VexRiscv_132_[4] = execute_SRC1[27];
    _zz_VexRiscv_132_[5] = execute_SRC1[26];
    _zz_VexRiscv_132_[6] = execute_SRC1[25];
    _zz_VexRiscv_132_[7] = execute_SRC1[24];
    _zz_VexRiscv_132_[8] = execute_SRC1[23];
    _zz_VexRiscv_132_[9] = execute_SRC1[22];
    _zz_VexRiscv_132_[10] = execute_SRC1[21];
    _zz_VexRiscv_132_[11] = execute_SRC1[20];
    _zz_VexRiscv_132_[12] = execute_SRC1[19];
    _zz_VexRiscv_132_[13] = execute_SRC1[18];
    _zz_VexRiscv_132_[14] = execute_SRC1[17];
    _zz_VexRiscv_132_[15] = execute_SRC1[16];
    _zz_VexRiscv_132_[16] = execute_SRC1[15];
    _zz_VexRiscv_132_[17] = execute_SRC1[14];
    _zz_VexRiscv_132_[18] = execute_SRC1[13];
    _zz_VexRiscv_132_[19] = execute_SRC1[12];
    _zz_VexRiscv_132_[20] = execute_SRC1[11];
    _zz_VexRiscv_132_[21] = execute_SRC1[10];
    _zz_VexRiscv_132_[22] = execute_SRC1[9];
    _zz_VexRiscv_132_[23] = execute_SRC1[8];
    _zz_VexRiscv_132_[24] = execute_SRC1[7];
    _zz_VexRiscv_132_[25] = execute_SRC1[6];
    _zz_VexRiscv_132_[26] = execute_SRC1[5];
    _zz_VexRiscv_132_[27] = execute_SRC1[4];
    _zz_VexRiscv_132_[28] = execute_SRC1[3];
    _zz_VexRiscv_132_[29] = execute_SRC1[2];
    _zz_VexRiscv_132_[30] = execute_SRC1[1];
    _zz_VexRiscv_132_[31] = execute_SRC1[0];
  end

  assign execute_FullBarrelShifterPlugin_reversed = ((execute_SHIFT_CTRL == `ShiftCtrlEnum_defaultEncoding_SLL_1) ? _zz_VexRiscv_132_ : execute_SRC1);
  always @ (*) begin
    _zz_VexRiscv_133_[0] = memory_SHIFT_RIGHT[31];
    _zz_VexRiscv_133_[1] = memory_SHIFT_RIGHT[30];
    _zz_VexRiscv_133_[2] = memory_SHIFT_RIGHT[29];
    _zz_VexRiscv_133_[3] = memory_SHIFT_RIGHT[28];
    _zz_VexRiscv_133_[4] = memory_SHIFT_RIGHT[27];
    _zz_VexRiscv_133_[5] = memory_SHIFT_RIGHT[26];
    _zz_VexRiscv_133_[6] = memory_SHIFT_RIGHT[25];
    _zz_VexRiscv_133_[7] = memory_SHIFT_RIGHT[24];
    _zz_VexRiscv_133_[8] = memory_SHIFT_RIGHT[23];
    _zz_VexRiscv_133_[9] = memory_SHIFT_RIGHT[22];
    _zz_VexRiscv_133_[10] = memory_SHIFT_RIGHT[21];
    _zz_VexRiscv_133_[11] = memory_SHIFT_RIGHT[20];
    _zz_VexRiscv_133_[12] = memory_SHIFT_RIGHT[19];
    _zz_VexRiscv_133_[13] = memory_SHIFT_RIGHT[18];
    _zz_VexRiscv_133_[14] = memory_SHIFT_RIGHT[17];
    _zz_VexRiscv_133_[15] = memory_SHIFT_RIGHT[16];
    _zz_VexRiscv_133_[16] = memory_SHIFT_RIGHT[15];
    _zz_VexRiscv_133_[17] = memory_SHIFT_RIGHT[14];
    _zz_VexRiscv_133_[18] = memory_SHIFT_RIGHT[13];
    _zz_VexRiscv_133_[19] = memory_SHIFT_RIGHT[12];
    _zz_VexRiscv_133_[20] = memory_SHIFT_RIGHT[11];
    _zz_VexRiscv_133_[21] = memory_SHIFT_RIGHT[10];
    _zz_VexRiscv_133_[22] = memory_SHIFT_RIGHT[9];
    _zz_VexRiscv_133_[23] = memory_SHIFT_RIGHT[8];
    _zz_VexRiscv_133_[24] = memory_SHIFT_RIGHT[7];
    _zz_VexRiscv_133_[25] = memory_SHIFT_RIGHT[6];
    _zz_VexRiscv_133_[26] = memory_SHIFT_RIGHT[5];
    _zz_VexRiscv_133_[27] = memory_SHIFT_RIGHT[4];
    _zz_VexRiscv_133_[28] = memory_SHIFT_RIGHT[3];
    _zz_VexRiscv_133_[29] = memory_SHIFT_RIGHT[2];
    _zz_VexRiscv_133_[30] = memory_SHIFT_RIGHT[1];
    _zz_VexRiscv_133_[31] = memory_SHIFT_RIGHT[0];
  end

  always @ (*) begin
    _zz_VexRiscv_134_ = 1'b0;
    if(_zz_VexRiscv_168_)begin
      if(_zz_VexRiscv_169_)begin
        if(_zz_VexRiscv_139_)begin
          _zz_VexRiscv_134_ = 1'b1;
        end
      end
    end
    if(_zz_VexRiscv_170_)begin
      if(_zz_VexRiscv_171_)begin
        if(_zz_VexRiscv_141_)begin
          _zz_VexRiscv_134_ = 1'b1;
        end
      end
    end
    if(_zz_VexRiscv_172_)begin
      if(_zz_VexRiscv_173_)begin
        if(_zz_VexRiscv_143_)begin
          _zz_VexRiscv_134_ = 1'b1;
        end
      end
    end
    if((! decode_RS1_USE))begin
      _zz_VexRiscv_134_ = 1'b0;
    end
  end

  always @ (*) begin
    _zz_VexRiscv_135_ = 1'b0;
    if(_zz_VexRiscv_168_)begin
      if(_zz_VexRiscv_169_)begin
        if(_zz_VexRiscv_140_)begin
          _zz_VexRiscv_135_ = 1'b1;
        end
      end
    end
    if(_zz_VexRiscv_170_)begin
      if(_zz_VexRiscv_171_)begin
        if(_zz_VexRiscv_142_)begin
          _zz_VexRiscv_135_ = 1'b1;
        end
      end
    end
    if(_zz_VexRiscv_172_)begin
      if(_zz_VexRiscv_173_)begin
        if(_zz_VexRiscv_144_)begin
          _zz_VexRiscv_135_ = 1'b1;
        end
      end
    end
    if((! decode_RS2_USE))begin
      _zz_VexRiscv_135_ = 1'b0;
    end
  end

  assign _zz_VexRiscv_139_ = (writeBack_INSTRUCTION[11 : 7] == decode_INSTRUCTION[19 : 15]);
  assign _zz_VexRiscv_140_ = (writeBack_INSTRUCTION[11 : 7] == decode_INSTRUCTION[24 : 20]);
  assign _zz_VexRiscv_141_ = (memory_INSTRUCTION[11 : 7] == decode_INSTRUCTION[19 : 15]);
  assign _zz_VexRiscv_142_ = (memory_INSTRUCTION[11 : 7] == decode_INSTRUCTION[24 : 20]);
  assign _zz_VexRiscv_143_ = (execute_INSTRUCTION[11 : 7] == decode_INSTRUCTION[19 : 15]);
  assign _zz_VexRiscv_144_ = (execute_INSTRUCTION[11 : 7] == decode_INSTRUCTION[24 : 20]);
  assign execute_BranchPlugin_eq = (execute_SRC1 == execute_SRC2);
  assign _zz_VexRiscv_145_ = execute_INSTRUCTION[14 : 12];
  always @ (*) begin
    if((_zz_VexRiscv_145_ == (3'b000))) begin
        _zz_VexRiscv_146_ = execute_BranchPlugin_eq;
    end else if((_zz_VexRiscv_145_ == (3'b001))) begin
        _zz_VexRiscv_146_ = (! execute_BranchPlugin_eq);
    end else if((((_zz_VexRiscv_145_ & (3'b101)) == (3'b101)))) begin
        _zz_VexRiscv_146_ = (! execute_SRC_LESS);
    end else begin
        _zz_VexRiscv_146_ = execute_SRC_LESS;
    end
  end

  always @ (*) begin
    case(execute_BRANCH_CTRL)
      `BranchCtrlEnum_defaultEncoding_INC : begin
        _zz_VexRiscv_147_ = 1'b0;
      end
      `BranchCtrlEnum_defaultEncoding_JAL : begin
        _zz_VexRiscv_147_ = 1'b1;
      end
      `BranchCtrlEnum_defaultEncoding_JALR : begin
        _zz_VexRiscv_147_ = 1'b1;
      end
      default : begin
        _zz_VexRiscv_147_ = _zz_VexRiscv_146_;
      end
    endcase
  end

  assign execute_BranchPlugin_missAlignedTarget = 1'b0;
  always @ (*) begin
    case(execute_BRANCH_CTRL)
      `BranchCtrlEnum_defaultEncoding_JALR : begin
        execute_BranchPlugin_branch_src1 = execute_RS1;
      end
      default : begin
        execute_BranchPlugin_branch_src1 = execute_PC;
      end
    endcase
  end

  assign _zz_VexRiscv_148_ = _zz_VexRiscv_245_[11];
  always @ (*) begin
    _zz_VexRiscv_149_[19] = _zz_VexRiscv_148_;
    _zz_VexRiscv_149_[18] = _zz_VexRiscv_148_;
    _zz_VexRiscv_149_[17] = _zz_VexRiscv_148_;
    _zz_VexRiscv_149_[16] = _zz_VexRiscv_148_;
    _zz_VexRiscv_149_[15] = _zz_VexRiscv_148_;
    _zz_VexRiscv_149_[14] = _zz_VexRiscv_148_;
    _zz_VexRiscv_149_[13] = _zz_VexRiscv_148_;
    _zz_VexRiscv_149_[12] = _zz_VexRiscv_148_;
    _zz_VexRiscv_149_[11] = _zz_VexRiscv_148_;
    _zz_VexRiscv_149_[10] = _zz_VexRiscv_148_;
    _zz_VexRiscv_149_[9] = _zz_VexRiscv_148_;
    _zz_VexRiscv_149_[8] = _zz_VexRiscv_148_;
    _zz_VexRiscv_149_[7] = _zz_VexRiscv_148_;
    _zz_VexRiscv_149_[6] = _zz_VexRiscv_148_;
    _zz_VexRiscv_149_[5] = _zz_VexRiscv_148_;
    _zz_VexRiscv_149_[4] = _zz_VexRiscv_148_;
    _zz_VexRiscv_149_[3] = _zz_VexRiscv_148_;
    _zz_VexRiscv_149_[2] = _zz_VexRiscv_148_;
    _zz_VexRiscv_149_[1] = _zz_VexRiscv_148_;
    _zz_VexRiscv_149_[0] = _zz_VexRiscv_148_;
  end

  always @ (*) begin
    case(execute_BRANCH_CTRL)
      `BranchCtrlEnum_defaultEncoding_JALR : begin
        execute_BranchPlugin_branch_src2 = {_zz_VexRiscv_149_,execute_INSTRUCTION[31 : 20]};
      end
      default : begin
        execute_BranchPlugin_branch_src2 = ((execute_BRANCH_CTRL == `BranchCtrlEnum_defaultEncoding_JAL) ? {{_zz_VexRiscv_151_,{{{_zz_VexRiscv_398_,execute_INSTRUCTION[19 : 12]},execute_INSTRUCTION[20]},execute_INSTRUCTION[30 : 21]}},1'b0} : {{_zz_VexRiscv_153_,{{{_zz_VexRiscv_399_,_zz_VexRiscv_400_},execute_INSTRUCTION[30 : 25]},execute_INSTRUCTION[11 : 8]}},1'b0});
        if(execute_PREDICTION_HAD_BRANCHED2)begin
          execute_BranchPlugin_branch_src2 = {29'd0, _zz_VexRiscv_248_};
        end
      end
    endcase
  end

  assign _zz_VexRiscv_150_ = _zz_VexRiscv_246_[19];
  always @ (*) begin
    _zz_VexRiscv_151_[10] = _zz_VexRiscv_150_;
    _zz_VexRiscv_151_[9] = _zz_VexRiscv_150_;
    _zz_VexRiscv_151_[8] = _zz_VexRiscv_150_;
    _zz_VexRiscv_151_[7] = _zz_VexRiscv_150_;
    _zz_VexRiscv_151_[6] = _zz_VexRiscv_150_;
    _zz_VexRiscv_151_[5] = _zz_VexRiscv_150_;
    _zz_VexRiscv_151_[4] = _zz_VexRiscv_150_;
    _zz_VexRiscv_151_[3] = _zz_VexRiscv_150_;
    _zz_VexRiscv_151_[2] = _zz_VexRiscv_150_;
    _zz_VexRiscv_151_[1] = _zz_VexRiscv_150_;
    _zz_VexRiscv_151_[0] = _zz_VexRiscv_150_;
  end

  assign _zz_VexRiscv_152_ = _zz_VexRiscv_247_[11];
  always @ (*) begin
    _zz_VexRiscv_153_[18] = _zz_VexRiscv_152_;
    _zz_VexRiscv_153_[17] = _zz_VexRiscv_152_;
    _zz_VexRiscv_153_[16] = _zz_VexRiscv_152_;
    _zz_VexRiscv_153_[15] = _zz_VexRiscv_152_;
    _zz_VexRiscv_153_[14] = _zz_VexRiscv_152_;
    _zz_VexRiscv_153_[13] = _zz_VexRiscv_152_;
    _zz_VexRiscv_153_[12] = _zz_VexRiscv_152_;
    _zz_VexRiscv_153_[11] = _zz_VexRiscv_152_;
    _zz_VexRiscv_153_[10] = _zz_VexRiscv_152_;
    _zz_VexRiscv_153_[9] = _zz_VexRiscv_152_;
    _zz_VexRiscv_153_[8] = _zz_VexRiscv_152_;
    _zz_VexRiscv_153_[7] = _zz_VexRiscv_152_;
    _zz_VexRiscv_153_[6] = _zz_VexRiscv_152_;
    _zz_VexRiscv_153_[5] = _zz_VexRiscv_152_;
    _zz_VexRiscv_153_[4] = _zz_VexRiscv_152_;
    _zz_VexRiscv_153_[3] = _zz_VexRiscv_152_;
    _zz_VexRiscv_153_[2] = _zz_VexRiscv_152_;
    _zz_VexRiscv_153_[1] = _zz_VexRiscv_152_;
    _zz_VexRiscv_153_[0] = _zz_VexRiscv_152_;
  end

  assign execute_BranchPlugin_branchAdder = (execute_BranchPlugin_branch_src1 + execute_BranchPlugin_branch_src2);
  assign BranchPlugin_jumpInterface_valid = ((memory_arbitration_isValid && memory_BRANCH_DO) && (! 1'b0));
  assign BranchPlugin_jumpInterface_payload = memory_BRANCH_CALC;
  assign IBusSimplePlugin_decodePrediction_rsp_wasWrong = BranchPlugin_jumpInterface_valid;
  assign _zz_VexRiscv_20_ = decode_ENV_CTRL;
  assign _zz_VexRiscv_17_ = execute_ENV_CTRL;
  assign _zz_VexRiscv_15_ = memory_ENV_CTRL;
  assign _zz_VexRiscv_18_ = _zz_VexRiscv_40_;
  assign _zz_VexRiscv_44_ = decode_to_execute_ENV_CTRL;
  assign _zz_VexRiscv_43_ = execute_to_memory_ENV_CTRL;
  assign _zz_VexRiscv_45_ = memory_to_writeBack_ENV_CTRL;
  assign _zz_VexRiscv_13_ = decode_BRANCH_CTRL;
  assign _zz_VexRiscv_47_ = _zz_VexRiscv_37_;
  assign _zz_VexRiscv_21_ = decode_to_execute_BRANCH_CTRL;
  assign _zz_VexRiscv_11_ = decode_SHIFT_CTRL;
  assign _zz_VexRiscv_8_ = execute_SHIFT_CTRL;
  assign _zz_VexRiscv_9_ = _zz_VexRiscv_35_;
  assign _zz_VexRiscv_24_ = decode_to_execute_SHIFT_CTRL;
  assign _zz_VexRiscv_23_ = execute_to_memory_SHIFT_CTRL;
  assign _zz_VexRiscv_29_ = _zz_VexRiscv_38_;
  assign _zz_VexRiscv_6_ = decode_ALU_BITWISE_CTRL;
  assign _zz_VexRiscv_4_ = _zz_VexRiscv_36_;
  assign _zz_VexRiscv_31_ = decode_to_execute_ALU_BITWISE_CTRL;
  assign _zz_VexRiscv_3_ = decode_ALU_CTRL;
  assign _zz_VexRiscv_1_ = _zz_VexRiscv_41_;
  assign _zz_VexRiscv_30_ = decode_to_execute_ALU_CTRL;
  assign _zz_VexRiscv_27_ = _zz_VexRiscv_39_;
  assign decode_arbitration_isFlushed = (({writeBack_arbitration_flushNext,{memory_arbitration_flushNext,execute_arbitration_flushNext}} != (3'b000)) || ({writeBack_arbitration_flushIt,{memory_arbitration_flushIt,{execute_arbitration_flushIt,decode_arbitration_flushIt}}} != (4'b0000)));
  assign execute_arbitration_isFlushed = (({writeBack_arbitration_flushNext,memory_arbitration_flushNext} != (2'b00)) || ({writeBack_arbitration_flushIt,{memory_arbitration_flushIt,execute_arbitration_flushIt}} != (3'b000)));
  assign memory_arbitration_isFlushed = ((writeBack_arbitration_flushNext != (1'b0)) || ({writeBack_arbitration_flushIt,memory_arbitration_flushIt} != (2'b00)));
  assign writeBack_arbitration_isFlushed = (1'b0 || (writeBack_arbitration_flushIt != (1'b0)));
  assign decode_arbitration_isStuckByOthers = (decode_arbitration_haltByOther || (((1'b0 || execute_arbitration_isStuck) || memory_arbitration_isStuck) || writeBack_arbitration_isStuck));
  assign decode_arbitration_isStuck = (decode_arbitration_haltItself || decode_arbitration_isStuckByOthers);
  assign decode_arbitration_isMoving = ((! decode_arbitration_isStuck) && (! decode_arbitration_removeIt));
  assign decode_arbitration_isFiring = ((decode_arbitration_isValid && (! decode_arbitration_isStuck)) && (! decode_arbitration_removeIt));
  assign execute_arbitration_isStuckByOthers = (execute_arbitration_haltByOther || ((1'b0 || memory_arbitration_isStuck) || writeBack_arbitration_isStuck));
  assign execute_arbitration_isStuck = (execute_arbitration_haltItself || execute_arbitration_isStuckByOthers);
  assign execute_arbitration_isMoving = ((! execute_arbitration_isStuck) && (! execute_arbitration_removeIt));
  assign execute_arbitration_isFiring = ((execute_arbitration_isValid && (! execute_arbitration_isStuck)) && (! execute_arbitration_removeIt));
  assign memory_arbitration_isStuckByOthers = (memory_arbitration_haltByOther || (1'b0 || writeBack_arbitration_isStuck));
  assign memory_arbitration_isStuck = (memory_arbitration_haltItself || memory_arbitration_isStuckByOthers);
  assign memory_arbitration_isMoving = ((! memory_arbitration_isStuck) && (! memory_arbitration_removeIt));
  assign memory_arbitration_isFiring = ((memory_arbitration_isValid && (! memory_arbitration_isStuck)) && (! memory_arbitration_removeIt));
  assign writeBack_arbitration_isStuckByOthers = (writeBack_arbitration_haltByOther || 1'b0);
  assign writeBack_arbitration_isStuck = (writeBack_arbitration_haltItself || writeBack_arbitration_isStuckByOthers);
  assign writeBack_arbitration_isMoving = ((! writeBack_arbitration_isStuck) && (! writeBack_arbitration_removeIt));
  assign writeBack_arbitration_isFiring = ((writeBack_arbitration_isValid && (! writeBack_arbitration_isStuck)) && (! writeBack_arbitration_removeIt));
  always @ (posedge clk or posedge reset) begin
    if (reset) begin
      IBusSimplePlugin_fetchPc_pcReg <= (32'b00000000000000000000000000000000);
      IBusSimplePlugin_fetchPc_booted <= 1'b0;
      IBusSimplePlugin_fetchPc_inc <= 1'b0;
      IBusSimplePlugin_decodePc_pcReg <= (32'b00000000000000000000000000000000);
      _zz_VexRiscv_59_ <= 1'b0;
      _zz_VexRiscv_61_ <= 1'b0;
      IBusSimplePlugin_decompressor_bufferValid <= 1'b0;
      _zz_VexRiscv_90_ <= 1'b0;
      IBusSimplePlugin_injector_nextPcCalc_valids_0 <= 1'b0;
      IBusSimplePlugin_injector_nextPcCalc_valids_1 <= 1'b0;
      IBusSimplePlugin_injector_nextPcCalc_valids_2 <= 1'b0;
      IBusSimplePlugin_injector_nextPcCalc_valids_3 <= 1'b0;
      IBusSimplePlugin_injector_decodeRemoved <= 1'b0;
      IBusSimplePlugin_pendingCmd <= (3'b000);
      IBusSimplePlugin_rspJoin_discardCounter <= (3'b000);
      CsrPlugin_mstatus_MIE <= 1'b0;
      CsrPlugin_mstatus_MPIE <= 1'b0;
      CsrPlugin_mstatus_MPP <= (2'b11);
      CsrPlugin_mie_MEIE <= 1'b0;
      CsrPlugin_mie_MTIE <= 1'b0;
      CsrPlugin_mie_MSIE <= 1'b0;
      CsrPlugin_interrupt_valid <= 1'b0;
      CsrPlugin_hadException <= 1'b0;
      execute_CsrPlugin_wfiWake <= 1'b0;
      _zz_VexRiscv_124_ <= 1'b1;
      _zz_VexRiscv_136_ <= 1'b0;
      execute_arbitration_isValid <= 1'b0;
      memory_arbitration_isValid <= 1'b0;
      writeBack_arbitration_isValid <= 1'b0;
      memory_to_writeBack_REGFILE_WRITE_DATA <= (32'b00000000000000000000000000000000);
      memory_to_writeBack_INSTRUCTION <= (32'b00000000000000000000000000000000);
    end else begin
      IBusSimplePlugin_fetchPc_booted <= 1'b1;
      if((IBusSimplePlugin_fetchPc_corrected || IBusSimplePlugin_fetchPc_pcRegPropagate))begin
        IBusSimplePlugin_fetchPc_inc <= 1'b0;
      end
      if((IBusSimplePlugin_fetchPc_output_valid && IBusSimplePlugin_fetchPc_output_ready))begin
        IBusSimplePlugin_fetchPc_inc <= 1'b1;
      end
      if(((! IBusSimplePlugin_fetchPc_output_valid) && IBusSimplePlugin_fetchPc_output_ready))begin
        IBusSimplePlugin_fetchPc_inc <= 1'b0;
      end
      if((IBusSimplePlugin_fetchPc_booted && ((IBusSimplePlugin_fetchPc_output_ready || IBusSimplePlugin_fetcherflushIt) || IBusSimplePlugin_fetchPc_pcRegPropagate)))begin
        IBusSimplePlugin_fetchPc_pcReg <= IBusSimplePlugin_fetchPc_pc;
      end
      if((decode_arbitration_isFiring && (! IBusSimplePlugin_decodePc_injectedDecode)))begin
        IBusSimplePlugin_decodePc_pcReg <= IBusSimplePlugin_decodePc_pcPlus;
      end
      if((IBusSimplePlugin_jump_pcLoad_valid && ((! decode_arbitration_isStuck) || decode_arbitration_removeIt)))begin
        IBusSimplePlugin_decodePc_pcReg <= IBusSimplePlugin_jump_pcLoad_payload;
      end
      if(IBusSimplePlugin_fetcherflushIt)begin
        _zz_VexRiscv_59_ <= 1'b0;
      end
      if(_zz_VexRiscv_57_)begin
        _zz_VexRiscv_59_ <= IBusSimplePlugin_iBusRsp_stages_0_output_valid;
      end
      if(IBusSimplePlugin_iBusRsp_stages_1_output_ready)begin
        _zz_VexRiscv_61_ <= IBusSimplePlugin_iBusRsp_stages_1_output_valid;
      end
      if(IBusSimplePlugin_fetcherflushIt)begin
        _zz_VexRiscv_61_ <= 1'b0;
      end
      if((IBusSimplePlugin_decompressor_output_valid && IBusSimplePlugin_decompressor_output_ready))begin
        IBusSimplePlugin_decompressor_bufferValid <= 1'b0;
      end
      if(_zz_VexRiscv_165_)begin
        if(_zz_VexRiscv_166_)begin
          IBusSimplePlugin_decompressor_bufferValid <= 1'b1;
        end else begin
          IBusSimplePlugin_decompressor_bufferValid <= 1'b0;
        end
      end
      if(IBusSimplePlugin_fetcherflushIt)begin
        IBusSimplePlugin_decompressor_bufferValid <= 1'b0;
      end
      if(IBusSimplePlugin_decompressor_output_ready)begin
        _zz_VexRiscv_90_ <= IBusSimplePlugin_decompressor_output_valid;
      end
      if(IBusSimplePlugin_fetcherflushIt)begin
        _zz_VexRiscv_90_ <= 1'b0;
      end
      if((! 1'b0))begin
        IBusSimplePlugin_injector_nextPcCalc_valids_0 <= 1'b1;
      end
      if(IBusSimplePlugin_fetcherflushIt)begin
        IBusSimplePlugin_injector_nextPcCalc_valids_0 <= 1'b0;
      end
      if((! execute_arbitration_isStuck))begin
        IBusSimplePlugin_injector_nextPcCalc_valids_1 <= IBusSimplePlugin_injector_nextPcCalc_valids_0;
      end
      if(IBusSimplePlugin_fetcherflushIt)begin
        IBusSimplePlugin_injector_nextPcCalc_valids_1 <= 1'b0;
      end
      if((! memory_arbitration_isStuck))begin
        IBusSimplePlugin_injector_nextPcCalc_valids_2 <= IBusSimplePlugin_injector_nextPcCalc_valids_1;
      end
      if(IBusSimplePlugin_fetcherflushIt)begin
        IBusSimplePlugin_injector_nextPcCalc_valids_2 <= 1'b0;
      end
      if((! writeBack_arbitration_isStuck))begin
        IBusSimplePlugin_injector_nextPcCalc_valids_3 <= IBusSimplePlugin_injector_nextPcCalc_valids_2;
      end
      if(IBusSimplePlugin_fetcherflushIt)begin
        IBusSimplePlugin_injector_nextPcCalc_valids_3 <= 1'b0;
      end
      if(decode_arbitration_removeIt)begin
        IBusSimplePlugin_injector_decodeRemoved <= 1'b1;
      end
      if(IBusSimplePlugin_fetcherflushIt)begin
        IBusSimplePlugin_injector_decodeRemoved <= 1'b0;
      end
      IBusSimplePlugin_pendingCmd <= IBusSimplePlugin_pendingCmdNext;
      IBusSimplePlugin_rspJoin_discardCounter <= (IBusSimplePlugin_rspJoin_discardCounter - _zz_VexRiscv_228_);
      if(IBusSimplePlugin_fetcherflushIt)begin
        IBusSimplePlugin_rspJoin_discardCounter <= IBusSimplePlugin_pendingCmdNext;
      end
      CsrPlugin_interrupt_valid <= 1'b0;
      if(_zz_VexRiscv_174_)begin
        if(_zz_VexRiscv_175_)begin
          CsrPlugin_interrupt_valid <= 1'b1;
        end
        if(_zz_VexRiscv_176_)begin
          CsrPlugin_interrupt_valid <= 1'b1;
        end
        if(_zz_VexRiscv_177_)begin
          CsrPlugin_interrupt_valid <= 1'b1;
        end
      end
      CsrPlugin_hadException <= CsrPlugin_exception;
      if(_zz_VexRiscv_162_)begin
        case(CsrPlugin_targetPrivilege)
          2'b11 : begin
            CsrPlugin_mstatus_MIE <= 1'b0;
            CsrPlugin_mstatus_MPIE <= CsrPlugin_mstatus_MIE;
            CsrPlugin_mstatus_MPP <= CsrPlugin_privilege;
          end
          default : begin
          end
        endcase
      end
      if(_zz_VexRiscv_163_)begin
        case(_zz_VexRiscv_164_)
          2'b11 : begin
            CsrPlugin_mstatus_MPP <= (2'b00);
            CsrPlugin_mstatus_MIE <= CsrPlugin_mstatus_MPIE;
            CsrPlugin_mstatus_MPIE <= 1'b1;
          end
          default : begin
          end
        endcase
      end
      execute_CsrPlugin_wfiWake <= (({_zz_VexRiscv_111_,{_zz_VexRiscv_110_,_zz_VexRiscv_109_}} != (3'b000)) || CsrPlugin_thirdPartyWake);
      _zz_VexRiscv_124_ <= 1'b0;
      _zz_VexRiscv_136_ <= (_zz_VexRiscv_33_ && writeBack_arbitration_isFiring);
      if((! writeBack_arbitration_isStuck))begin
        memory_to_writeBack_INSTRUCTION <= memory_INSTRUCTION;
      end
      if((! writeBack_arbitration_isStuck))begin
        memory_to_writeBack_REGFILE_WRITE_DATA <= _zz_VexRiscv_22_;
      end
      if(((! execute_arbitration_isStuck) || execute_arbitration_removeIt))begin
        execute_arbitration_isValid <= 1'b0;
      end
      if(((! decode_arbitration_isStuck) && (! decode_arbitration_removeIt)))begin
        execute_arbitration_isValid <= decode_arbitration_isValid;
      end
      if(((! memory_arbitration_isStuck) || memory_arbitration_removeIt))begin
        memory_arbitration_isValid <= 1'b0;
      end
      if(((! execute_arbitration_isStuck) && (! execute_arbitration_removeIt)))begin
        memory_arbitration_isValid <= execute_arbitration_isValid;
      end
      if(((! writeBack_arbitration_isStuck) || writeBack_arbitration_removeIt))begin
        writeBack_arbitration_isValid <= 1'b0;
      end
      if(((! memory_arbitration_isStuck) && (! memory_arbitration_removeIt)))begin
        writeBack_arbitration_isValid <= memory_arbitration_isValid;
      end
      case(execute_CsrPlugin_csrAddress)
        12'b001100000000 : begin
          if(execute_CsrPlugin_writeEnable)begin
            CsrPlugin_mstatus_MPP <= execute_CsrPlugin_writeData[12 : 11];
            CsrPlugin_mstatus_MPIE <= _zz_VexRiscv_249_[0];
            CsrPlugin_mstatus_MIE <= _zz_VexRiscv_250_[0];
          end
        end
        12'b001101000100 : begin
        end
        12'b110000000000 : begin
        end
        12'b001101000000 : begin
        end
        12'b001100000100 : begin
          if(execute_CsrPlugin_writeEnable)begin
            CsrPlugin_mie_MEIE <= _zz_VexRiscv_252_[0];
            CsrPlugin_mie_MTIE <= _zz_VexRiscv_253_[0];
            CsrPlugin_mie_MSIE <= _zz_VexRiscv_254_[0];
          end
        end
        12'b110010000000 : begin
        end
        default : begin
        end
      endcase
    end
  end

  always @ (posedge clk) begin
    if(IBusSimplePlugin_iBusRsp_stages_1_output_ready)begin
      _zz_VexRiscv_62_ <= IBusSimplePlugin_iBusRsp_stages_1_output_payload;
    end
    if(_zz_VexRiscv_165_)begin
      IBusSimplePlugin_decompressor_bufferData <= IBusSimplePlugin_iBusRsp_output_payload_rsp_inst[31 : 16];
    end
    if(IBusSimplePlugin_decompressor_output_ready)begin
      _zz_VexRiscv_91_ <= IBusSimplePlugin_decompressor_output_payload_pc;
      _zz_VexRiscv_92_ <= IBusSimplePlugin_decompressor_output_payload_rsp_error;
      _zz_VexRiscv_93_ <= IBusSimplePlugin_decompressor_output_payload_rsp_inst;
      _zz_VexRiscv_94_ <= IBusSimplePlugin_decompressor_output_payload_isRvc;
    end
    if(IBusSimplePlugin_injector_decodeInput_ready)begin
      IBusSimplePlugin_injector_formal_rawInDecode <= IBusSimplePlugin_decompressor_raw;
    end
    if(!(! (((dBus_rsp_ready && memory_MEMORY_ENABLE) && memory_arbitration_isValid) && memory_arbitration_isStuck))) begin
      $display("ERROR DBusSimplePlugin doesn't allow memory stage stall when read happend");
    end
    if(!(! (((writeBack_arbitration_isValid && writeBack_MEMORY_ENABLE) && (! writeBack_MEMORY_STORE)) && writeBack_arbitration_isStuck))) begin
      $display("ERROR DBusSimplePlugin doesn't allow writeback stage stall when read happend");
    end
    CsrPlugin_mip_MEIP <= externalInterrupt;
    CsrPlugin_mip_MTIP <= timerInterrupt;
    CsrPlugin_mip_MSIP <= softwareInterrupt;
    CsrPlugin_mcycle <= (CsrPlugin_mcycle + (64'b0000000000000000000000000000000000000000000000000000000000000001));
    if(writeBack_arbitration_isFiring)begin
      CsrPlugin_minstret <= (CsrPlugin_minstret + (64'b0000000000000000000000000000000000000000000000000000000000000001));
    end
    if(_zz_VexRiscv_174_)begin
      if(_zz_VexRiscv_175_)begin
        CsrPlugin_interrupt_code <= (4'b0111);
        CsrPlugin_interrupt_targetPrivilege <= (2'b11);
      end
      if(_zz_VexRiscv_176_)begin
        CsrPlugin_interrupt_code <= (4'b0011);
        CsrPlugin_interrupt_targetPrivilege <= (2'b11);
      end
      if(_zz_VexRiscv_177_)begin
        CsrPlugin_interrupt_code <= (4'b1011);
        CsrPlugin_interrupt_targetPrivilege <= (2'b11);
      end
    end
    if(_zz_VexRiscv_162_)begin
      case(CsrPlugin_targetPrivilege)
        2'b11 : begin
          CsrPlugin_mcause_interrupt <= (! CsrPlugin_hadException);
          CsrPlugin_mcause_exceptionCode <= CsrPlugin_trapCause;
          CsrPlugin_mepc <= decode_PC;
        end
        default : begin
        end
      endcase
    end
    _zz_VexRiscv_137_ <= _zz_VexRiscv_32_[11 : 7];
    _zz_VexRiscv_138_ <= _zz_VexRiscv_46_;
    if((! execute_arbitration_isStuck))begin
      decode_to_execute_SRC2 <= decode_SRC2;
    end
    if((! execute_arbitration_isStuck))begin
      decode_to_execute_MEMORY_STORE <= decode_MEMORY_STORE;
    end
    if((! memory_arbitration_isStuck))begin
      execute_to_memory_MEMORY_STORE <= execute_MEMORY_STORE;
    end
    if((! writeBack_arbitration_isStuck))begin
      memory_to_writeBack_MEMORY_STORE <= memory_MEMORY_STORE;
    end
    if((! execute_arbitration_isStuck))begin
      decode_to_execute_IS_CSR <= decode_IS_CSR;
    end
    if((! execute_arbitration_isStuck))begin
      decode_to_execute_SRC_LESS_UNSIGNED <= decode_SRC_LESS_UNSIGNED;
    end
    if((! memory_arbitration_isStuck))begin
      execute_to_memory_SHIFT_RIGHT <= execute_SHIFT_RIGHT;
    end
    if((! memory_arbitration_isStuck))begin
      execute_to_memory_MUL_LL <= execute_MUL_LL;
    end
    if((! execute_arbitration_isStuck))begin
      decode_to_execute_CSR_WRITE_OPCODE <= decode_CSR_WRITE_OPCODE;
    end
    if((! execute_arbitration_isStuck))begin
      decode_to_execute_IS_RVC <= decode_IS_RVC;
    end
    if((! execute_arbitration_isStuck))begin
      decode_to_execute_IS_MUL <= decode_IS_MUL;
    end
    if((! memory_arbitration_isStuck))begin
      execute_to_memory_IS_MUL <= execute_IS_MUL;
    end
    if((! writeBack_arbitration_isStuck))begin
      memory_to_writeBack_IS_MUL <= memory_IS_MUL;
    end
    if((! execute_arbitration_isStuck))begin
      decode_to_execute_MEMORY_ENABLE <= decode_MEMORY_ENABLE;
    end
    if((! memory_arbitration_isStuck))begin
      execute_to_memory_MEMORY_ENABLE <= execute_MEMORY_ENABLE;
    end
    if((! writeBack_arbitration_isStuck))begin
      memory_to_writeBack_MEMORY_ENABLE <= memory_MEMORY_ENABLE;
    end
    if((! execute_arbitration_isStuck))begin
      decode_to_execute_INSTRUCTION <= decode_INSTRUCTION;
    end
    if((! memory_arbitration_isStuck))begin
      execute_to_memory_INSTRUCTION <= execute_INSTRUCTION;
    end
    if((! writeBack_arbitration_isStuck))begin
      memory_to_writeBack_MEMORY_READ_DATA <= memory_MEMORY_READ_DATA;
    end
    if((! execute_arbitration_isStuck))begin
      decode_to_execute_BYPASSABLE_MEMORY_STAGE <= decode_BYPASSABLE_MEMORY_STAGE;
    end
    if((! memory_arbitration_isStuck))begin
      execute_to_memory_BYPASSABLE_MEMORY_STAGE <= execute_BYPASSABLE_MEMORY_STAGE;
    end
    if((! execute_arbitration_isStuck))begin
      decode_to_execute_SRC2_FORCE_ZERO <= decode_SRC2_FORCE_ZERO;
    end
    if((! writeBack_arbitration_isStuck))begin
      memory_to_writeBack_MUL_LOW <= memory_MUL_LOW;
    end
    if((! execute_arbitration_isStuck))begin
      decode_to_execute_ENV_CTRL <= _zz_VexRiscv_19_;
    end
    if((! memory_arbitration_isStuck))begin
      execute_to_memory_ENV_CTRL <= _zz_VexRiscv_16_;
    end
    if((! writeBack_arbitration_isStuck))begin
      memory_to_writeBack_ENV_CTRL <= _zz_VexRiscv_14_;
    end
    if((! memory_arbitration_isStuck))begin
      execute_to_memory_REGFILE_WRITE_DATA <= _zz_VexRiscv_42_;
    end
    if((! execute_arbitration_isStuck))begin
      decode_to_execute_BRANCH_CTRL <= _zz_VexRiscv_12_;
    end
    if((! memory_arbitration_isStuck))begin
      execute_to_memory_MUL_HH <= execute_MUL_HH;
    end
    if((! writeBack_arbitration_isStuck))begin
      memory_to_writeBack_MUL_HH <= memory_MUL_HH;
    end
    if((! execute_arbitration_isStuck))begin
      decode_to_execute_SHIFT_CTRL <= _zz_VexRiscv_10_;
    end
    if((! memory_arbitration_isStuck))begin
      execute_to_memory_SHIFT_CTRL <= _zz_VexRiscv_7_;
    end
    if((! execute_arbitration_isStuck))begin
      decode_to_execute_RS2 <= _zz_VexRiscv_26_;
    end
    if((! memory_arbitration_isStuck))begin
      execute_to_memory_MEMORY_ADDRESS_LOW <= execute_MEMORY_ADDRESS_LOW;
    end
    if((! writeBack_arbitration_isStuck))begin
      memory_to_writeBack_MEMORY_ADDRESS_LOW <= memory_MEMORY_ADDRESS_LOW;
    end
    if((! execute_arbitration_isStuck))begin
      decode_to_execute_PC <= _zz_VexRiscv_25_;
    end
    if((! memory_arbitration_isStuck))begin
      execute_to_memory_PC <= execute_PC;
    end
    if((! writeBack_arbitration_isStuck))begin
      memory_to_writeBack_PC <= memory_PC;
    end
    if((! execute_arbitration_isStuck))begin
      decode_to_execute_REGFILE_WRITE_VALID <= decode_REGFILE_WRITE_VALID;
    end
    if((! memory_arbitration_isStuck))begin
      execute_to_memory_REGFILE_WRITE_VALID <= execute_REGFILE_WRITE_VALID;
    end
    if((! writeBack_arbitration_isStuck))begin
      memory_to_writeBack_REGFILE_WRITE_VALID <= memory_REGFILE_WRITE_VALID;
    end
    if((! execute_arbitration_isStuck))begin
      decode_to_execute_SRC_USE_SUB_LESS <= decode_SRC_USE_SUB_LESS;
    end
    if((! execute_arbitration_isStuck))begin
      decode_to_execute_SRC1 <= decode_SRC1;
    end
    if((! memory_arbitration_isStuck))begin
      execute_to_memory_BRANCH_CALC <= execute_BRANCH_CALC;
    end
    if((! execute_arbitration_isStuck))begin
      decode_to_execute_RS1 <= _zz_VexRiscv_28_;
    end
    if((! memory_arbitration_isStuck))begin
      execute_to_memory_MUL_HL <= execute_MUL_HL;
    end
    if((! memory_arbitration_isStuck))begin
      execute_to_memory_BRANCH_DO <= execute_BRANCH_DO;
    end
    if((! execute_arbitration_isStuck))begin
      decode_to_execute_CSR_READ_OPCODE <= decode_CSR_READ_OPCODE;
    end
    if((! memory_arbitration_isStuck))begin
      execute_to_memory_MUL_LH <= execute_MUL_LH;
    end
    if((! execute_arbitration_isStuck))begin
      decode_to_execute_ALU_BITWISE_CTRL <= _zz_VexRiscv_5_;
    end
    if((! execute_arbitration_isStuck))begin
      decode_to_execute_ALU_CTRL <= _zz_VexRiscv_2_;
    end
    if((! execute_arbitration_isStuck))begin
      decode_to_execute_FORMAL_PC_NEXT <= _zz_VexRiscv_49_;
    end
    if((! memory_arbitration_isStuck))begin
      execute_to_memory_FORMAL_PC_NEXT <= execute_FORMAL_PC_NEXT;
    end
    if((! writeBack_arbitration_isStuck))begin
      memory_to_writeBack_FORMAL_PC_NEXT <= _zz_VexRiscv_48_;
    end
    if((! execute_arbitration_isStuck))begin
      decode_to_execute_PREDICTION_HAD_BRANCHED2 <= decode_PREDICTION_HAD_BRANCHED2;
    end
    if((! execute_arbitration_isStuck))begin
      decode_to_execute_BYPASSABLE_EXECUTE_STAGE <= decode_BYPASSABLE_EXECUTE_STAGE;
    end
    if((((! IBusSimplePlugin_iBusRsp_output_ready) && (IBusSimplePlugin_decompressor_output_valid && IBusSimplePlugin_decompressor_output_ready)) && (! IBusSimplePlugin_fetcherflushIt)))begin
      _zz_VexRiscv_62_[1] <= 1'b1;
    end
    case(execute_CsrPlugin_csrAddress)
      12'b001100000000 : begin
      end
      12'b001101000100 : begin
        if(execute_CsrPlugin_writeEnable)begin
          CsrPlugin_mip_MSIP <= _zz_VexRiscv_251_[0];
        end
      end
      12'b110000000000 : begin
      end
      12'b001101000000 : begin
        if(execute_CsrPlugin_writeEnable)begin
          CsrPlugin_mscratch <= execute_CsrPlugin_writeData[31 : 0];
        end
      end
      12'b001100000100 : begin
      end
      12'b110010000000 : begin
      end
      default : begin
      end
    endcase
  end

endmodule

module CCPipelinedMemoryBusRam (
      input   io_bus_cmd_valid,
      output  io_bus_cmd_ready,
      input   io_bus_cmd_payload_write,
      input  [31:0] io_bus_cmd_payload_address,
      input  [31:0] io_bus_cmd_payload_data,
      input  [3:0] io_bus_cmd_payload_mask,
      output  io_bus_rsp_valid,
      output [31:0] io_bus_rsp_payload_data,
      input   clk,
      input   reset);
  reg [31:0] _zz_CCPipelinedMemoryBusRam_4_;
  wire [10:0] _zz_CCPipelinedMemoryBusRam_5_;
  reg  _zz_CCPipelinedMemoryBusRam_1_;
  wire [29:0] _zz_CCPipelinedMemoryBusRam_2_;
  wire [31:0] _zz_CCPipelinedMemoryBusRam_3_;
  reg [7:0] _zz_CCPipelinedMemoryBusRam_6_;
  reg [7:0] _zz_CCPipelinedMemoryBusRam_7_;
  reg [7:0] _zz_CCPipelinedMemoryBusRam_8_;
  reg [7:0] _zz_CCPipelinedMemoryBusRam_9_;
  assign _zz_CCPipelinedMemoryBusRam_5_ = _zz_CCPipelinedMemoryBusRam_2_[10:0];
  always @ (*) begin
    _zz_CCPipelinedMemoryBusRam_4_ = {_zz_CCPipelinedMemoryBusRam_9_, _zz_CCPipelinedMemoryBusRam_8_, _zz_CCPipelinedMemoryBusRam_7_, _zz_CCPipelinedMemoryBusRam_6_};
  end
  always @ (posedge clk) begin
    if(io_bus_cmd_valid) begin
      _zz_CCPipelinedMemoryBusRam_6_ <= 0;
      _zz_CCPipelinedMemoryBusRam_7_ <= 0;
      _zz_CCPipelinedMemoryBusRam_8_ <= 0;
      _zz_CCPipelinedMemoryBusRam_9_ <= 0;
    end
  end

  always @ (posedge clk) begin
    if(io_bus_cmd_payload_mask[0] && io_bus_cmd_valid && io_bus_cmd_payload_write ) begin
    end
    if(io_bus_cmd_payload_mask[1] && io_bus_cmd_valid && io_bus_cmd_payload_write ) begin
    end
    if(io_bus_cmd_payload_mask[2] && io_bus_cmd_valid && io_bus_cmd_payload_write ) begin
    end
    if(io_bus_cmd_payload_mask[3] && io_bus_cmd_valid && io_bus_cmd_payload_write ) begin
    end
  end

  assign io_bus_rsp_valid = _zz_CCPipelinedMemoryBusRam_1_;
  assign _zz_CCPipelinedMemoryBusRam_2_ = (io_bus_cmd_payload_address >>> 2);
  assign _zz_CCPipelinedMemoryBusRam_3_ = io_bus_cmd_payload_data;
  assign io_bus_rsp_payload_data = _zz_CCPipelinedMemoryBusRam_4_;
  assign io_bus_cmd_ready = 1'b1;
  always @ (posedge clk or posedge reset) begin
    if (reset) begin
      _zz_CCPipelinedMemoryBusRam_1_ <= 1'b0;
    end else begin
      _zz_CCPipelinedMemoryBusRam_1_ <= ((io_bus_cmd_valid && io_bus_cmd_ready) && (! io_bus_cmd_payload_write));
    end
  end

endmodule

module PipelinedMemoryBusToApbBridge (
      input   io_pipelinedMemoryBus_cmd_valid,
      output  io_pipelinedMemoryBus_cmd_ready,
      input   io_pipelinedMemoryBus_cmd_payload_write,
      input  [31:0] io_pipelinedMemoryBus_cmd_payload_address,
      input  [31:0] io_pipelinedMemoryBus_cmd_payload_data,
      input  [3:0] io_pipelinedMemoryBus_cmd_payload_mask,
      output  io_pipelinedMemoryBus_rsp_valid,
      output [31:0] io_pipelinedMemoryBus_rsp_payload_data,
      output [19:0] io_apb_PADDR,
      output [0:0] io_apb_PSEL,
      output  io_apb_PENABLE,
      input   io_apb_PREADY,
      output  io_apb_PWRITE,
      output [31:0] io_apb_PWDATA,
      input  [31:0] io_apb_PRDATA,
      input   io_apb_PSLVERROR,
      input   clk,
      input   reset);
  wire  _zz_PipelinedMemoryBusToApbBridge_1_;
  wire  _zz_PipelinedMemoryBusToApbBridge_2_;
  wire  pipelinedMemoryBusStage_cmd_valid;
  reg  pipelinedMemoryBusStage_cmd_ready;
  wire  pipelinedMemoryBusStage_cmd_payload_write;
  wire [31:0] pipelinedMemoryBusStage_cmd_payload_address;
  wire [31:0] pipelinedMemoryBusStage_cmd_payload_data;
  wire [3:0] pipelinedMemoryBusStage_cmd_payload_mask;
  reg  pipelinedMemoryBusStage_rsp_valid;
  wire [31:0] pipelinedMemoryBusStage_rsp_payload_data;
  wire  io_pipelinedMemoryBus_cmd_halfPipe_valid;
  wire  io_pipelinedMemoryBus_cmd_halfPipe_ready;
  wire  io_pipelinedMemoryBus_cmd_halfPipe_payload_write;
  wire [31:0] io_pipelinedMemoryBus_cmd_halfPipe_payload_address;
  wire [31:0] io_pipelinedMemoryBus_cmd_halfPipe_payload_data;
  wire [3:0] io_pipelinedMemoryBus_cmd_halfPipe_payload_mask;
  reg  io_pipelinedMemoryBus_cmd_halfPipe_regs_valid;
  reg  io_pipelinedMemoryBus_cmd_halfPipe_regs_ready;
  reg  io_pipelinedMemoryBus_cmd_halfPipe_regs_payload_write;
  reg [31:0] io_pipelinedMemoryBus_cmd_halfPipe_regs_payload_address;
  reg [31:0] io_pipelinedMemoryBus_cmd_halfPipe_regs_payload_data;
  reg [3:0] io_pipelinedMemoryBus_cmd_halfPipe_regs_payload_mask;
  reg  pipelinedMemoryBusStage_rsp_regNext_valid;
  reg [31:0] pipelinedMemoryBusStage_rsp_regNext_payload_data;
  reg  state;
  assign _zz_PipelinedMemoryBusToApbBridge_1_ = (! state);
  assign _zz_PipelinedMemoryBusToApbBridge_2_ = (! io_pipelinedMemoryBus_cmd_halfPipe_regs_valid);
  assign io_pipelinedMemoryBus_cmd_halfPipe_valid = io_pipelinedMemoryBus_cmd_halfPipe_regs_valid;
  assign io_pipelinedMemoryBus_cmd_halfPipe_payload_write = io_pipelinedMemoryBus_cmd_halfPipe_regs_payload_write;
  assign io_pipelinedMemoryBus_cmd_halfPipe_payload_address = io_pipelinedMemoryBus_cmd_halfPipe_regs_payload_address;
  assign io_pipelinedMemoryBus_cmd_halfPipe_payload_data = io_pipelinedMemoryBus_cmd_halfPipe_regs_payload_data;
  assign io_pipelinedMemoryBus_cmd_halfPipe_payload_mask = io_pipelinedMemoryBus_cmd_halfPipe_regs_payload_mask;
  assign io_pipelinedMemoryBus_cmd_ready = io_pipelinedMemoryBus_cmd_halfPipe_regs_ready;
  assign pipelinedMemoryBusStage_cmd_valid = io_pipelinedMemoryBus_cmd_halfPipe_valid;
  assign io_pipelinedMemoryBus_cmd_halfPipe_ready = pipelinedMemoryBusStage_cmd_ready;
  assign pipelinedMemoryBusStage_cmd_payload_write = io_pipelinedMemoryBus_cmd_halfPipe_payload_write;
  assign pipelinedMemoryBusStage_cmd_payload_address = io_pipelinedMemoryBus_cmd_halfPipe_payload_address;
  assign pipelinedMemoryBusStage_cmd_payload_data = io_pipelinedMemoryBus_cmd_halfPipe_payload_data;
  assign pipelinedMemoryBusStage_cmd_payload_mask = io_pipelinedMemoryBus_cmd_halfPipe_payload_mask;
  assign io_pipelinedMemoryBus_rsp_valid = pipelinedMemoryBusStage_rsp_regNext_valid;
  assign io_pipelinedMemoryBus_rsp_payload_data = pipelinedMemoryBusStage_rsp_regNext_payload_data;
  always @ (*) begin
    pipelinedMemoryBusStage_cmd_ready = 1'b0;
    if(! _zz_PipelinedMemoryBusToApbBridge_1_) begin
      if(io_apb_PREADY)begin
        pipelinedMemoryBusStage_cmd_ready = 1'b1;
      end
    end
  end

  assign io_apb_PSEL[0] = pipelinedMemoryBusStage_cmd_valid;
  assign io_apb_PENABLE = state;
  assign io_apb_PWRITE = pipelinedMemoryBusStage_cmd_payload_write;
  assign io_apb_PADDR = pipelinedMemoryBusStage_cmd_payload_address[19:0];
  assign io_apb_PWDATA = pipelinedMemoryBusStage_cmd_payload_data;
  always @ (*) begin
    pipelinedMemoryBusStage_rsp_valid = 1'b0;
    if(! _zz_PipelinedMemoryBusToApbBridge_1_) begin
      if(io_apb_PREADY)begin
        pipelinedMemoryBusStage_rsp_valid = (! pipelinedMemoryBusStage_cmd_payload_write);
      end
    end
  end

  assign pipelinedMemoryBusStage_rsp_payload_data = io_apb_PRDATA;
  always @ (posedge clk or posedge reset) begin
    if (reset) begin
      io_pipelinedMemoryBus_cmd_halfPipe_regs_valid <= 1'b0;
      io_pipelinedMemoryBus_cmd_halfPipe_regs_ready <= 1'b1;
      pipelinedMemoryBusStage_rsp_regNext_valid <= 1'b0;
      state <= 1'b0;
    end else begin
      if(_zz_PipelinedMemoryBusToApbBridge_2_)begin
        io_pipelinedMemoryBus_cmd_halfPipe_regs_valid <= io_pipelinedMemoryBus_cmd_valid;
        io_pipelinedMemoryBus_cmd_halfPipe_regs_ready <= (! io_pipelinedMemoryBus_cmd_valid);
      end else begin
        io_pipelinedMemoryBus_cmd_halfPipe_regs_valid <= (! io_pipelinedMemoryBus_cmd_halfPipe_ready);
        io_pipelinedMemoryBus_cmd_halfPipe_regs_ready <= io_pipelinedMemoryBus_cmd_halfPipe_ready;
      end
      pipelinedMemoryBusStage_rsp_regNext_valid <= pipelinedMemoryBusStage_rsp_valid;
      if(_zz_PipelinedMemoryBusToApbBridge_1_)begin
        state <= pipelinedMemoryBusStage_cmd_valid;
      end else begin
        if(io_apb_PREADY)begin
          state <= 1'b0;
        end
      end
    end
  end

  always @ (posedge clk) begin
    if(_zz_PipelinedMemoryBusToApbBridge_2_)begin
      io_pipelinedMemoryBus_cmd_halfPipe_regs_payload_write <= io_pipelinedMemoryBus_cmd_payload_write;
      io_pipelinedMemoryBus_cmd_halfPipe_regs_payload_address <= io_pipelinedMemoryBus_cmd_payload_address;
      io_pipelinedMemoryBus_cmd_halfPipe_regs_payload_data <= io_pipelinedMemoryBus_cmd_payload_data;
      io_pipelinedMemoryBus_cmd_halfPipe_regs_payload_mask <= io_pipelinedMemoryBus_cmd_payload_mask;
    end
    pipelinedMemoryBusStage_rsp_regNext_payload_data <= pipelinedMemoryBusStage_rsp_payload_data;
  end

endmodule

module CpuComplex (
      output [19:0] io_apb_PADDR,
      output [0:0] io_apb_PSEL,
      output  io_apb_PENABLE,
      input   io_apb_PREADY,
      output  io_apb_PWRITE,
      output [31:0] io_apb_PWDATA,
      input  [31:0] io_apb_PRDATA,
      input   io_apb_PSLVERROR,
      input   io_externalInterrupt,
      input   io_timerInterrupt,
      input   clk,
      input   reset);
  wire  _zz_CpuComplex_3_;
  reg  _zz_CpuComplex_4_;
  reg  _zz_CpuComplex_5_;
  reg [31:0] _zz_CpuComplex_6_;
  wire  mainBusArbiter_io_iBus_cmd_ready;
  wire  mainBusArbiter_io_iBus_rsp_valid;
  wire  mainBusArbiter_io_iBus_rsp_payload_error;
  wire [31:0] mainBusArbiter_io_iBus_rsp_payload_inst;
  wire  mainBusArbiter_io_dBus_cmd_ready;
  wire  mainBusArbiter_io_dBus_rsp_ready;
  wire  mainBusArbiter_io_dBus_rsp_error;
  wire [31:0] mainBusArbiter_io_dBus_rsp_data;
  wire  mainBusArbiter_io_masterBus_cmd_valid;
  wire  mainBusArbiter_io_masterBus_cmd_payload_write;
  wire [31:0] mainBusArbiter_io_masterBus_cmd_payload_address;
  wire [31:0] mainBusArbiter_io_masterBus_cmd_payload_data;
  wire [3:0] mainBusArbiter_io_masterBus_cmd_payload_mask;
  wire  cpu_iBus_cmd_valid;
  wire [31:0] cpu_iBus_cmd_payload_pc;
  wire  cpu_dBus_cmd_valid;
  wire  cpu_dBus_cmd_payload_wr;
  wire [31:0] cpu_dBus_cmd_payload_address;
  wire [31:0] cpu_dBus_cmd_payload_data;
  wire [1:0] cpu_dBus_cmd_payload_size;
  wire  ram_io_bus_cmd_ready;
  wire  ram_io_bus_rsp_valid;
  wire [31:0] ram_io_bus_rsp_payload_data;
  wire  apbBridge_io_pipelinedMemoryBus_cmd_ready;
  wire  apbBridge_io_pipelinedMemoryBus_rsp_valid;
  wire [31:0] apbBridge_io_pipelinedMemoryBus_rsp_payload_data;
  wire [19:0] apbBridge_io_apb_PADDR;
  wire [0:0] apbBridge_io_apb_PSEL;
  wire  apbBridge_io_apb_PENABLE;
  wire  apbBridge_io_apb_PWRITE;
  wire [31:0] apbBridge_io_apb_PWDATA;
  wire  _zz_CpuComplex_7_;
  wire  _zz_CpuComplex_8_;
  wire  cpu_dBus_cmd_halfPipe_valid;
  wire  cpu_dBus_cmd_halfPipe_ready;
  wire  cpu_dBus_cmd_halfPipe_payload_wr;
  wire [31:0] cpu_dBus_cmd_halfPipe_payload_address;
  wire [31:0] cpu_dBus_cmd_halfPipe_payload_data;
  wire [1:0] cpu_dBus_cmd_halfPipe_payload_size;
  reg  cpu_dBus_cmd_halfPipe_regs_valid;
  reg  cpu_dBus_cmd_halfPipe_regs_ready;
  reg  cpu_dBus_cmd_halfPipe_regs_payload_wr;
  reg [31:0] cpu_dBus_cmd_halfPipe_regs_payload_address;
  reg [31:0] cpu_dBus_cmd_halfPipe_regs_payload_data;
  reg [1:0] cpu_dBus_cmd_halfPipe_regs_payload_size;
  wire  mainBusDecoder_logic_masterPipelined_cmd_valid;
  reg  mainBusDecoder_logic_masterPipelined_cmd_ready;
  wire  mainBusDecoder_logic_masterPipelined_cmd_payload_write;
  wire [31:0] mainBusDecoder_logic_masterPipelined_cmd_payload_address;
  wire [31:0] mainBusDecoder_logic_masterPipelined_cmd_payload_data;
  wire [3:0] mainBusDecoder_logic_masterPipelined_cmd_payload_mask;
  wire  mainBusDecoder_logic_masterPipelined_rsp_valid;
  wire [31:0] mainBusDecoder_logic_masterPipelined_rsp_payload_data;
  wire  mainBusDecoder_logic_hits_0;
  wire  _zz_CpuComplex_1_;
  wire  mainBusDecoder_logic_hits_1;
  wire  _zz_CpuComplex_2_;
  wire  mainBusDecoder_logic_noHit;
  reg  mainBusDecoder_logic_rspPending;
  reg  mainBusDecoder_logic_rspNoHit;
  reg [0:0] mainBusDecoder_logic_rspSourceId;
  assign _zz_CpuComplex_7_ = (mainBusDecoder_logic_rspPending && (! mainBusDecoder_logic_masterPipelined_rsp_valid));
  assign _zz_CpuComplex_8_ = (! cpu_dBus_cmd_halfPipe_regs_valid);
  CCMasterArbiter mainBusArbiter ( 
    .io_iBus_cmd_valid(cpu_iBus_cmd_valid),
    .io_iBus_cmd_ready(mainBusArbiter_io_iBus_cmd_ready),
    .io_iBus_cmd_payload_pc(cpu_iBus_cmd_payload_pc),
    .io_iBus_rsp_valid(mainBusArbiter_io_iBus_rsp_valid),
    .io_iBus_rsp_payload_error(mainBusArbiter_io_iBus_rsp_payload_error),
    .io_iBus_rsp_payload_inst(mainBusArbiter_io_iBus_rsp_payload_inst),
    .io_dBus_cmd_valid(cpu_dBus_cmd_halfPipe_valid),
    .io_dBus_cmd_ready(mainBusArbiter_io_dBus_cmd_ready),
    .io_dBus_cmd_payload_wr(cpu_dBus_cmd_halfPipe_payload_wr),
    .io_dBus_cmd_payload_address(cpu_dBus_cmd_halfPipe_payload_address),
    .io_dBus_cmd_payload_data(cpu_dBus_cmd_halfPipe_payload_data),
    .io_dBus_cmd_payload_size(cpu_dBus_cmd_halfPipe_payload_size),
    .io_dBus_rsp_ready(mainBusArbiter_io_dBus_rsp_ready),
    .io_dBus_rsp_error(mainBusArbiter_io_dBus_rsp_error),
    .io_dBus_rsp_data(mainBusArbiter_io_dBus_rsp_data),
    .io_masterBus_cmd_valid(mainBusArbiter_io_masterBus_cmd_valid),
    .io_masterBus_cmd_ready(mainBusDecoder_logic_masterPipelined_cmd_ready),
    .io_masterBus_cmd_payload_write(mainBusArbiter_io_masterBus_cmd_payload_write),
    .io_masterBus_cmd_payload_address(mainBusArbiter_io_masterBus_cmd_payload_address),
    .io_masterBus_cmd_payload_data(mainBusArbiter_io_masterBus_cmd_payload_data),
    .io_masterBus_cmd_payload_mask(mainBusArbiter_io_masterBus_cmd_payload_mask),
    .io_masterBus_rsp_valid(mainBusDecoder_logic_masterPipelined_rsp_valid),
    .io_masterBus_rsp_payload_data(mainBusDecoder_logic_masterPipelined_rsp_payload_data),
    .clk(clk),
    .reset(reset) 
  );
  VexRiscv cpu ( 
    .iBus_cmd_valid(cpu_iBus_cmd_valid),
    .iBus_cmd_ready(mainBusArbiter_io_iBus_cmd_ready),
    .iBus_cmd_payload_pc(cpu_iBus_cmd_payload_pc),
    .iBus_rsp_valid(mainBusArbiter_io_iBus_rsp_valid),
    .iBus_rsp_payload_error(mainBusArbiter_io_iBus_rsp_payload_error),
    .iBus_rsp_payload_inst(mainBusArbiter_io_iBus_rsp_payload_inst),
    .timerInterrupt(io_timerInterrupt),
    .externalInterrupt(io_externalInterrupt),
    .softwareInterrupt(_zz_CpuComplex_3_),
    .dBus_cmd_valid(cpu_dBus_cmd_valid),
    .dBus_cmd_ready(cpu_dBus_cmd_halfPipe_regs_ready),
    .dBus_cmd_payload_wr(cpu_dBus_cmd_payload_wr),
    .dBus_cmd_payload_address(cpu_dBus_cmd_payload_address),
    .dBus_cmd_payload_data(cpu_dBus_cmd_payload_data),
    .dBus_cmd_payload_size(cpu_dBus_cmd_payload_size),
    .dBus_rsp_ready(mainBusArbiter_io_dBus_rsp_ready),
    .dBus_rsp_error(mainBusArbiter_io_dBus_rsp_error),
    .dBus_rsp_data(mainBusArbiter_io_dBus_rsp_data),
    .clk(clk),
    .reset(reset) 
  );
  CCPipelinedMemoryBusRam ram ( 
    .io_bus_cmd_valid(_zz_CpuComplex_4_),
    .io_bus_cmd_ready(ram_io_bus_cmd_ready),
    .io_bus_cmd_payload_write(_zz_CpuComplex_1_),
    .io_bus_cmd_payload_address(mainBusDecoder_logic_masterPipelined_cmd_payload_address),
    .io_bus_cmd_payload_data(mainBusDecoder_logic_masterPipelined_cmd_payload_data),
    .io_bus_cmd_payload_mask(mainBusDecoder_logic_masterPipelined_cmd_payload_mask),
    .io_bus_rsp_valid(ram_io_bus_rsp_valid),
    .io_bus_rsp_payload_data(ram_io_bus_rsp_payload_data),
    .clk(clk),
    .reset(reset) 
  );
  PipelinedMemoryBusToApbBridge apbBridge ( 
    .io_pipelinedMemoryBus_cmd_valid(_zz_CpuComplex_5_),
    .io_pipelinedMemoryBus_cmd_ready(apbBridge_io_pipelinedMemoryBus_cmd_ready),
    .io_pipelinedMemoryBus_cmd_payload_write(_zz_CpuComplex_2_),
    .io_pipelinedMemoryBus_cmd_payload_address(mainBusDecoder_logic_masterPipelined_cmd_payload_address),
    .io_pipelinedMemoryBus_cmd_payload_data(mainBusDecoder_logic_masterPipelined_cmd_payload_data),
    .io_pipelinedMemoryBus_cmd_payload_mask(mainBusDecoder_logic_masterPipelined_cmd_payload_mask),
    .io_pipelinedMemoryBus_rsp_valid(apbBridge_io_pipelinedMemoryBus_rsp_valid),
    .io_pipelinedMemoryBus_rsp_payload_data(apbBridge_io_pipelinedMemoryBus_rsp_payload_data),
    .io_apb_PADDR(apbBridge_io_apb_PADDR),
    .io_apb_PSEL(apbBridge_io_apb_PSEL),
    .io_apb_PENABLE(apbBridge_io_apb_PENABLE),
    .io_apb_PREADY(io_apb_PREADY),
    .io_apb_PWRITE(apbBridge_io_apb_PWRITE),
    .io_apb_PWDATA(apbBridge_io_apb_PWDATA),
    .io_apb_PRDATA(io_apb_PRDATA),
    .io_apb_PSLVERROR(io_apb_PSLVERROR),
    .clk(clk),
    .reset(reset) 
  );
  always @(*) begin
    case(mainBusDecoder_logic_rspSourceId)
      1'b0 : begin
        _zz_CpuComplex_6_ = ram_io_bus_rsp_payload_data;
      end
      default : begin
        _zz_CpuComplex_6_ = apbBridge_io_pipelinedMemoryBus_rsp_payload_data;
      end
    endcase
  end

  assign cpu_dBus_cmd_halfPipe_valid = cpu_dBus_cmd_halfPipe_regs_valid;
  assign cpu_dBus_cmd_halfPipe_payload_wr = cpu_dBus_cmd_halfPipe_regs_payload_wr;
  assign cpu_dBus_cmd_halfPipe_payload_address = cpu_dBus_cmd_halfPipe_regs_payload_address;
  assign cpu_dBus_cmd_halfPipe_payload_data = cpu_dBus_cmd_halfPipe_regs_payload_data;
  assign cpu_dBus_cmd_halfPipe_payload_size = cpu_dBus_cmd_halfPipe_regs_payload_size;
  assign cpu_dBus_cmd_halfPipe_ready = mainBusArbiter_io_dBus_cmd_ready;
  assign io_apb_PADDR = apbBridge_io_apb_PADDR;
  assign io_apb_PSEL = apbBridge_io_apb_PSEL;
  assign io_apb_PENABLE = apbBridge_io_apb_PENABLE;
  assign io_apb_PWRITE = apbBridge_io_apb_PWRITE;
  assign io_apb_PWDATA = apbBridge_io_apb_PWDATA;
  assign mainBusDecoder_logic_masterPipelined_cmd_valid = mainBusArbiter_io_masterBus_cmd_valid;
  assign mainBusDecoder_logic_masterPipelined_cmd_payload_write = mainBusArbiter_io_masterBus_cmd_payload_write;
  assign mainBusDecoder_logic_masterPipelined_cmd_payload_address = mainBusArbiter_io_masterBus_cmd_payload_address;
  assign mainBusDecoder_logic_masterPipelined_cmd_payload_data = mainBusArbiter_io_masterBus_cmd_payload_data;
  assign mainBusDecoder_logic_masterPipelined_cmd_payload_mask = mainBusArbiter_io_masterBus_cmd_payload_mask;
  assign mainBusDecoder_logic_hits_0 = ((mainBusDecoder_logic_masterPipelined_cmd_payload_address & (~ (32'b00000000000000000001111111111111))) == (32'b00000000000000000000000000000000));
  always @ (*) begin
    _zz_CpuComplex_4_ = (mainBusDecoder_logic_masterPipelined_cmd_valid && mainBusDecoder_logic_hits_0);
    if(_zz_CpuComplex_7_)begin
      _zz_CpuComplex_4_ = 1'b0;
    end
  end

  assign _zz_CpuComplex_1_ = mainBusDecoder_logic_masterPipelined_cmd_payload_write;
  assign mainBusDecoder_logic_hits_1 = ((mainBusDecoder_logic_masterPipelined_cmd_payload_address & (~ (32'b00000000000011111111111111111111))) == (32'b10000000000000000000000000000000));
  always @ (*) begin
    _zz_CpuComplex_5_ = (mainBusDecoder_logic_masterPipelined_cmd_valid && mainBusDecoder_logic_hits_1);
    if(_zz_CpuComplex_7_)begin
      _zz_CpuComplex_5_ = 1'b0;
    end
  end

  assign _zz_CpuComplex_2_ = mainBusDecoder_logic_masterPipelined_cmd_payload_write;
  assign mainBusDecoder_logic_noHit = (! ({mainBusDecoder_logic_hits_1,mainBusDecoder_logic_hits_0} != (2'b00)));
  always @ (*) begin
    mainBusDecoder_logic_masterPipelined_cmd_ready = (({(mainBusDecoder_logic_hits_1 && apbBridge_io_pipelinedMemoryBus_cmd_ready),(mainBusDecoder_logic_hits_0 && ram_io_bus_cmd_ready)} != (2'b00)) || mainBusDecoder_logic_noHit);
    if(_zz_CpuComplex_7_)begin
      mainBusDecoder_logic_masterPipelined_cmd_ready = 1'b0;
    end
  end

  assign mainBusDecoder_logic_masterPipelined_rsp_valid = (({apbBridge_io_pipelinedMemoryBus_rsp_valid,ram_io_bus_rsp_valid} != (2'b00)) || (mainBusDecoder_logic_rspPending && mainBusDecoder_logic_rspNoHit));
  assign mainBusDecoder_logic_masterPipelined_rsp_payload_data = _zz_CpuComplex_6_;
  assign _zz_CpuComplex_3_ = 1'b0;
  always @ (posedge clk or posedge reset) begin
    if (reset) begin
      cpu_dBus_cmd_halfPipe_regs_valid <= 1'b0;
      cpu_dBus_cmd_halfPipe_regs_ready <= 1'b1;
      mainBusDecoder_logic_rspPending <= 1'b0;
      mainBusDecoder_logic_rspNoHit <= 1'b0;
    end else begin
      if(_zz_CpuComplex_8_)begin
        cpu_dBus_cmd_halfPipe_regs_valid <= cpu_dBus_cmd_valid;
        cpu_dBus_cmd_halfPipe_regs_ready <= (! cpu_dBus_cmd_valid);
      end else begin
        cpu_dBus_cmd_halfPipe_regs_valid <= (! cpu_dBus_cmd_halfPipe_ready);
        cpu_dBus_cmd_halfPipe_regs_ready <= cpu_dBus_cmd_halfPipe_ready;
      end
      if(mainBusDecoder_logic_masterPipelined_rsp_valid)begin
        mainBusDecoder_logic_rspPending <= 1'b0;
      end
      if(((mainBusDecoder_logic_masterPipelined_cmd_valid && mainBusDecoder_logic_masterPipelined_cmd_ready) && (! mainBusDecoder_logic_masterPipelined_cmd_payload_write)))begin
        mainBusDecoder_logic_rspPending <= 1'b1;
      end
      mainBusDecoder_logic_rspNoHit <= 1'b0;
      if(mainBusDecoder_logic_noHit)begin
        mainBusDecoder_logic_rspNoHit <= 1'b1;
      end
    end
  end

  always @ (posedge clk) begin
    if(_zz_CpuComplex_8_)begin
      cpu_dBus_cmd_halfPipe_regs_payload_wr <= cpu_dBus_cmd_payload_wr;
      cpu_dBus_cmd_halfPipe_regs_payload_address <= cpu_dBus_cmd_payload_address;
      cpu_dBus_cmd_halfPipe_regs_payload_data <= cpu_dBus_cmd_payload_data;
      cpu_dBus_cmd_halfPipe_regs_payload_size <= cpu_dBus_cmd_payload_size;
    end
    if((mainBusDecoder_logic_masterPipelined_cmd_valid && mainBusDecoder_logic_masterPipelined_cmd_ready))begin
      mainBusDecoder_logic_rspSourceId <= mainBusDecoder_logic_hits_1;
    end
  end

endmodule


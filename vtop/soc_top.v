module soc_top#(
    parameter DATA_WIDTH = 32,
    parameter ADDR_WIDTH = 32,
    parameter ID_WIDTH   = 1
)
(
    clk,
    nrst
);

// parameters
localparam STRB_WIDTH = DATA_WIDTH / 8;

//signal
input clk, nrst;
wire rst;
assign rst = !nrst;

// core Inputs
wire           axi_i_awready_i;
wire           axi_i_wready_i;
wire           axi_i_bvalid_i;
wire  [  1:0]  axi_i_bresp_i;
wire  [  3:0]  axi_i_bid_i;
wire           axi_i_arready_i;
wire           axi_i_rvalid_i;
wire  [ 31:0]  axi_i_rdata_i;
wire  [  1:0]  axi_i_rresp_i;
wire  [  3:0]  axi_i_rid_i;
wire           axi_i_rlast_i;
wire           axi_t_awvalid_i;
wire  [ 31:0]  axi_t_awaddr_i;
wire  [  3:0]  axi_t_awid_i;
wire  [  7:0]  axi_t_awlen_i;
wire  [  1:0]  axi_t_awburst_i;
wire           axi_t_wvalid_i;
wire  [ 31:0]  axi_t_wdata_i;
wire  [  3:0]  axi_t_wstrb_i;
wire           axi_t_wlast_i;
wire           axi_t_bready_i;
wire           axi_t_arvalid_i;
wire  [ 31:0]  axi_t_araddr_i;
wire  [  3:0]  axi_t_arid_i;
wire  [  7:0]  axi_t_arlen_i;
wire  [  1:0]  axi_t_arburst_i;
wire           axi_t_rready_i;
wire  [ 31:0]  intr_i;

// core Outputs
wire          axi_i_awvalid_o;
wire [ 31:0]  axi_i_awaddr_o;
wire [  3:0]  axi_i_awid_o;
wire [  7:0]  axi_i_awlen_o;
wire [  1:0]  axi_i_awburst_o;
wire          axi_i_wvalid_o;
wire [ 31:0]  axi_i_wdata_o;
wire [  3:0]  axi_i_wstrb_o;
wire          axi_i_wlast_o;
wire          axi_i_bready_o;
wire          axi_i_arvalid_o;
wire [ 31:0]  axi_i_araddr_o;
wire [  3:0]  axi_i_arid_o;
wire [  7:0]  axi_i_arlen_o;
wire [  1:0]  axi_i_arburst_o;
wire          axi_i_rready_o;
wire          axi_t_awready_o;
wire          axi_t_wready_o;
wire          axi_t_bvalid_o;
wire [  1:0]  axi_t_bresp_o;
wire [  3:0]  axi_t_bid_o;
wire          axi_t_arready_o;
wire          axi_t_rvalid_o;
wire [ 31:0]  axi_t_rdata_o;
wire [  1:0]  axi_t_rresp_o;
wire [  3:0]  axi_t_rid_o;
wire          axi_t_rlast_o;



// i_ram0 
wire [ID_WIDTH-1:0]    s00_axi_awid;
wire [ADDR_WIDTH-1:0]  s00_axi_awaddr;
wire [7:0]             s00_axi_awlen;
wire [2:0]             s00_axi_awsize;
wire [1:0]             s00_axi_awburst;
wire                   s00_axi_awlock;
wire [3:0]             s00_axi_awcache;
wire [2:0]             s00_axi_awprot;
wire                   s00_axi_awvalid;
wire                   s00_axi_awready;
wire [DATA_WIDTH-1:0]  s00_axi_wdata;
wire [STRB_WIDTH-1:0]  s00_axi_wstrb;
wire                   s00_axi_wlast;
wire                   s00_axi_wvalid;
wire                   s00_axi_wready;
wire [ID_WIDTH-1:0]    s00_axi_bid;
wire [1:0]             s00_axi_bresp;
wire                   s00_axi_bvalid;
wire                   s00_axi_bready;
wire [ID_WIDTH-1:0]    s00_axi_arid;
wire [ADDR_WIDTH-1:0]  s00_axi_araddr;
wire [7:0]             s00_axi_arlen;
wire [2:0]             s00_axi_arsize;
wire [1:0]             s00_axi_arburst;
wire                   s00_axi_arlock;
wire [3:0]             s00_axi_arcache;
wire [2:0]             s00_axi_arprot;
wire                   s00_axi_arvalid;
wire                   s00_axi_arready;
wire [ID_WIDTH-1:0]    s00_axi_rid;
wire [DATA_WIDTH-1:0]  s00_axi_rdata;
wire [1:0]             s00_axi_rresp;
wire                   s00_axi_rlast;
wire                   s00_axi_rvalid;
wire                   s00_axi_rready;

// d_ram0 
wire [ID_WIDTH-1:0]    s01_axi_awid;
wire [ADDR_WIDTH-1:0]  s01_axi_awaddr;
wire [7:0]             s01_axi_awlen;
wire [2:0]             s01_axi_awsize;
wire [1:0]             s01_axi_awburst;
wire                   s01_axi_awlock;
wire [3:0]             s01_axi_awcache;
wire [2:0]             s01_axi_awprot;
wire                   s01_axi_awvalid;
wire                   s01_axi_awready;
wire [DATA_WIDTH-1:0]  s01_axi_wdata;
wire [STRB_WIDTH-1:0]  s01_axi_wstrb;
wire                   s01_axi_wlast;
wire                   s01_axi_wvalid;
wire                   s01_axi_wready;
wire [ID_WIDTH-1:0]    s01_axi_bid;
wire [1:0]             s01_axi_bresp;
wire                   s01_axi_bvalid;
wire                   s01_axi_bready;
wire [ID_WIDTH-1:0]    s01_axi_arid;
wire [ADDR_WIDTH-1:0]  s01_axi_araddr;
wire [7:0]             s01_axi_arlen;
wire [2:0]             s01_axi_arsize;
wire [1:0]             s01_axi_arburst;
wire                   s01_axi_arlock;
wire [3:0]             s01_axi_arcache;
wire [2:0]             s01_axi_arprot;
wire                   s01_axi_arvalid;
wire                   s01_axi_arready;
wire [ID_WIDTH-1:0]    s01_axi_rid;
wire [DATA_WIDTH-1:0]  s01_axi_rdata;
wire [1:0]             s01_axi_rresp;
wire                   s01_axi_rlast;
wire                   s01_axi_rvalid;
wire                   s01_axi_rready;


riscv_tcm_wrapper #(
    .BOOT_VECTOR        (0),
    .CORE_ID            (0),
    .TCM_MEM_BASE       (0),
    .MEM_CACHE_ADDR_MIN (0),
    .MEM_CACHE_ADDR_MAX (32'hffffffff)
) soc0 (
    // Inputs
     .clk_i(clk),
     .rst_i(rst),
     .rst_cpu_i(rst),
     .axi_i_awready_i(axi_i_awready_i),
     .axi_i_wready_i(axi_i_wready_i),
     .axi_i_bvalid_i(axi_i_bvalid_i),
     .axi_i_bresp_i(axi_i_bresp_i),
     .axi_i_bid_i(axi_i_bid_i),
     .axi_i_arready_i(axi_i_arready_i),
     .axi_i_rvalid_i(axi_i_rvalid_i),
     .axi_i_rdata_i(axi_i_rdata_i),
     .axi_i_rresp_i(axi_i_rresp_i),
     .axi_i_rid_i(axi_i_rid_i),
     .axi_i_rlast_i(axi_i_rlast_i),
     .axi_t_awvalid_i(axi_t_awvalid_i),
     .axi_t_awaddr_i(axi_t_awaddr_i),
     .axi_t_awid_i(axi_t_awid_i),
     .axi_t_awlen_i(axi_t_awlen_i),
     .axi_t_awburst_i(axi_t_awburst_i),
     .axi_t_wvalid_i(axi_t_wvalid_i),
     .axi_t_wdata_i(axi_t_wdata_i),
     .axi_t_wstrb_i(axi_t_wstrb_i),
     .axi_t_wlast_i(axi_t_wlast_i),
     .axi_t_bready_i(axi_t_bready_i),
     .axi_t_arvalid_i(axi_t_arvalid_i),
     .axi_t_araddr_i(axi_t_araddr_i),
     .axi_t_arid_i(axi_t_arid_i),
     .axi_t_arlen_i(axi_t_arlen_i),
     .axi_t_arburst_i(axi_t_arburst_i),
     .axi_t_rready_i(axi_t_rready_i),
     .intr_i(32'd0),

    //  outputs
     .axi_i_awvalid_o(axi_i_awvalid_o),
     .axi_i_awaddr_o(axi_i_awaddr_o),
     .axi_i_awid_o(axi_i_awid_o),
     .axi_i_awlen_o(axi_i_awlen_o),
     .axi_i_awburst_o(axi_i_awburst_o),
     .axi_i_wvalid_o(axi_i_wvalid_o),
     .axi_i_wdata_o(axi_i_wdata_o),
     .axi_i_wstrb_o(axi_i_wstrb_o),
     .axi_i_wlast_o(axi_i_wlast_o),
     .axi_i_bready_o(axi_i_bready_o),
     .axi_i_arvalid_o(axi_i_arvalid_o),
     .axi_i_araddr_o(axi_i_araddr_o),
     .axi_i_arid_o(axi_i_arid_o),
     .axi_i_arlen_o(axi_i_arlen_o),
     .axi_i_arburst_o(axi_i_arburst_o),
     .axi_i_rready_o(axi_i_rready_o),
     .axi_t_awready_o(axi_t_awready_o),
     .axi_t_wready_o(axi_t_wready_o),
     .axi_t_bvalid_o(axi_t_bvalid_o),
     .axi_t_bresp_o(axi_t_bresp_o),
     .axi_t_bid_o(axi_t_bid_o),
     .axi_t_arready_o(axi_t_arready_o),
     .axi_t_rvalid_o(axi_t_rvalid_o),
     .axi_t_rdata_o(axi_t_rdata_o),
     .axi_t_rresp_o(axi_t_rresp_o),
     .axi_t_rid_o(axi_t_rid_o),
     .axi_t_rlast_o(axi_t_rlast_o)
);

axi_s2m2_interconnect #
(
    .DATA_WIDTH(DATA_WIDTH),
    .ADDR_WIDTH(ADDR_WIDTH),
    .STRB_WIDTH(DATA_WIDTH/8),
    .ID_WIDTH(1),
    .AWUSER_ENABLE(0),
    .AWUSER_WIDTH(1),
    .WUSER_ENABLE(0),
    .WUSER_WIDTH(1),
    .BUSER_ENABLE(0),
    .BUSER_WIDTH(1),
    .ARUSER_ENABLE(0),
    .ARUSER_WIDTH(1),
    .RUSER_ENABLE(0),
    .RUSER_WIDTH(1),
    .FORWARD_ID(0),
    .M_REGIONS(1),
    .M00_BASE_ADDR(0),
    .M00_ADDR_WIDTH(32/*{M_REGIONS{32'd24}}*/),
    .M00_CONNECT_READ(2'b11),
    .M00_CONNECT_WRITE(2'b11),
    .M00_SECURE(1'b0),
    .M01_BASE_ADDR(0),
    .M01_ADDR_WIDTH(32/*{M_REGIONS{32'd24}}*/),
    .M01_CONNECT_READ(2'b11),
    .M01_CONNECT_WRITE(2'b11),
    .M01_SECURE(1'b0)
) axi_s2m2_interconnect (
    .clk(clk),
    .rst(rst),
    /* AXI slave interface */
    .s00_axi_awid(axi_i_awid_o),
    .s00_axi_awaddr(axi_i_awaddr_o),
    .s00_axi_awlen(axi_i_awlen_o),
    .s00_axi_awsize(3'b010),    //32 bits width
    .s00_axi_awburst(axi_i_awburst_o),
    .s00_axi_awlock(0),
    .s00_axi_awcache(0),
    .s00_axi_awprot(0),
    .s00_axi_awqos(0),
    .s00_axi_awuser(0),
    .s00_axi_awvalid(axi_i_awvalid_o),
    .s00_axi_awready(axi_i_awready_i),
    .s00_axi_wdata(axi_i_wdata_o),
    .s00_axi_wstrb(axi_i_wstrb_o),
    .s00_axi_wlast(axi_i_wlast_o),
    .s00_axi_wuser(0),
    .s00_axi_wvalid(axi_i_wvalid_o),
    .s00_axi_wready(axi_i_wready_i),
    .s00_axi_bid(axi_i_bid_i),
    .s00_axi_bresp(axi_i_bresp_i),
    .s00_axi_buser(),
    .s00_axi_bvalid(axi_i_bvalid_i),
    .s00_axi_bready(axi_i_bready_o),
    .s00_axi_arid(axi_i_arid_o),
    .s00_axi_araddr(axi_i_araddr_o),
    .s00_axi_arlen(axi_i_arlen_o),
    .s00_axi_arsize(3'b010),
    .s00_axi_arburst(axi_i_araddr_o),
    .s00_axi_arlock(0),
    .s00_axi_arcache(0),
    .s00_axi_arprot(0),
    .s00_axi_arqos(0),
    .s00_axi_aruser(0),
    .s00_axi_arvalid(axi_i_arvalid_o),
    .s00_axi_arready(axi_i_arready_i),
    .s00_axi_rid(axi_i_rid_i),
    .s00_axi_rdata(axi_i_rdata_i),
    .s00_axi_rresp(axi_i_rresp_i),
    .s00_axi_rlast(axi_i_rlast_i),
    .s00_axi_ruser(),
    .s00_axi_rvalid(axi_i_rvalid_i),
    .s00_axi_rready(axi_i_rready_o),

    .s01_axi_awid(axi_t_awid_i),
    .s01_axi_awaddr(axi_t_awaddr_i),
    .s01_axi_awlen(axi_t_awlen_i),
    .s01_axi_awsize(3'b010),    //32 bits width
    .s01_axi_awburst(axi_t_awburst_i),
    .s01_axi_awlock(0),
    .s01_axi_awcache(0),
    .s01_axi_awprot(0),
    .s01_axi_awqos(0),
    .s01_axi_awuser(0),
    .s01_axi_awvalid(axi_t_awvalid_i),
    .s01_axi_awready(axi_t_awready_o),
    .s01_axi_wdata(axi_t_wdata_i),
    .s01_axi_wstrb(axi_t_wstrb_i),
    .s01_axi_wlast(axi_t_wlast_i),
    .s01_axi_wuser(0),
    .s01_axi_wvalid(axi_t_wvalid_i),
    .s01_axi_wready(axi_t_wready_o),
    .s01_axi_bid(axi_t_bid_o),
    .s01_axi_bresp(axi_t_bresp_o),
    .s01_axi_buser(),
    .s01_axi_bvalid(axi_t_bvalid_o),
    .s01_axi_bready(axi_t_bready_i),
    .s01_axi_arid(axi_t_arid_i),
    .s01_axi_araddr(axi_t_araddr_i),
    .s01_axi_arlen(axi_t_arlen_i),
    .s01_axi_arsize(3'b010),
    .s01_axi_arburst(axi_t_arburst_i),
    .s01_axi_arlock(0),
    .s01_axi_arcache(0),
    .s01_axi_arprot(0),
    .s01_axi_arqos(0),
    .s01_axi_aruser(0),
    .s01_axi_arvalid(axi_t_arvalid_i),
    .s01_axi_arready(axi_t_arready_o),
    .s01_axi_rid(axi_t_rid_o),
    .s01_axi_rdata(axi_t_rdata_o),
    .s01_axi_rresp(axi_t_rresp_o),
    .s01_axi_rlast(axi_t_rlast_o),
    .s01_axi_ruser(axi_t_ruser_o),
    .s01_axi_rvalid(axi_t_rvalid_o),
    .s01_axi_rready(axi_t_rready_i),

    /* AXI master interface */
    .m00_axi_awid(s00_axi_awid),
    .m00_axi_awaddr(s00_axi_awaddr),
    .m00_axi_awlen(s00_axi_awlen),
    .m00_axi_awsize(),    //32 bits width
    .m00_axi_awburst(s00_axi_awburst),
    .m00_axi_awlock(),
    .m00_axi_awcache(),
    .m00_axi_awprot(),
    .m00_axi_awqos(),
    .m00_axi_awregion(),
    .m00_axi_awuser(),
    .m00_axi_awvalid(s00_axi_awvalid),
    .m00_axi_awready(s00_axi_awready),
    .m00_axi_wdata(s00_axi_wdata),
    .m00_axi_wstrb(s00_axi_wstrb),
    .m00_axi_wlast(s00_axi_wlast),
    .m00_axi_wuser(),
    .m00_axi_wvalid(s00_axi_wvalid),
    .m00_axi_wready(s00_axi_wready),
    .m00_axi_bid(0),
    .m00_axi_bresp(s00_axi_bresp),
    .m00_axi_buser(),
    .m00_axi_bvalid(s00_axi_bvalid),
    .m00_axi_bready(s00_axi_bready),
    .m00_axi_arid(s00_axi_arid),
    .m00_axi_araddr(s00_axi_araddr),
    .m00_axi_arlen(s00_axi_arlen),
    .m00_axi_arsize(),
    .m00_axi_arburst(s00_axi_arburst),
    .m00_axi_arlock(),
    .m00_axi_arcache(),
    .m00_axi_arprot(),
    .m00_axi_arqos(),
    .m00_axi_arregion(),
    .m00_axi_aruser(),
    .m00_axi_arvalid(s00_axi_arvalid),
    .m00_axi_arready(s00_axi_arready),
    .m00_axi_rid(s00_axi_rid),
    .m00_axi_rdata(s00_axi_rdata),
    .m00_axi_rresp(s00_axi_rresp),
    .m00_axi_rlast(s00_axi_rlast),
    .m00_axi_ruser(0),
    .m00_axi_rvalid(s00_axi_rvalid),
    .m00_axi_rready(s00_axi_rready),

    .m01_axi_awid(s01_axi_awid),
    .m01_axi_awaddr(s01_axi_awaddr),
    .m01_axi_awlen(s01_axi_awlen),
    .m01_axi_awsize(),
    .m01_axi_awburst(s01_axi_awburst),
    .m01_axi_awlock(),
    .m01_axi_awcache(),
    .m01_axi_awprot(),
    .m01_axi_awqos(),
    .m01_axi_awregion(),
    .m01_axi_awuser(),
    .m01_axi_awvalid(s01_axi_awvalid),
    .m01_axi_awready(s01_axi_awready),
    .m01_axi_wdata(s01_axi_wdata),
    .m01_axi_wstrb(s01_axi_wstrb),
    .m01_axi_wlast(s01_axi_wlast),
    .m01_axi_wuser(),
    .m01_axi_wvalid(s01_axi_wvalid),
    .m01_axi_wready(s01_axi_wready),
    .m01_axi_bid(0),
    .m01_axi_bresp(s01_axi_bresp),
    .m01_axi_buser(),
    .m01_axi_bvalid(s01_axi_bvalid),
    .m01_axi_bready(s01_axi_bready),
    .m01_axi_arid(s01_axi_arid),
    .m01_axi_araddr(s01_axi_araddr),
    .m01_axi_arlen(s01_axi_arlen),
    .m01_axi_arsize(),
    .m01_axi_arburst(s01_axi_arburst),
    .m01_axi_arlock(),
    .m01_axi_arcache(),
    .m01_axi_arprot(),
    .m01_axi_arqos(),
    .m01_axi_arregion(),
    .m01_axi_aruser(),
    .m01_axi_arvalid(s01_axi_arvalid),
    .m01_axi_arready(s01_axi_arready),
    .m01_axi_rid(s01_axi_rid),
    .m01_axi_rdata(s01_axi_rdata),
    .m01_axi_rresp(s01_axi_rresp),
    .m01_axi_rlast(s01_axi_rlast),
    .m01_axi_ruser(0),
    .m01_axi_rvalid(s01_axi_rvalid),
    .m01_axi_rready(s01_axi_rready)
);


axi_ram #
(
    // Width of data bus in bits
    .DATA_WIDTH(DATA_WIDTH),
    // Width of address bus in bits
    .ADDR_WIDTH(ADDR_WIDTH),
    // Width of wstrb (width of data bus in words)
    .STRB_WIDTH((STRB_WIDTH)),
    // Width of ID signal
    .ID_WIDTH(ID_WIDTH),
    // Extra pipeline register on output
    .PIPELINE_OUTPUT(0)
) i_ram (
    .clk(clk),
    .rst(rst),
    .s_axi_awid(s00_axi_awid),
    .s_axi_awaddr(s00_axi_awaddr),
    .s_axi_awlen(s00_axi_awlen),
    .s_axi_awsize(s00_axi_awsize),
    .s_axi_awburst(s00_axi_awburst),
    .s_axi_awlock(s00_axi_awlock),
    .s_axi_awcache(s00_axi_awcache),
    .s_axi_awprot(s00_axi_awprot),
    .s_axi_awvalid(s00_axi_awvalid),
    .s_axi_awready(s00_axi_awready),
    .s_axi_wdata(s00_axi_wdata),
    .s_axi_wstrb(s00_axi_wstrb),
    .s_axi_wlast(s00_axi_wlast),
    .s_axi_wvalid(s00_axi_wvalid),
    .s_axi_wready(s00_axi_wready),
    .s_axi_bid(s00_axi_bid),
    .s_axi_bresp(s00_axi_bresp),
    .s_axi_bvalid(s00_axi_bvalid),
    .s_axi_bready(s00_axi_bready),
    .s_axi_arid(s00_axi_arid),
    .s_axi_araddr(s00_axi_araddr),
    .s_axi_arlen(s00_axi_arlen),
    .s_axi_arsize(s00_axi_arsize),
    .s_axi_arburst(s00_axi_arburst),
    .s_axi_arlock(s00_axi_arlock),
    .s_axi_arcache(s00_axi_arcache),
    .s_axi_arprot(s00_axi_arprot),
    .s_axi_arvalid(s00_axi_arvalid),
    .s_axi_arready(s00_axi_arready),
    .s_axi_rid(s00_axi_rid),
    .s_axi_rdata(s00_axi_rdata),
    .s_axi_rresp(s00_axi_rresp),
    .s_axi_rlast(s00_axi_rlast),
    .s_axi_rvalid(s00_axi_rvalid),
    .s_axi_rready(s00_axi_rready)
);


axi_ram #
(
    // Width of data bus in bits
    .DATA_WIDTH(DATA_WIDTH),
    // Width of address bus in bits
    .ADDR_WIDTH(ADDR_WIDTH),
    // Width of wstrb (width of data bus in words)
    .STRB_WIDTH((STRB_WIDTH)),
    // Width of ID signal
    .ID_WIDTH(ID_WIDTH),
    // Extra pipeline register on output
    .PIPELINE_OUTPUT(0)
) d_ram (
    .clk(clk),
    .rst(rst),
    .s_axi_awid(s01_axi_awid),
    .s_axi_awaddr(s01_axi_awaddr),
    .s_axi_awlen(s01_axi_awlen),
    .s_axi_awsize(s01_axi_awsize),
    .s_axi_awburst(s01_axi_awburst),
    .s_axi_awlock(s01_axi_awlock),
    .s_axi_awcache(s01_axi_awcache),
    .s_axi_awprot(s01_axi_awprot),
    .s_axi_awvalid(s01_axi_awvalid),
    .s_axi_awready(s01_axi_awready),
    .s_axi_wdata(s01_axi_wdata),
    .s_axi_wstrb(s01_axi_wstrb),
    .s_axi_wlast(s01_axi_wlast),
    .s_axi_wvalid(s01_axi_wvalid),
    .s_axi_wready(s01_axi_wready),
    .s_axi_bid(s01_axi_bid),
    .s_axi_bresp(s01_axi_bresp),
    .s_axi_bvalid(s01_axi_bvalid),
    .s_axi_bready(s01_axi_bready),
    .s_axi_arid(s01_axi_arid),
    .s_axi_araddr(s01_axi_araddr),
    .s_axi_arlen(s01_axi_arlen),
    .s_axi_arsize(s01_axi_arsize),
    .s_axi_arburst(s01_axi_arburst),
    .s_axi_arlock(s01_axi_arlock),
    .s_axi_arcache(s01_axi_arcache),
    .s_axi_arprot(s01_axi_arprot),
    .s_axi_arvalid(s01_axi_arvalid),
    .s_axi_arready(s01_axi_arready),
    .s_axi_rid(s01_axi_rid),
    .s_axi_rdata(s01_axi_rdata),
    .s_axi_rresp(s01_axi_rresp),
    .s_axi_rlast(s01_axi_rlast),
    .s_axi_rvalid(s01_axi_rvalid),
    .s_axi_rready(s01_axi_rready)
);

endmodule




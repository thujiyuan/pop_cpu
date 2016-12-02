----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    21:01:41 11/24/2016 
-- Design Name: 
-- Module Name:    pop_cpu - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
library work;
use work.recordDefs.ALL;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity pop_cpu is
	port ( inclk : in std_logic;
			 inrst : in STD_LOGIC;
			 RAM1OE : out  STD_LOGIC;
			 RAM1WE : out  STD_LOGIC;
			 RAM1EN : out  STD_LOGIC;
			 RAM1addr : out  STD_LOGIC_VECTOR (17 downto 0);
			 RAM1data : inout  STD_LOGIC_VECTOR (15 downto 0);
			 outRam2OE : out  STD_LOGIC;
			 outRam2WE : out  STD_LOGIC;
			 outRam2EN : out  STD_LOGIC;
			 outRam2Addr : out STD_LOGIC_VECTOR(17 downto 0);
			 outRam2Data : inout STD_LOGIC_VECTOR(15 downto 0);
			 dataReady : in STD_LOGIC;
			 tsre : in STD_LOGIC;
			 tbre : in STD_LOGIC;
			 outrdn : out STD_LOGIC;
			 outwdn : out STD_LOGIC;
			 ins : out std_logic_vector(15 downto 0);
			 l7 : out std_logic_vector(6 downto 0);
			 r7 : out std_logic_vector(6 downto 0);
			 Hs : out std_logic;
			 Vs : out std_logic;
			 Rout : out std_logic_vector(2 downto 0);
			 Gout : out std_logic_vector(2 downto 0);
			 Bout : out std_logic_vector(2 downto 0));
end pop_cpu;

architecture Behavioral of pop_cpu is
	component PC
		Port(	clk : in STD_LOGIC;
				rwPause : in STD_LOGIC;
				passerPause: in STD_LOGIC;
				PCin: in STD_LOGIC_VECTOR(15 downto 0);
				PCout: out STD_LOGIC_VECTOR(15 downto 0));
	end component;
	component InsFetcher
		Port(	Ram2OE : out  STD_LOGIC;
				Ram2WE : out  STD_LOGIC;
				Ram2EN : out  STD_LOGIC;
				Ram2Addr : out STD_LOGIC_VECTOR(17 downto 0);
				Ram2Data : inout STD_LOGIC_VECTOR(15 downto 0);
			
				ins : out STD_LOGIC_VECTOR(15 downto 0);
				addr : in STD_LOGIC_VECTOR(15 downto 0);
				MEMAddr : in STD_LOGIC_VECTOR(17 downto 0);
				MEMReadData : out STD_LOGIC_VECTOR(15 downto 0);
				MEMWriteData : in STD_LOGIC_VECTOR(15 downto 0);
				MEMRead : in STD_LOGIC;
				MEMWrite : in STD_LOGIC;
				clk : in STD_LOGIC);
	end component;
	component PCAdder
		Port(	PCin: in STD_LOGIC_VECTOR(15 downto 0);
			PCout: out STD_LOGIC_VECTOR(15 downto 0));
	end component;
	component PCSelector
		Port(	PC_1: in STD_LOGIC_VECTOR(15 downto 0);
				branchResult: in STD_LOGIC_VECTOR(15 downto 0);
				regResult: in STD_LOGIC_VECTOR(15 downto 0);
				ctrl: in STD_LOGIC_VECTOR(1 downto 0);
				PCout: out STD_LOGIC_VECTOR(15 downto 0));
	end component;
	
	component IF_IDRegs
		port( inPC : in STD_LOGIC_VECTOR (15 downto 0);
				inInst : in STD_LOGIC_VECTOR (15 downto 0);
				clk : in  STD_LOGIC;
				pause : in STD_LOGIC;
				clear : in STD_LOGIC;
				outInst : out STD_LOGIC_VECTOR (15 downto 0);
				outPC : out STD_LOGIC_VECTOR (15 downto 0);
				outRxNum : out STD_LOGIC_VECTOR (2 downto 0);
				outRyNum : out STD_LOGIC_VECTOR (2 downto 0));
	end component;
	
	component Registers
		Port ( readRegister1 : in  STD_LOGIC_VECTOR (2 downto 0);
           readRegister2 : in  STD_LOGIC_VECTOR (2 downto 0);
           writeRegister : in  STD_LOGIC_VECTOR (3 downto 0);
           writeData : in  STD_LOGIC_VECTOR (15 downto 0);
           regWrite : in  STD_LOGIC;
           rx : out  STD_LOGIC_VECTOR (15 downto 0);
           ry : out  STD_LOGIC_VECTOR (15 downto 0);
           T : out  STD_LOGIC_VECTOR (15 downto 0);
           IH : out  STD_LOGIC_VECTOR (15 downto 0);
           SP : out  STD_LOGIC_VECTOR (15 downto 0);
           RA : out  STD_LOGIC_VECTOR (15 downto 0);
			  clk : in STD_LOGIC);
	end component;
	component bypasser
		Port ( inrx : in  STD_LOGIC_VECTOR (15 downto 0);
           inry : in  STD_LOGIC_VECTOR (15 downto 0);
           inT : in  STD_LOGIC_VECTOR (15 downto 0);
           inIH : in  STD_LOGIC_VECTOR (15 downto 0);
           inSP : in  STD_LOGIC_VECTOR (15 downto 0);
			  
		   rxNum : in  STD_LOGIC_VECTOR (2 downto 0);
           ryNum : in  STD_LOGIC_VECTOR (2 downto 0);
           instruction : in  STD_LOGIC_VECTOR (15 downto 0);
			  
           EXERegWrite : in  STD_LOGIC;
           EXEWBDes : in  STD_LOGIC_VECTOR (3 downto 0);
           EXEMemRead : in  STD_LOGIC;
           EXErst : in  STD_LOGIC_VECTOR (15 downto 0);
			  
           MEMRegWrite : in  STD_LOGIC;
           MEMWBDes : in  STD_LOGIC_VECTOR (3 downto 0);
           MEMMemRead : in  STD_LOGIC;
           MEMrst : in  STD_LOGIC_VECTOR (15 downto 0);
			  
           WBRegWrite : in  STD_LOGIC;
           WBWBDes : in  STD_LOGIC_VECTOR (3 downto 0);
           WBwriteData : in  STD_LOGIC_VECTOR (15 downto 0);
			  
           outrx : out  STD_LOGIC_VECTOR (15 downto 0);
           outry : out  STD_LOGIC_VECTOR (15 downto 0);
           outT : out  STD_LOGIC_VECTOR (15 downto 0);
           outIH : out  STD_LOGIC_VECTOR (15 downto 0);
           outSP : out  STD_LOGIC_VECTOR (15 downto 0);
           dataPause : out  STD_LOGIC);
	end component;
	component Control
		Port ( instruction : in  STD_LOGIC_VECTOR (15 downto 0);
				  rx : in  STD_LOGIC_VECTOR (15 downto 0);
				  T : in  STD_LOGIC_VECTOR (15 downto 0);
				  immSel : out  STD_LOGIC_VECTOR (2 downto 0);
				  PCSelCtr : out  STD_LOGIC_VECTOR (1 downto 0);
				  ALUFunc : out  STD_LOGIC_VECTOR (2 downto 0);
				  ALUSrc0 : out  STD_LOGIC_VECTOR (1 downto 0);
				  ALUSrc1 : out  STD_LOGIC_VECTOR (2 downto 0);
				  MEMRead : out  STD_LOGIC;
				  MEMWrite : out  STD_LOGIC;
				  MEMSrc : out  STD_LOGIC_VECTOR (1 downto 0);
				  WBDes : out  STD_LOGIC_VECTOR (3 downto 0);
				  WBSrc : out  STD_LOGIC;
				  RegWrite : out  STD_LOGIC);
	end component;
	component Extender
		Port(	ins : in STD_LOGIC_VECTOR(15 downto 0);
			immSel : in STD_LOGIC_VECTOR(2 downto 0);
			immResult: out STD_LOGIC_VECTOR(15 downto 0));
	end component;
	component AddressAdder
		Port(	PCin: in STD_LOGIC_VECTOR(15 downto 0);
			address: in STD_LOGIC_VECTOR(15 downto 0);
			result: out STD_LOGIC_VECTOR(15 downto 0));
	end component;
	
	component ID_EXERegs
		Port ( inALUFunc : in  STD_LOGIC_VECTOR (2 downto 0);
			  inALUSrc0 : in  STD_LOGIC_VECTOR (1 downto 0);
			  inALUSrc1 : in  STD_LOGIC_VECTOR (2 downto 0);
			  inWBDes : in  STD_LOGIC_VECTOR (3 downto 0);
			  inWBSrc : in  STD_LOGIC;
			  inMEMRead : in  STD_LOGIC;
			  inMEMWrite : in  STD_LOGIC;
			  inMEMSrc : in  STD_LOGIC_VECTOR (1 downto 0);
			  inRegWrite : in  STD_LOGIC;
			  inExtend : in  STD_LOGIC_VECTOR (15 downto 0);
			  inPC : in  STD_LOGIC_VECTOR (15 downto 0);
			  inRx : in  STD_LOGIC_VECTOR (15 downto 0);
			  inRy : in  STD_LOGIC_VECTOR (15 downto 0);
			  inIH : in  STD_LOGIC_VECTOR (15 downto 0);
			  inSP : in  STD_LOGIC_VECTOR (15 downto 0);
			  inRA : in  STD_LOGIC_VECTOR (15 downto 0);
			  clk : in  STD_LOGIC;
			  pause : in STD_LOGIC;
			  clear : in STD_LOGIC;
			  outALUFunc : out  STD_LOGIC_VECTOR (2 downto 0);
			  outALUSrc0 : out  STD_LOGIC_VECTOR (1 downto 0);
			  outALUSrc1 : out  STD_LOGIC_VECTOR (2 downto 0);
			  outWBDes : out  STD_LOGIC_VECTOR (3 downto 0);
			  outWBSrc : out  STD_LOGIC;
			  outMEMRead : out  STD_LOGIC;
			  outMEMWrite : out  STD_LOGIC;
			  outMEMSrc : out  STD_LOGIC_VECTOR (1 downto 0);
			  outRegWrite : out  STD_LOGIC;
			  outExtend : out  STD_LOGIC_VECTOR (15 downto 0);
			  outPC : out  STD_LOGIC_VECTOR (15 downto 0);
			  outRx : out  STD_LOGIC_VECTOR (15 downto 0);
			  outRy : out  STD_LOGIC_VECTOR (15 downto 0);
			  outIH : out  STD_LOGIC_VECTOR (15 downto 0);
			  outSP : out  STD_LOGIC_VECTOR (15 downto 0);
			  outRA : out  STD_LOGIC_VECTOR (15 downto 0));
	end component;
	
	component ALUSrc0MUX
		Port ( rx : in  STD_LOGIC_VECTOR (15 downto 0);
				 ry : in  STD_LOGIC_VECTOR (15 downto 0);
             SP : in  STD_LOGIC_VECTOR (15 downto 0);
             ctrl : in  STD_LOGIC_VECTOR (1 downto 0);
             output : out  STD_LOGIC_VECTOR (15 downto 0));
	end component;
	component ALUSrc1MUX
		Port ( imm : in  STD_LOGIC_VECTOR (15 downto 0);
				rx : in  STD_LOGIC_VECTOR (15 downto 0);
				ry : in  STD_LOGIC_VECTOR (15 downto 0);
				IH : in  STD_LOGIC_VECTOR (15 downto 0);
				PC : in  STD_LOGIC_VECTOR (15 downto 0);
				ctrl : in  STD_LOGIC_VECTOR (2 downto 0);
				output : out  STD_LOGIC_VECTOR (15 downto 0));
	end component;
	component ALU
		 Port ( src1 : in  STD_LOGIC_VECTOR (15 downto 0);
				  src2 : in  STD_LOGIC_VECTOR (15 downto 0);
				  func : in  STD_LOGIC_VECTOR (2 downto 0);
				  rst : out  STD_LOGIC_VECTOR (15 downto 0));
	end component;
	component ReadWritePauser
		 Port ( inMEMWrite : in  STD_LOGIC;
				  inMEMRead : in  STD_LOGIC;
				  inAddr : in  STD_LOGIC_VECTOR (15 downto 0);
				  readWritePause : out  STD_LOGIC);
	end component;
	
	component EXE_MEMRegs
		Port ( inWBDes : in  STD_LOGIC_VECTOR (3 downto 0);
					inWBSrc : in  STD_LOGIC;
					inMEMRead : in  STD_LOGIC;
					inMEMWrite : in  STD_LOGIC;
					inMEMType : in STD_LOGIC_VECTOR (2 downto 0);
					inMEMSrc : in  STD_LOGIC_VECTOR (1 downto 0);
					inRegWrite : in  STD_LOGIC;
					inRst : in  STD_LOGIC_VECTOR (15 downto 0);
					inRA : in  STD_LOGIC_VECTOR (15 downto 0);
					inRx : in  STD_LOGIC_VECTOR (15 downto 0);
					inRy : in  STD_LOGIC_VECTOR (15 downto 0);
					clk : in  STD_LOGIC;
					pause : in STD_LOGIC;
					clear : in STD_LOGIC;
					outWBDes : out  STD_LOGIC_VECTOR (3 downto 0);
					outWBSrc : out  STD_LOGIC;
					outMEMRead : out  STD_LOGIC;
					outMEMWrite : out  STD_LOGIC;
					outMEMType : out STD_LOGIC_VECTOR (2 downto 0);
					outMEMSrc : out  STD_LOGIC_VECTOR (1 downto 0);
					outRegWrite : out  STD_LOGIC;
					outRst : out  STD_LOGIC_VECTOR (15 downto 0);
					outRA : out  STD_LOGIC_VECTOR (15 downto 0);
					outRx : out  STD_LOGIC_VECTOR (15 downto 0);
					outRy : out  STD_LOGIC_VECTOR (15 downto 0));
	end component;
	
	component MEMSrcMUX
		 Port ( rx : in  STD_LOGIC_VECTOR (15 downto 0);
				  ry : in  STD_LOGIC_VECTOR (15 downto 0);
				  RA : in  STD_LOGIC_VECTOR (15 downto 0);
				  ctrl : in  STD_LOGIC_VECTOR (1 downto 0);
				  output : out  STD_LOGIC_VECTOR (15 downto 0));
	end component;
	
	component MEMAccess
		Port ( inAddress : in  STD_LOGIC_VECTOR (15 downto 0);
				  inMemType : in STD_LOGIC_VECTOR (2 downto 0);
				  inData : in  STD_LOGIC_VECTOR (15 downto 0);
				  dataReady : in STD_LOGIC;
				  tsre : in STD_LOGIC;
				  tbre : in STD_LOGIC;
				  RAMbuffer : out STD_LOGIC_VECTOR (15 downto 0);
				  RAM1addr : out  STD_LOGIC_VECTOR (17 downto 0);
				  RAM1data : inout  STD_LOGIC_VECTOR (15 downto 0);
				  RAM1OE : out  STD_LOGIC;
				  RAM1WE : out  STD_LOGIC;
				  RAM1EN : out  STD_LOGIC;
				  RAM2addr : out  STD_LOGIC_VECTOR (17 downto 0);
				  RAM2DataOut : out  STD_LOGIC_VECTOR (15 downto 0);
				  RAM2DataIn : In  STD_LOGIC_VECTOR (15 downto 0);
				  --RAM2Read : out STD_LOGIC;
				  --RAM2Write : out STD_LOGIC;
				  rdn : out  STD_LOGIC;
				  wrn : out  STD_LOGIC;
				  clk : in  STD_LOGIC;
				  rst : in  STD_LOGIC);
	end component;
	
	component MEM_WBRegs
		 Port ( inRst : in  STD_LOGIC_VECTOR (15 downto 0);
	           	inBuffer : in  STD_LOGIC_VECTOR (15 downto 0);
	           	inWBDes : in  STD_LOGIC_VECTOR (3 downto 0);
	           	inWBSrc : in  STD_LOGIC;
	           	inRegWrite : in  STD_LOGIC;
				 clk : in  STD_LOGIC;
				 pause : in STD_LOGIC;
				 clear : in STD_LOGIC;
	           	outRst : out  STD_LOGIC_VECTOR (15 downto 0);
	           	outBuffer : out  STD_LOGIC_VECTOR (15 downto 0);
	           	outWBDes : out  STD_LOGIC_VECTOR (3 downto 0);
	           	outWBSrc : out  STD_LOGIC;
	           	outRegWrite : out  STD_LOGIC);
	end component;
	
	component WBSrcMUX
		 Port ( inRst : in  STD_LOGIC_VECTOR (15 downto 0);
				  inBuffer : in  STD_LOGIC_VECTOR (15 downto 0);
				  inWBSrc : in  STD_LOGIC;
				  output : out  STD_LOGIC_VECTOR (15 downto 0));
	end component;
	
	component clockDivider
    Port ( inclk : in  STD_LOGIC;
			  rst : in STD_LOGIC;
           outclk : out  STD_LOGIC);
	end component;
	
	component shumaDecoder
    Port ( wei : in  STD_LOGIC_VECTOR (3 downto 0);
           decode : out  STD_LOGIC_VECTOR (6 downto 0));
	end component;
	
	component MEMTypeMUX
    Port ( INALURst : in  STD_LOGIC_VECTOR (15 downto 0);
           INMemRead : in  STD_LOGIC;
           INMemWrite : in  STD_LOGIC;
           OUTMemType : out  STD_LOGIC_VECTOR (2 downto 0));
	end component;
	
	component VGAAccess
    Port ( inclk : in  STD_LOGIC;
           Rin : in  STD_LOGIC_VECTOR (2 downto 0);
           Gin : in  STD_LOGIC_VECTOR (2 downto 0);
           Bin : in  STD_LOGIC_VECTOR (2 downto 0);
           Hs : out  STD_LOGIC;
           Vs : out  STD_LOGIC;
           Rout : out  STD_LOGIC_VECTOR (2 downto 0);
           Gout : out  STD_LOGIC_VECTOR (2 downto 0);
           Bout : out  STD_LOGIC_VECTOR (2 downto 0);
           xOut : out  STD_LOGIC_VECTOR (9 downto 0);
           yOut : out  STD_LOGIC_VECTOR (9 downto 0));
	end component;
	
	component cachedVGAControler
		port(
			inX : in STD_LOGIC_VECTOR(9 downto 0);
			inY : in STD_LOGIC_VECTOR(9 downto 0);
			inChar : in STD_LOGIC_VECTOR(15 downto 0);
			inWriteEnable : in STD_LOGIC;
			outR : out STD_LOGIC_VECTOR(2 downto 0);
			outG : out STD_LOGIC_VECTOR(2 downto 0);
			outB : out STD_LOGIC_VECTOR(2 downto 0));
	end component;
	
	component vgaInterface
    Port ( inData : in  STD_LOGIC_VECTOR (15 downto 0);
           outChar : out  STD_LOGIC_VECTOR (15 downto 0);
           memType : in  STD_LOGIC_VECTOR(2 downto 0);
           outWriteEnable : out  STD_LOGIC);
	end component;
	
	--signal insRam2OE : STD_LOGIC := '1';
	--signal insRam2WE : STD_LOGIC := '1';
	--signal insRam2EN : STD_LOGIC := '1';
	--signal insRam2Addr : STD_LOGIC_VECTOR(17 downto 0) := (others=>'0');
	--signal insRam2Data : STD_LOGIC_VECTOR(15 downto 0) := (others=>'0');
	
	signal memRam2Addr : STD_LOGIC_VECTOR(17 downto 0) := (others=>'0');
	signal memRam2Dataout : STD_LOGIC_VECTOR(15 downto 0) := (others=>'0');
	signal memRam2Datain : STD_LOGIC_VECTOR(15 downto 0) := (others=>'0');
	signal memRam2Read : STD_LOGIC := '0';
	signal memRam2Write : STD_LOGIC := '0';
	
	signal PC_InsFetcher_PC : STD_LOGIC_VECTOR(15 downto 0) := (others=>'0');
	
	signal PC_PCAdder_PC : STD_LOGIC_VECTOR(15 downto 0) := (others=>'0');
	
	signal InsFetcher_IFIDRegs_instruction : STD_LOGIC_VECTOR(15 downto 0) := (others=>'0');
	
	signal PCAdder_IFIDRegs_PC : STD_LOGIC_VECTOR(15 downto 0) := (others=>'0');
	
	signal PCAdder_PCSelector_PC : STD_LOGIC_VECTOR(15 downto 0) := (others=>'0');
	
	signal PCSelect_PC_PC : STD_LOGIC_VECTOR(15 downto 0) := (others=>'0');
	
	signal IFIDRegs_Registers_rxNum : STD_LOGIC_VECTOR(2 downto 0) := (others=>'0');
	signal IFIDRegs_Registers_ryNum : STD_LOGIC_VECTOR(2 downto 0) := (others=>'0');
	
	signal IFIDRegs_bypasser_rxNum : STD_LOGIC_VECTOR(2 downto 0) := (others=>'0');
	signal IFIDRegs_bypasser_ryNum : STD_LOGIC_VECTOR(2 downto 0) := (others=>'0');
	signal IFIDRegs_bypasser_instruction : STD_LOGIC_VECTOR(15 downto 0) := (others=>'0');

	signal IFIDRegs_Extender_instruction : STD_LOGIC_VECTOR(15 downto 0) := (others=>'0');
	
	signal IFIDRegs_AddressAdder_PC : STD_LOGIC_VECTOR(15 downto 0) := (others=>'0');

	signal IFIDRegs_IDEXERegs_PC : STD_LOGIC_VECTOR(15 downto 0) := (others=>'0');

	signal IFIDRegs_Control_instruction : STD_LOGIC_VECTOR(15 downto 0) := (others=>'0');

	signal Registers_bypasser_rx : STD_LOGIC_VECTOR(15 downto 0) := (others=>'0');
	signal Registers_bypasser_ry : STD_LOGIC_VECTOR(15 downto 0) := (others=>'0');
	signal Registers_bypasser_T : STD_LOGIC_VECTOR(15 downto 0) := (others=>'0');
	signal Registers_bypasser_IH : STD_LOGIC_VECTOR(15 downto 0) := (others=>'0');
	signal Registers_bypasser_SP : STD_LOGIC_VECTOR(15 downto 0) := (others=>'0');

	signal Registers_IDEXERegs_RA : STD_LOGIC_VECTOR(15 downto 0) := (others=>'0');	

	signal bypasser_PC_dataPause : STD_LOGIC := '0';

	signal bypasser_PCSelector_rx : STD_LOGIC_VECTOR(15 downto 0) := (others=>'0');	

	signal bypasser_IFIDRegs_dataPause : STD_LOGIC := '0';

	signal bypasser_IDEXERegs_dataPause : STD_LOGIC := '0';
	signal bypasser_IDEXERegs_rx : STD_LOGIC_VECTOR(15 downto 0) := (others=>'0');
	signal bypasser_IDEXERegs_ry : STD_LOGIC_VECTOR(15 downto 0) := (others=>'0');
	signal bypasser_IDEXERegs_T : STD_LOGIC_VECTOR(15 downto 0) := (others=>'0');
	signal bypasser_IDEXERegs_IH : STD_LOGIC_VECTOR(15 downto 0) := (others=>'0');
	signal bypasser_IDEXERegs_SP : STD_LOGIC_VECTOR(15 downto 0) := (others=>'0');

	signal bypasser_Control_T : STD_LOGIC_VECTOR(15 downto 0) := (others=>'0');
	signal bypasser_Control_rx : STD_LOGIC_VECTOR(15 downto 0) := (others=>'0');

	signal Extender_AddressAdder_imm : STD_LOGIC_VECTOR(15 downto 0) := (others=>'0');

	signal Extender_IDEXERegs_imm : STD_LOGIC_VECTOR(15 downto 0) := (others=>'0');

	signal AddressAdder_PCSelector_PC : STD_LOGIC_VECTOR(15 downto 0) := (others=>'0');

	signal Control_PCSelector_PCSelCtr : STD_LOGIC_VECTOR(1 downto 0) := (others=>'0');

	signal Control_Extender_immSel : STD_LOGIC_VECTOR(2 downto 0) := (others=>'0');
	
	signal Control_IDEXERegs_ALUFunc : STD_LOGIC_VECTOR(2 downto 0) := (others=>'0');
	signal Control_IDEXERegs_ALUSrc0 : STD_LOGIC_VECTOR(1 downto 0) := (others=>'0');
	signal Control_IDEXERegs_ALUSrc1 : STD_LOGIC_VECTOR(2 downto 0) := (others=>'0');
	signal Control_IDEXERegs_MEMRead : STD_LOGIC := '0';
	signal Control_IDEXERegs_MEMWrite : STD_LOGIC := '0';
	signal Control_IDEXERegs_MEMSrc : STD_LOGIC_VECTOR(1 downto 0) := (others=>'0');
	signal Control_IDEXERegs_WBDes : STD_LOGIC_VECTOR(3 downto 0) := (others=>'0');
	signal Control_IDEXERegs_WBSrc : STD_LOGIC :='0';
	signal Control_IDEXERegs_RegWrite : STD_LOGIC :='0';
	
	signal Control_IFIDRegs_clear : STD_LOGIC := '0';
	
	signal IDEXERegs_ALUSrc0MUX_ALUSrc0 : STD_LOGIC_VECTOR(1 downto 0) := (others=>'0');
	signal IDEXERegs_ALUSrc0MUX_rx: STD_LOGIC_VECTOR(15 downto 0) := (others=>'0');
	signal IDEXERegs_ALUSrc0MUX_ry: STD_LOGIC_VECTOR(15 downto 0) := (others=>'0');
	signal IDEXERegs_ALUSrc0MUX_SP: STD_LOGIC_VECTOR(15 downto 0) := (others=>'0');

	signal IDEXERegs_ALUSrc1MUX_ALUSrc1 : STD_LOGIC_VECTOR(2 downto 0) := (others=>'0');
	signal IDEXERegs_ALUSrc1MUX_imm : STD_LOGIC_VECTOR(15 downto 0) := (others=>'0');
	signal IDEXERegs_ALUSrc1MUX_rx : STD_LOGIC_VECTOR(15 downto 0) := (others=>'0');
	signal IDEXERegs_ALUSrc1MUX_ry : STD_LOGIC_VECTOR(15 downto 0) := (others=>'0');
	signal IDEXERegs_ALUSrc1MUX_IH : STD_LOGIC_VECTOR(15 downto 0) := (others=>'0');
	signal IDEXERegs_ALUSrc1MUX_PC : STD_LOGIC_VECTOR(15 downto 0) := (others=>'0');

	signal IDEXERegs_ALU_ALUFunc : STD_LOGIC_VECTOR(2 downto 0) := (others=>'0');

	signal IDEXERegs_EXEMEMRegs_MEMRead : STD_LOGIC := '0';
	signal IDEXERegs_EXEMEMRegs_MEMWrite : STD_LOGIC := '0';
	signal IDEXERegs_EXEMEMRegs_MEMSrc : STD_LOGIC_VECTOR(1 downto 0) := (others=>'0');
	signal IDEXERegs_EXEMEMRegs_WBDes : STD_LOGIC_VECTOR(3 downto 0) := (others=>'0');
	signal IDEXERegs_EXEMEMRegs_WBSrc : STD_LOGIC :='0';
	signal IDEXERegs_EXEMEMRegs_RegWrite : STD_LOGIC :='0';
	signal IDEXERegs_EXEMEMRegs_RA : STD_LOGIC_VECTOR(15 downto 0) := (others=>'0');
	signal IDEXERegs_EXEMEMRegs_rx : STD_LOGIC_VECTOR(15 downto 0) := (others=>'0');
	signal IDEXERegs_EXEMEMRegs_ry : STD_LOGIC_VECTOR(15 downto 0) := (others=>'0');

	signal IDEXERegs_readWritePause_MEMRead : STD_LOGIC := '0';
	signal IDEXERegs_readWritePause_MEMWrite : STD_LOGIC := '0';

	signal IDEXERegs_bypasser_MEMRead : STD_LOGIC := '0';
	signal IDEXERegs_bypasser_WBDes : STD_LOGIC_VECTOR(3 downto 0) := (others=>'0');
	signal IDEXERegs_bypasser_RegWrite : STD_LOGIC := '0';

	signal IDEXERegs_MEMTypeMUX_MEMRead : STD_LOGIC := '0';
	signal IDEXERegs_MEMTypeMUX_MEMWrite : STD_LOGIC := '0';

	signal ALUSrc0MUX_ALU_ALUSrc0 : STD_LOGIC_VECTOR(15 downto 0) := (others=>'0');

	signal ALUSrc1MUX_ALU_ALUSrc1 : STD_LOGIC_VECTOR(15 downto 0) := (others=>'0');

	signal ALU_EXEMEMRegs_rst : STD_LOGIC_VECTOR(15 downto 0) := (others=>'0');

	signal ALU_readWritePause_rst : STD_LOGIC_VECTOR(15 downto 0) := (others=>'0');

	signal ALU_bypasser_rst : STD_LOGIC_VECTOR(15 downto 0) := (others=>'0');
	
	signal ALU_MEMTypeMUX_rst : STD_LOGIC_VECTOR(15 downto 0) := (others=>'0');

	signal readWritePause_PC_pause : STD_LOGIC := '0';
	
	signal MEMTypeMUX_EXEMEMRegs_MemType : STD_LOGIC_VECTOR(2 downto 0) := (others=>'1');

	signal EXEMEMRegs_MEMWBRegs_WBDes : STD_LOGIC_VECTOR(3 downto 0) := (others=>'0');
	signal EXEMEMRegs_MEMWBRegs_WBSrc : STD_LOGIC :='0';
	signal EXEMEMRegs_MEMWBRegs_RegWrite : STD_LOGIC :='0';
	signal EXEMEMRegs_MEMWBRegs_rst : STD_LOGIC_VECTOR(15 downto 0) := (others=>'0');

	signal EXEMEMRegs_MEMSrcMUX_MEMSrc : STD_LOGIC_VECTOR(1 downto 0) := (others=>'0');
	signal EXEMEMRegs_MEMSrcMUX_rx : STD_LOGIC_VECTOR(15 downto 0) := (others=>'0');
	signal EXEMEMRegs_MEMSrcMUX_ry : STD_LOGIC_VECTOR(15 downto 0) := (others=>'0');
	signal EXEMEMRegs_MEMSrcMUX_RA : STD_LOGIC_VECTOR(15 downto 0) := (others=>'0');

	signal EXEMEMRegs_MEMAccess_MemType : STD_LOGIC_VECTOR(2 downto 0) := (others=>'0');
	signal EXEMEMRegs_MEMAccess_rst : STD_LOGIC_VECTOR(15 downto 0) := (others=>'0');

	signal EXEMEMRegs_vgaInterface_rx : STD_LOGIC_VECTOR(15 downto 0) := (others=>'0');
	signal EXEMEMRegs_vgaInterface_MemType : STD_LOGIC_VECTOR(2 downto 0) := (others=>'0');
	
	signal EXEMEMRegs_bypasser_WBDes : STD_LOGIC_VECTOR(3 downto 0) := (others=>'0');
	signal EXEMEMRegs_bypasser_RegWrite : STD_LOGIC :='0';
	signal EXEMEMRegs_bypasser_MEMRead : STD_LOGIC :='0';
	signal EXEMEMRegs_bypasser_rst : STD_LOGIC_VECTOR(15 downto 0) := (others=>'0');

	signal MEMSrcMUX_MEMAccess_writeData : STD_LOGIC_VECTOR(15 downto 0) := (others=>'0');

	signal MEMAccess_MEMWBRegs_buffer : STD_LOGIC_VECTOR(15 downto 0) := (others=>'0');

	signal MEMWBRegs_WBSrcMUX_rst : STD_LOGIC_VECTOR(15 downto 0) := (others=>'0');
	signal MEMWBRegs_WBSrcMUX_buffer : STD_LOGIC_VECTOR(15 downto 0) := (others=>'0');
	signal MEMWBRegs_WBSrcMUX_WBSrc : STD_LOGIC := '0';

	signal MEMWBRegs_Registers_WBDes : STD_LOGIC_VECTOR(3 downto 0) := (others=>'0');
	signal MEMWBRegs_Registers_RegWrite : STD_LOGIC :='0';

	signal MEMWBRegs_bypasser_WBDes : STD_LOGIC_VECTOR(3 downto 0) := (others=>'0');
	signal MEMWBRegs_bypasser_RegWrite : STD_LOGIC :='0';

	signal WBSrcMUX_Registers_writeData : STD_LOGIC_VECTOR(15 downto 0) := (others=>'0');
	signal WBSrcMUX_bypasser_writeData : STD_LOGIC_VECTOR(15 downto 0) := (others=>'0');
	
	--signal IFIDRegs_clear : std_logic :='0';
	
	signal clk : std_logic := '0';
	
	signal Ram2OE : std_logic := '1';
	signal Ram2WE : std_logic := '1';
	signal Ram2EN : std_logic := '1';
	signal Ram2Addr : std_logic_vector(17 downto 0) := (others=>'1');
	signal Ram2Data : std_logic_vector(15 downto 0) := (others=>'Z');
	signal rdn : std_logic := '1';
	signal wdn : std_logic := '1';
	
	signal cachedVGAControler_VGAAccess_R : std_logic_vector(2 downto 0) := (others=>'0');
	signal cachedVGAControler_VGAAccess_G : std_logic_vector(2 downto 0) := (others=>'0');
	signal cachedVGAControler_VGAAccess_B : std_logic_vector(2 downto 0) := (others=>'0');

	signal VGAAccess_cachedVGAControler_x : std_logic_vector(9 downto 0) := (others=>'0');
	signal VGAAccess_cachedVGAControler_y : std_logic_vector(9 downto 0) := (others=>'0');

	signal vgaInterface_cachedVGAControler_char : std_logic_vector(15 downto 0) := (others=>'0');
	signal vgaInterface_cachedVGAControler_writeEnable : std_logic := '0';

begin
	PC_PCAdder_PC <= PC_InsFetcher_PC;

	PCAdder_PCSelector_PC <= PCAdder_IFIDRegs_PC;

	IFIDRegs_Control_instruction <= IFIDRegs_bypasser_instruction;
	IFIDRegs_Extender_instruction <= IFIDRegs_bypasser_instruction;

	IFIDRegs_bypasser_rxNum <= IFIDRegs_Registers_rxNum;

	IFIDRegs_bypasser_ryNum <= IFIDRegs_Registers_ryNum;

	IFIDRegs_IDEXERegs_PC <= IFIDRegs_AddressAdder_PC;

	bypasser_IDEXERegs_dataPause <= bypasser_PC_dataPause;
	bypasser_IFIDRegs_dataPause <= bypasser_PC_dataPause;

	bypasser_Control_rx <= bypasser_PCSelector_rx;
	bypasser_IDEXERegs_rx <= bypasser_PCSelector_rx;

	bypasser_Control_T <= bypasser_IDEXERegs_T;

	Extender_IDEXERegs_imm <= Extender_AddressAdder_imm;
	
	Control_IFIDRegs_clear <= Control_PCSelector_PCSelCtr(1) or Control_PCSelector_PCSelCtr(0);

	IDEXERegs_ALUSrc1MUX_rx <= IDEXERegs_ALUSrc0MUX_rx;
	IDEXERegs_EXEMEMRegs_rx <= IDEXERegs_ALUSrc0MUX_rx;

	IDEXERegs_ALUSrc1MUX_ry <= IDEXERegs_ALUSrc0MUX_ry;
	IDEXERegs_EXEMEMRegs_ry <= IDEXERegs_ALUSrc0MUX_ry;

	IDEXERegs_readWritePause_MEMRead <= IDEXERegs_EXEMEMRegs_MEMRead;
	IDEXERegs_bypasser_MEMRead <= IDEXERegs_EXEMEMRegs_MEMRead;
	IDEXERegs_MEMTypeMUX_MEMRead <= IDEXERegs_EXEMEMRegs_MEMRead;

	IDEXERegs_readWritePause_MEMWrite <= IDEXERegs_EXEMEMRegs_MEMWrite;
	IDEXERegs_MEMTypeMUX_MEMWrite <= IDEXERegs_EXEMEMRegs_MEMWrite;

	IDEXERegs_bypasser_WBDes <= IDEXERegs_EXEMEMRegs_WBDes;

	IDEXERegs_bypasser_RegWrite <= IDEXERegs_EXEMEMRegs_RegWrite;

	ALU_readWritePause_rst <= ALU_EXEMEMRegs_rst;
	ALU_bypasser_rst <= ALU_EXEMEMRegs_rst;
	ALU_MEMTypeMUX_rst <= ALU_EXEMEMRegs_rst;
	
	EXEMEMRegs_bypasser_WBDes <= EXEMEMRegs_MEMWBRegs_WBDes;

	EXEMEMRegs_bypasser_RegWrite <= EXEMEMRegs_MEMWBRegs_RegWrite;
	
	EXEMEMRegs_vgaInterface_rx <= EXEMEMRegs_MEMSrcMUX_rx;
	
	EXEMEMRegs_vgaInterface_MemType <= EXEMEMRegs_MEMAccess_MemType;
	
	memRam2Read <= EXEMEMRegs_bypasser_MEMRead;

	EXEMEMRegs_MEMAccess_rst <= EXEMEMRegs_MEMWBRegs_rst;
	EXEMEMRegs_bypasser_rst <= EXEMEMRegs_MEMWBRegs_rst;

	MEMWBRegs_bypasser_WBDes <= MEMWBRegs_Registers_WBDes;

	MEMWBRegs_bypasser_RegWrite <= MEMWBRegs_Registers_RegWrite;

	WBSrcMUX_bypasser_writeData <= WBSrcMUX_Registers_writeData;
	
	--IFIDRegs_clear <= Control_IFIDRegs_clear or bypasser_IFIDRegs_dataPause;
	
	--ins(7 downto 0) <= PC_InsFetcher_PC(7 downto 0);
	--ins(15 downto 8) <= WBSrcMUX_Registers_writeData(7 downto 0);
	--r7 <= readWritePause_PC_pause&"00000"&bypasser_PC_dataPause;
	--ins <= by;
	
	sml : shumaDecoder port map( PC_InsFetcher_PC(7 downto 4), l7);
	smr : shumaDecoder port map( PC_InsFetcher_PC(3 downto 0), r7);
	--ins(15) <= bypasser_PC_dataPause;
	--ins(14) <= readWritePause_PC_pause;
	--ins(13 downto 0) <= (others=>'0');--RAM1data(13 downto 0);
	--ins <= ALU_bypasser_rst;
	--ins <= bypasser_IDEXERegs_rx;
	--ins <= Registers_bypasser_ry;
	--ins <= WBSrcMUX_Registers_writeData;
	--ins(15) <= IDEXERegs_bypasser_RegWrite;
	--ins(14) <= EXEMEMRegs_bypasser_RegWrite;
	--ins(13 downto 10 ) <= IDEXERegs_bypasser_WBDes;
	--ins(9 downto 6 ) <= EXEMEMRegs_bypasser_WBDes;
	--ins(5 downto 0 ) <= (others => '0');
	--ins <= memRam2DataOut;
	process(clk, wdn)
	variable cnt : STD_LOGIC_VECTOR(3 downto 0) := "0000"; 
	begin
	ins(15 downto 9) <= wdn & rdn & dataready & tsre & EXEMEMRegs_MEMAccess_MemType;
	ins(8 downto 4) <= (others => '0');
	ins(3 downto 0) <= "0000";
	if(wdn'event and wdn='1') then
		cnt := cnt + 1;
	end if;
	--if(clk'event and clk='1') then
		--ins(0)<=bm(conv_integer(cnt))(conv_integer(cnt));
	--end if;
	end process;
	--process(IDEXERegs_ALUSrc0MUX_rx, IDEXERegs_ALUSrc0MUX_ry, IDEXERegs_ALUSrc0MUX_SP, IDEXERegs_ALUSrc0MUX_ALUSrc0)
	--begin
	--	case IDEXERegs_ALUSrc0MUX_ALUSrc0 is
			--when "00" => 
				--ALUSrc0MUX_ALU_ALUSrc0 <= 	IDEXERegs_ALUSrc0MUX_ry;
			--when "01" => 
				--ALUSrc0MUX_ALU_ALUSrc0 <= IDEXERegs_ALUSrc0MUX_SP;
			--when "10" =>
				--ALUSrc0MUX_ALU_ALUSrc0 <= IDEXERegs_ALUSrc0MUX_rx;
			--when "11" =>
				--ALUSrc0MUX_ALU_ALUSrc0 <= (others => '0');
			--when others =>
		--end case;
	--end process;
	outRam2OE <= Ram2OE;
	outRam2WE <= Ram2WE;
	outRam2EN <= Ram2EN;
	outRam2Addr <= Ram2Addr;
	outRam2Data <= Ram2Data;
	outrdn <= rdn;
	outwdn <= wdn;

	p : PC port map(				clk, 
										readWritePause_PC_pause, 
										bypasser_PC_dataPause, 
										PCSelect_PC_PC, 
										PC_InsFetcher_PC);
										
	insf : InsFetcher port map(Ram2OE, Ram2WE, Ram2EN, Ram2Addr, Ram2Data, 
										InsFetcher_IFIDRegs_instruction, 
										PC_InsFetcher_PC, 
										memRam2Addr,
										memRam2DataIn,
										memRam2DataOut,
										memRam2Read,
										memRam2Write,
										inclk);
								
	pca : PCAdder port map(		PC_PCAdder_PC, 
										PCAdder_IFIDRegs_PC);
										
	pcs : PCSelector port map(	PCAdder_PCSelector_PC, 
										AddressAdder_PCSelector_PC,
										bypasser_PCSelector_rx, 
										Control_PCSelector_PCSelCtr, 
										PCSelect_PC_PC);
										
	ifidr : IF_IDRegs port map(PCAdder_IFIDRegs_PC, 
										InsFetcher_IFIDRegs_instruction,
										clk, 
										bypasser_IFIDRegs_dataPause, 
										Control_IFIDRegs_clear,
										IFIDRegs_bypasser_instruction, 
										IFIDRegs_AddressAdder_PC, 
										IFIDRegs_Registers_rxNum,
										IFIDRegs_Registers_ryNum);
										
	regis : Registers port map(IFIDRegs_Registers_rxNum, 
										IFIDRegs_Registers_ryNum,
										MEMWBRegs_Registers_WBDes,
										WBSrcMUX_Registers_writeData,
										MEMWBRegs_Registers_RegWrite,
										Registers_bypasser_rx, 
										Registers_bypasser_ry, 
										Registers_bypasser_T, 
										Registers_bypasser_IH,
										Registers_bypasser_SP,
										clk => clk);
										
	bypas : bypasser port map(
										Registers_bypasser_rx, 
										Registers_bypasser_ry, 
										Registers_bypasser_T, 
										Registers_bypasser_IH,
										Registers_bypasser_SP,
										IFIDRegs_bypasser_rxNum, 
										IFIDRegs_bypasser_ryNum, 
										IFIDRegs_bypasser_instruction,
										IDEXERegs_bypasser_RegWrite,
										IDEXERegs_bypasser_WBDes, 
										IDEXERegs_bypasser_MEMRead, 
										ALU_bypasser_rst,
										EXEMEMRegs_bypasser_RegWrite,
										EXEMEMRegs_bypasser_WBDes,
										EXEMEMRegs_bypasser_MEMRead, 
										EXEMEMRegs_bypasser_rst,
										MEMWBRegs_bypasser_RegWrite,
										MEMWBRegs_bypasser_WBDes, 
										WBSrcMUX_bypasser_writeData,
										bypasser_PCSelector_rx,
										bypasser_IDEXERegs_ry, 
										bypasser_IDEXERegs_T, 
										bypasser_IDEXERegs_IH,
										bypasser_IDEXERegs_SP,
										bypasser_PC_dataPause);
										
	conrt : Control port map(
										IFIDRegs_Control_instruction, 
										bypasser_Control_rx, 
										bypasser_Control_T, 
										Control_Extender_immSel, 
										Control_PCSelector_PCSelCtr,
										Control_IDEXERegs_ALUFunc, 
										Control_IDEXERegs_ALUSrc0, 
										Control_IDEXERegs_ALUSrc1,
										Control_IDEXERegs_MEMRead, 
										Control_IDEXERegs_MEMWrite, 
										Control_IDEXERegs_MEMSrc,
										Control_IDEXERegs_WBDes, 
										Control_IDEXERegs_WBSrc, 
										Control_IDEXERegs_RegWrite);
										
	exten : Extender port map(
										IFIDRegs_Extender_instruction, 
										Control_Extender_immSel, 
										Extender_AddressAdder_imm);
										
	addre : AddressAdder port map(
										IFIDRegs_AddressAdder_PC,
										Extender_AddressAdder_imm, 
										AddressAdder_PCSelector_PC);
										
	idexe : ID_EXERegs port map(
										Control_IDEXERegs_ALUFunc, 
										Control_IDEXERegs_ALUSrc0, 
										Control_IDEXERegs_ALUSrc1,
										Control_IDEXERegs_WBDes, 
										Control_IDEXERegs_WBSrc,
										Control_IDEXERegs_MEMRead, 
										Control_IDEXERegs_MEMWrite, 
										Control_IDEXERegs_MEMSrc,
										Control_IDEXERegs_RegWrite, 
										Extender_IDEXERegs_imm, 
										IFIDRegs_IDEXERegs_PC,
										bypasser_IDEXERegs_rx, 
										bypasser_IDEXERegs_ry, 
										bypasser_IDEXERegs_IH, 
										bypasser_IDEXERegs_SP, 
										Registers_IDEXERegs_RA,
										clk, 
										'0',
										bypasser_IDEXERegs_dataPause, 
										IDEXERegs_ALU_ALUFunc, 
										IDEXERegs_ALUSrc0MUX_ALUSrc0, 
										IDEXERegs_ALUSrc1MUX_ALUSrc1,
										IDEXERegs_EXEMEMRegs_WBDes, 
										IDEXERegs_EXEMEMRegs_WBSrc,
										IDEXERegs_EXEMEMRegs_MEMRead, 
										IDEXERegs_EXEMEMRegs_MEMWrite, 
										IDEXERegs_EXEMEMRegs_MEMSrc,
										IDEXERegs_EXEMEMRegs_RegWrite, 
										IDEXERegs_ALUSrc1MUX_imm, 
										IDEXERegs_ALUSrc1MUX_PC,
										IDEXERegs_ALUSrc0MUX_rx, 
										IDEXERegs_ALUSrc0MUX_ry, 
										IDEXERegs_ALUSrc1MUX_IH, 
										IDEXERegs_ALUSrc0MUX_SP, 
										IDEXERegs_EXEMEMRegs_RA);
											
	alus0m : ALUSrc0MUX port map(
										IDEXERegs_ALUSrc0MUX_rx, 
										IDEXERegs_ALUSrc0MUX_ry, 
										IDEXERegs_ALUSrc0MUX_SP, 
										IDEXERegs_ALUSrc0MUX_ALUSrc0, 
										ALUSrc0MUX_ALU_ALUSrc0);
										
	alus1m : ALUSrc1MUX port map(
										IDEXERegs_ALUSrc1MUX_imm, 
										IDEXERegs_ALUSrc1MUX_rx, 
										IDEXERegs_ALUSrc1MUX_ry, 
										IDEXERegs_ALUSrc1MUX_IH, 
										IDEXERegs_ALUSrc1MUX_PC, 
										IDEXERegs_ALUSrc1MUX_ALUSrc1, 
										ALUSrc1MUX_ALU_ALUSrc1);
										
	al : ALU port map(
										ALUSrc0MUX_ALU_ALUSrc0, 
										ALUSrc1MUX_ALU_ALUSrc1, 
										IDEXERegs_ALU_ALUFunc, 
										ALU_EXEMEMRegs_rst);
										
	rwpau : ReadWritePauser port map(
										IDEXERegs_readWritePause_MEMWrite, 
										IDEXERegs_readWritePause_MEMRead, 
										ALU_readWritePause_rst, 
										readWritePause_PC_pause);
										
	exemr : EXE_MEMRegs port map(
										IDEXERegs_EXEMEMRegs_WBDes, 
										IDEXERegs_EXEMEMRegs_WBSrc,
										IDEXERegs_EXEMEMRegs_MEMRead, 
										IDEXERegs_EXEMEMRegs_MEMWrite,
										MEMTypeMUX_EXEMEMRegs_MemType,
										IDEXERegs_EXEMEMRegs_MEMSrc,
										IDEXERegs_EXEMEMRegs_RegWrite, 
										ALU_EXEMEMRegs_rst, 
										IDEXERegs_EXEMEMRegs_RA, 
										IDEXERegs_EXEMEMRegs_rx, 
										IDEXERegs_EXEMEMRegs_ry,
										clk, '0', '0',
										EXEMEMRegs_MEMWBRegs_WBDes, 
										EXEMEMRegs_MEMWBRegs_WBSrc,
										EXEMEMRegs_bypasser_MEMRead, 
										memRam2Write,
										EXEMEMRegs_MEMAccess_MemType,
										EXEMEMRegs_MEMSrcMUX_MEMSrc,
										EXEMEMRegs_MEMWBRegs_RegWrite, 
										EXEMEMRegs_MEMWBRegs_rst,
										EXEMEMRegs_MEMSrcMUX_RA, 
										EXEMEMRegs_MEMSrcMUX_rx, 
										EXEMEMRegs_MEMSrcMUX_ry);
										
	memsm : MEMSrcMUX port map(EXEMEMRegs_MEMSrcMUX_rx, 
										EXEMEMRegs_MEMSrcMUX_ry, 
										EXEMEMRegs_MEMSrcMUX_RA, 
										EXEMEMRegs_MEMSrcMUX_MEMSrc, 
										MEMSrcMUX_MEMAccess_writeData);
										
	memac : MEMAccess port map(EXEMEMRegs_MEMAccess_rst, 
										--EXEMEMRegs_MEMAccess_MEMRead, 
										--EXEMEMRegs_MEMAccess_MEMWrite,
										EXEMEMRegs_MEMAccess_MemType,
										MEMSrcMUX_MEMAccess_writeData,
										dataReady, tsre, tbre, 
										MEMAccess_MEMWBRegs_buffer,
										RAM1addr, RAM1data, RAM1OE, RAM1WE, RAM1EN,
										memRam2Addr, memRam2DataOut, memRam2DataIn, --memRam2Read, memRam2Write,
										rdn, wdn, clk=>inclk, rst=>inrst);
										
	memwr : MEM_WBRegs port map(EXEMEMRegs_MEMWBRegs_rst, 
										MEMAccess_MEMWBRegs_buffer,
										EXEMEMRegs_MEMWBRegs_WBDes, 
										EXEMEMRegs_MEMWBRegs_WBSrc, 
										EXEMEMRegs_MEMWBRegs_RegWrite,
										clk, '0', '0',
										MEMWBRegs_WBSrcMUX_rst, 
										MEMWBRegs_WBSrcMUX_buffer,
										MEMWBRegs_Registers_WBDes, 
										MEMWBRegs_WBSrcMUX_WBSrc, 
										MEMWBRegs_Registers_RegWrite);
										
	wbsm : WBSrcMUX port map(
										MEMWBRegs_WBSrcMUX_rst, 
										MEMWBRegs_WBSrcMUX_buffer, 
										MEMWBRegs_WBSrcMUX_WBSrc, 
										WBSrcMUX_Registers_writeData);
										
	memtm : MEMTypeMUX port map(ALU_MEMTypeMUX_rst,
											IDEXERegs_MEMTypeMUX_MEMRead,
											IDEXERegs_MEMTypeMUX_MEMWrite,
											MEMTypeMUX_EXEMEMRegs_MemType);
											
	vgaa : VGAAccess port map( inclk,
										cachedVGAControler_VGAAccess_R,
										cachedVGAControler_VGAAccess_G,
										cachedVGAControler_VGAAccess_B,
										Hs, Vs,
										Rout, Gout, Bout,
										VGAAccess_cachedVGAControler_x,
										VGAAccess_cachedVGAControler_y);
										
	cachc : cachedVGAControler	port map ( VGAAccess_cachedVGAControler_x,
														VGAAccess_cachedVGAControler_y,					
														vgaInterface_cachedVGAControler_char,
														vgaInterface_cachedVGAControler_writeEnable,
														cachedVGAControler_VGAAccess_R,
														cachedVGAControler_VGAAccess_G,
														cachedVGAControler_VGAAccess_B);
														
	vgaif : vgaInterface port map ( EXEMEMRegs_vgaInterface_rx,
												vgaInterface_cachedVGAControler_char,
												EXEMEMRegs_vgaInterface_MemType,
												vgaInterface_cachedVGAControler_writeEnable);
												
	clockd : clockDivider port map(inclk,inrst,clk);
	--clk <= inclk;
end Behavioral;


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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity pop_cpu is
	port ( clk : in std_logic;
			 RAM1OE : out  STD_LOGIC;
			 RAM1WE : out  STD_LOGIC;
			 RAM1EN : out  STD_LOGIC;
			 RAM1addr : out  STD_LOGIC_VECTOR (17 downto 0);
			 RAM1data : inout  STD_LOGIC_VECTOR (15 downto 0);
			 Ram2OE : out  STD_LOGIC;
			 Ram2WE : out  STD_LOGIC;
			 Ram2EN : out  STD_LOGIC;
			 Ram2Addr : out STD_LOGIC_VECTOR(17 downto 0);
			 Ram2Data : inout STD_LOGIC_VECTOR(15 downto 0);
			 dataReady : in STD_LOGIC;
			 tsre : in STD_LOGIC;
			 rdn : out STD_LOGIC;
			 wrn : out STD_LOGIC;
			 ins : out std_logic_vector(15 downto 0);
			 r7 : out std_logic_vector(6 downto 0));
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
				Ram2Data : in STD_LOGIC_VECTOR(15 downto 0);
				addr : in STD_LOGIC_VECTOR(15 downto 0);
				ins : out STD_LOGIC_VECTOR(15 downto 0);
				rwPause : in STD_LOGIC);
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
           RA : out  STD_LOGIC_VECTOR (15 downto 0));
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
             output : out  STD_LOGIC_VECTOR (15 downto 0);
				 clk : in STD_LOGIC);
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
				  inMEMRead : in  STD_LOGIC;
				  inMEMWrite : in  STD_LOGIC;
				  inData : in  STD_LOGIC_VECTOR (15 downto 0);
				  dataReady : in STD_LOGIC;
				  tsre : in STD_LOGIC;
				  RAMbuffer : out STD_LOGIC_VECTOR (15 downto 0);
				  RAM1addr : out  STD_LOGIC_VECTOR (17 downto 0);
				  RAM1data : inout  STD_LOGIC_VECTOR (15 downto 0);
				  RAM1OE : out  STD_LOGIC;
				  RAM1WE : out  STD_LOGIC;
				  RAM1EN : out  STD_LOGIC;
				  RAM2addr : out  STD_LOGIC_VECTOR (17 downto 0);
				  RAM2DataOut : out  STD_LOGIC_VECTOR (15 downto 0);
				  RAM2DataIn : In  STD_LOGIC_VECTOR (15 downto 0);
				  RAM2OE : out  STD_LOGIC;
				  RAM2WE : out  STD_LOGIC;
				  RAM2EN : out  STD_LOGIC;
				  rdn : out  STD_LOGIC;
				  wrn : out  STD_LOGIC);
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
	
	component Ram2Access
			port ( pause : in std_logic;
	
					 insRam2OE : in  STD_LOGIC;
					 insRam2WE : in  STD_LOGIC;
					 insRam2EN : in  STD_LOGIC;
					 insRam2Addr : in STD_LOGIC_VECTOR(17 downto 0);
					 insRam2Data : inout STD_LOGIC_VECTOR(15 downto 0);
					 
					 memRead	: in std_logic;
					 memRam2OE : in  STD_LOGIC;
					 memRam2WE : in  STD_LOGIC;
					 memRam2EN : in  STD_LOGIC;
					 memRam2Addr : in STD_LOGIC_VECTOR(17 downto 0);
					 memRam2DataOut : in STD_LOGIC_VECTOR(15 downto 0);
					 memRam2DataIn : out STD_LOGIC_VECTOR(15 downto 0);
					 
					 Ram2OE : out  STD_LOGIC;
					 Ram2WE : out  STD_LOGIC;
					 Ram2EN : out  STD_LOGIC;
					 Ram2Addr : out STD_LOGIC_VECTOR(17 downto 0);
					 Ram2Data : inout STD_LOGIC_VECTOR(15 downto 0));
	end component;
	
	signal insRam2OE : STD_LOGIC := '1';
	signal insRam2WE : STD_LOGIC := '1';
	signal insRam2EN : STD_LOGIC := '1';
	signal insRam2Addr : STD_LOGIC_VECTOR(17 downto 0) := (others=>'0');
	signal insRam2Data : STD_LOGIC_VECTOR(15 downto 0) := (others=>'0');
	
	signal memRam2OE : STD_LOGIC := '1';
	signal memRam2WE : STD_LOGIC := '1';
	signal memRam2EN : STD_LOGIC := '1';
	signal memRam2Addr : STD_LOGIC_VECTOR(17 downto 0) := (others=>'0');
	signal memRam2Dataout : STD_LOGIC_VECTOR(15 downto 0) := (others=>'0');
	signal memRam2Datain : STD_LOGIC_VECTOR(15 downto 0) := (others=>'0');
	
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


	signal ALUSrc0MUX_ALU_ALUSrc0 : STD_LOGIC_VECTOR(15 downto 0) := (others=>'0');

	signal ALUSrc1MUX_ALU_ALUSrc1 : STD_LOGIC_VECTOR(15 downto 0) := (others=>'0');

	signal ALU_EXEMEMRegs_rst : STD_LOGIC_VECTOR(15 downto 0) := (others=>'0');

	signal ALU_readWritePause_rst : STD_LOGIC_VECTOR(15 downto 0) := (others=>'0');

	signal ALU_bypasser_rst : STD_LOGIC_VECTOR(15 downto 0) := (others=>'0');

	signal readWritePause_PC_pause : STD_LOGIC := '0';

	signal readWritePause_InsFetcher_pause : STD_LOGIC := '0';

	signal readWritePause_Ram2Access_pause : STD_LOGIC := '0';

	signal EXEMEMRegs_MEMWBRegs_WBDes : STD_LOGIC_VECTOR(3 downto 0) := (others=>'0');
	signal EXEMEMRegs_MEMWBRegs_WBSrc : STD_LOGIC :='0';
	signal EXEMEMRegs_MEMWBRegs_RegWrite : STD_LOGIC :='0';
	signal EXEMEMRegs_MEMWBRegs_rst : STD_LOGIC_VECTOR(15 downto 0) := (others=>'0');

	signal EXEMEMRegs_MEMSrcMUX_MEMSrc : STD_LOGIC_VECTOR(1 downto 0) := (others=>'0');
	signal EXEMEMRegs_MEMSrcMUX_rx : STD_LOGIC_VECTOR(15 downto 0) := (others=>'0');
	signal EXEMEMRegs_MEMSrcMUX_ry : STD_LOGIC_VECTOR(15 downto 0) := (others=>'0');
	signal EXEMEMRegs_MEMSrcMUX_RA : STD_LOGIC_VECTOR(15 downto 0) := (others=>'0');

	signal EXEMEMRegs_MEMAccess_MEMRead : STD_LOGIC := '0';
	signal EXEMEMRegs_MEMAccess_MEMWrite : STD_LOGIC := '0';
	signal EXEMEMRegs_MEMAccess_rst : STD_LOGIC_VECTOR(15 downto 0) := (others=>'0');

	signal EXEMEMRegs_bypasser_WBDes : STD_LOGIC_VECTOR(3 downto 0) := (others=>'0');
	signal EXEMEMRegs_bypasser_RegWrite : STD_LOGIC :='0';
	signal EXEMEMRegs_bypasser_MEMRead : STD_LOGIC :='0';
	signal EXEMEMRegs_bypasser_rst : STD_LOGIC_VECTOR(15 downto 0) := (others=>'0');

	signal EXEMEMRegs_Ram2Access_MEMRead : STD_LOGIC := '0';

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

	IDEXERegs_readWritePause_MEMWrite <= IDEXERegs_EXEMEMRegs_MEMWrite;

	IDEXERegs_bypasser_WBDes <= IDEXERegs_EXEMEMRegs_WBDes;

	IDEXERegs_bypasser_RegWrite <= IDEXERegs_EXEMEMRegs_RegWrite;

	ALU_readWritePause_rst <= ALU_EXEMEMRegs_rst;
	ALU_bypasser_rst <= ALU_EXEMEMRegs_rst;

	readWritePause_InsFetcher_pause <= readWritePause_PC_pause;
	readWritePause_Ram2Access_pause <= readWritePause_PC_pause;

	EXEMEMRegs_bypasser_WBDes <= EXEMEMRegs_MEMWBRegs_WBDes;

	EXEMEMRegs_bypasser_RegWrite <= EXEMEMRegs_MEMWBRegs_RegWrite;

	EXEMEMRegs_MEMAccess_rst <= EXEMEMRegs_MEMWBRegs_rst;
	EXEMEMRegs_bypasser_rst <= EXEMEMRegs_MEMWBRegs_rst;

	EXEMEMRegs_bypasser_MEMRead <= EXEMEMRegs_MEMAccess_MEMRead;
	EXEMEMRegs_Ram2Access_MEMRead <= EXEMEMRegs_MEMAccess_MEMRead;

	MEMWBRegs_bypasser_WBDes <= MEMWBRegs_Registers_WBDes;

	MEMWBRegs_bypasser_RegWrite <= MEMWBRegs_Registers_RegWrite;

	WBSrcMUX_bypasser_writeData <= WBSrcMUX_Registers_writeData;
	
	--IFIDRegs_clear <= Control_IFIDRegs_clear or bypasser_IFIDRegs_dataPause;
	
	ins(7 downto 0) <= PC_InsFetcher_PC(7 downto 0);
	ins(15 downto 8) <= WBSrcMUX_Registers_writeData(7 downto 0);
	r7 <= readWritePause_PC_pause&"00000"&bypasser_PC_dataPause;
	--ins <= by;
	
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

	p : PC port map(				clk, 
										readWritePause_PC_pause, 
										bypasser_PC_dataPause, 
										PCSelect_PC_PC, 
										PC_InsFetcher_PC);
										
	insf : InsFetcher port map(insRam2OE, insRam2WE, insRam2EN, insRam2Addr, insRam2Data, 
										PC_InsFetcher_PC, 
										InsFetcher_IFIDRegs_instruction, 
										readWritePause_InsFetcher_pause);
										
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
										Registers_bypasser_SP);
										
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
										ALUSrc0MUX_ALU_ALUSrc0, 
										clk);
										
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
										IDEXERegs_EXEMEMRegs_MEMSrc,
										IDEXERegs_EXEMEMRegs_RegWrite, 
										ALU_EXEMEMRegs_rst, 
										IDEXERegs_EXEMEMRegs_RA, 
										IDEXERegs_EXEMEMRegs_rx, 
										IDEXERegs_EXEMEMRegs_ry,
										clk, '0', '0',
										EXEMEMRegs_MEMWBRegs_WBDes, 
										EXEMEMRegs_MEMWBRegs_WBSrc,
										EXEMEMRegs_MEMAccess_MEMRead, 
										EXEMEMRegs_MEMAccess_MEMWrite, 
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
										EXEMEMRegs_MEMAccess_MEMRead, 
										EXEMEMRegs_MEMAccess_MEMWrite, 
										MEMSrcMUX_MEMAccess_writeData,
										dataReady, tsre, 
										MEMAccess_MEMWBRegs_buffer,
										RAM1addr, RAM1data, RAM1OE, RAM1WE, RAM1EN,
										memRam2Addr, memRam2DataOut, memRam2DataIn, memRam2OE, memRam2WE, memRam2EN,
										rdn, wrn);
										
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
										
	ram2a : Ram2Access port map(
										readWritePause_Ram2Access_pause, 
										insRam2OE, insRam2WE, insRam2EN, insRam2Addr, insRam2Data,
										EXEMEMRegs_Ram2Access_MEMRead, 
										memRam2OE, memRam2WE, memRam2EN, memRam2Addr, memRam2DataOut, memRam2DataIn,
										Ram2OE, Ram2WE, Ram2EN, Ram2Addr, Ram2Data);
end Behavioral;


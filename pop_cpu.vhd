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
			 Ram2Addr : inout STD_LOGIC_VECTOR(15 downto 0);
			 Ram2Data : in STD_LOGIC_VECTOR(15 downto 0));
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
				ctrl: in STD_LOGIC_VECTOR(2 downto 0);
				PCout: out STD_LOGIC_VECTOR(15 downto 0));
	end component;
	
	component IF_IDRegs
		port( inPC : in STD_LOGIC_VECTOR (15 downto 0);
				inInst : in STD_LOGIC_VECTOR (15 downto 0);
				clk : in  STD_LOGIC;
				pause : in STD_LOGIC;
				clear : in STD_LOGIC;
				intSave : in STD_LOGIC;         --ÖÐ¶Ï±£´æ
				intRecover : in STD_LOGIC;    --ÖÐ¶Ï»Ö¸´
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
           SP : out  STD_LOGIC_VECTOR (15 downto 0));
	end component;
	component bypasser
		Port ( inrx : in  STD_LOGIC_VECTOR (15 downto 0);
           inry : in  STD_LOGIC_VECTOR (15 downto 0);
           inT : in  STD_LOGIC_VECTOR (15 downto 0);
           inTH : in  STD_LOGIC_VECTOR (15 downto 0);
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
           outTH : out  STD_LOGIC_VECTOR (15 downto 0);
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
				  RAM2data : inout  STD_LOGIC_VECTOR (15 downto 0);
				  RAM2OE : out  STD_LOGIC;
				  RAM2WE : out  STD_LOGIC;
				  RAM2EN : out  STD_LOGIC;
				  rdn : out  STD_LOGIC;
				  wrn : out  STD_LOGIC);
	end component;
	
	component MEM_WBRegs
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
				  RAM2data : inout  STD_LOGIC_VECTOR (15 downto 0);
				  RAM2OE : out  STD_LOGIC;
				  RAM2WE : out  STD_LOGIC;
				  RAM2EN : out  STD_LOGIC;
				  rdn : out  STD_LOGIC;
				  wrn : out  STD_LOGIC);
	end component;
	
	component WBSrcMUX
		 Port ( inRst : in  STD_LOGIC_VECTOR (15 downto 0);
				  inBuffer : in  STD_LOGIC_VECTOR (15 downto 0);
				  inWBSrc : in  STD_LOGIC;
				  output : out  STD_LOGIC_VECTOR (15 downto 0));
	end component;
	
	signal PC_InsFetcher_PC : STD_LOGIC_VECTOR(15 downto 0) := (others=>'0');
	
	signal PC_PCAdder_PC : STD_LOGIC_VECTOR(15 downto 0) := (others=>'0');
	
	signal InsFetcher_IFIDRegs_instruction : STD_LOGIC_VECTOR(15 downto 0) := (others=>'0');
	
	signal PCAdder_IFIDRegs_PC : STD_LOGIC_VECTOR(15 downto 0) := (others=>'0');
	
	signal PCAdder_PCSelector_PC : STD_LOGIC_VECTOR(15 downto 0) := (others=>'0');
	
	signal PCSelect_PC_PC : STD_LOGIC_VECTOR(15 downto 0) := (others=>'0');
	
	signal IFIDRegs_Registers_rxNum : STD_LOGIC_VECTOR(15 downto 0) := (others=>'0');
	signal IFIDRegs_Registers_ryNum : STD_LOGIC_VECTOR(15 downto 0) := (others=>'0');
	
	signal IFIDRegs_bypasser_rxNum : STD_LOGIC_VECTOR(15 downto 0) := (others=>'0');
	signal IFIDRegs_bypasser_ryNum : STD_LOGIC_VECTOR(15 downto 0) := (others=>'0');
	signal IFIDRegs_bypasser_instruction : STD_LOGIC_VECTOR(15 downto 0) := (others=>'0');

	signal IFIDRegs_Extender_instruction : STD_LOGIC_VECTOR(15 downto 0) := (others=>'0');
	
	signal IFIDRegs_AddressAdder_instruction : STD_LOGIC_VECTOR(15 downto 0) := (others=>'0');

	
begin


end Behavioral;


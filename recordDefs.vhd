--
--	Package File Template
--
--	Purpose: This package defines supplemental types, subtypes, 
--		 constants, and functions 
--
--   To use any of the example code shown below, uncomment the lines and modify as necessary
--

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_SIGNED.all;

package recordDefs is

type ALUFuncRec is record
	sigSLL : STD_LOGIC_VECTOR (2 downto 0);
	sigSRL : STD_LOGIC_VECTOR (2 downto 0);
	sigSRA : STD_LOGIC_VECTOR (2 downto 0);
	sigADD : STD_LOGIC_VECTOR (2 downto 0);
	sigSUB : STD_LOGIC_VECTOR (2 downto 0);
	sigAND : STD_LOGIC_VECTOR (2 downto 0);
	sigOR  : STD_LOGIC_VECTOR (2 downto 0);
	sigCMP : STD_LOGIC_VECTOR (2 downto 0);
end record;

constant ALUFunc : ALUFuncRec := (
					sigSLL => "000",
					sigSRL => "001",
					sigSRA => "010",
					sigADD => "011",
					sigSUB => "100",
					sigAND => "101",
					sigOR  => "110",
					sigCMP => "111");

type ALUSrc0Rec is record
	rx : STD_LOGIC_VECTOR (1 downto 0);
	ry : STD_LOGIC_VECTOR (1 downto 0);
	zero : STD_LOGIC_VECTOR (1 downto 0);
	SP : STD_LOGIC_VECTOR (1 downto 0);
end record;					

constant ALUSrc0 : ALUSrc0Rec := (
					ry => "00",
					SP => "01",
					rx => "10",
					zero => "11");
					
type ALUSrc1Rec is record
	imm : STD_LOGIC_VECTOR (2 downto 0);
	rx  : STD_LOGIC_VECTOR (2 downto 0);
	ry  : STD_LOGIC_VECTOR (2 downto 0);
	IH  : STD_LOGIC_VECTOR (2 downto 0);
	PC  : STD_LOGIC_VECTOR (2 downto 0);
end record;

constant ALUSrc1 : ALUSrc1Rec := (
					imm => "000",
					rx  => "001",
					ry  => "010",
					IH  => "011",
					PC  => "100");
					
					
type MEMSrcRec is record
	rx : STD_LOGIC_VECTOR (1 downto 0);
	ry : STD_LOGIC_VECTOR (1 downto 0);
	RA : STD_LOGIC_VECTOR (1 downto 0);
end record;

constant MEMSrc : MEMSrcRec := (
					rx => "00",
					ry => "01",
					RA => "10");
			
constant Hsa : integer range 0 to 1000 := 640;	--行显示区的开始
constant Hsb : integer range 0 to 1000 := 656;	--行消隐区的开始
constant Hsc : integer range 0 to 1000 := 752;	--行消隐区中0段的开始
constant Hsd : integer range 0 to 1000 := 800;	--行消隐区中0段的结束

constant Vsa : integer range 0 to 1000 := 480;	--同上，对应场区
constant Vsb : integer range 0 to 1000 := 490;
constant Vsc : integer range 0 to 1000 := 492;
constant Vsd : integer range 0 to 1000 := 525;
			
end recordDefs;



package body recordDefs is

 
end recordDefs;

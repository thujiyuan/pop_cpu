----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    22:44:29 11/20/2016 
-- Design Name: 
-- Module Name:    ID_EXERegs - Behavioral 
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity ID_EXERegs is
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
end ID_EXERegs;

architecture Behavioral of ID_EXERegs is
begin

process(clk)
variable tempALUFunc : STD_LOGIC_VECTOR (2 downto 0);
variable tempALUSrc0 : STD_LOGIC_VECTOR (1 downto 0);
variable tempALUSrc1 : STD_LOGIC_VECTOR (2 downto 0);
variable tempWBDes : STD_LOGIC_VECTOR (3 downto 0);
variable tempWBSrc : STD_LOGIC;
variable tempMEMRead : STD_LOGIC;
variable tempMEMWrite : STD_LOGIC;
variable tempMEMSrc : STD_LOGIC_VECTOR (1 downto 0);
variable tempRegWrite : STD_LOGIC;
variable tempExtend,tempPC,tempIH,tempSP :  STD_LOGIC_VECTOR (15 downto 0);
variable tempRA,tempRx,tempRy :  STD_LOGIC_VECTOR (15 downto 0);
begin
	if(clk'event and clk = '1') then
		if(clear = '1') then
			outALUFunc <= "000";
			outALUSrc0 <= "00";
			outALUSrc1 <= "000";
			outWBDes <= "0000";
			outWBSrc <= '0';
			outMEMRead <= '0';
			outMEMWrite <= '0';
			outMEMSrc <= "00";
			outRegWrite <= '0';
			outExtend <= (others => '0');
			outSP <= (others => '0');
			outIH <= (others => '0');
			outPC <= (others => '0');
			outRA <= (others => '0');
			outRx <= (others => '0');
			outRy <= (others => '0');
			tempALUFunc := "000";
			tempALUSrc0 := "00";
			tempALUSrc1 := "000";
			tempWBDes := "0000";
			tempWBSrc := '0';
			tempMEMRead := '0';
			tempMEMWrite := '0';
			tempMEMSrc := "00";
			tempRegWrite := '0';
			tempExtend := (others => '0');
			tempIH := (others => '0');
			tempSP := (others => '0');
			tempPC := (others => '0');
			tempRA := (others => '0');
			tempRx := (others => '0');
			tempRy := (others => '0');
		elsif(pause = '1') then
			outALUFunc <= tempALUFunc;
			outALUSrc0 <= tempALUSrc0;
			outALUSrc1 <= tempALUSrc1;
			outWBDes <= tempWBDes;
			outWBSrc <= tempWBSrc;
			outMEMRead <= tempMEMRead;
			outMEMWrite <= tempMEMWrite;
			outMEMSrc <= tempMEMSrc;
			outRegWrite <= tempRegWrite;
			outExtend <= tempExtend;
			outIH <= tempIH;
			outSP <= tempSP;
			outPC <= tempPC;
			outRA <= tempRA;
			outRx <= tempRx;
			outRy <= tempRy;
		elsif(pause = '0') then
			tempALUFunc := inALUFunc;
			tempALUSrc0 := inALUSrc0;
			tempALUSrc1 := inALUSrc1;
			tempWBDes := inWBDes;
			tempWBSrc := inWBSrc;
			tempMEMRead := inMEMRead;
			tempMEMWrite := inMEMWrite;
			tempMEMSrc := inMEMSrc;
			tempRegWrite := inRegWrite;
			tempExtend := inExtend;
			tempPC := inPC;
			tempSP := inSP;
			tempIH := inIH;
			tempRA := inRA;
			tempRx := inRx;
			tempRy := inRy;
			outALUFunc <= inALUFunc;
			outALUSrc0 <= inALUSrc0;
			outALUSrc1 <= inALUSrc1;
			outWBDes <= inWBDes;
			outWBSrc <= inWBSrc;
			outMEMRead <= inMEMRead;
			outMEMWrite <= inMEMWrite;
			outMEMSrc <= inMEMSrc;
			outRegWrite <= inRegWrite;
			outExtend <= inExtend;
			outSP <= inSP;
			outIH <= inIH;
			outPC <= inPC;
			outRA <= inRA;
			outRx <= inRx;
			outRy <= inRy;
		end if;
	end if;
end process;

end Behavioral;


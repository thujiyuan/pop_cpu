----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    15:24:59 11/25/2016 
-- Design Name: 
-- Module Name:    Ram2Access - Behavioral 
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

entity Ram2Access is
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
end Ram2Access;

architecture Behavioral of Ram2Access is

begin
	process(pause, insRam2OE, insRam2WE, insRam2EN, insRam2Addr, insRam2Data,
						memRam2OE, memRam2WE, memRam2EN, memRam2Addr, memRam2DataOut)
	begin
		if(pause='0')then
			Ram2OE <= insRam2OE;
			Ram2WE <= insRam2WE;
			Ram2EN <= insRam2EN;
			Ram2Addr <= insRam2Addr;
			Ram2Data <= insRam2Data;
		else
			Ram2OE <= memRam2OE;
			Ram2WE <= memRam2WE;
			Ram2EN <= memRam2EN;
			Ram2Addr <= memRam2Addr;
			Ram2Data <= memRam2DataOut;
		end if;
	end process;
	process(Ram2Data)
	begin
		if(pause='0')then
			insRam2Data <= Ram2Data;
		elsif(memRead='1')then
			memRam2DataIn <= Ram2Data;
		end if;
	end process;
end Behavioral;


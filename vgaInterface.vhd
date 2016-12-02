----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    03:13:55 12/02/2016 
-- Design Name: 
-- Module Name:    vgaInterface - Behavioral 
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

entity vgaInterface is
    Port ( inData : in  STD_LOGIC_VECTOR (15 downto 0);
           outChar : out  STD_LOGIC_VECTOR (15 downto 0);
           memType : in  STD_LOGIC_VECTOR(2 downto 0);
           outWriteEnable : out  STD_LOGIC);
end vgaInterface;

architecture Behavioral of vgaInterface is

begin
	outChar <= inData;
	process(memType)
	begin
		if(memType = "101")then
			outWriteEnable <= '1';
		else
			outWriteEnable <= '0';
		end if;
	end process;
end Behavioral;


----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    16:53:08 12/01/2016 
-- Design Name: 
-- Module Name:    MEMTypeMUX - Behavioral 
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

entity MEMTypeMUX is
    Port ( INALURst : in  STD_LOGIC_VECTOR (15 downto 0);
           INMemRead : in  STD_LOGIC;
           INMemWrite : in  STD_LOGIC;
           OUTMemType : out  STD_LOGIC_VECTOR (2 downto 0));
end MEMTypeMUX;

architecture Behavioral of MEMTypeMUX is

begin
process(INALURst, INMemRead, INMemWrite)
begin
	if(INMemRead = '1') then
		if(INALURst < "1000000000000000") then
			OUTMemType <= "111";        --read ram2/disable
		elsif(INALURst = "1011111100000000") then
			OUTMemType <= "000";			 --read serial
		elsif(INALURst = "1011111100000001") then
			OUTMemType <= "001";			 --read serial status
		else
			OUTMemType <= "010";			 --read ram1
		end if;
	elsif(INMemWrite = '1') then
		if(INALURst < "1000000000000000") then
			OUTMemType <= "110";        --write ram2
		elsif(INALURst = "1011111100000000") then
			OUTMemType <= "011";			 --write serial
		elsif(INALURst = X"BF04") then
			OUTMemType <= "101";			 --write vga
		else
			OUTMemType <= "100";			 --write ram1
		end if;
	else
		 OUTMemType <= "111";
	end if;
end process;
end Behavioral;


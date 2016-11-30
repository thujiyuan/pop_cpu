----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    23:31:45 11/29/2016 
-- Design Name: 
-- Module Name:    shumaDecoder - Behavioral 
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

entity shumaDecoder is
    Port ( wei : in  STD_LOGIC_VECTOR (3 downto 0);
           decode : out  STD_LOGIC_VECTOR (6 downto 0));
end shumaDecoder;

architecture Behavioral of shumaDecoder is
	
begin
	process(wei)
	begin
		case wei is
			when "0000" =>
				decode <= not "1000000";
			when "0001" =>
				decode <= not "1111001";
			when "0010" =>
				decode <= not "0100100";
			when "0011" =>
				decode <= not "0110000";
			when "0100" =>
				decode <= not "0011001";
			when "0101" =>
				decode <= not "0010010";
			when "0110" =>
				decode <= not "0000010";
			when "0111" =>
				decode <= not "1111000";
			when "1000" =>
				decode <= not "0000000";
			when "1001" =>
				decode <= not "0010000";
			when "1010" =>
				decode <= not "0001000";
			when "1011" =>
				decode <= not "0000011";
			when "1100" =>
				decode <= not "1000110";
			when "1101" =>
				decode <= not "0100001";
			when "1110" =>
				decode <= not "0000110";
			when "1111" =>
				decode <= not "0001110";
			when others =>
				decode <= "0000000";
		end case;
	end process;
end Behavioral;


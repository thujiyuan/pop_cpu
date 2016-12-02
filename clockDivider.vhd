----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    22:21:19 11/29/2016 
-- Design Name: 
-- Module Name:    clockDivider - Behavioral 
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

entity clockDivider is
    Port ( inclk : in  STD_LOGIC;
			  rst : in STD_LOGIC;
           outclk : out  STD_LOGIC);
end clockDivider;

architecture Behavioral of clockDivider is

begin
	process(inclk, rst)
		variable state : std_logic_vector(16 downto 0) := (others=>'0');
		variable clk : std_logic := '0';
		variable paused : STD_LOGIC := '1';
	begin
	if(rst = '1') then
		if(inclk'event and inclk='1' and paused = '0')then
			if(state="00000000000000000")then
				outclk <= clk;
				clk := not clk;
				state := state + '1';
			elsif(state=2)then
				state := "00000000000000000";
			else
				state := state + '1';
			end if;	
		end if;
	else
		paused := not paused;
	end if;
	end process;
end Behavioral;


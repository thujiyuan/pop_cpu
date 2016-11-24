----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    18:31:40 11/23/2016 
-- Design Name: 
-- Module Name:    FlashAccess - Behavioral 
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
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity FlashAccess is
    Port ( flashWrite : in  STD_LOGIC;
           flashRead : in  STD_LOGIC;
           inAddr : in  STD_LOGIC_VECTOR (21 downto 0);
           addrBus : out  STD_LOGIC_VECTOR (22 downto 0);
           inData : in  STD_LOGIC_VECTOR (15 downto 0);
			  outData : out  STD_LOGIC_VECTOR (15 downto 0);
           dataBus : inout  STD_LOGIC_VECTOR (15 downto 0);
			  dataWrite : out STD_LOGIC;
			  dataReady : out STD_LOGIC;
           CE0 : out  STD_LOGIC;
           OE : out  STD_LOGIC;
           WE : out  STD_LOGIC;
			  clk : in STD_LOGIC);
end FlashAccess;

architecture Behavioral of FlashAccess is

begin
process(clk)
variable state : STD_LOGIC_VECTOR (4 downto 0) := "00000";
begin
	if(clk'event and clk = '1') then
		if(flashWrite = '1') then
			case state is
				when "00000" =>		--erase mode
					WE <= '0';
					CE0 <= '0';
					dataBus <= "0000000000100000";
					state := "00001";
				when "00001" =>		
					WE <= '1';
					state := "00010";
				when "00010" =>			--do erase
					WE <= '0';
					addrBus <= inAddr&'0';
					dataBus <= "0000000011010000";
					state := "00011";
				when "00011" =>
					WE <= '1';
					state := "01000";
	--			when "00100" =>			--check erase
	--				WE <= '0';
	--				dataBus <= "0000000001110000";
	--				state := "00101";
	--			when "00101" =>
	--				WE <= '1';
	--				state <= "00110";
	--			when "00110" =>
	--				OE <= '0';
	--				dataBus <= (others => 'Z');
	--				state := "00111";
	--			when "00111" =>
	--				if(dataBus(7) = '1') then
	--					state := "01000";
	--				else
	--					state := "00100";
	--				end if;
				when "01000" =>		--write mode
					WE <= '0';
					dataBus <= "0000000001000000";
					state := "01001";
				when "01001" =>
					WE <= '1';
					state := "01010";
				when "01010" =>		--do write
					WE <= '0';
					addrBus <= inAddr&'0';
					dataBus <= inData;
					state := "01011";
				when "01011" =>
					WE <= '1';
					dataWrite <= '1';
					state := "00000";
	--			when "01100" =>  --check write
	--				WE <= '0';
	--				dataBus <= "0000000001110000";
	--				state := "01101";
	--			when "01101" =>
	--				WE <= '1';
	--				state <= "01110";
	--			when "01110" =>
	--				OE <= '0';
	--				dataBus <= (others => 'Z');
	--				state := "01111";
	--			when "01111" =>
	--				if(dataBus(7) = '1') then
	--					state := "00000";
	--					modifying <= '0';
	--				else
	--					state := "01100";
	--				end if;
				when others =>
			end case;
		elsif(flashRead = '1') then
			case state is
				when "00000" =>	--read mode
					CE0 <= '0';
					WE <= '0';
					dataBus <= "0000000011111111";
					state := "10000";
				when "10000" =>
					WE <= '1';
					state := "10001";
				when "10001" =>  --do read
					OE <= '0';
					addrBus <= inAddr&'0';
					dataBus <= (others => 'Z');
					state := "10010";
				when "10010" =>
					OE <= '1';
					dataReady <= '1';
					state := "00000";
				when others =>
			end case;
		else
			state := "00000";
			dataReady <= '0';
			dataWrite <= '0';
		end if;
	end if;
end process;

end Behavioral;


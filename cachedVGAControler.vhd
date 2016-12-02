----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    23:45:25 12/01/2016 
-- Design Name: 
-- Module Name:    cachedVGAControler - Behavioral 
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
library work;
use work.recordDefs.ALL;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity cachedVGAControler is
		port(
			inX : in STD_LOGIC_VECTOR(9 downto 0);
			inY : in STD_LOGIC_VECTOR(9 downto 0);
			inChar : in STD_LOGIC_VECTOR(15 downto 0);
			inWriteEnable : in STD_LOGIC;
			outR : out STD_LOGIC_VECTOR(2 downto 0);
			outG : out STD_LOGIC_VECTOR(2 downto 0);
			outB : out STD_LOGIC_VECTOR(2 downto 0)
			);
end cachedVGAControler;

architecture Behavioral of cachedVGAControler is
	signal cache : bitmap ;
begin
process(inChar, inWriteEnable)
	variable cursorX : INTEGER range 0 to 80 := 0; --×Ö·û×ø±ê
	variable cursorY : INTEGER range 0 to 30 := 0; 
begin
	if(inWriteEnable'event and inWriteEnable='1') then
		case inchar(7 downto 0) is
								--next line
								--clear
			when others =>	--set the char
				cache(cursorY)(cursorX) <= inchar(7 downto 0);
				cursorX := cursorX + 1;
				if(cursorX = 80) then
					cursorX := 0;
					cursorY := cursorY + 1;
					if(cursorY = 30) then --page up
						cursorY := 29;
						cache(0 to 28) <= cache(1 to 29);
						cache(29) <= emptyRow;
					end if;
				end if;
		end case;
	end if;
end process;

process(inX, inY)
	variable charData : charNib := char_space;
	variable cursorX : INTEGER range 0 to 80 := 0; --×Ö·û×ø±ê
	variable cursorY : INTEGER range 0 to 30 := 0;
	variable pixelX : INTEGER range 0 to 7 := 0;		--ÏñËØ×ø±ê
	variable pixelY : INTEGER range 0 to 15 := 0;
begin
	cursorX := conv_integer(inX(9 downto 3));
	cursorY := conv_integer(inY(9 downto 4));
	pixelX := conv_integer(inX(2 downto 0));
	pixelY := conv_integer(inY(3 downto 0));
	case cache(cursorY)(cursorX) is
		when others =>
			charData := char_space;
	end case;
	
	case charData(pixelY)(pixelX) is
		when '0' =>
			outR <= "000";
			outG <= "000";
			outB <= "000";
		when others =>
			outR <= "111";
			outG <= "111";
			outB <= "111";
		end case;
end process;
end Behavioral;


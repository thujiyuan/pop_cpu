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
	signal cache : bitmap;
begin
process(inChar, inWriteEnable)
	variable charData : charNib := char_space;
	variable cursorX : STD_LOGIC_VECTOR(9 downto 0) := (others => '0'); --×Ö·û×ø±ê
	variable cursorY : STD_LOGIC_VECTOR(9 downto 0) := (others => '0'); 
	variable coorX : STD_LOGIC_VECTOR(9 downto 0) := (others => '0');	  --ÏñËØ×ø±ê
	variable coorY : STD_LOGIC_VECTOR(9 downto 0) := (others => '0');
	variable coorXint : integer range 0 to 640 := 0;	  --ÏñËØ×ø±ê
	variable coorYint : integer range 0 to 480 := 0;
begin
	if(inWriteEnable'event and inWriteEnable='1') then
		coorX(9 downto 0) := cursorX(9 downto 0); -- ÏñËØx×ø±êÎª×Ö·ûx×ø±ê*8
		coorY(9 downto 0) := cursorX(9 downto 0); -- ÏñËØy×ø±êÎª×Ö·ûy×ø±ê*16
		coorXint := conv_integer(coorX);
		coorYint := conv_integer(coorY);
		if(inChar(15)='0') then -- ascii
			case inChar(7 downto 0) is
				when X"30" =>
					charData := char_0;
				when X"31" =>
					charData := char_1;
				when X"32" =>
					charData := char_2;
				when X"33" =>
					charData := char_3;
				when X"34" =>
					charData := char_4;
				when X"35" =>
					charData := char_5;
				when X"36" =>
					charData := char_6;
				when X"37" =>
					charData := char_7;
				when X"38" =>
					charData := char_8;
				when X"39" =>
					charData := char_9;
				when X"3a" =>
					
				when X"3b" =>
					
				when X"3c" =>
					
				when X"3d" =>
					
				when X"3e" =>
					
				when X"3f" =>
					
				when X"40" =>
					
				when X"41" =>
					
				when X"42" =>
					
				when X"43" =>
					
				when X"44" =>
					
				when X"45" =>
					
				when X"46" =>
					
				when X"47" =>
					
				when X"48" =>
					
				when X"49" =>
					
				when X"4a" =>
					
				when X"4b" =>
					
				when X"4c" =>
					
				when X"4d" =>
					
				when X"4e" =>
					
				when X"4f" =>
					
				when X"50" =>
					
				when X"51" =>
					
				when X"52" =>
					
				when X"53" =>
					
				when X"54" =>
					
				when X"55" =>
					
				when X"56" =>
					
				when X"57" =>
					
				when X"58" =>
					
				when X"59" =>
					
				when X"5a" =>
					
				when X"5b" =>
					
				when X"5c" =>
					
				when X"5d" =>
					
				when X"5e" =>
					
				when X"5f" =>
					
				when X"60" =>
					
				when X"61" =>
					
				when X"62" =>
					
				when X"63" =>
					
				when X"64" =>
					
				when X"65" =>
					
				when others =>
						
				end case;
		else --number
		end if;
		cache(coorYint)(coorXint to coorXint + 7) <= charData(0)(7)
													  &charData(1)(7)
													  &charData(2)(7)
													  &charData(3)(7)
													  &charData(4)(7)
													  &charData(5)(7)
													  &charData(6)(7)
													  &charData(7)(7);

--		for i in 0 to 29 loop
--			for j in 0 to 79 loop
--				for row in 0 to 7 loop
--					for col in 0 to 7 loop
--						cache(16 * i + row)(8 * j + col) <= charData(col)(7 - row);
--					end loop;
--				end loop;
--				for row in 0 to 7 loop
--					for col in 0 to 7 loop
--						cache(16 * i + 8 + row)(8 * j + col) <= charData(col + 8)(7 - row);
--					end loop;
--				end loop;
--			end loop;
--		end loop;
		
	end if;
end process;

process(inX, inY)
begin
	outR <= "111";
	outG <= "111";
	outB <= "111";
end process;
end Behavioral;


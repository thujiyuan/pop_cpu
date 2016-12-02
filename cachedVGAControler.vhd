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
			outB : out STD_LOGIC_VECTOR(2 downto 0);
			VRAMclk : in STD_LOGIC
			);
end cachedVGAControler;

architecture Behavioral of cachedVGAControler is
	signal clka : STD_LOGIC := '0';
	signal wea : STD_LOGIC_VECTOR(0 DOWNTO 0) := (others => '0');
	signal addra : STD_LOGIC_VECTOR(11 DOWNTO 0) := (others => '0');
	signal dina : STD_LOGIC_VECTOR(7 DOWNTO 0) := (others => '0');
	signal douta : STD_LOGIC_VECTOR(7 DOWNTO 0) := (others => '0');
	signal clkb : STD_LOGIC := '0';
	signal web : STD_LOGIC_VECTOR(0 DOWNTO 0) := (others => '1');
	signal addrb : STD_LOGIC_VECTOR(11 DOWNTO 0) := (others => '0');
	signal dinb : STD_LOGIC_VECTOR(7 DOWNTO 0) := (others => '0');
	signal doutb : STD_LOGIC_VECTOR(7 DOWNTO 0) := (others => '0');
	
	signal tempchar : STD_LOGIC_VECTOR(7 downto 0) := (others => '0');
									 
	COMPONENT VGARam
  PORT (
    clka : IN STD_LOGIC;
    wea : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
    addra : IN STD_LOGIC_VECTOR(11 DOWNTO 0);
    dina : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
    douta : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
    clkb : IN STD_LOGIC;
    web : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
    addrb : IN STD_LOGIC_VECTOR(11 DOWNTO 0);
    dinb : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
    doutb : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
  );
END COMPONENT;
begin
vram : VGARam
  PORT MAP (
    clka => clka,
    wea => wea,
    addra => addra,
    dina => dina,
    douta => douta,
    clkb => clkb,
    web => web,
    addrb => addrb,
    dinb => dinb,
    doutb => doutb
  );
  
  web <= "1";
  wea <= "0";

process(VRAMclk)
variable cnt : STD_LOGIC_VECTOR(3 downto 0) := "0000"; 
begin
	if(VRAMclk'event and VRAMclk='1') then
		cnt := cnt + 1;
		--if(cnt = 4) then
			clka <= not clka;
			clkb <= not clkb;
			--cnt := "0000";
		--end if;
	end if;
end process;

process(inWriteEnable)
	variable cursorX : STD_LOGIC_VECTOR(6 downto 0) := (others => '0'); --×Ö·û×ø±ê
	variable cursorY : STD_LOGIC_VECTOR(4 downto 0) := (others => '0'); 
begin
	if(inWriteEnable'event and inWriteEnable='0') then
		addrb <= cursorX & cursorY;
		dinb <= tempChar;
		--addrb <= cursorX & cursorY;
		cursorX := cursorX + 1;
		if(cursorX = 79) then
			cursorY := cursorY + 1;
			cursorX := (others => '0');
			if(cursorY = 30) then
				cursorY := (others => '0');
			end if;
		end if;
	end if;
end process;

process(inWriteEnable)
begin
	if(inWriteEnable'event and inWriteEnable='1') then
		tempchar <= inChar(7 downto 0);
	end if;
end process;

process(inX, inY)
	variable cursorX : STD_LOGIC_VECTOR(6 downto 0) := (others => '0'); --×Ö·û×ø±ê
	variable cursorY : STD_LOGIC_VECTOR(4 downto 0) := (others => '0'); 
begin
	cursorX := inX(9 downto 3);
	cursorY := inY(8 downto 4);
	--addra <= cursorX & cursorY;
	addra <= cursorX & cursorY;
end process;

process(inX, inY, douta)
	variable charData : charNib := char_space;
	variable cursorX : INTEGER range 0 to 80 := 0; --×Ö·û×ø±ê
	variable cursorY : INTEGER range 0 to 30 := 0;
	variable pixelX : INTEGER range 0 to 7 := 0;		--ÏñËØ×ø±ê
	variable pixelY : INTEGER range 0 to 15 := 0;
	variable indexX : INTEGER range 0 to 7 := 0;		
	variable indexY : INTEGER range 0 to 15 := 0;
begin
	cursorX := conv_integer(inX(9 downto 3));
	cursorY := conv_integer(inY(9 downto 4));
	pixelX := conv_integer(inX(2 downto 0));
	pixelY := conv_integer(inY(3 downto 0));
	case douta is
		when X"20" =>
			charData := char_space; --¿Õ¸ñ
		when X"21" =>
			charData := char_exclamation; --!
		when X"22" =>
			charData := char_quote; --"
		when X"23" =>
			charData := char_pound; --#
		when X"24" =>
			charData := char_dollar; --$
		when X"25" =>
			charData := char_percent; --%
		when X"26" =>
			charData := char_and; --&
		when X"27" =>
			charData := char_singleQuate; --'
		when X"28" =>
			charData := char_leftBracket; --(
		when X"29" =>
			charData := char_rightBracket; --)
		when X"2A" =>
			charData := char_star; --*
		when X"2B" =>
			charData := char_plus; --+
		when X"2C" =>
			charData := char_comma; --,
		when X"2D" =>
			charData := char_minus; ---
		when X"2E" =>
			charData := char_dot; --.
		when X"2F" =>
			charData := char_slash; --/
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
		
		when X"41" =>
			charData := char_A_H;
		when X"42" =>
			charData := char_B_H;
		when X"43" =>
			charData := char_C_H;
		when X"44" =>
			charData := char_D_H;
		when X"45" =>
			charData := char_E_H;
		when X"46" =>
			charData := char_F_H;
		when X"47" =>
			charData := char_G_H;
		when X"48" =>
			charData := char_H_H;
		when X"49" =>
			charData := char_I_H;
		when X"4A" =>
			charData := char_J_H;
		when X"4B" =>
			charData := char_K_H;
		when X"4C" =>
			charData := char_L_H;
		when X"4D" =>
			charData := char_M_H;
		when X"4E" =>
			charData := char_N_H;
		when X"4F" =>
			charData := char_O_H;
		when X"50" =>
			charData := char_P_H;
		when X"51" =>
			charData := char_Q_H;
		when X"52" =>
			charData := char_R_H;
		when X"53" =>
			charData := char_S_H;
		when X"54" =>
			charData := char_T_H;
		when X"55" =>
			charData := char_U_H;
		when X"56" =>
			charData := char_V_H;
		when X"57" =>
			charData := char_W_H;
		when X"58" =>
			charData := char_X_H;
		when X"59" =>
			charData := char_Y_H;
		when X"5A" =>
			charData := char_Z_H;
		
		when X"5B" =>
			charData := char_openobracket; --[
		when X"5C" =>
			charData := char_backslash; --\
		when X"5D" =>
			charData := char_closeobracket; --]
		when X"5E" =>
			charData := char_power; --^ 
		when X"5F" =>
			charData := char_underline; --_
		when X"60" =>
			charData := char_minute; --`
			
		when X"61" =>
			charData := char_A_l;
		when X"62" =>
			charData := char_B_l;
		when X"63" =>
			charData := char_C_l;
		when X"64" =>
			charData := char_D_l;
		when X"65" =>
			charData := char_E_l;
		when X"66" =>
			charData := char_F_l;
		when X"67" =>
			charData := char_G_l;
		when X"68" =>
			charData := char_H_l;
		when X"69" =>
			charData := char_I_l;
		when X"6A" =>
			charData := char_J_l;
		when X"6B" =>
			charData := char_K_l;
		when X"6C" =>
			charData := char_L_l;
		when X"6D" =>
			charData := char_M_l;
		when X"6E" =>
			charData := char_N_l;
		when X"6F" =>
			charData := char_O_l;
		when X"70" =>
			charData := char_P_l;
		when X"71" =>
			charData := char_Q_l;
		when X"72" =>
			charData := char_R_l;
		when X"73" =>
			charData := char_S_l;
		when X"74" =>
			charData := char_T_l;
		when X"75" =>
			charData := char_U_l;
		when X"76" =>
			charData := char_V_l;
		when X"77" =>
			charData := char_W_l;
		when X"78" =>
			charData := char_X_l;
		when X"79" =>
			charData := char_Y_l;
		when X"7A" =>
			charData := char_Z_l;
		
		when X"7B" =>
			charData := char_leftBrace; --{
		when X"7C" =>
			charData := char_straightSlash; --|
		when X"7D" =>
			charData := char_rightBrace; --}
		when X"7E" =>
			charData := char_tilde; --~
		
		when others =>
			charData := char_star;
	end case;
	
	if(pixelY > 7) then
		indexY := pixelX + 8;
		indexX := 15 - pixelY;
	else 
		indexY := pixelX;
		indexX := 7 - pixelY;
	end if;
	
	case charData(indexY)(indexX) is
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


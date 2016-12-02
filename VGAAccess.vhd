----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    20:31:03 11/23/2016 
-- Design Name: 
-- Module Name:    VGAAccess - Behavioral 
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

entity VGAAccess is
    Port ( inclk : in  STD_LOGIC;
           Rin : in  STD_LOGIC_VECTOR (2 downto 0);
           Gin : in  STD_LOGIC_VECTOR (2 downto 0);
           Bin : in  STD_LOGIC_VECTOR (2 downto 0);
           Hs : out  STD_LOGIC;
           Vs : out  STD_LOGIC;
           Rout : out  STD_LOGIC_VECTOR (2 downto 0);
           Gout : out  STD_LOGIC_VECTOR (2 downto 0);
           Bout : out  STD_LOGIC_VECTOR (2 downto 0);
           xOut : out  STD_LOGIC_VECTOR (9 downto 0);
           yOut : out  STD_LOGIC_VECTOR (9 downto 0));
end VGAAccess;

architecture Behavioral of VGAAccess is
	signal clk : std_logic := '1';
begin

process(inclk)
	variable state : std_logic := '0';
begin
	if(inclk'event and inclk = '1') then
		if(state = '0') then
			state := '1';
		else
			clk <= not clk;
			state := '0';
		end if;
	end if;
end process;

process(clk)
variable xCnt : STD_LOGIC_VECTOR (9 downto 0) := (others => '0');
variable yCnt : STD_LOGIC_VECTOR (9 downto 0) := (others => '0');
variable valid : STD_LOGIC := '0';
begin
	if(clk'event and clk = '1') then
			valid := '1';
			if(xCnt > Hsa or yCnt > Vsa) then
				valid := '0';
			end if;
			if(xCnt >= Hsb and xCnt < Hsc) then
				Hs <= '0';
			else
				Hs <= '1';
			end if;
			if(yCnt >= Vsb and yCnt < Vsc) then
				Vs <= '0';
			else
				Vs <= '1';
			end if;
			if(valid = '1') then
				Rout <= Rin;
				Gout <= Gin;
				Bout <= Bin;
			else
				Rout <= "000";
				Gout <= "000";
				Bout <= "000";
			end if;
			if(xCnt = 799) then
				xCnt := (others => '0');
				yCnt := yCnt + 1;
			else
				xCnt := xCnt + 1;
			end if;
			if(yCnt = 525) then
				yCnt := (others => '0');
			end if;	
	end if;
	xOut <= xCnt;
	yOut <= yCnt;
end process;

end Behavioral;


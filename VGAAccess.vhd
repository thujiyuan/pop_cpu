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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity VGAAccess is
    Port ( clk : in  STD_LOGIC;
           Rin : in  STD_LOGIC_VECTOR (2 downto 0);
           Gin : in  STD_LOGIC_VECTOR (2 downto 0);
           Bin : in  STD_LOGIC_VECTOR (2 downto 0);
			  dataReady : in STD_LOGIC;
           Hs : out  STD_LOGIC;
           Vs : out  STD_LOGIC;
           Rout : out  STD_LOGIC_VECTOR (2 downto 0);
           Gout : out  STD_LOGIC_VECTOR (2 downto 0);
           Bout : out  STD_LOGIC_VECTOR (2 downto 0);
           xOut : out  STD_LOGIC_VECTOR (9 downto 0);
           yOut : out  STD_LOGIC_VECTOR (9 downto 0));
end VGAAccess;

architecture Behavioral of VGAAccess is

begin

process(clk)
variable xCnt : integer range 0 to 1000 := 0;
variable yCnt : integer range 0 to 1000 := 0;
variable valid : STD_LOGIC := '0';
begin
	if(dataReady = '1') then
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
			xCnt := 0;
		else
			xCnt := xCnt + 1;
		end if;
		if(yCnt = 524) then
			yCnt := 0;
		else
			yCnt := yCnt + 1;
		end if;	
		xOut <= xCnt;
		yOut <= yCnt;
	end if;
end process;

end Behavioral;


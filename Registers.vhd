----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    19:48:47 11/20/2016 
-- Design Name: 
-- Module Name:    Registers - Behavioral 
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

entity Registers is
    Port ( readRegister1 : in  STD_LOGIC_VECTOR (2 downto 0);
           readRegister2 : in  STD_LOGIC_VECTOR (2 downto 0);
           writeRegister : in  STD_LOGIC_VECTOR (3 downto 0);
           writeData : in  STD_LOGIC_VECTOR (15 downto 0);
           regWrite : in  STD_LOGIC;
           rx : out  STD_LOGIC_VECTOR (15 downto 0);
           ry : out  STD_LOGIC_VECTOR (15 downto 0);
           T : out  STD_LOGIC_VECTOR (15 downto 0);
           IH : out  STD_LOGIC_VECTOR (15 downto 0);
           SP : out  STD_LOGIC_VECTOR (15 downto 0);
			  RA : out  STD_LOGIC_VECTOR (15 downto 0);
			  clk : in STD_LOGIC);
end Registers;

architecture Behavioral of Registers is
	signal r000,r001,r010,r011,r100,r101,r110,r111,rIH,rSP,rT,rRA 
					: std_logic_vector(15 downto 0) := "0000000000000000";
begin
	process(readRegister1,readRegister2)	
	begin
		case readRegister1 is
			when "000" =>
				rx <= r000;
			when "001" =>
				rx <= r001;
			when "010" =>
				rx <= r010;
			when "011" =>
				rx <= r011;
				
			when "100" =>
				rx <= r100;
			when "101" =>
				rx <= r101;
			when "110" =>
				rx <= r110;
			when "111" =>
				rx <= r111;
			when others =>null;
		end case;
		case readRegister2 is
			when "000" =>
				ry <= r000;
			when "001" =>
				ry <= r001;
			when "010" =>
				ry <= r010;
			when "011" =>
				ry <= r011;
				
			when "100" =>
				ry <= r100;
			when "101" =>
				ry <= r101;
			when "110" =>
				ry <= r110;
			when "111" =>
				ry <= r111;
			when others =>null;
		end case;
		T <= rT;
		IH <= rIH;
		SP <= rSP;
		RA <= rRA;
	end process;
	process(writeRegister,writeData,regWrite,clk)
	begin
	if(clk'event and clk='0') then
			if(regWrite='1')then
				case writeRegister is
					when "0000" =>
						r000 <= writeData;
					when "0001" =>
						r001 <= writeData;
					when "0010" =>
						r010 <= writeData;
					when "0011" =>
						r011 <= writeData;
						
					when "0100" =>
						r100 <= writeData;
					when "0101" =>
						r101 <= writeData;
					when "0110" =>
						r110 <= writeData;
					when "0111" =>
						r111 <= writeData;
						
					when "1000" =>
						rIH <= writeData;
					when "1001" =>
						rSP <= writeData;
					when "1010" =>
						rT  <= writeData;
					when "1011" =>
						rRA <= writeData;
					when others =>null;
				end case;
			end if;
		end if;
	end process;
end Behavioral;

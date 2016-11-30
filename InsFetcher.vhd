----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    22:41:23 11/20/2016 
-- Design Name: 
-- Module Name:    InsFetcher - Behavioral 
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

entity InsFetcher is
	Port(	Ram2OE : out  STD_LOGIC;
			Ram2WE : out  STD_LOGIC;
			Ram2EN : out  STD_LOGIC;
			Ram2Addr : out STD_LOGIC_VECTOR(17 downto 0);
			Ram2Data : inout STD_LOGIC_VECTOR(15 downto 0);
			
			ins : out STD_LOGIC_VECTOR(15 downto 0);
			addr : in STD_LOGIC_VECTOR(15 downto 0);
			MEMAddr : in STD_LOGIC_VECTOR(17 downto 0);
			MEMReadData : out STD_LOGIC_VECTOR(15 downto 0);
			MEMWriteData : in STD_LOGIC_VECTOR(15 downto 0);
			MEMRead : in STD_LOGIC;
			MEMWrite : in STD_LOGIC);
			
end InsFetcher;

architecture Behavioral of InsFetcher is
	
begin
	process(addr, MEMWrite, MEMAddr, MEMRead, MEMWriteData)
	begin
		if(MEMWrite = '0' and MEMRead = '0') then --insfetch
			Ram2OE <= '0';
			Ram2WE <= '1';
			Ram2EN <= '0';
			Ram2Addr <= "00" & addr;
			Ram2Data <= (others => 'Z');
		elsif(MEMWrite = '0' and MEMRead = '1' and MEMAddr < "00" & X"8000") then --mem read ram2
			Ram2OE <= '0';
			Ram2WE <= '1';
			Ram2EN <= '0';
			Ram2Addr <= MEMAddr;
			Ram2Data <= (others => 'Z');
		elsif(MEMWrite = '1' and MEMRead = '0' and MEMAddr < "00" & X"8000") then --mem write ram2
			Ram2OE <= '1';
			Ram2WE <= '0';
			Ram2EN <= '0';
			Ram2Addr <= MEMAddr;
			Ram2Data <= MEMWriteData;
		else 
			Ram2OE <= '0';
			Ram2WE <= '1';
			Ram2EN <= '0';
			Ram2Addr <= "00" & addr;
			Ram2Data <= (others => 'Z');
		end if;
	end process;
	
	process(Ram2Data)
	begin
		if(MEMRead = '0' and MEMWrite = '0') then --insfetch
			ins <= Ram2Data;
		elsif(MEMWrite = '0' and MEMRead = '1' and MEMAddr < "00" & X"8000") then --mem read ram2
			MEMReadData <= Ram2Data;
			ins <= "0000100000000000";
		elsif(MEMWrite = '1' and MEMRead = '0' and MEMAddr < "00" & X"8000") then --mem write ram2
			ins <= "0000100000000000";
		else
			ins <= Ram2Data;
		end if;
	end process;

end Behavioral;


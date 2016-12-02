----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    20:48:18 11/20/2016 
-- Design Name: 
-- Module Name:    MEMAccess - Behavioral 
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

entity MEMAccess is
    Port ( inAddress : in  STD_LOGIC_VECTOR (15 downto 0);
           inMemType : in STD_LOGIC_VECTOR (2 downto 0);
           inData : in  STD_LOGIC_VECTOR (15 downto 0);
			  dataReady : in STD_LOGIC;
			  tsre : in STD_LOGIC;
			  tbre : in STD_LOGIC;
			  RAMbuffer : out STD_LOGIC_VECTOR (15 downto 0);
           RAM1addr : out  STD_LOGIC_VECTOR (17 downto 0);
           RAM1data : inout  STD_LOGIC_VECTOR (15 downto 0);
           RAM1OE : out  STD_LOGIC;
           RAM1WE : out  STD_LOGIC;
           RAM1EN : out  STD_LOGIC;
           RAM2addr : out  STD_LOGIC_VECTOR (17 downto 0);
           RAM2DataOut : out  STD_LOGIC_VECTOR (15 downto 0);
			  RAM2DataIn : In  STD_LOGIC_VECTOR (15 downto 0);
			  --RAM2Read : out STD_LOGIC;
			  --RAM2Write : out STD_LOGIC;
           rdn : out  STD_LOGIC;
           wrn : out  STD_LOGIC;
			  clk : in  STD_LOGIC;
			  rst : in STD_LOGIC);
end MEMAccess;

architecture Behavioral of MEMAccess is
begin
	RAM2Addr <= "00" & inAddress;
	RAM2DataOut <= inData;

process(inAddress, inMEMType, inData, clk, rst)
begin
--	if(inMEMRead = '1') then
--		if(inAddress = "1011111100000000") then -- read serial 
--			RAM1OE <= '1';
--			RAM1WE <= '1';
--			RAM1EN <= '1';
--			rdn <= '0';
--			wrn <= '1';
--			RAM1Data <= (others => 'Z');
--		elsif(inAddress = "1011111100000001") then -- read serial status
--			RAM1OE <= '1';
--			RAM1WE <= '1';
--			RAM1EN <= '1';
--			rdn <= '1';
--			wrn <= '1';
--			RAM1Data <= (others => 'Z');
--		else		--read ram1
--			rdn <= '1';
--			wrn <= '1';
--			RAM1OE <= '0';
--			RAM1WE <= '1';
--			RAM1EN <= '0';
--			Ram1Addr <= "00" & inAddress;
--			Ram1Data <= (others => 'Z');
--		end if;
--	elsif(inMEMWrite = '1') then
--		if(inAddress = "1011111100000000") then -- write serial
--			
--		elsif(inAddress < "1000000000000000") then --write ram2
--			
--		else		--write ram1
--			Ram1Addr <= "00" & inAddress;		
--		end if;
--		if(clk'event and clk = '0')then
--			if(inAddress = "1011111100000000") then -- write serial
--				RAM1Data <= inData;
--				RAM1OE <= '1';
--				RAM1WE <= '1';
--				RAM1EN <= '1';
--				wrn <= '0';
--				rdn <= '1';
--			elsif(inAddress < "1000000000000000") then --write ram2
--				
--			else		--write ram1
--				Ram1Data <= inData;
--				rdn <= '1';
--				wrn <= '1';
--				RAM1OE <= '1';
--				RAM1WE <= '0';
--				RAM1EN <= '0';
--			end if;
--		end if;
--	else
--		rdn <= '1';
--		wrn <= '1';
--		--RAM1OE <= '1';
--		--RAM1WE <= '1';
--		--RAM1EN <= '1';
--		--RAM2OE <= '1';
--		--RAM2WE <= '1';
--		--RAM2EN <= '1';
--		--Ram1Addr <= (others => '1');
--		--Ram2Addr <= (others => '1');
--		--Ram1Data <= (others => 'Z');
--	end if;
if(rst = '1') then
	if(clk'event and clk = '0') then
	case inMemType is
		when "000" => --read serial
			RAM1OE <= '1';
			RAM1WE <= '1';
			RAM1EN <= '1';
			rdn <= '0';
			wrn <= '1';
			RAM1Data <= (others => 'Z');
		when "001" => --read serial satus
			RAM1OE <= '1';
			RAM1WE <= '1';
			RAM1EN <= '1';
			rdn <= '1';
			wrn <= '1';
			--RAM1Data <= (others => 'Z');
		when "010" => --read ram1
			rdn <= '1';
			wrn <= '1';
			RAM1OE <= '0';
			RAM1WE <= '1';
			RAM1EN <= '0';
			Ram1Addr <= "00" & inAddress;
			Ram1Data <= (others => 'Z');
		when "011" => --write serial
			RAM1Data <= inData;
			RAM1OE <= '1';
			RAM1WE <= '1';
			RAM1EN <= '1';
			wrn <= '0';
			rdn <= '1';
		when "100" => --write ram1
			Ram1Data <= inData;
			Ram1Addr <= "00" & inAddress;
			rdn <= '1';
			wrn <= '1';
			RAM1OE <= '1';
			RAM1WE <= '0';
			RAM1EN <= '0';
		when others => --disable
			RAM1OE <= '1';
			RAM1WE <= '1';
			RAM1EN <= '1';
			rdn <= '1';
			wrn <= '1';
			--RAM1Data <= (others => 'Z');
		end case;
	end if;
else
	RAM1OE <= '1';
	RAM1WE <= '1';
	RAM1EN <= '1';
	rdn <= '1';
	wrn <= '1';
	RAM1Data <= (others => 'Z');
	Ram1Addr <= (others => '1');
end if;
end process;

process(RAM1Data, RAM2DataIn, dataReady, inAddress, tsre, inMemType, tbre)
begin
--	if(inAddress < "1000000000000000") then --read ram2
--		RAMBuffer <= RAM2DataIn;
--	elsif(inAddress = "1011111100000000") then --read serial
--		RAMBuffer <= "00000000" & RAM1Data(7 downto 0);
--	elsif(inAddress = "1011111100000001") then --read serial state
--		RAMBuffer <= "00000000000000" & dataReady & tsre;
--	else -- read ram1
--		RAMBuffer <= RAM1Data;
--	end if;
	case inMemType is
		when "000" => --read serial
			RAMBuffer <= "00000000" & RAM1Data(7 downto 0);
		when "001" => --read serial status
			RAMBuffer <= "00000000000000" & dataReady & (tsre and tbre);
		when "010" => --read ram1
			RAMBuffer <= RAM1Data;
		when "111" => --read ram2
			RAMBuffer <= RAM2DataIn;
		when others =>
			RAMBuffer <= ( others=>'0' );
	end case;
end process;

end Behavioral;


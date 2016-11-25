----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    13:23:05 11/25/2016 
-- Design Name: 
-- Module Name:    kernalWriter - Behavioral 
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

entity kernalWriter is
    Port ( RAM1Data : inout  STD_LOGIC_VECTOR (7 downto 0);
			  RAM1OE,RAM1WE,RAM1EN,rdn,wrn : out STD_LOGIC;
			  serialDataReady,tbre,tsre,clk : in STD_LOGIC;
			  flashAddr : out STD_LOGIC_VECTOR (22 downto 0);
			  flashData : inout STD_LOGIC_VECTOR (15 downto 0);
			  flashCE0  : out STD_LOGIC;
			  flashOE   : out STD_LOGIC;
			  flashWE   : out STD_LOGIC);
end kernalWriter;

architecture Behavioral of kernalWriter is
component FlashAccess	Port ( flashWrite : in  STD_LOGIC;
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
end component;
signal flashWrite : STD_LOGIC := '0';
signal inAddr : STD_LOGIC_VECTOR (21 downto 0) := (others => '0');
signal outData, inFlashData : STD_LOGIC_VECTOR (15 downto 0);
signal flashDataReady : STD_LOGIC := '0';
signal flashDataWrite : STD_LOGIC := '0';
signal flashDataReadyCfm : STD_LOGIC := '0';
signal flashDataWriteCfm : STD_LOGIC := '0';
begin
flash : FlashAccess port map(flashWrite, '0', inAddr, flashAddr, inFlashData, outData, flashData, flashDataWrite, flashDataReady,
										flashCE0, flashOE, flashWE, clk);

process(clk)
variable bytesRead : STD_LOGIC := '0';
variable state : STD_LOGIC_VECTOR(3 downto 0) := "0000";
variable instRead : STD_LOGIC_VECTOR(15 downto 0) := "0000000000000000";
variable instAddr : STD_LOGIC_VECTOR(15 downto 0) := "0000000000000000";
begin
if(clk'event and clk = '1') then
	case state is 
		when "0000" => 	-- read from uart
			RAM1OE <= '1';
			RAM1WE <= '1';
			RAM1EN <= '1';
			state := "0001";
		when "0001" =>
			rdn <= '1';
			RAM1Data <= (others => 'Z');
			state := "0010";
		when "0010" =>
			if(serialDataReady = '1') then
				rdn <= '0';
				state := "0011";
			else
				state := "0001";
			end if;
		when "0011" =>
			if(bytesRead = '0') then		--write lower half
				instRead(7 downto 0) := RAM1Data;
				bytesRead := '1';
				state := "0000";
			else									--write higher half and send to flash
				instRead(15 downto 8) := RAM1Data;
				bytesRead := '0';
				flashWrite <= '1';
				inAddr <= "100000"&instAddr;
				inFlashData <= instRead;
				state := "0100";
			end if;
		when "0100" =>							--wait until write over and write next
			if(flashDataWrite = '1') then
				instAddr := instAddr + "1";
				flashWrite <= '0';
				state := "0000";
			end if;	
		when others =>
		
	end case;
end if;	
end process;
end Behavioral;


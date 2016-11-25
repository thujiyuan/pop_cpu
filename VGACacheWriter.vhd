----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    17:21:41 11/24/2016 
-- Design Name: 
-- Module Name:    VGACacheWriter - Behavioral 
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
use recordDefs.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity VGACacheWriter is
    Port ( inPos : in  STD_LOGIC_VECTOR (15 downto 0);
           inChar : in  STD_LOGIC_VECTOR (15 downto 0);
			  WE : in STD_LOGIC;
			  writeOver : out STD_LOGIC;
			  flashAddr : out STD_LOGIC_VECTOR (22 downto 0);
			  flashData : inout STD_LOGIC_VECTOR (15 downto 0);
			  flashCE0  : out STD_LOGIC;
			  flashOE   : out STD_LOGIC;
			  flashWE   : out STD_LOGIC;
			  clk : in STD_LOGIC;
			  VGAPause : out STD_LOGIC);
end VGACacheWriter;

architecture Behavioral of VGACacheWriter is
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
variable bytesWrite : STD_LOGIC_VECTOR(3 downto 0) := "0000";
variable writing : STD_LOGIC := '0';
variable posX : STD_LOGIC_VECTOR(5 downto 0) := (others => '0');
variable posY : STD_LOGIC_VECTOR(5 downto 0) := (others => '0');
variable charMap : bitMap;
variable tempAddr : STD_LOGIC_VECTOR (21 downto 0) := (others => '0');
begin
	if(clk'event and clk = '1') then
		if(WE = '1' and writing = '0') then
			writing := '1';
			VGAPause <= '1';
			writeOver <= '0';
			posX := inPos(13 downto 8);
			posY := inPos(5 downto 0);
			case inChar(7 downto 0) is --确定要显示的字符
				when others =>
			end case;
		end if;
		if(writing = '1') then
				--写一个字到flash中
			if(flashDataWrite = '0') then  --计算要写的地址
				inAddr <= "000000"&posX&posY&bytesWrite;		--写一个字到flash
				inFlashData <= charMap(CONV_INTEGER(bytesWrite));
				flashWrite <= '1';
			else		--写下一个字
				if(bytesWrite /= "1111") then
					bytesWrite := bytesWrite + "1";
					flashWrite <= '0';
				else
					bytesWrite := "0000";	--写完，返回响应
					writing := '0';
					VGAPause <= '0';
					writeOver <= '1';
				end if;	
			end if;
		end if;
	end if;
end process;

end Behavioral;


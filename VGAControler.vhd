----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    21:12:48 11/23/2016 
-- Design Name: 
-- Module Name:    VGAControler - Behavioral 
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

entity VGAControler is
    Port ( xin : in  STD_LOGIC_VECTOR (9 downto 0);
           yin : in  STD_LOGIC_VECTOR (9 downto 0);
           Rout : out  STD_LOGIC_VECTOR (2 downto 0);
           Gout : out  STD_LOGIC_VECTOR (2 downto 0);
           Bout : out  STD_LOGIC_VECTOR (2 downto 0);
			  dataReady : out STD_LOGIC;
			  flashAddr : out STD_LOGIC_VECTOR (22 downto 0);
			  flashData : inout STD_LOGIC_VECTOR (15 downto 0);
			  flashCE0  : out STD_LOGIC;
			  flashOE   : out STD_LOGIC;
			  flashWE   : out STD_LOGIC;
			  pause		: in STD_LOGIC;
			  clk       : in STD_LOGIC);
end VGAControler;

architecture Behavioral of VGAControler is
component FlashAccess	Port ( flashWrite : in  STD_LOGIC;
           flashRead : in  STD_LOGIC;
           inAddr : in  STD_LOGIC_VECTOR (15 downto 0);
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
signal flashRead : STD_LOGIC := '0';
signal inAddr : STD_LOGIC_VECTOR (15 downto 0) := (others => '0');
signal outData : STD_LOGIC_VECTOR (15 downto 0);
signal modifying : STD_LOGIC;
signal flashDataReady : STD_LOGIC := '0';
signal flashDataWrite : STD_LOGIC := '0';
signal flashDataReadyCfm : STD_LOGIC := '0';
signal flashDataWriteCfm : STD_LOGIC := '0';
begin
flash : FlashAccess port map('0', flashRead, inAddr, flashAddr, (others => '0'), outData, flashData, flashDataWrite, flashDataReady,
										flashCE0, flashOE, flashWE, clk);
process(clk)
variable nowBuffer, nextBuffer : STD_LOGIC_VECTOR(15 downto 0);
variable nextBufferReady : STD_LOGIC := '0';
variable nextAddr : STD_LOGIC_VECTOR(15 downto 0) := (others => '0');
variable init : STD_LOGIC := '1';
variable xindex, yindex : STD_LOGIC_VECTOR(5 downto 0);	--下一段buffer在内存中的地址的（11 downto 6）和（5 downto 0）
variable bitNum : STD_LOGIC_VECTOR(3 downto 0);	--要求的像素点在buffer中的位置
begin
if(clk'event and clk = '1') then
	if(pause = '0') then
		if(init =  '1') then
			dataReady <= '0';
			if(flashDataReady = '0') then
				flashRead <= '1';
				inAddr <= "0000000000000000";
			else
				flashRead <= '0';
				nowBuffer := outData;
				init := '0';
			end if;
		else		--init end
			if(xin >= Hsa or yin >= Vsa) then --消隐区
				dataready <= '1';
			else
				if(nextBufferReady = '0') then	--下一个段帧缓存没准备好
					if(flashDataReady = '0') then		--计算下一段帧缓存的地址并向flash读取
						flashRead <= '1';
						xindex := xin(9 downto 4);
						yindex := yin(9 downto 4);
						xindex := xindex + "1";
						if(xindex >= maxCharH) then
							xindex := (others => '0');
							yindex := yindex + "1";
						end if;
						if(yindex >= maxCharV) then
							yindex := (others => '0');
						end if;
						nextAddr := "0000" & xindex & yindex;
						inAddr<= nextAddr;
					else		--读取已经准备好的帧
						nextBuffer := outData;
						nextBufferReady := '1';
						flashRead <= '0';
					end if;
				end if;
				
				bitNum := xin(3 downto 0);	--根据buffer值返回输出像素
				if(bitNum < 15) then
					case bitNum is
						when "1111" =>			--buffer用尽,如果nextbuffer没准备好则进行等待,否则正常输出
							if(nextBufferReady = '1') then
								if(nowBuffer(0) = '0') then
									Rout <= "000";
									Gout <= "000";
									Bout <= "000";
								else
									Rout <= "111";
									Gout <= "111";
									Bout <= "111";
								end if;
									dataReady <= '1';
									nowBuffer := nextBuffer;
									nextBufferReady := '0';
							else
									dataReady <= '0';
							end if;
						when others =>
							if(nowBuffer(CONV_INTEGER(bitNum)) = '0') then
									Rout <= "000";
									Gout <= "000";
									Bout <= "000";
								else
									Rout <= "111";
									Gout <= "111";
									Bout <= "111";
								end if;
									dataReady <= '1';		
					end case;
				end if;
			end if;	
		end if; 
	else
		dataReady <= '0';  --暂停信号来临时将VGA显示暂停
	end if;
end if;	
end process;
end Behavioral;


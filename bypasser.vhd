----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    20:52:52 11/20/2016 
-- Design Name: 
-- Module Name:    bypasser - Behavioral 
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

-- Uncomment IHe following library declaration if using
-- ariIHmetic functions wiIH Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment IHe following library declaration if instantiating
-- any Xilinx primitives in IHis code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity bypasser is
    Port ( inrx : in  STD_LOGIC_VECTOR (15 downto 0);
           inry : in  STD_LOGIC_VECTOR (15 downto 0);
           inT : in  STD_LOGIC_VECTOR (15 downto 0);
           inIH : in  STD_LOGIC_VECTOR (15 downto 0);
           inSP : in  STD_LOGIC_VECTOR (15 downto 0);
			  
			  rxNum : in  STD_LOGIC_VECTOR (2 downto 0);
           ryNum : in  STD_LOGIC_VECTOR (2 downto 0);
           instruction : in  STD_LOGIC_VECTOR (15 downto 0);
			  
           EXERegWrite : in  STD_LOGIC;
           EXEWBDes : in  STD_LOGIC_VECTOR (3 downto 0);
           EXEMemRead : in  STD_LOGIC;
           EXErst : in  STD_LOGIC_VECTOR (15 downto 0);
			  
           MEMRegWrite : in  STD_LOGIC;
           MEMWBDes : in  STD_LOGIC_VECTOR (3 downto 0);
           MEMMemRead : in  STD_LOGIC;
           MEMrst : in  STD_LOGIC_VECTOR (15 downto 0);
			  
           WBRegWrite : in  STD_LOGIC;
           WBWBDes : in  STD_LOGIC_VECTOR (3 downto 0);
           WBwriteData : in  STD_LOGIC_VECTOR (15 downto 0);
			  
           outrx : out  STD_LOGIC_VECTOR (15 downto 0);
           outry : out  STD_LOGIC_VECTOR (15 downto 0);
           outT : out  STD_LOGIC_VECTOR (15 downto 0);
           outIH : out  STD_LOGIC_VECTOR (15 downto 0);
           outSP : out  STD_LOGIC_VECTOR (15 downto 0);
           dataPause : out  STD_LOGIC);
end bypasser;

architecture Behavioral of bypasser is

begin
	process(inrx,inry,inT,inIH,inSP,rxNum,ryNum,instruction,
				EXERegWrite,EXEWBDes,EXEMemRead,EXErst,
				MEMRegWrite,MEMWBDes,MEMMemRead,MEMrst,
				WBRegWrite,WBWBDes,WBwriteData)
	begin
		--outrx datapause=0 or 1
		if(EXERegWrite='1' and EXEWBDes='0'&rxNum)then
			if(EXEMemRead='1')then
				case instruction(15 downto 11) is
					when "01101" =>--LI
						outrx <= EXErst;
						dataPause <= '0';
					when "00110" =>--SLL SRA
						outrx <= EXErst;
						dataPause <= '0';
					when "10010" =>--LW_SP
						outrx <= EXErst;
						dataPause <= '0';
					when "11110" =>--MFIH
						if(instruction(0)='0')then
							outrx <= EXErst;
							dataPause <= '0';
						else
							dataPause <= '1';
						end if;
					when "11101" =>--MFPC NEG
						if(instruction(7 downto 0) = "01000000")then
							outrx <= EXErst;
							dataPause <= '0';
						elsif(instruction(4 downto 0) = "01011")then
							outrx <= EXErst;
							dataPause <= '0';
						else
							dataPause <= '1';
						end if;
					when others =>
						dataPause <= '1';
				end case;
			else
				outrx <= EXErst;
				dataPause <= '0';
			end if;
		elsif(MEMRegWrite='1' and MEMWBDes='0'&rxNum)then
			if(MEMMemRead='1')then
				case instruction(15 downto 11) is
					when "01101" =>--LI
						outrx <= MEMrst;
						dataPause <= '0';
					when "00110" =>--SLL SRA
						outrx <= MEMrst;
						dataPause <= '0';
					when "10010" =>--LW_SP
						outrx <= MEMrst;
						dataPause <= '0';
					when "11110" =>--MFIH
						if(instruction(0)='0')then
							outrx <= MEMrst;
							dataPause <= '0';
						else
							dataPause <= '1';
						end if;
					when "11101" =>--MFPC NEG
						if(instruction(7 downto 0) = "01000000")then
							outrx <= MEMrst;
							dataPause <= '0';
						elsif(instruction(4 downto 0) = "01011")then
							outrx <= MEMrst;
							dataPause <= '0';
						else
							dataPause <= '1';
						end if;
					when others =>
						dataPause <= '1';
				end case;
			else
				outrx <= MEMrst;
				dataPause <= '0';
			end if;
		elsif(WBRegWrite='1' and WBWBDes='0'&rxNum)then
			outrx <= WBwriteData;
			dataPause <= '0';
		else
			outrx <= inrx;
			dataPause <= '0';
		end if;

		--outry datapause=1
		if(EXERegWrite='1' and EXEWBDes='0'&ryNum)then
			if(EXEMemRead='1')then
				case instruction(15 downto 11) is
					when "01000" =>--ADDIU3
						outry <= EXErst;
					when "10011" =>--LW
						outry <= EXErst;
					when others => 
						dataPause <= '1';
				end case;
			else
				outry <= EXErst;
			end if;
		elsif(MEMRegWrite='1' and MEMWBDes='0'&ryNum)then
			if(MEMMemRead='1')then
				case instruction(15 downto 11) is
					when "01000" =>--ADDIU3
						outry <= MEMrst;
					when "01001" =>--ADDIU
						outry <= MEMrst;		
					when "10011" =>--LW
						outry <= MEMrst;
					when others => 
						dataPause <= '1';
				end case;
			else
				outry <= MEMrst;
			end if;
		elsif(WBRegWrite='1' and WBWBDes='0'&ryNum)then
			outry <= WBwriteData;
		else
			outry <= inry;
		end if;

		--outT datapause=1
		if(EXERegWrite='1' and EXEWBDes="1010")then
			outT 	<= EXErst;
		elsif(MEMRegWrite='1' and MEMWBDes="1010")then
			outT 	<= MEMrst;
		elsif(WBRegWrite='1' and WBWBDes="1010")then
			outT 	<= WBwriteData;
		else
			outT 	<= inT;
		end if;

		--outIH datapause=1
		if(EXERegWrite='1' and EXEWBDes="1000")then
			outIH <= EXErst;
		elsif(MEMRegWrite='1' and MEMWBDes="1000")then
			outIH <= MEMrst;
		elsif(WBRegWrite='1' and WBWBDes="1000")then
			outIH <= WBwriteData;
		else
			outIH <= inIH;
		end if;

		--outSP datapause=1
		if(EXERegWrite='1' and EXEWBDes="1001")then
			outSP <= EXErst;
		elsif(MEMRegWrite='1' and MEMWBDes="1001")then
			outSP <= MEMrst;
		elsif(WBRegWrite='1' and WBWBDes="1001")then
			outSP <= WBwriteData;
		else
			outSP <= inSP;
		end if;
		
	end process;
end Behavioral;

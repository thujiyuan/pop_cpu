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
		if(EXERegWrite='1')then
			if(EXEWBDes='0'&rxNum)then
				if(EXEMemRead='1')then
					case instruction(15 downto 11) is
						when "01101" =>--LI
							outrx <= inrx;
							outry <= inry;
							outT 	<= inT;
							outIH <= inIH;
							outSP <= inSP;
							dataPause <= '0';
						when "00110" =>--SLL SRA
							outrx <= inrx;
							outry <= inry;
							outT 	<= inT;
							outIH <= inIH;
							outSP <= inSP;
							dataPause <= '0';
						when "10010" =>--LW_SP
							outrx <= inrx;
							outry <= inry;
							outT 	<= inT;
							outIH <= inIH;
							outSP <= inSP;
							dataPause <= '0';
						when "11110" =>--MFIH
							if(instruction(0)='0')then
								outrx <= inrx;
								outry <= inry;
								outT 	<= inT;
								outIH <= inIH;
								outSP <= inSP;
								dataPause <= '0';
							else
								dataPause <= '1';
							end if;
						when "11101" =>--MFPC NEG
							if(instruction(7 downto 0) = "01000000")then
								outrx <= inrx;
								outry <= inry;
								outT 	<= inT;
								outIH <= inIH;
								outSP <= inSP;
								dataPause <= '0';
							elsif(instruction(4 downto 0) = "01011")then
								outrx <= inrx;
								outry <= inry;
								outT 	<= inT;
								outIH <= inIH;
								outSP <= inSP;
								dataPause <= '0';
							else
								dataPause <= '1';
							end if;
						when others =>
							dataPause <= '1';
					end case;
				else
					outrx <= EXErst;
					outry <= inry;
					outT 	<= inT;
					outIH <= inIH;
					outSP <= inSP;
					dataPause <= '0';
				end if;
			elsif(EXEWBDes='0'&ryNum)then
				if(EXEMemRead='1')then
					case instruction(15 downto 11) is
						when "01000" =>--ADDIU3
							outrx <= inrx;
							outry <= inry;
							outT 	<= inT;
							outIH <= inIH;
							outSP <= inSP;
							dataPause <= '0';
						when "10011" =>--LW
							outrx <= inrx;
							outry <= inry;
							outT 	<= inT;
							outIH <= inIH;
							outSP <= inSP;
							dataPause <= '0';
						when others => 
							dataPause <= '1';
					end case;
				else
					outrx <= inrx;
					outry <= EXErst;
					outT 	<= inT;
					outIH <= inIH;
					outSP <= inSP;
					dataPause <= '0';
				end if;
			elsif(EXEWBDes="1010")then--T
				outrx <= inrx;
				outry <= inry;
				outT 	<= EXErst;
				outIH <= inIH;
				outSP <= inSP;
				dataPause <= '0';
			elsif(EXEWBDes="1000")then--IH
				outrx <= inrx;
				outry <= inry;
				outT 	<= inT;
				outIH <= EXErst;
				outSP <= inSP;
				dataPause <= '0';
			elsif(EXEWBDes="1001")then--SP
				outrx <= inrx;
				outry <= inry;
				outT 	<= inT;
				outIH <= inIH;
				outSP <= EXErst;
				dataPause <= '0';
			else
				outrx <= inrx;
				outry <= inry;
				outT 	<= inT;
				outIH <= inIH;
				outSP <= inSP;
				dataPause <= '0';
			end if;
		elsif(MEMRegWrite='1')then
			if(MEMWBDes='0'&rxNum)then
				if(MEMMemRead='1')then
					case instruction(15 downto 11) is
						when "01101" =>--LI
							outrx <= inrx;
							outry <= inry;
							outT 	<= inT;
							outIH <= inIH;
							outSP <= inSP;
							dataPause <= '0';
						when "00110" =>--SLL SRA
							outrx <= inrx;
							outry <= inry;
							outT 	<= inT;
							outIH <= inIH;
							outSP <= inSP;
							dataPause <= '0';
						when "10010" =>--LW_SP
							outrx <= inrx;
							outry <= inry;
							outT 	<= inT;
							outIH <= inIH;
							outSP <= inSP;
							dataPause <= '0';
						when "11110" =>--MFIH
							if(instruction(0)='0')then
								outrx <= inrx;
								outry <= inry;
								outT 	<= inT;
								outIH <= inIH;
								outSP <= inSP;
								dataPause <= '0';
							else
								dataPause <= '1';
							end if;
						when "11101" =>--MFPC NEG
							if(instruction(7 downto 0) = "01000000")then
								outrx <= inrx;
								outry <= inry;
								outT 	<= inT;
								outIH <= inIH;
								outSP <= inSP;
								dataPause <= '0';
							elsif(instruction(4 downto 0) = "01011")then
								outrx <= inrx;
								outry <= inry;
								outT 	<= inT;
								outIH <= inIH;
								outSP <= inSP;
								dataPause <= '0';
							else
								dataPause <= '1';
							end if;
						when others =>
							dataPause <= '1';
					end case;
				else
					outrx <= MEMrst;
					outry <= inry;
					outT 	<= inT;
					outIH <= inIH;
					outSP <= inSP;
					dataPause <= '0';
				end if;
			elsif(MEMWBDes='0'&ryNum)then
				if(MEMMemRead='1')then
					case instruction(15 downto 11) is
						when "01000" =>--ADDIU3
							outrx <= inrx;
							outry <= inry;
							outT 	<= inT;
							outIH <= inIH;
							outSP <= inSP;
							dataPause <= '0';
						when "10011" =>--LW
							outrx <= inrx;
							outry <= inry;
							outT 	<= inT;
							outIH <= inIH;
							outSP <= inSP;
							dataPause <= '0';
						when others => 
							dataPause <= '1';
					end case;
				else
					outrx <= inrx;
					outry <= MEMrst;
					outT 	<= inT;
					outIH <= inIH;
					outSP <= inSP;
					dataPause <= '0';
				end if;
			elsif(MEMWBDes="1010")then--T
				outrx <= inrx;
				outry <= inry;
				outT 	<= MEMrst;
				outIH <= inIH;
				outSP <= inSP;
				dataPause <= '0';
			elsif(MEMWBDes="1000")then--IH
				outrx <= inrx;
				outry <= inry;
				outT 	<= inT;
				outIH <= MEMrst;
				outSP <= inSP;
				dataPause <= '0';
			elsif(MEMWBDes="1001")then--SP
				outrx <= inrx;
				outry <= inry;
				outT 	<= inT;
				outIH <= inIH;
				outSP <= MEMrst;
				dataPause <= '0';
			else
				outrx <= inrx;
				outry <= inry;
				outT 	<= inT;
				outIH <= inIH;
				outSP <= inSP;
				dataPause <= '0';
			end if;
		elsif(WBRegWrite='1')then
			if(WBWBDes='0'&rxNum)then
				outrx <= WBwriteData;
				outry <= inry;
				outT 	<= inT;
				outIH <= inIH;
				outSP <= inSP;
				dataPause <= '0';
			elsif(WBWBDes='0'&ryNum)then
				outrx <= inrx;
				outry <= WBwriteData;
				outT 	<= inT;
				outIH <= inIH;
				outSP <= inSP;
				dataPause <= '0';
			elsif(WBWBDes="1010")then--T
				outrx <= inrx;
				outry <= inry;
				outT 	<= WBwriteData;
				outIH <= inIH;
				outSP <= inSP;
				dataPause <= '0';
			elsif(WBWBDes="1000")then--IH
				outrx <= inrx;
				outry <= inry;
				outT 	<= inT;
				outIH <= WBwriteData;
				outSP <= inSP;
				dataPause <= '0';
			elsif(WBWBDes="1001")then--SP
				outrx <= inrx;
				outry <= inry;
				outT 	<= inT;
				outIH <= inIH;
				dataPause <= '0';
				outSP <= WBwriteData;
			else
				outrx <= inrx;
				outry <= inry;
				outT 	<= inT;
				outIH <= inIH;
				outSP <= inSP;
				dataPause <= '0';
			end if;
		else
			outrx <= inrx;
			outry <= inry;
			outT 	<= inT;
			outIH <= inIH;
			outSP <= inSP;
			dataPause <= '0';
		end if;
	end process;
end Behavioral;

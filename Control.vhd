----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    22:34:56 11/20/2016 
-- Design Name: 
-- Module Name:    Control - Behavioral 
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

entity Control is
    Port ( instruction : in  STD_LOGIC_VECTOR (15 downto 0);
           rx : in  STD_LOGIC_VECTOR (15 downto 0);
           T : in  STD_LOGIC_VECTOR (15 downto 0);
           immSel : out  STD_LOGIC_VECTOR (2 downto 0);
           PCSelCtr : out  STD_LOGIC_VECTOR (1 downto 0);
           ALUFunc : out  STD_LOGIC_VECTOR (2 downto 0);
           ALUSrc0 : out  STD_LOGIC_VECTOR (1 downto 0);
           ALUSrc1 : out  STD_LOGIC_VECTOR (2 downto 0);
           MEMRead : out  STD_LOGIC;
           MEMWrite : out  STD_LOGIC;
           MEMSrc : out  STD_LOGIC_VECTOR (1 downto 0);
           WBDes : out  STD_LOGIC_VECTOR (3 downto 0);
           WBSrc : out  STD_LOGIC;
           RegWrite : out  STD_LOGIC);
end Control;

architecture Behavioral of Control is

begin
	process(instruction,rx,T)
	begin
		case instruction(15 downto 11) is
			when "01101" =>								--LI
				immSel <= "100";
				PCSelCtr <= "00";
				ALUFunc <= "011";
				ALUSrc0 <= "11";
				ALUSrc1 <= "000";
				MEMRead <= '0';
				MEMWrite <= '0';
				MEMSrc <= "00";
				WBDes <= '0'&instruction(10 downto 8);
				WBSrc <= '0';
				RegWrite <= '1';
			when "00110" =>
				case instruction(1 downto 0) is
					when "00" =>							--SLL
						immSel <= "000";
						PCSelCtr <= "00";
						ALUFunc <= "000";
						ALUSrc0 <= "00";
						ALUSrc1 <= "000";
						MEMRead <= '0';
						MEMWrite <= '0';
						MEMSrc <= "00";
						WBDes <= '0'&instruction(10 downto 8);
						WBSrc <= '0';
						RegWrite <= '1';
					when "11" =>							--SRA
						immSel <= "000";
						PCSelCtr <= "00";
						ALUFunc <= "010";
						ALUSrc0 <= "00";
						ALUSrc1 <= "000";
						MEMRead <= '0';
						MEMWrite <= '0';
						MEMSrc <= "00";
						WBDes <= '0'&instruction(10 downto 8);
						WBSrc <= '0';
						RegWrite <= '1';
					when others =>
						immSel <= "000";
						PCSelCtr <= "00";
						ALUFunc <= "111";
						ALUSrc0 <= "00";
						ALUSrc1 <= "001";
						MEMRead <= '0';
						MEMWrite <= '0';
						MEMSrc <= "00";
						WBDes <= '0'&instruction(10 downto 8);
						WBSrc <= '0';
						RegWrite <= '0';
				end case;
			when "11101" =>
				case instruction(4 downto 0) is
					when "00100" =>						--SLLV
						immSel <= "000";
						PCSelCtr <= "00";
						ALUFunc <= "000";
						ALUSrc0 <= "00";
						ALUSrc1 <= "001";
						MEMRead <= '0';
						MEMWrite <= '0';
						MEMSrc <= "00";
						WBDes <= '0'&instruction(7 downto 5);
						WBSrc <= '0';
						RegWrite <= '1';
					when "00110" =>						--SRLV
						immSel <= "000";
						PCSelCtr <= "00";
						ALUFunc <= "001";
						ALUSrc0 <= "00";
						ALUSrc1 <= "001";
						MEMRead <= '0';
						MEMWrite <= '0';
						MEMSrc <= "00";
						WBDes <= '0'&instruction(7 downto 5);
						WBSrc <= '0';
						RegWrite <= '1';
					when "01101" =>						--OR
						immSel <= "000";
						PCSelCtr <= "00";
						ALUFunc <= "110";
						ALUSrc0 <= "10";
						ALUSrc1 <= "010";
						MEMRead <= '0';
						MEMWrite <= '0';
						MEMSrc <= "00";
						WBDes <= '0'&instruction(10 downto 8);
						WBSrc <= '0';
						RegWrite <= '1';
					when "01100" =>						--AND
						immSel <= "000";
						PCSelCtr <= "00";
						ALUFunc <= "101";
						ALUSrc0 <= "10";
						ALUSrc1 <= "010";
						MEMRead <= '0';
						MEMWrite <= '0';
						MEMSrc <= "00";
						WBDes <= '0'&instruction(10 downto 8);
						WBSrc <= '0';
						RegWrite <= '1';
					when "00000" =>
						case instruction(7 downto 5) is
							when "010" =>					--MFPC
								immSel <= "000";
								PCSelCtr <= "00";
								ALUFunc <= "011";
								ALUSrc0 <= "11";
								ALUSrc1 <= "100";
								MEMRead <= '0';
								MEMWrite <= '0';
								MEMSrc <= "00";
								WBDes <= '0'&instruction(10 downto 8);
								WBSrc <= '0';
								RegWrite <= '1';
							when "000" =>					--JR
								immSel <= "000";
								PCSelCtr <= "10";
								ALUFunc <= "111";
								ALUSrc0 <= "00";
								ALUSrc1 <= "001";
								MEMRead <= '0';
								MEMWrite <= '0';
								MEMSrc <= "00";
								WBDes <= '0'&instruction(10 downto 8);
								WBSrc <= '0';
								RegWrite <= '0';
							when others =>
								immSel <= "000";
								PCSelCtr <= "00";
								ALUFunc <= "111";
								ALUSrc0 <= "00";
								ALUSrc1 <= "001";
								MEMRead <= '0';
								MEMWrite <= '0';
								MEMSrc <= "00";
								WBDes <= '0'&instruction(10 downto 8);
								WBSrc <= '0';
								RegWrite <= '0';
						end case;
					when "01010" =>						--CMP
						immSel <= "000";
						PCSelCtr <= "00";
						ALUFunc <= "111";
						ALUSrc0 <= "10";
						ALUSrc1 <= "010";
						MEMRead <= '0';
						MEMWrite <= '0';
						MEMSrc <= "00";
						WBDes <= "1010";
						WBSrc <= '0';
						RegWrite <= '1';
					when "01011" =>						--NEG
						immSel <= "000";
						PCSelCtr <= "00";
						ALUFunc <= "100";
						ALUSrc0 <= "11";
						ALUSrc1 <= "010";
						MEMRead <= '0';
						MEMWrite <= '0';
						MEMSrc <= "00";
						WBDes <= '0'&instruction(10 downto 8);
						WBSrc <= '0';
						RegWrite <= '1';
					when others =>
						immSel <= "000";
						PCSelCtr <= "00";
						ALUFunc <= "111";
						ALUSrc0 <= "00";
						ALUSrc1 <= "001";
						MEMRead <= '0';
						MEMWrite <= '0';
						MEMSrc <= "00";
						WBDes <= '0'&instruction(10 downto 8);
						WBSrc <= '0';
						RegWrite <= '0';
				end case;
			when "01100" => 
				case instruction(10 downto 8) is
					when "011" => 							--ADDSP
						immSel <= "011";
						PCSelCtr <= "00";
						ALUFunc <= "011";
						ALUSrc0 <= "01";
						ALUSrc1 <= "000";
						MEMRead <= '0';
						MEMWrite <= '0';
						MEMSrc <= "00";
						WBDes <= "1001";
						WBSrc <= '0';
						RegWrite <= '1';
					when "010" => 							--SW_RS
						immSel <= "011";
						PCSelCtr <= "00";
						ALUFunc <= "011";
						ALUSrc0 <= "01";
						ALUSrc1 <= "000";
						MEMRead <= '0';
						MEMWrite <= '1';
						MEMSrc <= "10";
						WBDes <= '0'&instruction(10 downto 8);
						WBSrc <= '0';
						RegWrite <= '0';
					when "100" => 							--MTSP
						immSel <= "000";
						PCSelCtr <= "00";
						ALUFunc <= "011";
						ALUSrc0 <= "11";
						ALUSrc1 <= "001";
						MEMRead <= '0';
						MEMWrite <= '0';
						MEMSrc <= "00";
						WBDes <= "1001";
						WBSrc <= '0';
						RegWrite <= '1';
					when "000" => 							--BTEQZ
						immSel <= "011";
						if(T="0000000000000000")then
							PCSelCtr <= "01";
						else
							PCSelCtr <= "00";
						end if;
						ALUFunc <= "111";
						ALUSrc0 <= "00";
						ALUSrc1 <= "001";
						MEMRead <= '0';
						MEMWrite <= '0';
						MEMSrc <= "00";
						WBDes <= '0'&instruction(10 downto 8);
						WBSrc <= '0';
						RegWrite <= '0';
					when "001" => 							--BTNEZ
						immSel <= "011";
						if(T="0000000000000001")then
							PCSelCtr <= "01";
						else
							PCSelCtr <= "00";
						end if;
						ALUFunc <= "111";
						ALUSrc0 <= "00";
						ALUSrc1 <= "001";
						MEMRead <= '0';
						MEMWrite <= '0';
						MEMSrc <= "00";
						WBDes <= '0'&instruction(10 downto 8);
						WBSrc <= '0';
						RegWrite <= '0';
					when others =>
						immSel <= "000";
						PCSelCtr <= "00";
						ALUFunc <= "111";
						ALUSrc0 <= "00";
						ALUSrc1 <= "001";
						MEMRead <= '0';
						MEMWrite <= '0';
						MEMSrc <= "00";
						WBDes <= '0'&instruction(10 downto 8);
						WBSrc <= '0';
						RegWrite <= '0';
				end case;
			when "01000" =>								--ADDIU3
				immSel <= "001";
				PCSelCtr <= "00";
				ALUFunc <= "011";
				ALUSrc0 <= "10";
				ALUSrc1 <= "000";
				MEMRead <= '0';
				MEMWrite <= '0';
				MEMSrc <= "00";
				WBDes <= '0'&instruction(7 downto 5);
				WBSrc <= '0';
				RegWrite <= '1';
			when "11100" =>
				case instruction(1 downto 0) is
					when "01" =>							--ADDU 
						immSel <= "000";
						PCSelCtr <= "00";
						ALUFunc <= "011";
						ALUSrc0 <= "10";
						ALUSrc1 <= "010";
						MEMRead <= '0';
						MEMWrite <= '0';
						MEMSrc <= "00";
						WBDes <= '0'&instruction(4 downto 2);
						WBSrc <= '0';
						RegWrite <= '1';
					when "11" =>							--SUBU
						immSel <= "000";
						PCSelCtr <= "00";
						ALUFunc <= "100";
						ALUSrc0 <= "10";
						ALUSrc1 <= "010";
						MEMRead <= '0';
						MEMWrite <= '0';
						MEMSrc <= "00";
						WBDes <= '0'&instruction(4 downto 2);
						WBSrc <= '0';
						RegWrite <= '1';
					when others => 
						immSel <= "000";
						PCSelCtr <= "00";
						ALUFunc <= "111";
						ALUSrc0 <= "00";
						ALUSrc1 <= "001";
						MEMRead <= '0';
						MEMWrite <= '0';
						MEMSrc <= "00";
						WBDes <= '0'&instruction(10 downto 8);
						WBSrc <= '0';
						RegWrite <= '0';
				end case;
			when "11010" => 								--SW_SP
				immSel <= "011";
				PCSelCtr <= "00";
				ALUFunc <= "011";
				ALUSrc0 <= "01";
				ALUSrc1 <= "000";
				MEMRead <= '0';
				MEMWrite <= '1';
				MEMSrc <= "00";
				WBDes <= '0'&instruction(10 downto 8);
				WBSrc <= '0';
				RegWrite <= '0';
			when "11011" => 								--SW
				immSel <= "010";
				PCSelCtr <= "00";
				ALUFunc <= "011";
				ALUSrc0 <= "10";
				ALUSrc1 <= "000";
				MEMRead <= '0';
				MEMWrite <= '1';
				MEMSrc <= "01";
				WBDes <= '0'&instruction(10 downto 8);
				WBSrc <= '0';
				RegWrite <= '0';
			when "10011" =>								--LW 
				immSel <= "010";
				PCSelCtr <= "00";
				ALUFunc <= "011";
				ALUSrc0 <= "10";
				ALUSrc1 <= "000";
				MEMRead <= '1';
				MEMWrite <= '0';
				MEMSrc <= "00";
				WBDes <= '0'&instruction(7 downto 5);
				WBSrc <= '1';
				RegWrite <= '1';
			when "10010" => 								--LW_SP
				immSel <= "011";
				PCSelCtr <= "00";
				ALUFunc <= "011";
				ALUSrc0 <= "01";
				ALUSrc1 <= "000";
				MEMRead <= '1';
				MEMWrite <= '0';
				MEMSrc <= "00";
				WBDes <= '0'&instruction(10 downto 8);
				WBSrc <= '1';
				RegWrite <= '1';
			when "11110" =>
				case instruction(7 downto 0) is
					when "00000000" => 					--MFIH
						immSel <= "000";
						PCSelCtr <= "00";
						ALUFunc <= "011";
						ALUSrc0 <= "11";
						ALUSrc1 <= "011";
						MEMRead <= '0';
						MEMWrite <= '0';
						MEMSrc <= "00";
						WBDes <= '0'&instruction(10 downto 8);
						WBSrc <= '0';
						RegWrite <= '1';
					when "00000001" => 					--MTIH
						immSel <= "000";
						PCSelCtr <= "00";
						ALUFunc <= "011";
						ALUSrc0 <= "11";
						ALUSrc1 <= "001";
						MEMRead <= '0';
						MEMWrite <= '0';
						MEMSrc <= "00";
						WBDes <= "1000";
						WBSrc <= '0';
						RegWrite <= '1';
					when others => 
						immSel <= "000";
						PCSelCtr <= "00";
						ALUFunc <= "111";
						ALUSrc0 <= "00";
						ALUSrc1 <= "001";
						MEMRead <= '0';
						MEMWrite <= '0';
						MEMSrc <= "00";
						WBDes <= '0'&instruction(10 downto 8);
						WBSrc <= '0';
						RegWrite <= '0';
					end case;
			when "00010" =>								--B 
				immSel <= "100";
				PCSelCtr <= "01";
				ALUFunc <= "111";
				ALUSrc0 <= "00";
				ALUSrc1 <= "001";
				MEMRead <= '0';
				MEMWrite <= '0';
				MEMSrc <= "00";
				WBDes <= '0'&instruction(10 downto 8);
				WBSrc <= '0';
				RegWrite <= '0';
			when "00100" => 								--BEQZ
				immSel <= "011";
				if(rx="0000000000000000")then
					PCSelCtr <= "01";
				else
					PCSelCtr <= "00";
				end if;
				ALUFunc <= "111";
				ALUSrc0 <= "00";
				ALUSrc1 <= "001";
				MEMRead <= '0';
				MEMWrite <= '0';
				MEMSrc <= "00";
				WBDes <= '0'&instruction(10 downto 8);
				WBSrc <= '0';
				RegWrite <= '0';
			when "00101" =>								--BNEZ
				immSel <= "011";
				if(rx="0000000000000000")then
					PCSelCtr <= "00";
				else
					PCSelCtr <= "01";
				end if;
				ALUFunc <= "111";
				ALUSrc0 <= "00";
				ALUSrc1 <= "001";
				MEMRead <= '0';
				MEMWrite <= '0';
				MEMSrc <= "00";
				WBDes <= '0'&instruction(10 downto 8);
				WBSrc <= '0';
				RegWrite <= '0';
			when others => 
				immSel <= "000";
				PCSelCtr <= "00";
				ALUFunc <= "111";
				ALUSrc0 <= "00";
				ALUSrc1 <= "001";
				MEMRead <= '0';
				MEMWrite <= '0';
				MEMSrc <= "00";
				WBDes <= '0'&instruction(10 downto 8);
				WBSrc <= '0';
				RegWrite <= '0';
		end case;
	end process;
end Behavioral;


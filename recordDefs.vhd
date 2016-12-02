--
--	Package File Template
--
--	Purpose: This package defines supplemental types, subtypes, 
--		 constants, and functions 
--
--   To use any of the example code shown below, uncomment the lines and modify as necessary
--

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_UNSIGNED.all;

package recordDefs is

type ALUFuncRec is record
	sigSLL : STD_LOGIC_VECTOR (2 downto 0);
	sigSRL : STD_LOGIC_VECTOR (2 downto 0);
	sigSRA : STD_LOGIC_VECTOR (2 downto 0);
	sigADD : STD_LOGIC_VECTOR (2 downto 0);
	sigSUB : STD_LOGIC_VECTOR (2 downto 0);
	sigAND : STD_LOGIC_VECTOR (2 downto 0);
	sigOR  : STD_LOGIC_VECTOR (2 downto 0);
	sigCMP : STD_LOGIC_VECTOR (2 downto 0);
end record;

constant ALUFunc : ALUFuncRec := (
					sigSLL => "000",
					sigSRL => "001",
					sigSRA => "010",
					sigADD => "011",
					sigSUB => "100",
					sigAND => "101",
					sigOR  => "110",
					sigCMP => "111");

type ALUSrc0Rec is record
	rx : STD_LOGIC_VECTOR (1 downto 0);
	ry : STD_LOGIC_VECTOR (1 downto 0);
	zero : STD_LOGIC_VECTOR (1 downto 0);
	SP : STD_LOGIC_VECTOR (1 downto 0);
end record;					

constant ALUSrc0 : ALUSrc0Rec := (
					ry => "00",
					SP => "01",
					rx => "10",
					zero => "11");
					
type ALUSrc1Rec is record
	imm : STD_LOGIC_VECTOR (2 downto 0);
	rx  : STD_LOGIC_VECTOR (2 downto 0);
	ry  : STD_LOGIC_VECTOR (2 downto 0);
	IH  : STD_LOGIC_VECTOR (2 downto 0);
	PC  : STD_LOGIC_VECTOR (2 downto 0);
end record;

constant ALUSrc1 : ALUSrc1Rec := (
					imm => "000",
					rx  => "001",
					ry  => "010",
					IH  => "011",
					PC  => "100");
					
					
type MEMSrcRec is record
	rx : STD_LOGIC_VECTOR (1 downto 0);
	ry : STD_LOGIC_VECTOR (1 downto 0);
	RA : STD_LOGIC_VECTOR (1 downto 0);
end record;

constant MEMSrc : MEMSrcRec := (
					rx => "00",
					ry => "01",
					RA => "10");
			
constant Hsa : integer range 0 to 1000 := 640;	--行显示区的开始
constant Hsb : integer range 0 to 1000 := 656;	--行消隐区的开始
constant Hsc : integer range 0 to 1000 := 752;	--行消隐区中0段的开始
constant Hsd : integer range 0 to 1000 := 800;	--行消隐区中0段的结束

constant Vsa : integer range 0 to 1000 := 480;	--同上，对应场区
constant Vsb : integer range 0 to 1000 := 490;
constant Vsc : integer range 0 to 1000 := 492;
constant Vsd : integer range 0 to 1000 := 525;

constant maxCharH : STD_LOGIC_VECTOR(5 downto 0) := "101000"; --一行最多显示40个字符
constant maxCharV : STD_LOGIC_VECTOR(5 downto 0) := "011110"; --一列最多显示30个字符

type bitMap is array(0 to 480) of STD_LOGIC_VECTOR(0 to 640);
type charNib is array(0 to 15) of STD_LOGIC_VECTOR(0 to 7);

constant char_0 : charNib := (
										X"00", X"E0", X"10", X"08", 
										X"08", X"10", X"E0", X"00", 
										X"00", X"0F", X"10", X"20", 
										X"20", X"10", X"0F", X"00");
constant char_1 : charNib := (
										X"00", X"10", X"10", X"F8", 
										X"00", X"00", X"00", X"00", 
										X"00", X"20", X"20", X"3F", 
										X"20", X"20", X"00", X"00");
constant char_2 : charNib := (
										X"00", X"70", X"08", X"08", 
										X"08", X"88", X"70", X"00", 
										X"00", X"30", X"28", X"24", 
										X"22", X"21", X"30", X"00");
constant char_3 : charNib := (
										X"00", X"30", X"08", X"88", 
										X"88", X"48", X"30", X"00", 
										X"00", X"00", X"18", X"20", 
										X"20", X"11", X"0E", X"00");
constant char_4 : charNib := (
										X"00", X"00", X"C0", X"20", 
										X"10", X"F8", X"00", X"00", 
										X"00", X"07", X"04", X"24", 
										X"24", X"3F", X"24", X"00");
constant char_5 : charNib := (
										X"00", X"F8", X"08", X"88", 
										X"88", X"08", X"08", X"00", 
										X"00", X"19", X"21", X"20", 
										X"20", X"11", X"0E", X"00");
constant char_6 : charNib := (
										X"00", X"E0", X"10", X"88", 
										X"88", X"18", X"00", X"00", 
										X"00", X"0F", X"11", X"20", 
										X"20", X"11", X"0E", X"00");
constant char_7 : charNib := (
										X"00", X"38", X"08", X"08", 
										X"C8", X"38", X"08", X"00", 
										X"00", X"00", X"00", X"3F", 
										X"00", X"00", X"00", X"00");
constant char_8 : charNib := (
										X"00", X"70", X"88", X"08", 
										X"08", X"88", X"70", X"00", 
										X"00", X"1C", X"22", X"21", 
										X"21", X"22", X"1C", X"00");
constant char_9 : charNib := (
										X"00", X"E0", X"10", X"08", 
										X"08", X"10", X"E0", X"00", 
										X"00", X"00", X"31", X"22", 
										X"22", X"11", X"0F", X"00");
constant char_space : charNib := ( -- --
										X"00", X"00", X"00", X"00", 
										X"00", X"00", X"00", X"00", 
										X"00", X"00", X"00", X"00", 
										X"00", X"00", X"00", X"00");
constant char_exclamation : charNib := ( --!
										X"00", X"00", X"00", X"F8", 
										X"00", X"00", X"00", X"00", 
										X"00", X"00", X"00", X"33", 
										X"30", X"00", X"00", X"00");
constant char_quote : charNib := ( --"
										X"00", X"10", X"0C", X"06", 
										X"10", X"0C", X"06", X"00", 
										X"00", X"00", X"00", X"00", 
										X"00", X"00", X"00", X"00");
constant char_pound : charNib := ( --#
										X"40", X"C0", X"78", X"40", 
										X"C0", X"78", X"40", X"00", 
										X"04", X"3F", X"04", X"04", 
										X"3F", X"04", X"04", X"00");
constant char_dollar : charNib := ( --$
										X"00", X"70", X"88", X"FC", 
										X"08", X"30", X"00", X"00", 
										X"00", X"18", X"20", X"FF", 
										X"21", X"1E", X"00", X"00");
constant char_percent : charNib := ( --%
										X"F0", X"08", X"F0", X"00", 
										X"E0", X"18", X"00", X"00", 
										X"00", X"21", X"1C", X"03", 
										X"1E", X"21", X"1E", X"00");
constant char_and : charNib := ( --&
										X"00", X"F0", X"08", X"88", 
										X"70", X"00", X"00", X"00", 
										X"1E", X"21", X"23", X"24", 
										X"19", X"27", X"21", X"10");
constant char_singleQuate : charNib := ( --'
										X"10", X"16", X"0E", X"00", 
										X"00", X"00", X"00", X"00", 
										X"00", X"00", X"00", X"00", 
										X"00", X"00", X"00", X"00");
constant char_leftBracket : charNib := ( --(
										X"00", X"00", X"00", X"E0", 
										X"18", X"04", X"02", X"00", 
										X"00", X"00", X"00", X"07", 
										X"18", X"20", X"40", X"00");
constant char_rightBracket : charNib := ( --)
										X"00", X"02", X"04", X"18", 
										X"E0", X"00", X"00", X"00", 
										X"00", X"40", X"20", X"18", 
										X"07", X"00", X"00", X"00");
constant char_star : charNib := ( --*
										X"40", X"40", X"80", X"F0", 
										X"80", X"40", X"40", X"00", 
										X"02", X"02", X"01", X"0F", 
										X"01", X"02", X"02", X"00");
constant char_plus : charNib := ( --+
										X"00", X"00", X"00", X"F0", 
										X"00", X"00", X"00", X"00", 
										X"01", X"01", X"01", X"1F", 
										X"01", X"01", X"01", X"00");
constant char_comma : charNib := ( --,
										X"00", X"00", X"00", X"00", 
										X"00", X"00", X"00", X"00", 
										X"80", X"B0", X"70", X"00", 
										X"00", X"00", X"00", X"00");
constant char_minus : charNib := ( ---
										X"00", X"00", X"00", X"00", 
										X"00", X"00", X"00", X"00", 
										X"00", X"01", X"01", X"01", 
										X"01", X"01", X"01", X"01");
constant char_dot : charNib := ( --.
										X"00", X"00", X"00", X"00", 
										X"00", X"00", X"00", X"00", 
										X"00", X"30", X"30", X"00", 
										X"00", X"00", X"00", X"00");
constant char_slash : charNib := ( --/
										X"00", X"00", X"00", X"00", 
										X"80", X"60", X"18", X"04", 
										X"00", X"60", X"18", X"06", 
										X"01", X"00", X"00", X"00");
constant char_A_H : charNib := ( 
										X"00", X"00", X"C0", X"38", 
										X"E0", X"00", X"00", X"00", 
										X"20", X"3C", X"23", X"02", 
										X"02", X"27", X"38", X"20"); 

constant char_B_H : charNib := ( 
										X"08", X"F8", X"88", X"88", 
										X"88", X"70", X"00", X"00", 
										X"20", X"3F", X"20", X"20", 
										X"20", X"11", X"0E", X"00"); 

constant char_C_H : charNib := ( 
										X"C0", X"30", X"08", X"08", 
										X"08", X"08", X"38", X"00", 
										X"07", X"18", X"20", X"20", 
										X"20", X"10", X"08", X"00"); 

constant char_D_H : charNib := ( 
										X"08", X"F8", X"08", X"08", 
										X"08", X"10", X"E0", X"00", 
										X"20", X"3F", X"20", X"20", 
										X"20", X"10", X"0F", X"00"); 

constant char_E_H : charNib := ( 
										X"08", X"F8", X"88", X"88", 
										X"E8", X"08", X"10", X"00", 
										X"20", X"3F", X"20", X"20", 
										X"23", X"20", X"18", X"00"); 

constant char_F_H : charNib := ( 
										X"08", X"F8", X"88", X"88", 
										X"E8", X"08", X"10", X"00", 
										X"20", X"3F", X"20", X"00", 
										X"03", X"00", X"00", X"00"); 

constant char_G_H : charNib := ( 
										X"C0", X"30", X"08", X"08", 
										X"08", X"38", X"00", X"00", 
										X"07", X"18", X"20", X"20", 
										X"22", X"1E", X"02", X"00");

constant char_H_H : charNib := ( 
										X"08", X"F8", X"08", X"00", 
										X"00", X"08", X"F8", X"08", 
										X"20", X"3F", X"21", X"01", 
										X"01", X"21", X"3F", X"20"); 

constant char_I_H : charNib := ( 
										X"00", X"08", X"08", X"F8", 
										X"08", X"08", X"00", X"00", 
										X"00", X"20", X"20", X"3F", 
										X"20", X"20", X"00", X"00"); 

constant char_J_H : charNib := ( 
										X"00", X"00", X"08", X"08", 
										X"F8", X"08", X"08", X"00", 
										X"C0", X"80", X"80", X"80", 
										X"7F", X"00", X"00", X"00"); 

constant char_K_H : charNib := ( 
										X"08", X"F8", X"88", X"C0", 
										X"28", X"18", X"08", X"00", 
										X"20", X"3F", X"20", X"01", 
										X"26", X"38", X"20", X"00"); 

constant char_L_H : charNib := ( 
										X"08", X"F8", X"08", X"00", 
										X"00", X"00", X"00", X"00", 
										X"20", X"3F", X"20", X"20", 
										X"20", X"20", X"30", X"00"); 

constant char_M_H : charNib := ( 
										X"08", X"F8", X"F8", X"00", 
										X"F8", X"F8", X"08", X"00", 
										X"20", X"3F", X"00", X"3F", 
										X"00", X"3F", X"20", X"00");  

constant char_N_H : charNib := ( 
										X"08", X"F8", X"30", X"C0", 
										X"00", X"08", X"F8", X"08", 
										X"20", X"3F", X"20", X"00", 
										X"07", X"18", X"3F", X"00"); 

constant char_O_H : charNib := ( 
										X"E0", X"10", X"08", X"08", 
										X"08", X"10", X"E0", X"00", 
										X"0F", X"10", X"20", X"20", 
										X"20", X"10", X"0F", X"00"); 

constant char_P_H : charNib := ( 
										X"08", X"F8", X"08", X"08", 
										X"08", X"08", X"F0", X"00", 
										X"20", X"3F", X"21", X"01", 
										X"01", X"01", X"00", X"00"); 

constant char_Q_H : charNib := ( 
										X"E0", X"10", X"08", X"08", 
										X"08", X"10", X"E0", X"00", 
										X"0F", X"18", X"24", X"24", 
										X"38", X"50", X"4F", X"00"); 

constant char_R_H : charNib := ( 
										X"08", X"F8", X"88", X"88", 
										X"88", X"88", X"70", X"00", 
										X"20", X"3F", X"20", X"00", 
										X"03", X"0C", X"30", X"20"); 

constant char_S_H : charNib := ( 
										X"00", X"70", X"88", X"08", 
										X"08", X"08", X"38", X"00", 
										X"00", X"38", X"20", X"21", 
										X"21", X"22", X"1C", X"00"); 

constant char_T_H : charNib := ( 
										X"18", X"08", X"08", X"F8", 
										X"08", X"08", X"18", X"00", 
										X"00", X"00", X"20", X"3F", 
										X"20", X"00", X"00", X"00"); 

constant char_U_H : charNib := ( 
										X"08", X"F8", X"08", X"00", 
										X"00", X"08", X"F8", X"08", 
										X"00", X"1F", X"20", X"20", 
										X"20", X"20", X"1F", X"00"); 

constant char_V_H : charNib := ( 
										X"08", X"78", X"88", X"00", 
										X"00", X"C8", X"38", X"08", 
										X"00", X"00", X"07", X"38", 
										X"0E", X"01", X"00", X"00"); 

constant char_W_H : charNib := ( 
										X"F8", X"08", X"00", X"F8", 
										X"00", X"08", X"F8", X"00", 
										X"03", X"3C", X"07", X"00", 
										X"07", X"3C", X"03", X"00"); 

constant char_X_H : charNib := ( 
										X"08", X"18", X"68", X"80", 
										X"80", X"68", X"18", X"08", 
										X"20", X"30", X"2C", X"03", 
										X"03", X"2C", X"30", X"20"); 

constant char_Y_H : charNib := ( 
										X"08", X"38", X"C8", X"00", 
										X"C8", X"38", X"08", X"00", 
										X"00", X"00", X"20", X"3F", 
										X"20", X"00", X"00", X"00"); 

constant char_Z_H : charNib := ( 
										X"10", X"08", X"08", X"08", 
										X"C8", X"38", X"08", X"00", 
										X"20", X"38", X"26", X"21", 
										X"20", X"20", X"18", X"00"); 

constant char_underline: charNib := ( 
										X"00", X"00", X"00", X"00", 
										X"00", X"00", X"00", X"00", 
										X"80", X"80", X"80", X"80", 
										X"80", X"80", X"80", X"80"); 

constant char_power : charNib := ( 
										X"00", X"00", X"04", X"02", 
										X"02", X"02", X"04", X"00", 
										X"00", X"00", X"00", X"00", 
										X"00", X"00", X"00", X"00"); 

constant char_openobracket : charNib := ( 
										X"00", X"00", X"00", X"FE", 
										X"02", X"02", X"02", X"00", 
										X"00", X"00", X"00", X"7F", 
										X"40", X"40", X"40", X"00"); 

constant char_closeobracket : charNib := ( 
										X"00", X"02", X"02", X"02", 
										X"FE", X"00", X"00", X"00", 
										X"00", X"40", X"40", X"40", 
										X"7F", X"00", X"00", X"00");

constant char_backslash : charNib := ( 
										X"00", X"0C", X"30", X"C0", 
										X"00", X"00", X"00", X"00", 
										X"00", X"00", X"00", X"01", 
										X"06", X"38", X"C0", X"00");

constant char_minute : charNib := ( 
										X"00", X"02", X"02", X"04", 
										X"00", X"00", X"00", X"00", 
										X"00", X"00", X"00", X"00", 
										X"00", X"00", X"00", X"00");   

constant char_A_l : charNib := (
                                                X"00",X"00",X"80",X"80",
                                                X"80",X"80",X"00",X"00",
                                                X"00",X"19",X"24",X"22",
                                                X"22",X"22",X"3F",X"20");

constant char_B_l : charNib := (
                                                X"08",X"F8",X"00",X"80",
                                                X"80",X"00",X"00",X"00",
                                                X"00",X"3F",X"11",X"20",
                                                X"20",X"11",X"0E",X"00");

constant char_C_l : charNib := (
                                                X"00",X"00",X"00",X"80",
                                                X"80",X"80",X"00",X"00",
                                                X"00",X"0E",X"11",X"20",
                                                X"20",X"20",X"11",X"00");

constant char_D_l : charNib := (
                                                X"00",X"00",X"00",X"80",
                                                X"80",X"88",X"F8",X"00",
                                                X"00",X"0E",X"11",X"20",
                                                X"20",X"10",X"3F",X"20");

constant char_E_l : charNib := (
                                                X"00",X"00",X"80",X"80",
                                                X"80",X"80",X"00",X"00",
                                                X"00",X"1F",X"22",X"22",
                                                X"22",X"22",X"13",X"00");

constant char_F_l : charNib := (
                                                X"00",X"80",X"80",X"F0",
                                                X"88",X"88",X"88",X"18",
                                                X"00",X"20",X"20",X"3F",
                                                X"20",X"20",X"00",X"00");

constant char_G_l : charNib := (
                                                X"00",X"00",X"80",X"80",
                                                X"80",X"80",X"80",X"00",
                                                X"00",X"6B",X"94",X"94",
                                                X"94",X"93",X"60",X"00");

constant char_H_l : charNib := (
                                                X"08",X"F8",X"00",X"80",
                                                X"80",X"80",X"00",X"00",
                                                X"20",X"3F",X"21",X"00",
                                                X"00",X"20",X"3F",X"20");

constant char_I_l : charNib := (
                                                X"00",X"80",X"98",X"98",
                                                X"00",X"00",X"00",X"00",
                                                X"00",X"20",X"20",X"3F",
                                                X"20",X"20",X"00",X"00");

constant char_J_l : charNib := (
                                                X"00",X"00",X"00",X"80",
                                                X"98",X"98",X"00",X"00",
                                                X"00",X"C0",X"80",X"80",
                                                X"80",X"7F",X"00",X"00");

constant char_K_l : charNib := (
                                                X"08",X"F8",X"00",X"00",
                                                X"80",X"80",X"80",X"00",
                                                X"20",X"3F",X"24",X"02",
                                                X"2D",X"30",X"20",X"00");

constant char_L_l : charNib := (
                                                X"00",X"08",X"08",X"F8",
                                                X"00",X"00",X"00",X"00",
                                                X"00",X"20",X"20",X"3F",
                                                X"20",X"20",X"00",X"00");

constant char_M_l : charNib := (
                                                X"80",X"80",X"80",X"80",
                                                X"80",X"80",X"80",X"00",
                                                X"20",X"3F",X"20",X"00",
                                                X"3F",X"20",X"00",X"3F");

constant char_N_l : charNib := (
                                                X"80",X"80",X"00",X"80",
                                                X"80",X"80",X"00",X"00",
                                                X"20",X"3F",X"21",X"00",
                                                X"00",X"20",X"3F",X"20");

constant char_O_l : charNib := (
                                                X"00",X"00",X"80",X"80",
                                                X"80",X"80",X"00",X"00",
                                                X"00",X"1F",X"20",X"20",
                                                X"20",X"20",X"1F",X"00");

constant char_P_l : charNib := (
                                                X"80",X"80",X"00",X"80",
                                                X"80",X"00",X"00",X"00",
                                                X"80",X"FF",X"A1",X"20",
                                                X"20",X"11",X"0E",X"00");

constant char_Q_l : charNib := (
                                                X"00",X"00",X"00",X"80",
                                                X"80",X"80",X"80",X"00",
                                                X"00",X"0E",X"11",X"20",
                                                X"20",X"A0",X"FF",X"80");

constant char_R_l : charNib := (
                                                X"80",X"80",X"80",X"00",
                                                X"80",X"80",X"80",X"00",
                                                X"00",X"33",X"24",X"24",
                                                X"24",X"24",X"19",X"00");

constant char_S_l : charNib := (
                                                X"00",X"00",X"80",X"80",
                                                X"80",X"80",X"80",X"00",
                                                X"00",X"33",X"24",X"24",
                                                X"24",X"24",X"19",X"00");

constant char_T_l : charNib := (
                                                X"00",X"80",X"80",X"E0",
                                                X"80",X"80",X"00",X"00",
                                                X"00",X"00",X"00",X"1F",
                                                X"20",X"20",X"00",X"00");

constant char_U_l : charNib := (
                                                X"80",X"80",X"00",X"00",
                                                X"00",X"80",X"80",X"00",
                                                X"00",X"1F",X"20",X"20",
                                                X"20",X"10",X"3F",X"20");

constant char_V_l : charNib := (
                                                X"80",X"80",X"80",X"00",
                                                X"00",X"80",X"80",X"80",
                                                X"00",X"01",X"0E",X"30",
                                                X"08",X"06",X"01",X"00");

constant char_W_l : charNib := (
                                                X"80",X"80",X"00",X"80",
                                                X"00",X"80",X"80",X"80",
                                                X"0F",X"30",X"0C",X"03",
                                                X"0C",X"30",X"0F",X"00");

constant char_X_l : charNib := (
                                                X"00",X"80",X"80",X"00",
                                                X"80",X"80",X"80",X"00",
                                                X"00",X"20",X"31",X"2E",
                                                X"0E",X"31",X"20",X"00");

constant char_Y_l : charNib := (
                                                X"80",X"80",X"80",X"00",
                                                X"00",X"80",X"80",X"80",
                                                X"80",X"81",X"8E",X"70",
                                                X"18",X"06",X"01",X"00");

constant char_Z_l : charNib := (
                                                X"00",X"80",X"80",X"80",
                                                X"80",X"80",X"80",X"00",
                                                X"00",X"21",X"30",X"2C",
                                                X"22",X"21",X"30",X"00");

constant char_leftBrace : charNib := (
                                                X"00",X"80",X"80",X"80",
                                                X"80",X"80",X"80",X"00",
                                                X"00",X"21",X"30",X"2C",
                                                X"22",X"21",X"30",X"00");

constant char_straightSlash : charNib := (
                                                X"00",X"00",X"00",X"00",
                                                X"FF",X"00",X"00",X"00",
                                                X"00",X"00",X"00",X"00",
                                                X"FF",X"00",X"00",X"00");

constant char_rightBrace : charNib := (
                                                X"00",X"02",X"02",X"7C",
                                                X"80",X"00",X"00",X"00",
                                                X"00",X"40",X"40",X"3F",
                                                X"00",X"00",X"00",X"00");

constant char_tilde : charNib := (
                                                X"00",X"06",X"01",X"01",
                                                X"02",X"02",X"04",X"04",
                                                X"00",X"00",X"00",X"00",
                                                X"00",X"00",X"00",X"00");

                                                                                                


										
end recordDefs;



package body recordDefs is

 
end recordDefs;

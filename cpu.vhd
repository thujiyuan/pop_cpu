library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;

entity cpu is
end cpu;

architecture Behavioral of cpu is
	component pop_cpu
		port ( clk : in std_logic;
			 RAM1OE : out  STD_LOGIC;
			 RAM1WE : out  STD_LOGIC;
			 RAM1EN : out  STD_LOGIC;
			 RAM1addr : out  STD_LOGIC_VECTOR (17 downto 0);
			 RAM1data : inout  STD_LOGIC_VECTOR (15 downto 0);
			 Ram2OE : out  STD_LOGIC;
			 Ram2WE : out  STD_LOGIC;
			 Ram2EN : out  STD_LOGIC;
			 Ram2Addr : out STD_LOGIC_VECTOR(17 downto 0);
			 Ram2Data : inout STD_LOGIC_VECTOR(15 downto 0);
			 dataReady : in STD_LOGIC;
			 tsre : in STD_LOGIC;
			 rdn : out STD_LOGIC;
			 wrn : out STD_LOGIC);
	end component;
	signal clk : std_logic := '1';
	signal RAM1OE : STD_LOGIC := '0';
	signal RAM1WE : STD_LOGIC := '0';
	signal RAM1EN : STD_LOGIC := '0';
	signal RAM1addr : STD_LOGIC_VECTOR (17 downto 0) :=(others=>'0');
	signal RAM1data : STD_LOGIC_VECTOR (15 downto 0) :=(others=>'0');
	signal Ram2OE : STD_LOGIC := '0';
	signal Ram2WE : STD_LOGIC := '0';
	signal Ram2EN : STD_LOGIC := '0';
	signal Ram2Addr : STD_LOGIC_VECTOR(17 downto 0) :=(others=>'0');
	signal Ram2Data : STD_LOGIC_VECTOR(15 downto 0) :=(others=>'0');
	signal dataReady : STD_LOGIC := '0';
	signal tsre : STD_LOGIC := '0';
	signal rdn : STD_LOGIC := '0';
	signal wrn : STD_LOGIC := '0';
	signal cnt : STD_LOGIC_VECTOR(3 downto 0) := "0000";
begin
	c : pop_cpu port map(clk, RAM1OE, RAM1WE, RAM1EN, RAM1addr, RAM1data,
				Ram2OE, Ram2WE, Ram2EN, Ram2Addr, Ram2Data,
				dataReady, tsre, rdn, wrn);
	clk <= not clk after 100ns;
	cnt <= cnt + "1" after 200ns;
	process(Ram2Addr)
	begin
	case Ram2Addr is
		when "000000000000000000" =>
			Ram2Data <= "0110100010111111";   --li 000 BF
		when "000000000000000001" =>
			Ram2Data <= "0011000000000000";   --sll 000 8
		when "000000000000000010" =>
			Ram2Data <= "0100100000000001";   --addiu 000 1
		when "000000000000000011" =>
			Ram2Data <= "1001100000100000";   --lw 000 001 0
		--when "000000000000000100" =>
			--Ram2Data <= "0110100000100000"; 
		--when "000000000000000101" =>
			--Ram2Data <= X"db20";
		--when "000000000000000110" =>
			--Ram2Data <= X"db41"; 
		--when "000000000000000111" =>
			--Ram2Data <= X"e145";

		--when "000000000000001000" =>
			--Ram2Data <= X"e149";	 
		--when "000000000000001001" =>
			--Ram2Data <= X"4b02";
		--when "000000000000001010" =>
			--Ram2Data <= X"4cff";
		--when "000000000000001011" =>
			--Ram2Data <= X"2cf9"; 

		when others => 
			Ram2Data <= "0000100000000000"; --nop
	end case;
	end process;
	process(RAM1addr,rdn)
	begin
		if(RAM1EN='0')then
			case RAM1addr is
				when "00"&X"BF00" =>
					RAM1data <= X"1001";
				when others =>
					RAM1data <= X"0000";
			end case;
		else
			if(rdn='0')then
				RAM1data <= X"1001";
			end if;
			dataReady <= '1';
			tsre <= '1';
		end if;
	end process;
end Behavioral;
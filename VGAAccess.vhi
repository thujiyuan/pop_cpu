
-- VHDL Instantiation Created from source file VGAAccess.vhd -- 21:07:31 11/23/2016
--
-- Notes: 
-- 1) This instantiation template has been automatically generated using types
-- std_logic and std_logic_vector for the ports of the instantiated module
-- 2) To use this template to instantiate this entity, cut-and-paste and then edit

	COMPONENT VGAAccess
	PORT(
		clk : IN std_logic;
		Rin : IN std_logic_vector(2 downto 0);
		Gin : IN std_logic_vector(2 downto 0);
		Bin : IN std_logic_vector(2 downto 0);
		dataReady : IN std_logic;          
		Hs : OUT std_logic;
		Vs : OUT std_logic;
		Rout : OUT std_logic_vector(2 downto 0);
		Gout : OUT std_logic_vector(2 downto 0);
		Bout : OUT std_logic_vector(2 downto 0);
		xOut : OUT std_logic_vector(9 downto 0);
		yOut : OUT std_logic_vector(9 downto 0)
		);
	END COMPONENT;

	Inst_VGAAccess: VGAAccess PORT MAP(
		clk => ,
		Rin => ,
		Gin => ,
		Bin => ,
		dataReady => ,
		Hs => ,
		Vs => ,
		Rout => ,
		Gout => ,
		Bout => ,
		xOut => ,
		yOut => 
	);



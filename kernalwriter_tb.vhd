LIBRARY ieee  ; 
USE ieee.std_logic_1164.all  ; 
USE ieee.std_logic_arith.all  ; 
USE ieee.STD_LOGIC_UNSIGNED.all  ; 
ENTITY kernalwriter_tb  IS 
END ; 
 
ARCHITECTURE kernalwriter_tb_arch OF kernalwriter_tb IS
  SIGNAL flashData   :  std_logic_vector (15 downto 0)  ; 
  SIGNAL flashOE   :  STD_LOGIC  ; 
  SIGNAL RAM1Data   :  std_logic_vector (7 downto 0) := (others => '0') ; 
  SIGNAL RAM1EN   :  STD_LOGIC  ; 
  SIGNAL rdn   :  STD_LOGIC  ; 
  SIGNAL RAM1OE   :  STD_LOGIC  ; 
  SIGNAL flashCE0   :  STD_LOGIC  ; 
  SIGNAL wrn   :  STD_LOGIC  ; 
  SIGNAL serialDataReady   :  STD_LOGIC  := '0'; 
  SIGNAL flashAddr   :  std_logic_vector (22 downto 0)  ; 
  SIGNAL flashWE   :  STD_LOGIC  ; 
  SIGNAL clk   :  STD_LOGIC  := '0'; 
  SIGNAL RAM1WE   :  STD_LOGIC  ; 
  SIGNAL tbre   :  STD_LOGIC  ; 
  SIGNAL tsre   :  STD_LOGIC  ; 
  COMPONENT kernalWriter  
    PORT ( 
      flashData  : inout std_logic_vector (15 downto 0) ; 
      flashOE  : out STD_LOGIC ; 
      RAM1Data  : inout std_logic_vector (7 downto 0) ; 
      RAM1EN  : out STD_LOGIC ; 
      rdn  : out STD_LOGIC ; 
      RAM1OE  : out STD_LOGIC ; 
      flashCE0  : out STD_LOGIC ; 
      wrn  : out STD_LOGIC ; 
      serialDataReady  : in STD_LOGIC ; 
      flashAddr  : out std_logic_vector (22 downto 0) ; 
      flashWE  : out STD_LOGIC ; 
      clk  : in STD_LOGIC ; 
      RAM1WE  : out STD_LOGIC ; 
      tbre  : in STD_LOGIC ; 
      tsre  : in STD_LOGIC ); 
  END COMPONENT ; 
BEGIN
  DUT  : kernalWriter  
    PORT MAP ( 
      flashData   => flashData  ,
      flashOE   => flashOE  ,
      RAM1Data   => RAM1Data  ,
      RAM1EN   => RAM1EN  ,
      rdn   => rdn  ,
      RAM1OE   => RAM1OE  ,
      flashCE0   => flashCE0  ,
      wrn   => wrn  ,
      serialDataReady   => serialDataReady  ,
      flashAddr   => flashAddr  ,
      flashWE   => flashWE  ,
      clk   => clk  ,
      RAM1WE   => RAM1WE  ,
      tbre   => tbre  ,
      tsre   => tsre   ) ;
  clk <= not clk after 100ns;
  Ram1Data <= Ram1Data + "1" after 1000ns;
  serialDataReady <= not serialDataReady after 500ns;
END ; 


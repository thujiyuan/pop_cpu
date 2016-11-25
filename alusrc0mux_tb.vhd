LIBRARY ieee  ; 
LIBRARY work  ; 
USE ieee.std_logic_1164.all  ;
USE ieee.std_logic_ARITH.all  ; 
USE ieee.std_logic_UNSIGNED.all  ;  
USE work.recordDefs.all  ; 
ENTITY alusrc0mux_tb  IS 
END ; 
 
ARCHITECTURE alusrc0mux_tb_arch OF alusrc0mux_tb IS
  SIGNAL output   :  std_logic_vector (15 downto 0)  ; 
  SIGNAL ctrl   :  std_logic_vector (1 downto 0) := "00" ; 
  SIGNAL rx   :  std_logic_vector (15 downto 0)  ; 
  SIGNAL SP   :  std_logic_vector (15 downto 0)  ; 
  SIGNAL ry   :  std_logic_vector (15 downto 0)  ; 
  COMPONENT ALUSrc0MUX  
    PORT ( 
      output  : out std_logic_vector (15 downto 0) ; 
      ctrl  : in std_logic_vector (1 downto 0) ; 
      rx  : in std_logic_vector (15 downto 0) ; 
      SP  : in std_logic_vector (15 downto 0) ; 
      ry  : in std_logic_vector (15 downto 0) ); 
  END COMPONENT ; 
BEGIN
  DUT  : ALUSrc0MUX  
    PORT MAP ( 
      output   => output  ,
      ctrl   => ctrl  ,
      rx   => rx  ,
      SP   => SP  ,
      ry   => ry   ) ; 
    ctrl <= ctrl + "1" after 50 ns;
    rx <= "1111000000000000";
    ry <= "0000111100000000";
    SP <= "0000000011110000";
END ; 


----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    20:31:03 11/23/2016 
-- Design Name: 
-- Module Name:    VGAAccess - Behavioral 
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity VGAAccess is
    Port ( clk : in  STD_LOGIC;
           Rin : in  STD_LOGIC_VECTOR (2 downto 0);
           Gin : in  STD_LOGIC_VECTOR (2 downto 0);
           Bin : in  STD_LOGIC_VECTOR (2 downto 0);
           Hs : out  STD_LOGIC;
           Vs : out  STD_LOGIC;
           Rout : out  STD_LOGIC_VECTOR (2 downto 0);
           Gout : out  STD_LOGIC_VECTOR (2 downto 0);
           Bout : out  STD_LOGIC_VECTOR (2 downto 0);
           xOut : out  STD_LOGIC_VECTOR (9 downto 0);
           yOut : out  STD_LOGIC_VECTOR (9 downto 0));
end VGAAccess;

architecture Behavioral of VGAAccess is

begin


end Behavioral;


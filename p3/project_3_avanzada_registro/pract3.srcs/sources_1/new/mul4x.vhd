----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 21.10.2019 17:56:12
-- Design Name: 
-- Module Name: mul4x - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
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
use IEEE.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity mul4x is
    port(
    X : in std_logic_vector(3 downto 0);
    Y : in std_logic_vector(3 downto 0);
    Z : out std_logic_vector(7 downto 0)
    );
end mul4x;

architecture Behavioral of mul4x is

begin
    Z<=X*Y;

end Behavioral;


end Behavioral;

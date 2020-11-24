library IEEE;
use IEEE.std_logic_1164.all;
--use ieee.std_logic_arith.all;
--use ieee.std_logic_unsigned.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

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
    signal x_x,y_y: unsigned (3 downto 0);
    signal z_z: unsigned(7 downto 0);

begin
    x_x <= unsigned(X);
    y_y <= unsigned(Y);
    z_z <= x_x*y_y;
    Z <= std_logic_vector (z_z(7 downto 0));
    --Z<=X*Y;

end Behavioral;
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

entity sumador8 is
    port(
    A : in std_logic_vector(7 downto 0);
    B : in std_logic_vector(7 downto 0);
    C : out std_logic_vector(7 downto 0)
    );
end sumador8;

architecture Behavioral of sumador8 is
    signal a_a,b_b,c_c: unsigned (7 downto 0);

begin
    a_a <= unsigned(A);
    b_b <= unsigned(B);
    c_c <= a_a+b_b;
    C <= std_logic_vector(c_c(7 downto 0));

    --C<=A+B;
end Behavioral;
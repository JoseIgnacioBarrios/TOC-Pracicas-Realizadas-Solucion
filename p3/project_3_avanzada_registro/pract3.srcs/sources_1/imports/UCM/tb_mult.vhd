----------------------------------------------------------------------------------
library ieee;

use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

-------------------------------------------------------------------------------
-- Entity
-------------------------------------------------------------------------------
entity tb_mult8 is
end tb_mult8;

-------------------------------------------------------------------------------
-- Architecture
-------------------------------------------------------------------------------

architecture beh of tb_mult8 is
  -- Component Declaration for the Unit Under Test (UUT)
  component mul4_4
    port(X : in  std_logic_vector(3 downto 0);
         Y : in  std_logic_vector(3 downto 0);
         Z : out std_logic_vector(7 downto 0);
         clk:in std_logic
         );
  end component;

  -- Inputs
  signal X : std_logic_vector(3 downto 0) := (others => '0');
  signal Y : std_logic_vector(3 downto 0) := (others => '0');
  signal clk :std_logic;

  -- Outputs
  signal Z : std_logic_vector(7 downto 0);

  -- Expected output
  signal S_xpct : std_logic_vector(7 downto 0) := (others => '0');
   constant clk_period : time := 10 ns;

begin
reloj_process :process
   begin
	clk <= '0';
	wait for clk_period/500;
	clk <= '1';
	wait for clk_period/500;
end process;
	-- Instantiate the Unit Under Test (UUT)
  UUT : mul4_4
    port map (X => X,
              Y => Y,
              Z => Z,
              clk=>clk);

  -- Stimulus process
  p_stim : process
    variable v_i : natural := 0;
    variable v_j : natural := 0;
  begin
    wait for 1 ps;
    i_loop : for v_i in 0 to 15 loop
      j_loop : for v_j in 0 to 15 loop
        X <= std_logic_vector(to_unsigned(v_i, 4));
        Y <= std_logic_vector(to_unsigned(v_j, 4));
        S_xpct <= std_logic_vector(to_unsigned(v_i * v_j, 8));
        wait for 5 ns;
        assert Z = S_xpct
          report "Error multiplying, "&integer'image(v_i)&" * " &integer'image(v_j)& " = " & integer'image(v_i*v_j) &
          " not " &integer'image(to_integer(unsigned(S_xpct)))
          severity error;
        wait for 5 ns;
      end loop j_loop;
    end loop i_loop;

    wait;
  end process p_stim;
end beh;

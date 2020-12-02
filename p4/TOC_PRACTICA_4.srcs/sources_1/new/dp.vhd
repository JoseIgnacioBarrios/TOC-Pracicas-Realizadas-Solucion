library ieee;
use IEEE.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;


entity dp is
    generic ( m: integer := 4);
    port(
       clk           : in  std_logic;   -- Input clock
       reset         : in  std_logic;   -- General reset
       a_in        	 : in  std_logic_vector(m-1 downto 0);   
       b_in    		 : in  std_logic_vector(m-1 downto 0);
       control       : in  std_logic_vector(8 downto 0);
       estado        : out std_logic_vector(1 downto 0);    
       acc           : out std_logic_vector(2*m-1 downto 0)
    );
end dp;

architecture Behavioral of dp is
 signal a_ld,a_sh,b_ld,b_sh,n_ld,n_ce,n_ud,acc_ld,acc_mux : std_logic;
 signal n_zero: std_logic;
 signal a,b: std_logic_vector(2*m-1 downto 0);
 signal acc_reg, mux_output: std_logic_vector(2*m-1 downto 0);
 signal n:std_logic_vector(m-1 downto 0);
 
begin
(a_ld,a_sh,b_ld,b_sh,n_ld,n_ce,n_ud,acc_ld,acc_mux)<=control; -- control(8) es a_ld.
 estado <= (n_zero & b(0));
 acc <= acc_reg;

p_areg: process (clk, reset) is
  begin
    if reset = '1' then
      a <= (others => '0');
    elsif rising_edge(clk) then
      if a_ld = '1' then
        a<="0000"&a_in;
	  elsif a_sh = '1' then
	    a <=  a(2*m-2 downto 0)&'0';  
		end if;
    end if;
  end process p_areg;

p_breg: process (clk, reset) is
  begin
    if reset = '1' then
      b <= (others => '0');
    elsif rising_edge(clk) then
      if b_ld = '1' then
        b<="0000"&b_in;
	  elsif b_sh = '1' then
	    b <= '0'& b(2*m-1 downto 1);  
		end if;
    end if;
  end process p_breg;

p_ncount: process (clk, reset) is
  begin
    if reset = '1' then
      n <= (others => '0');
    elsif rising_edge(clk) then
      if n_ld = '1' then
        n<="1000";
	  elsif n_ce = '1' then
	      if n_ud = '1' then
	        n <= n + 1;
	      else
	        n <= n - 1;
		  end if;
      end if;
    end if;
  end process p_ncount;

p_accreg: process (clk, reset) is
  begin
    if reset = '1' then
      acc_reg <= (others => '0');
    elsif rising_edge(clk) then
      if acc_ld = '1' then
        acc_reg <=mux_output; 
	  end if;
    end if;
  end process p_accreg;
  
 p_accmux: process (acc_mux, acc_reg, a) is
  begin
    if acc_mux = '0' then
      mux_output <= (others => '0');
    else 
      mux_output <= acc_reg + a;   
    end if;
  end process p_accmux;
  
 p_comp_n: process (n) is
  begin
    if n="0000" then
        n_zero<= '1';
    else
        n_zero<= '0';
    end if;
 end process p_comp_n;  

end Behavioral;



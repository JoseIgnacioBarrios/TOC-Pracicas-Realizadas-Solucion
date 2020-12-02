
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity uc is
        port(
       clk           : in  std_logic;   -- Input clock
       reset         : in  std_logic;   -- General reset
       ini           : in  std_logic;
       estado        : in  std_logic_vector(1 downto 0); 
       control       : out std_logic_vector(8 downto 0);   
       fin           : out std_logic
    );
end uc;

architecture Behavioral of uc is
    type t_st is (s0, s1, s2, s3, s4);
	signal current_state, next_state : t_st;
	signal n_zero, b_zero  : std_logic;
	signal ini_listo,Sig2,Sig3: std_logic;

   constant c_a_ld: std_logic_vector(8 downto 0)    := "100000000";
   constant c_a_sh: std_logic_vector(8 downto 0)    := "010000000";
   constant c_b_ld: std_logic_vector(8 downto 0)    := "001000000";
   constant c_b_sh: std_logic_vector(8 downto 0)    := "000100000";
   constant c_n_ld: std_logic_vector(8 downto 0)    := "000010000";
   constant c_n_ce: std_logic_vector(8 downto 0)    := "000001000";
   constant c_n_ud: std_logic_vector(8 downto 0)    := "000000100";
   constant c_acc_ld: std_logic_vector(8 downto 0)  := "000000010";
   constant c_acc_mux: std_logic_vector(8 downto 0) := "000000001";
   
   	component debouncer is
	  port (
		 rst             : in  std_logic;
		 clk             : in  std_logic;
		 x               : in  std_logic;
		 xdeb            : out std_logic;
		 xdebfallingedge : out std_logic;
		 xdebrisingedge  : out std_logic
		 );
	end component;
   
begin
    (n_zero, b_zero) <= estado;
    
    rebotes: debouncer port map (reset,clk,ini,ini_listo,Sig2,Sig3); 
    -- El mapeo se puede hacer así, sin flechas, directamente poniendo el nombre de las señales que conectas en el orden correcto.
    -- Las señales salientes Sig2 y Sig3 (xdebfallingedge y xdebrisingedge) no se usan para nada. La que se usa es ini_listo que es
    -- la señal de inicio pasada por el debouncer (xdeb).


  p_sincrono : process (clk, reset) is
  begin
    if reset = '1' then
      current_state <= s0;
    elsif rising_edge(clk) then
      current_state <= next_state;
    end if;
  end process  p_sincrono;

 p_comb: process (current_state,ini_listo, n_zero,b_zero) is
 begin
    control<=(others=>'0');
    case current_state is
        when s0 =>
            fin<='1';
            control<= (others => '0');
            if ini='1' then
                next_state<=s1;
            else
                next_state<=current_state;
            end if;
        when s1 =>
            fin<='0';
            control<=c_a_ld or c_b_ld or c_n_ld or c_acc_ld;
            next_state<=s2;
        when s2 =>
            fin<='0';
            control<= (others => '0');
            if n_zero='1' then
                next_state<=s0;
            else
                if b_zero='1' then
                    next_state<=s4;
                else
                    next_state<=s3;
                end if;
            end if;
        when s3 =>
            fin<='0';
            control<= c_a_sh or c_b_sh or c_n_ce;
            next_state<=s2;
        when s4 =>
            fin<='0';
            control<= c_a_sh or c_b_sh or c_n_ce or c_acc_ld or c_acc_mux;
            next_state<=s2;  
        when others => 
            fin<='0';
            control<= (others => '0');
            next_state<=current_state;
        end case;   
 end process p_comb;
 


end Behavioral;


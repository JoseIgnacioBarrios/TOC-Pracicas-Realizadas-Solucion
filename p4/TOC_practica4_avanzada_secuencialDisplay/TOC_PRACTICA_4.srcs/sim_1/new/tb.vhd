
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity tb is
end tb;

architecture Behavioral of tb is

    COMPONENT mult_asm
    port(clk         : in  std_logic;   -- Input clock
       reset         : in  std_logic;   -- General reset
       inicio        : in  std_logic;   -- Start of algorithm
       a_in        	 : in  std_logic_vector(3 downto 0);   
       b_in    		 : in  std_logic_vector(3 downto 0);    
       res_2Displays : out std_logic_vector(7 downto 0); 
       done       	 : out std_logic   
       );
    END COMPONENT;

    --Inputs
   signal clk : std_logic := '0';
   signal reset : std_logic := '0';
   signal inicio : std_logic := '0';
   signal a_in : std_logic_vector(3 downto 0) := (others => '0');
   signal b_in : std_logic_vector(3 downto 0) := (others => '0');

 	--Outputs
   signal res_2Displays : std_logic_vector(7 downto 0);
   signal done : std_logic;

   -- Clock period definitions
   constant clk_period : time := 10 ns;
    
begin

   uut: mult_asm PORT MAP (
      clk => clk,
      reset => reset,
      inicio => inicio,
      a_in => a_in,
      b_in => b_in,
      res_2Displays => res_2Displays,
      done => done
    );


   clk_process :process
   begin
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
   end process;

 stim_proc: process
   begin		
		reset<='1';
		wait for 100 ns;
		reset<='0';
		a_in<="0101";
		b_in<="0101";
        wait for 60 ms;
		inicio <='1';
		wait for 100 ns;
		inicio <='0';

		
		wait for 110 ms;
		b_in<="1011";
		wait for 100 ns;
		inicio <='1';
		wait for 100 ns;
		inicio <='0';
		
		wait for 110 ns;
		a_in<="1001";
		wait for 100 ns;
		inicio <='1';
		wait for 100 ns;
		inicio <='0';
		
		wait for 110 ms;
		a_in<="1010";
		wait for 100 ns;
		inicio <='1';
		wait for 100 ns;
		inicio <='0';

		
		wait for 110 ms;
		a_in<="0001";
		b_in<="0001";
		wait for 100 ns;
		inicio <='1';
		wait for 100 ns;
		inicio <='0';
      wait;
   end process;


end Behavioral;

----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02.12.2019 16:59:42
-- Design Name: 
-- Module Name: tb - Behavioral
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


LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY tb IS
END tb;
 
ARCHITECTURE behavior OF tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT tragaperras
    PORT(
         clk : IN  std_logic;
         reset : IN  std_logic;
         inicio : IN  std_logic;
         parar : IN  std_logic;
         cirsa1 : OUT  std_logic_vector(6 downto 0);
         cirsa2 : OUT  std_logic_vector(6 downto 0);
         leds : OUT  std_logic_vector(9 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal reset : std_logic := '1';
   signal inicio : std_logic := '1';
   signal parar : std_logic := '1';

 	--Outputs
   signal cirsa1 : std_logic_vector(6 downto 0);
   signal cirsa2 : std_logic_vector(6 downto 0);
   signal leds : std_logic_vector(9 downto 0);

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: tragaperras PORT MAP (
          clk => clk,
          reset => reset,
          inicio => inicio,
          parar => parar,
          cirsa1 => cirsa1,
          cirsa2 => cirsa2,
          leds => leds
        );

   -- Clock process definitions
   clk_process :process
   begin
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
   end process;

 

   -- Stimulus process
   stim_proc: process
   begin
		-- Para hacer simulaciones y que se vea algo, hay que modificar los relojes que entran
		-- a algunos de los componentes, si no, la simulación es eterna.
		-- En Datapath habría que ponerle 
		--      al generador_patrones (gp) el reloj de 100Hz
		--      al process de seg, el reloj de 100Hz
		
      wait for 150 ns;	
			reset<='0'; --Lógica negada
		wait for 150 ns;
			reset<='1';
		wait for 30 ms;
			inicio<='0'; --Lógica negada
		wait for 150 ns;
			inicio<='1';
		wait for 700 ms;
		   parar<='0'; --Lógica negada
		wait for 150 ns;
			parar<='1';

      wait;
   end process;

END;

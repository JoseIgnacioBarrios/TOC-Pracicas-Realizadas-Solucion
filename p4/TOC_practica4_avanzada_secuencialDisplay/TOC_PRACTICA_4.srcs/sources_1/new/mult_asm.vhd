
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity mult_asm is
  generic  (n: integer := 4);
  port(clk           : in  std_logic;   -- Input clock
       reset         : in  std_logic;   -- General reset
       inicio        : in  std_logic;   -- Start of algorithm
       a_in        	 : in  std_logic_vector(n-1 downto 0);   
       b_in    		 : in  std_logic_vector(n-1 downto 0);    
       --res_2Displays : out std_logic_vector(2*n-1 downto 0);
       
       display : out  STD_LOGIC_VECTOR (6 downto 0);
       display_enable : out  STD_LOGIC_VECTOR (3 downto 0);
       
       done       	 : out std_logic   
       );
end mult_asm;

architecture Behavioral of mult_asm is
    
  signal control : std_logic_vector(8 downto 0);   -- Control signals
  signal status  : std_logic_vector(1 downto 0);   -- Status signals
  signal acc_8bit  : std_logic_vector(2*n-1 downto 0);
  signal contador_refresco : STD_LOGIC_VECTOR (19 downto 0);
  signal muxau:STD_LOGIC_VECTOR (3 downto 0);
  signal sel: std_logic;
  component dp
    port(
       clk           : in  std_logic;   -- Input clock
       reset         : in  std_logic;   -- General reset
       a_in        	 : in  std_logic_vector(n-1 downto 0);   
       b_in    		 : in  std_logic_vector(n-1 downto 0);
       control       : in  std_logic_vector(8 downto 0);
       estado        : out std_logic_vector(1 downto 0);    
       acc           : out std_logic_vector(2*n-1 downto 0)
    );
  end component;

   component uc
     port(
       clk           : in  std_logic;   -- Input clock
       reset         : in  std_logic;   -- General reset
       ini           : in  std_logic;
       estado        : in  std_logic_vector(1 downto 0); 
       control       : out std_logic_vector(8 downto 0);   
       fin           : out std_logic
    );
 end component;
    component displays
     port(
        reset : in STD_LOGIC;
        clk : in STD_LOGIC;       
        digito_0 : in  STD_LOGIC_VECTOR (3 downto 0);
        digito_1 : in  STD_LOGIC_VECTOR (3 downto 0);
        digito_2 : in  STD_LOGIC_VECTOR (3 downto 0);
        digito_3 : in  STD_LOGIC_VECTOR (3 downto 0);
        display : out  STD_LOGIC_VECTOR (6 downto 0);
        display_enable : out  STD_LOGIC_VECTOR (3 downto 0)
        );
        end component;


begin


  controller: uc port map (
    clk      => clk,                    -- Input clock
    reset    => reset,                  -- General reset
	 ini	 => inicio,
	 estado   => status,
	 control  => control,
	 fin     => done
    );

  datapath : dp port map(
     clk     => clk,              -- Input clock
     reset   => reset,            -- General reset
     a_in    => a_in,
     b_in    => b_in,
	 control => control, 
     estado	=> status,
	 acc  => acc_8bit--res_2Displays--acc_8bit
     );
    muxau<= acc_8bit(3 downto 0)  when contador_refresco(19 downto 18) = "00" else acc_8bit(7 downto 4);
    displa :  displays  port map (
        clk     => clk,              -- Input clock
        reset   => reset,            -- General reset
      digito_0 => muxau ,
      digito_1 => "0000",--acc_8bit(7 downto 4) ,
      digito_2 =>  "0000",--acc_8bit(11 downto 8) ,
      digito_3 =>  "0000",--acc_8bit(15 downto 12) ,
        display => display,
        display_enable => display_enable
    );
    
    process(clk)
    begin
        if rising_edge(clk) then
            if (reset = '1') then
                contador_refresco <= (others=>'0');
            else
                contador_refresco <= contador_refresco + 1;
            end if;
        end if;
    end process;
    
end Behavioral;
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity mul4_4 is
    port(
    X : in std_logic_vector(3 downto 0);
    Y : in std_logic_vector(3 downto 0);
    Z : out std_logic_vector(7 downto 0);
--    Zbis: out std_logic_vector(7 downto 0);
    clk : in std_logic
    );
end mul4_4;

architecture Behavioral of mul4_4 is
    component sumador8 is
     port(
        A : in std_logic_vector(7 downto 0);
        B : in std_logic_vector(7 downto 0);
        C : out std_logic_vector(7 downto 0)
        );
    end component sumador8;
    
   
    
    signal in1a, in1b, in2b, in3b, out1, out2, reg1, reg2, reg3, reg4, reg5 : std_logic_vector(7 downto 0);
begin

    sum1: sumador8 port map (in1a,in1b,out1);
    
    sum2: sumador8 port map (reg1,reg2,out2);
    
    sum3: sumador8 port map (reg3,reg5,Z);
    
--    mimul: mul4x port map(X,Y,Zbis);

    in1a <= "0000" & X when Y(0)='1' else
            "00000000";       
    in1b <= "000" & X & "0" when Y(1)='1' else
            "00000000";
    in2b <= "00" & X & "00" when Y(2)='1' else
            "00000000";
    in3b <= "0" & X & "000" when Y(3)='1' else
            "00000000";
            
sumReg: process (clk) 
   begin
        if rising_edge(clk) then 
        reg1 <= out1;
        reg2 <= in2b;
        reg3 <= out2;
        reg4 <= in3b;
        reg5<=reg4;
        end if;
   end process sumReg;
end Behavioral;


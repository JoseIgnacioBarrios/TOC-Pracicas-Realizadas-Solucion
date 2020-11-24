library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity mul4_4 is
    port(
    X : in std_logic_vector(3 downto 0);
    Y : in std_logic_vector(3 downto 0);
    Z : out std_logic_vector(7 downto 0)
    --Zbis: out std_logic_vector(7 downto 0)
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
    
     component mul4x is
     port(
        X : in std_logic_vector(3 downto 0);
        Y : in std_logic_vector(3 downto 0);
        Z : out std_logic_vector(7 downto 0)
        );
    end component mul4x;
    
    
    signal in1a, in1b, in2b, in3b, out1, out2 : std_logic_vector(7 downto 0);
    signal a,b,c,d: std_logic_vector(3 downto 0);
begin
--para usar el sumador
    a<=(X(3)and Y(0))&(X(2)and Y(0))&(X(1)and Y(0))&(X(0)and Y(0));
    b<=(X(3)and Y(1))&(X(2)and Y(1))&(X(1)and Y(1))&(X(0)and Y(1));
    c<=(X(3)and Y(2))&(X(2)and Y(2))&(X(1)and Y(2))&(X(0)and Y(2));
    d<=(X(3)and Y(3))&(X(2)and Y(3))&(X(1)and Y(3))&(X(0)and Y(3));
    in1a<="0000"&a;
    in1b<="000"&b&"0";
    in2b<="00"&c&"00";
    in3b<="0"&d&"000";
    sum1: sumador8 port map (in1a,in1b,out1);
    sum2: sumador8 port map (out1,in2b,out2);
    sum3: sumador8 port map (out2,in3b,Z);
    
    ------para usar el operador * de la libreria numeric_std
    
    --mimul: mul4x port map(X,Y,Z);



end Behavioral;
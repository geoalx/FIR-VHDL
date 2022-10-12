----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 21.04.2022 19:17:36
-- Design Name: 
-- Module Name: fir_2 - Behavioral
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


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity pip_direct is
    generic(data_width : integer := 8);
    Port ( clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           valid_in : in STD_LOGIC;
           x : in STD_LOGIC_VECTOR (7 downto 0) := (others => '0');
           valid_out : out STD_LOGIC;
           y : out STD_LOGIC_VECTOR (18 downto 0));
end pip_direct;

architecture Behavioral of pip_direct is
    type rom_type is array(7 downto 0) of std_logic_vector(7 downto 0);
    signal rom : rom_type:= ("00001000", "00000111", "00000110", "00000101", "00000100", "00000011", "00000010",
    "00000001");    
    
    type ram_type is array (7 downto 0) of std_logic_vector (data_width-1 downto 0);
    signal RAM : ram_type := (others => (others => '0'));
	 
    type m_type is array(7 downto 0) of std_logic_vector(15 downto 0);
    signal m: m_type := (others => (others => '0'));
    signal p1: std_logic_vector(15 downto 0):= (others => '0');
    type p2_type is array(1 downto 0) of std_logic_vector(15 downto 0);
    type p3_type is array(2 downto 0) of std_logic_vector(15 downto 0);
    type p4_type is array(3 downto 0) of std_logic_vector(15 downto 0);
    type p5_type is array(4 downto 0) of std_logic_vector(15 downto 0);
    type p6_type is array(5 downto 0) of std_logic_vector(15 downto 0);
    type p7_type is array(6 downto 0) of std_logic_vector(15 downto 0);

    signal p2 : p2_type := (others => (others => '0'));    
    signal p3 : p3_type := (others => (others => '0'));
    signal p4 : p4_type := (others => (others => '0'));
    signal p5 : p5_type := (others => (others => '0'));
    signal p6 : p6_type := (others => (others => '0'));
    signal p7 : p7_type := (others => (others => '0'));

    type a_type is array(7 downto 0) of std_logic_vector(18 downto 0);
    signal a: a_type := (others => (others => '0'));

    signal tempval0 : std_logic_vector(7 downto 0) := (others => '0');

begin
    process(clk,rst)
    begin

        if rst = '1' then 
        ram <= (others => (others => '0'));
        m <= (others => (others => '0'));
        a <= (others => (others => '0'));
        y <= (others => '0');
        valid_out <= '0';
        p1 <= (others=>'0');
        p2 <= (others => (others=>'0'));
        p3 <= (others => (others=>'0'));
        p4 <= (others => (others=>'0'));
        p5 <= (others => (others=>'0'));
        p6 <= (others => (others=>'0'));
        p7 <= (others => (others=>'0'));
        tempval0 <= (others => '0');

        elsif(clk'event and clk='1') then
                valid_out <= tempval0(7);
                    for i in 1 to 7 loop
                        tempval0(i) <= tempval0(i-1);
                    end loop;
                        tempval0(0) <= valid_in;
            
                if valid_in = '1' then        
                    for i in 7 downto 1 loop
                        ram(i) <= ram(i-1);
                    end loop;
                        ram(0) <= x;
                  end if;


                    for i in 6 downto 1 loop
                        p7(i) <= p7(i-1); 
                    end loop;
                    p7(0) <= rom(7)*ram(6);
                    
                    for i in 5 downto 1 loop
                        p6(i) <= p6(i-1); 
                    end loop;
                    p6(0) <= rom(6)*ram(5);
                    
                    
                    for i in 4 downto 1 loop
                        p5(i) <= p5(i-1);
                    end loop;
                    p5(0) <= rom(5)*ram(4);

                    for i in 3 downto 1 loop
                        p4(i) <= p4(i-1);
                    end loop;
                    p4(0) <= rom(4)*ram(3);

                    for i in 2 downto 1 loop
                        p3(i) <= p3(i-1);
                    end loop;
                    p3(0) <= rom(3)*ram(2);

                    p2(1) <= p2(0);
                    p2(0) <= rom(2)*ram(1);

                    p1 <= rom(1)*ram(0);

                    m(7) <= p7(6);
                    m(6) <= p6(5);
                    m(5) <= p5(4);
                    m(4) <= p4(3);
                    m(3) <= p3(2);
                    m(2) <= p2(1);
                    m(1) <= p1;
                    m(0)<= rom(0)*x;

                    y <= a(6)+ m(7);
                    for i in 7 downto 1 loop
                        a(i) <= a(i-1)+ m(i) ;
                    end loop;
                    a(0) <= m(0) + "0000000000000000000";
                    
        end if;
    end process;
end Behavioral;

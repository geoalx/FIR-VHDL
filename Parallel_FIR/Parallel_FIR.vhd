
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
-- NTUA
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity fir_par_d is
generic(
    data_width : integer := 8
);
Port(
    clk : in std_logic;
    rst : in std_logic;
    valid_in : in std_logic;
    x0, x1 : in std_logic_vector(7 downto 0);
    y0, y1 : out std_logic_vector(18 downto 0);
    valid_out : out std_logic
);
end fir_par_d;

architecture Behavioral of fir_par_d is
    
    type a_type is array(6 downto 0) of std_logic_vector(18 downto 0);
    signal a: a_type := (others => (others => '0'));
        
    type e_type is array(6 downto 0) of std_logic_vector(18 downto 0);
    signal e: e_type := (others => (others => '0'));
    
    type rom_type is array(7 downto 0) of std_logic_vector(7 downto 0);
    signal rom : rom_type:= ("00001000", "00000111", "00000110", "00000101", "00000100", "00000011", "00000010",
    "00000001");    
    
    type ram_type is array (7 downto 0) of std_logic_vector (data_width-1 downto 0);
    signal ram : ram_type := (others => (others => '0'));

    type temp_type is array (3 downto 0) of std_logic_vector (data_width*2 - 1 downto 0);
    signal temp : temp_type := (others => (others => '0'));
    
    type z_type is array(7 downto 0) of std_logic_vector(15 downto 0); --y0
    signal z: z_type := (others => (others => '0'));
  
    type m_type is array(7 downto 0) of std_logic_vector(15 downto 0); --y1
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

    signal k1: std_logic_vector(15 downto 0):= (others => '0');
    type k2_type is array(1 downto 0) of std_logic_vector(15 downto 0);
    type k3_type is array(2 downto 0) of std_logic_vector(15 downto 0);
    type k4_type is array(3 downto 0) of std_logic_vector(15 downto 0);
    type k5_type is array(4 downto 0) of std_logic_vector(15 downto 0);
    type k6_type is array(5 downto 0) of std_logic_vector(15 downto 0);
    type k7_type is array(6 downto 0) of std_logic_vector(15 downto 0);

    signal k2 : k2_type := (others => (others => '0'));    
    signal k3 : k3_type := (others => (others => '0'));
    signal k4 : k4_type := (others => (others => '0'));
    signal k5 : k5_type := (others => (others => '0'));
    signal k6 : k6_type := (others => (others => '0'));
    signal k7 : k7_type := (others => (others => '0'));

    signal tempval : std_logic_vector(8 downto 0) := (others => '0');
begin
    process(clk,rst)
    begin
        if rst = '1' then
            valid_out <= '0';
            ram <= (others=>(others=>'0'));
            y0 <= (others => '0');
            y1 <= (others => '0');

            p1 <= (others=>'0');
            p2 <= (others => (others=>'0'));
            p3 <= (others => (others=>'0'));
            p4 <= (others => (others=>'0'));
            p5 <= (others => (others=>'0'));
            p6 <= (others => (others=>'0'));
            p7 <= (others => (others=>'0'));

            k1 <= (others=>'0');
            k2 <= (others => (others=>'0'));
            k3 <= (others => (others=>'0'));
            k4 <= (others => (others=>'0'));
            k5 <= (others => (others=>'0'));
            k6 <= (others => (others=>'0'));
            k7 <= (others => (others=>'0'));
            
            a <= (others => (others => '0'));
            e <= (others => (others => '0'));
            m <= (others => (others => '0'));
            z <= (others => (others => '0'));
            
            tempval <= (others => '0');
            temp <= (others => (others=>'0'));

        elsif clk'event and clk = '1' then
            valid_out <= tempval(8);
            tempval(0) <= valid_in;
            for i in 1 to 8 loop
                tempval(i) <= tempval(i-1);
            end loop;
            if(valid_in = '1') then
                ram(0) <= x0;
                ram(1) <= x1;
                for i in 7 downto 2 loop
                    ram(i) <= ram(i-2);
                end loop;
            end if;
                for i in 6 downto 1 loop
                    p7(i) <= p7(i-1);
                    k7(i) <= k7(i-1);
                end loop;
                p7(0) <=  ram(6)*rom(7);
                k7(0) <= ram(7)*rom(7);

                for i in 5 downto 1 loop
                    p6(i) <= p6(i-1); 
                    k6(i) <= k6(i-1);
                end loop;
                p6(0) <=ram(7)*rom(6);
                k6(0) <=ram(6)*rom(6);
                
                for i in 4 downto 1 loop
                    p5(i) <= p5(i-1);
                    k5(i) <= k5(i-1);
                end loop;
                p5(0) <= ram(4)*rom(5);
                k5(0) <= ram(5)*rom(5);

                for i in 3 downto 1 loop
                    p4(i) <= p4(i-1);
                    k4(i) <= k4(i-1);
                end loop;
                p4(0) <= ram(5)*rom(4);
                k4(0) <= ram(4)*rom(4);

                for i in 2 downto 1 loop
                    p3(i) <= p3(i-1);
                    k3(i) <= k3(i-1);
                end loop;
                p3(0) <= ram(2)*rom(3) ;
                k3(0) <= ram(3)*rom(3);

                p2(1) <= p2(0);
                k2(1) <= k2(0);
                p2(0) <= ram(3)*rom(2);
                k2(0) <= ram(2)*rom(2);

                p1 <= ram(0)*rom(1);
                k1 <= ram(1)*rom(1);

                m(7) <= p7(6);
                m(6) <= p6(5);
                m(5) <= p5(4);
                m(4) <= p4(3);
                m(3) <= p3(2);
                m(2) <= p2(1);
                m(1) <= p1;
                m(0)<= ram(1)*rom(0);

                temp(3) <= k7(6);
                temp(2) <= k5(4);
                temp(1) <= k3(2);
                temp(0) <= k1;
                
                
                z(7) <= temp(3);
                z(6) <= k6(5);
                z(5) <= temp(2);
                z(4) <= k4(3);
                z(3) <= temp(1);
                z(2) <= k2(1);
                z(1) <= temp(0);
                z(0)<= ram(0)*rom(0);
                
               y1<=e(6) + m(7);
               y0<=a(6) + z(7);
                for i in 6 downto 1 loop
                    e(i) <= e(i-1) + m(i); --y1
                    a(i) <= a(i-1) + z(i); --y0
                end loop;
                e(0) <= m(0) + "0000000000000000000";
                a(0) <= z(0) + "0000000000000000000";
                --y0 <= ram(0)*rom(0) + temp(0) + ram(2)*rom(2) + temp(1) +  ram(4)*rom(4) + temp(2) + ram(6)*rom(6) + temp(3);
                --y1 <= ram(1)*rom(0) + ram(0)*rom(1) + ram(3)*rom(2) + ram(2)*rom(3) + ram(5)*rom(4) + ram(4)*rom(5) + ram(7)*rom(6) + ram(6)*rom(7);
        end if;
    end process;
end Behavioral;

----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 06.04.2022 21:50:09
-- Design Name: 
-- Module Name: MAC - Behavioral
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

entity MAC is
    Port ( clk : in std_logic;
           ram_dat : in STD_LOGIC_VECTOR (7 downto 0);
           rom_dat : in STD_LOGIC_VECTOR (7 downto 0);
           rst : in STD_LOGIC;
           mac_init : in std_logic;
           y : out STD_LOGIC_VECTOR (18 downto 0);
           valid_out : out STD_LOGIC);
end MAC;

architecture Behavioral of MAC is

signal acc : std_logic_vector(18 downto 0):=(others => '0');

begin

    valid_out <= '1' when rst <= '0' else '0';

    process(clk,rst)
    begin
        if(rst = '1') then 
            acc <= (others => '0');
            y <= (others => '0');
        elsif(clk'event and clk='1') then 
            
            if(mac_init = '1') then 
                y <= acc;
                acc <= (others => '0');
            else
                acc <= acc + ram_dat*rom_dat;
            end if;
        end if;

    end process;

end Behavioral;

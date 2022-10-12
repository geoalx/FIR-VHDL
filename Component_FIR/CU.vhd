----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 06.04.2022 20:53:24
-- Design Name: 
-- Module Name: CU - Behavioral
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

entity CU is
    Port ( clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           valid_in : in STD_LOGIC;
           rom_address : out STD_LOGIC_VECTOR (2 downto 0);
           mac_init : out STD_LOGIC;
           ram_address : out STD_LOGIC_VECTOR (2 downto 0));
end CU;

architecture Behavioral of CU is

signal acc : std_logic_vector(3 downto 0):="0000";

begin
rom_address <= acc(2 downto 0) when acc(3) = '0' else "000";
ram_address <= acc(2 downto 0) when acc(3) = '0' else "000";
mac_init <= '1' when acc="0000" else '0';

process(clk,rst)
begin
    if(rst = '1') then
        acc <= "0000";
    elsif(clk'event and clk='1') then
        if(acc = "1000") then
            acc <= "0000";
        else
            acc <= acc + 1;
        end if;
        
    end if;
end process;

end Behavioral;

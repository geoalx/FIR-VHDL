----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 13.04.2022 09:13:14
-- Design Name: 
-- Module Name: FIR_tb_test - Behavioral
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

entity FIR_tb is
--  Port ( );
end FIR_tb;

architecture FIR_sim_t of FIR_tb is

component FIR is
    generic (
        data_w : integer := 8
        );
    Port ( clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           valid_in : in STD_LOGIC;
           x : in STD_LOGIC_VECTOR (7 downto 0);
           valid_out : out STD_LOGIC;
           y : out STD_LOGIC_VECTOR (18 downto 0));
end component;

signal clk,valid_out,rst : std_logic := '0';
signal x : std_logic_vector(7 downto 0):="00000001";
signal y : std_logic_vector(18 downto 0);
signal valid_in : std_logic:='1';
begin
UUT : FIR Port map(clk=>clk,rst=>rst,valid_in=>valid_in,valid_out=>valid_out,x=>x,y=>y);
clk <= not clk after 1ns;

process
begin
x<="11000010";
wait for 2ns;
x<="10111110";
wait for 2ns;
x<="01100101";
wait for 2ns;
x<="10101000";
wait for 2ns;
x<="00101100";
wait for 2ns;
x<="10110101";
wait for 2ns;
x<="00001001";
wait for 2ns;
x<="01000111";
wait for 2ns;
x<="00001100";
wait for 2ns;
x<="00011001";
wait for 2ns;
x<="11010010";
wait for 2ns;
x<="10110010";
wait for 2ns;
x<="01010001";
wait for 2ns;
x<="11110011";
wait for 2ns;
x<="00001001";
wait for 2ns;
x <= (others => '0');
wait for 12800ns;    


end process;


end FIR_sim_t;

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

entity FIR_PAR_D_TB is
--  Port ( );
end FIR_PAR_D_TB;

architecture FIR_par_sim_tb of FIR_PAR_D_TB is

component fir_par_d is
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
end component;

signal clk,valid_out,flag,rst : std_logic := '0';
signal x1,x0 : std_logic_vector(7 downto 0) :="00000001";
signal y1,y0 : std_logic_vector(18 downto 0);
signal valid_in : std_logic:='1';
begin
UUT : fir_par_d Port map(clk=>clk,rst=>rst,valid_in=>valid_in,valid_out=>valid_out,x1=>x1,x0=>x0,y0=>y0,y1=>y1);
clk <= not clk after 1ns;

process
begin
x0<="11000010";
x1<="10111110";
wait for 2ns;
x0<="01100101";
x1<="10101000";
wait for 2ns;
x0<="00101100";
x1<="10110101";
wait for 2ns;
x0<="00001001";
x1<="01000111";
wait for 2ns;
x0<="00001100";
x1<="00011001";
wait for 2ns;
valid_in <= '0';
wait for 2ns;
valid_in <= '1';
x0<="11010010";
x1<="10110010";
wait for 2ns;
x0<="01010001";
x1<="11110011";
wait for 2ns;
x0<="00001001";
x1<=(others =>'0');
wait for 2ns;
x0 <= (others => '0');
wait for 12800ns;    


end process;


end FIR_par_sim_tb;

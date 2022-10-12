----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 06.04.2022 22:10:46
-- Design Name: 
-- Module Name: FIR - Behavioral
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity FIR is
generic (
        data_w : integer := 8
        );
    Port ( clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           valid_in : in STD_LOGIC;
           x : in STD_LOGIC_VECTOR (7 downto 0);
           valid_out : out STD_LOGIC;
           y : out STD_LOGIC_VECTOR (18 downto 0));
end FIR;

architecture Structural of FIR is

component RAM is
    generic (
       data_width : integer :=8  				--- width of data (bits)
    );
   port (clk  : in std_logic;
         we   : in std_logic;						--- memory write enable
         en   : in std_logic;				--- operation enable
         addr : in std_logic_vector(2 downto 0);			-- memory address
         di   : in std_logic_vector(data_width-1 downto 0);		-- input data
         rst : in  std_logic;              -- reset RAM
         do   : out std_logic_vector(data_width-1 downto 0));		-- output data
end component;

component ROM is
    generic (
       coeff_width : integer :=8  				--- width of coefficients (bits)
    );
   Port ( clk : in  STD_LOGIC;
             en : in  STD_LOGIC;				--- operation enable
          addr : in  STD_LOGIC_VECTOR (2 downto 0);			-- memory address
          rom_out : out  STD_LOGIC_VECTOR (coeff_width-1 downto 0));	-- output data
end component;

component CU is
    Port ( clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           valid_in : in STD_LOGIC;
           rom_address : out STD_LOGIC_VECTOR (2 downto 0);
           mac_init : out STD_LOGIC;
           ram_address : out STD_LOGIC_VECTOR (2 downto 0));
end component;

component MAC is
    Port ( clk : in std_logic;
           ram_dat : in STD_LOGIC_VECTOR (7 downto 0);
           rom_dat : in STD_LOGIC_VECTOR (7 downto 0);
           rst : in STD_LOGIC;
           mac_init : in std_logic;
           y : out STD_LOGIC_VECTOR (18 downto 0);
           valid_out : out STD_LOGIC);
end component;

signal tempromaddr,tempramaddr : std_logic_vector(2 downto 0);
signal tempinit : std_logic;
signal tempromdat,tempramdat : std_logic_vector(7 downto 0);
signal we_ram,all_out : std_logic;
signal tempvalid : std_logic_vector (9 downto 0);

begin
    
    we_ram <= tempinit and valid_in;
    valid_out <= all_out and tempvalid(9);
    CU0 : CU Port map(clk=>clk,rst=>rst,valid_in=>valid_in,rom_address=>tempromaddr,mac_init=>tempinit,ram_address=>tempramaddr);
    ROM0 : ROM Port map(clk=>clk,en=>'1',addr=>tempromaddr,rom_out=>tempromdat);
    RAM0 : RAM Port map(clk=>clk,rst=>rst,we=>we_ram,en=>'1',addr=>tempramaddr,di=>x,do=>tempramdat);
    MAC0 : MAC Port map(clk=>clk,rst=>rst,mac_init=>tempinit,valid_out=>all_out,ram_dat=>tempramdat,rom_dat=>tempromdat,y=>y);
    process (clk)
    begin
        if clk'event and clk='1' then
            for i in 9 downto 1 loop
                tempvalid(i) <= tempvalid(i-1);
            end loop;
            tempvalid(0) <= valid_in;
        end if;
    end process;

end Structural;

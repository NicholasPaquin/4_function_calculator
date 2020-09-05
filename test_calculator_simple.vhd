LIBRARY ieee;
USE ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity test_calculator is
  port (
    i_clk : in std_logic;
    o_butt: out unsigned(4 downto 0);
    o_ent, o_clr: out std_logic;
    o_rtn: out unsigned(31 downto 0);
    o_test: out integer;
    o_test_passed: out std_logic;
    o_all_tests_passed: out std_logic
  ) ;
end test_calculator ;

architecture arch of test_calculator is
    component calculator_simple port(
        i_clk : in std_logic;
        i_butt : in unsigned(4 downto 0);
        i_ent, i_clr : in std_logic;
        o_rtn: out unsigned(31 downto 0);
        o_d0, o_d1, o_d2, o_d3, o_d4, o_d5, o_d6, o_d7, o_d8: out unsigned(4 downto 0)
    );
    end component;
    signal v_d0, v_d1, v_d2, v_d3, v_d4, v_d5, v_d6, v_d7, v_d8: unsigned(4 downto 0);
begin
    c_calc: calculator_simple port map(i_clk, o_butt, o_ent, o_rtn);
    o_test <= 0;
    o_all_tests_passed <= '0';
    o_test_passed <= '0'
    p_test : process
    begin
        
        
    end process ; -- p_test_0


end architecture ; -- arch
LIBRARY ieee;
USE ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity test_alu is
end test_alu;
architecture testbench_alu of test_alu is
    component alu port(
        clk : in std_logic;
        w : in std_logic;
        operator : in unsigned(1 downto 0);
        num0, num1 : in unsigned(31 downto 0);
        result : out unsigned(31 downto 0);
        done : out std_logic
    );
    end component;
    signal v_des_res: unsigned(31 downto 0);
    signal v_test_count: integer := 0;
    signal v_clk: std_logic;
    signal v_write, v_done: std_logic := '0';
    signal v_num0, v_num1, v_result : unsigned(31 downto 0);
    signal v_operator: unsigned(1 downto 0);
    -- create signals

    constant c_clk_period : time := 1 us;

begin

    p_clk : process
    begin
        v_clk <= '0';
        wait for c_clk_period/2;
        v_clk <= '1';
        wait for c_clk_period/2;
    end process p_clk;

    alu_unit :alu port map (v_clk, v_write, v_operator, v_num0, v_num1, v_result, v_done);
    
    p_test: process
    begin        
        v_num0 <= "00000100000000100000000000000010";
        v_num1 <= "00000000000000000000000000000010";
        v_operator <= "00";
        v_des_res <= "00000100000000100000000000000100";
        v_write <= '1';
        wait until v_done = '1';
        assert v_result = v_des_res report "failed addition" severity failure;
        v_test_count <= 1;
        v_write <= '0';
        v_operator <= "01";
        v_des_res <= "00000100000000100000000000000000";
        v_write <= '1';
        wait until v_done = '1';
        assert v_result = v_des_res report "failed subtraction" severity failure;
        v_test_count <= 2;
        v_write <= '0';
        v_operator <= "10";
        v_des_res <= "00001000000001000000000000000100";
        v_write <= '1';
        wait until v_done = '1';
        assert v_result = v_des_res report "failed multiplication" severity failure;
        v_test_count <= 3;
        v_write <= '0';
        v_operator <= "11";
        v_des_res <= "00000010000000010000000000000001";
        v_write <= '1';
        wait until v_done = '1';
        assert v_result = v_des_res report "failed division" severity failure;
        report "Test done!" severity failure;
    end process; --p_test
end testbench_alu ; -- testbench_alu
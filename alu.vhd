LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

entity alu is
  port (
    clk : in std_logic;
    w : in std_logic;
    operator : in unsigned(1 downto 0);
    num0, num1 : in unsigned(31 downto 0);
    result : out unsigned(31 downto 0);
    done : out std_logic
  ) ;
end alu;

architecture alu_imp of alu is
    signal v_calc : std_logic := '0';
    signal v_prev_result : unsigned(31 downto 0);
begin
    v_prev_result <= (others => '0');
    p_alu : process( clk )
        variable temp : unsigned(63 downto 0);
    begin
        if rising_edge(clk) and w = '1' then
            case( operator ) is
            
                when "00" =>
                    result <= num0 + num1;
                when "01" =>
                    result <= num0 - num1;
                when "10" =>
                    temp := num0 * num1;
                    result <= temp(31 downto 0);
                when "11" =>
                    result <= num0/num1;
                when others =>
                    result <= (others => '0');
            end case ;
            done <= '1';
            v_calc <= '1';
        else
            done <= '0';
        end if ;
        -- done <= '1';
    end process ; -- p_alu
    -- p_done : process( w, operator, num0, num1 )
    -- begin
    --     done <= '0';
    --     v_calc <= '0';
    -- end process ; -- p_done
    

    


end alu_imp ; -- alu_imp
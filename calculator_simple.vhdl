LIBRARY ieee;
USE ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity calculator is
  port (
    i_clk : in std_logic;
    i_butt : in unsigned(4 downto 0);
    i_ent, i_clr : in std_logic;
    o_rtn: out unsigned(31 downto 0);
    o_d0, o_d1, o_d2, o_d3, o_d4, o_d5, o_d6, o_d7, o_d8: out unsigned(4 downto 0)
  ) ;
end calculator ;

architecture calc of calculator is
    component alu port(
        clk : in std_logic;
        w : in std_logic;
        operator : in unsigned(1 downto 0);
        num1, num2 : in unsigned(31 downto 0);
        result : out unsigned(31 downto 0);
        done : out std_logic
    );
    end component;

    signal val : std_logic;
    signal w0, w1, w2, w3, w4, w5, w6, w7, w8 :std_logic := '0';
    signal v0, v1, v2, v3, v4, v5, v6, v7, v8: std_logic := '0';
    signal v_num0, v_num1, v_comp : unsigned(31 downto 0) := (others => '0');
    signal v_val0, v_val1, v_valc, v_done : std_logic := '0';
    signal op : unsigned(1 downto 0) := (others => '0');
    signal v_write :std_logic := '0';
    signal v_temp_op: unsigned(4 downto 0);


    type t_state is (s_input1, s_input2, s_calc, s_wait, s_error);

    signal v_current_state, v_next_state : t_state;
begin
    val <= i_butt(4);
    alu_unit :alu port map (i_clk, v_write, op,  v_num0, v_num1, v_comp, v_done);


    p_state_machine : process( i_clk )
    begin
        if rising_edge(i_clk) then
            v_current_state <= v_next_state;
        end if;
    end process ; 

    p_state_transition : process( i_ent, i_butt, i_clr )
    begin
        if (i_clr = '1') then
            v_current_state <= s_input1;
            v_num0 <= (others => '0');
            v_num1 <= (others => '0');
            v_comp <= (others => '0');
            v_val0 <= '0';
            v_val1 <= '0';
            v_valc <= '0';
            op <= (others => '0');
            v0 <= '0';
            v1 <= '0';
            v2 <= '0';
            v3 <= '0';
            v4 <= '0';
            v5 <= '0';
            v6 <= '0';
            v7 <= '0';
            v8 <= '0';
        elsif val = '1' and i_butt < "11001" then
            w0 <= not v0;
            w1 <= not v1 and not w0;
            w2 <= not v2 and not w0 and not w1;
            w3 <= not v3 and not w0 and not w1 and not w2;
            w4 <= not v4 and not w0 and not w1 and not w2 and not w3;
            w5 <= not v5 and not w0 and not w1 and not w2 and not w3 and not w4;
            w6 <= not v6 and not w0 and not w1 and not w2 and not w3 and not w4 and not w5;
            w7 <= not v7 and not w0 and not w1 and not w2 and not w3 and not w4 and not w5 and not w6;
            w8 <= not v8 and not w0 and not w1 and not w2 and not w3 and not w4 and not w5 and not w6 and not w7;
        end if;
        case( v_current_state ) is
        
            when s_input1 =>
                if i_ent = '0' and i_clr = '0' and i_butt >= "11001" and v_val0 = '1' then
                    v_next_state <= s_input2;
                    v_temp_op <= (i_butt - "11001");
                    op <= v_temp_op(1 downto 0);
                elsif (i_butt < "11001" or i_ent = '1') and v8 = '0' and i_clr = '0' then
                    v_next_state <= s_input1;
                else
                    v_next_state <= s_error;
                end if;
                
            when s_input2 =>
                if (i_ent = '1' or i_butt >= "11001") and v_val1 = '1' then
                    v_next_state <= s_calc;
                elsif (i_butt < "11001" or i_ent = '1') and v8 = '0' then
                    v_next_state <= s_input2;
                else
                    v_next_state <= s_error;
                end if;      
                
            when s_calc =>
                if i_butt >= "11001" and v_valc = '1' then
                    v_next_state <= s_input2;
                    v_num0 <= v_comp;
                    v_temp_op <= (i_butt - "11001");
                    op <= v_temp_op(1 downto 0);
                elsif i_butt < "11001" and v_valc = '1' then
                    v_next_state <= s_input1;
                else
                    v_next_state <= s_calc;
                end if; 
                
            when others =>
                if i_butt >= "11001" then
                    v_next_state <= s_error;
                elsif val = '1' then
                    v_next_state <= s_input1;
                    v_num0 <= (others => '0');
                    v_val0 <= '1';
                    v_num0 <= v_num1 + i_butt;
                    v_num1 <= (others => '0');
                    v_val1 <= '0';
                else
                    v_next_state <= s_error;
                end if;
                    
        
        end case ;
    end process ; -- p_state_transition

    p_state_machine_decoder : process( i_butt, i_ent, i_clr )
    begin
        case( v_current_state ) is
        
            when s_input1 =>
                if val = '1' and i_butt < "11001" then
                    v_num0 <= v_num0*10 + (i_butt - "10000");
                    o_rtn <= v_num0;
                    v_val0 <= '1';
                end if;
            when s_input2 =>
                if val = '1' and i_butt < "11001" then
                    v_num1 <= v_num1*10 + (i_butt - "10000");
                    o_rtn <= v_num1;
                    v_val1 <= '1';
                end if;

            when s_calc =>
                if i_ent = '1' and v_val0 = '1' and v_val1 = '1' then
                    v_write <= '1';
                end if;
            when others =>
                v_num0 <= (others => '0');
                v_num1 <= (others => '0');
                op <= (others => '0');
                v_val0 <= '0';
                v_val1 <= '0';
        end case ;
        
    end process ; -- p_state_machine_decoder

    p_display_num : process( i_clk )
        variable v_count: integer := 0;
    begin
        if (rising_edge(i_clk) and v_done = '1') then
            v_valc <= '1';
            o_rtn <= v_comp;
            v_num0 <= (others => '0');
            v_num1 <= (others => '0');
            v_val0 <= '0';
            v_val1 <= '0';
            -- disply everything i would just write python to automate this part

            v_write <= '0';
        end if;

    end process ; -- p_display_num

    -- registors for the display

    p_rise_edge_0: process(i_clk, i_clr)
    begin
        if i_clr = '1' then
            o_d0 <= (others => '0');
        elsif rising_edge(i_clk) and w0 = '1' then
            o_d0 <= i_butt;
            v0 <= '1';
        end if;
    end process ; --rise_edge_0

    p_rise_edge_1: process(i_clk, i_clr)
    begin
        if i_clr = '1' then
            o_d1 <= (others => '0');
        elsif rising_edge(i_clk) and w1 = '1' then
            o_d1 <= i_butt;
            v1 <= '1';
        end if;
    end process ; --rise_edge_1

    p_rise_edge_2: process(i_clk, i_clr)
    begin
        if i_clr = '1' then
            o_d2 <= (others => '0');
        elsif rising_edge(i_clk) and w2 = '1' then
            o_d2 <= i_butt;
            v2 <= '1';
        end if;
    end process ; --rise_edge_2

    p_rise_edge_3: process(i_clk, i_clr)
    begin
        if i_clr = '1' then
            o_d3 <= (others => '0');
        elsif rising_edge(i_clk) and w3 = '1' then
            o_d3 <= i_butt;
            v3 <= '1';
        end if;
    end process ; --rise_edge_0

    p_rise_edge_4: process(i_clk, i_clr)
    begin
        if i_clr = '1' then
            o_d4 <= (others => '0');
        elsif rising_edge(i_clk) and w4 = '1' then
            o_d4 <= i_butt;
            v4 <= '1';
        end if;
    end process ; --rise_edge_0

    p_rise_edge_5: process(i_clk, i_clr)
    begin
        if i_clr = '1' then
            o_d5 <= (others => '0');
        elsif rising_edge(i_clk) and w5 = '1' then
            o_d5 <= i_butt;
            v5 <= '1';
        end if;
    end process ; --rise_edge_0

    p_rise_edge_6: process(i_clk, i_clr)
    begin
        if i_clr = '1' then
            o_d6 <= (others => '0');
        elsif rising_edge(i_clk) and w6 = '1' then
            o_d6 <= i_butt;
            v6 <= '1';
        end if;
    end process ; --rise_edge_0

    p_rise_edge_7: process(i_clk, i_clr)
    begin
        if i_clr = '1' then
            o_d7 <= (others => '0');
        elsif rising_edge(i_clk) and w7 = '1' then
            o_d7 <= i_butt;
            v7 <= '1';
        end if;
    end process ; --rise_edge_0

    p_rise_edge_8: process(i_clk, i_clr)
    begin
        if i_clr = '1' then
            o_d8 <= (others => '0');
        elsif rising_edge(i_clk) and w8 = '1' then
            o_d8 <= i_butt;
            v8 <= '1';
        end if;
    end process ; --rise_edge_0


end architecture ; -- arch
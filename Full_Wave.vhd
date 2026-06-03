library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity full_wave is
    port (
        half_cycle : in  std_logic;                    -- directly from phase accumulator
        sine_val   : in  std_logic_vector(6 downto 0);
        dac_out    : out std_logic_vector(7 downto 0)
    );
end full_wave;

architecture behavioral of full_wave is
begin

    -- purely combinational, no clock needed anymore
    process(half_cycle, sine_val)
    begin
        if half_cycle = '0' then
            -- positive half: 128 + sine_val
            dac_out <= '1' & sine_val;
        else
            -- negative half: 128 - sine_val
            dac_out <= std_logic_vector(
                to_unsigned(128, 8) - resize(unsigned(sine_val), 8)
            );
        end if;
    end process;

end behavioral;
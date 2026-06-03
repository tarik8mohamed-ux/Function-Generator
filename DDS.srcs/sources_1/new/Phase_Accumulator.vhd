library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity phase_accumulator is
    port (
        clk         : in  std_logic;
        reset       : in  std_logic;
        enable      : in  std_logic;
        tuning_word : in  unsigned(15 downto 0);
        addr        : out std_logic_vector(6 downto 0);
        half_cycle  : out std_logic                    -- new output, goes to full_wave
    );
end phase_accumulator;

architecture behavioral of phase_accumulator is

    signal accumulator : unsigned(15 downto 0) := (others => '0');

    -- internal versions of the address bits
    signal raw_addr   : unsigned(6 downto 0);
    signal direction  : std_logic;

begin

    process(clk)
    begin
        if rising_edge(clk) then
            if reset = '1' then
                accumulator <= (others => '0');
            elsif enable = '1' then
                accumulator <= accumulator + tuning_word;
            end if;
        end if;
    end process;

    -- bit 15 tells full_wave which half of the sine we are in
    half_cycle <= accumulator(15);

    -- bit 14 tells us if we are ascending or descending
    direction  <= accumulator(14);

    -- bits 13 downto 7 are the raw table address
    raw_addr   <= accumulator(13 downto 7);

    -- if ascending use address directly
    -- if descending mirror it (127 - addr) by inverting bits
    -- this makes the address count backwards through the table
    addr <= std_logic_vector(raw_addr)       when direction = '0'
       else std_logic_vector(not raw_addr);

end behavioral;
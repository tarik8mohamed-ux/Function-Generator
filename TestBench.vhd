library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity testbench is
end testbench;

architecture behavioral of testbench is

    component phase_accumulator is
        port (
            clk         : in  std_logic;
            reset       : in  std_logic;
            enable      : in  std_logic;
            tuning_word : in  unsigned(15 downto 0);
            addr        : out std_logic_vector(6 downto 0);
            half_cycle  : out std_logic
        );
    end component;

    component sine_table is
        port (
            addr     : in  std_logic_vector(6 downto 0);
            sine_val : out std_logic_vector(6 downto 0)
        );
    end component;

    component full_wave is
        port (
            half_cycle : in  std_logic;
            sine_val   : in  std_logic_vector(6 downto 0);
            dac_out    : out std_logic_vector(7 downto 0)
        );
    end component;

    signal clk         : std_logic := '0';
    signal reset       : std_logic := '1';
    signal enable      : std_logic := '0';
    signal tuning_word : unsigned(15 downto 0) := (others => '0');
    signal addr        : std_logic_vector(6 downto 0);
    signal half_cycle  : std_logic;
    signal sine_val    : std_logic_vector(6 downto 0);
    signal dac_out     : std_logic_vector(7 downto 0);

    constant CLK_PERIOD : time := 10 ns;

begin

    phase_acc_inst : phase_accumulator
        port map (
            clk         => clk,
            reset       => reset,
            enable      => enable,
            tuning_word => tuning_word,
            addr        => addr,
            half_cycle  => half_cycle
        );

    sine_table_inst : sine_table
        port map (
            addr     => addr,
            sine_val => sine_val
        );

    full_wave_inst : full_wave
        port map (
            half_cycle => half_cycle,
            sine_val   => sine_val,
            dac_out    => dac_out
        );

    clk_process : process
    begin
        clk <= '0';
        wait for CLK_PERIOD / 2;
        clk <= '1';
        wait for CLK_PERIOD / 2;
    end process;

    stimulus_process : process
    begin
        reset       <= '1';
        enable      <= '0';
        tuning_word <= (others => '0');
        wait for CLK_PERIOD * 10;

        reset <= '0';
        wait for CLK_PERIOD * 2;

        -- low frequency
        tuning_word <= to_unsigned(100, 16);
        enable      <= '1';
        wait for CLK_PERIOD * 5000;

        -- higher frequency
        tuning_word <= to_unsigned(500, 16);
        wait for CLK_PERIOD * 5000;

        wait;
    end process;

end behavioral;
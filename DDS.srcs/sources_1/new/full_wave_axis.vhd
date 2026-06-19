library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity full_wave_axis is
    port (
        clk           : in  std_logic;
        reset         : in  std_logic;
        half_cycle    : in  std_logic;
        sine_val      : in  std_logic_vector(6 downto 0);

        -- AXI4-Stream output
        m_axis_tdata  : out std_logic_vector(7 downto 0);
        m_axis_tvalid : out std_logic;
        m_axis_tlast  : out std_logic;
        m_axis_tready : in  std_logic;

        -- frame size - how many samples before TLAST pulses
        frame_size    : in  unsigned(15 downto 0)
    );
end full_wave_axis;

architecture behavioral of full_wave_axis is

    signal dac_out      : std_logic_vector(7 downto 0);
    signal sample_count : unsigned(15 downto 0) := (others => '0');

begin

    -- existing full wave logic unchanged
    dac_out <= '1' & sine_val when half_cycle = '0'
          else std_logic_vector(to_unsigned(128, 8) - resize(unsigned(sine_val), 8));

    -- data is always valid, DDS produces a sample every clock
    m_axis_tdata  <= dac_out;
    m_axis_tvalid <= '1';

    -- pulse TLAST at the end of each frame
    process(clk)
    begin
        if rising_edge(clk) then
            if reset = '1' then
                sample_count <= (others => '0');
                m_axis_tlast <= '0';
            elsif m_axis_tready = '1' then
                if sample_count = frame_size - 1 then
                    sample_count <= (others => '0');
                    m_axis_tlast <= '1';
                else
                    sample_count <= sample_count + 1;
                    m_axis_tlast <= '0';
                end if;
            end if;
        end if;
    end process;

end behavioral;

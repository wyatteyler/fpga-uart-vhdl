library ieee;
use ieee.std_logic_1164.all;

entity uart_echo_top is
	generic (
		CLKS_PER_BIT	:	integer := 1085
	);
	port (
		clk			:	in std_logic;
		btn_rst		:	in std_logic;
		UART_RX		:	in std_logic;
		UART_TX		:	out std_logic
	);
end uart_echo_top;

architecture rtl of uart_echo_top is
	signal rx_valid	:	std_logic;
	signal rx_byte	:	std_logic_vector(7 downto 0);
	signal tx_done	:	std_logic;
begin
	RX_inst : entity work.RX_uart
		generic map (CLKS_PER_BIT => CLKS_PER_BIT)
		port map (
			clk	=> clk,
			rst	=> btn_rst,
			RX_line	=> UART_RX,
			RX_data_valid => rx_valid,
			RX_data_byte => rx_byte
		);

	TX_inst : entity work.TX_uart
		generic map (CLKS_PER_BIT => CLKS_PER_BIT)
		port map (
			clk => clk,
			rst => btn_rst,
			TX_start => rx_valid,
			TX_data_in => rx_byte,
			TX_line => UART_TX,
			TX_done => tx_done
		);
end architecture rtl;

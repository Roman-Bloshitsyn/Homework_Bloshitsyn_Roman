//----------------------------------------------------------------------------
// Task
//----------------------------------------------------------------------------

module double_tokens_with_flow_control
(
    input  clk,
    input  rst,

    input  up_valid,
    output up_ready,
    input  up_token,

    output down_valid,
    input  down_ready,
    output down_data
);

//---------------------------------------------------------
//Handshakes

logic go_in, go_out;

assign go_in = up_valid & up_ready;
assign go_out = down_valid & down_ready;

//---------------------------------------------------------
//Счетчик единиц

    logic [0:6] cnt;

    always @(posedge clk)
    begin
        if (cnt == 'd99)
            cnt <= '0;

        if (rst)
            cnt <= '0;
        else if (go_in & up_token)
            cnt <= cnt + 'd1;
        else if (go_out & ~ up_token)
            cnt <= (cnt == '0) ? '0 : (cnt - 1'd1); // счетчик при запуске токена в модуль начинает считать при выпуске идет обратный отсчет
    end
//---------------------------------------------------------
//Выходные данные

    assign down_data = (up_token & go_in) | (cnt != '0); // данные единица только когда токен единица и мы вогнали этот токен или счетчик не равен нулю
    assign down_valid = (down_ready & up_valid) | (down_ready & ~ go_in); // мы хотим то что пришло в такт вышло в этот же такт или если ничего не приходит но мы хотим дальше передать данные
    assign up_ready = down_ready & up_valid & ~ overflow; // готов принять данные в такт когда приёмник готов получить данные и на входе данное корекктно

//---------------------------------------------------------
//Overflow
    
    logic overflow;

    always_ff @ (posedge clk)
        if (rst)
            overflow <= 1'b0;
        else  
            overflow <= (cnt == 'd99) ? 1'b1 : 1'b0;


  // Task:
  // Implement module double input signals (tokens). The module must use signals valid-ready for
  // transfer tokens. If the module receives more than 100 sequential tokens then it must set up_ready = 0;


endmodule
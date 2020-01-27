`define GREENPWM RGB0PWM
`define REDPWM   RGB1PWM
`define BLUEPWM  RGB2PWM

module entry(
    // These properties are defined in `fomu-pvt.pcf`
    
    output rgb0,
    output rgb1,
    output rgb2,
    output usb_dp,
    output usb_dn,
    output usb_dp_pu,
    input clock_input
);
endmodule


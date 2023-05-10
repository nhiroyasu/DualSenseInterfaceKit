//
//  dual_sense_signal_reader.h
//  CLangTraining
//
//  Created by NH on 2023/05/06.
//

#ifndef dual_sense_signal_reader_h
#define dual_sense_signal_reader_h

#include <stdio.h>
typedef struct {
    uint8_t left_stick_x_axis;
    uint8_t left_stick_y_axis;
    uint8_t right_stick_x_axis;
    uint8_t right_stick_y_axis;
    uint8_t l2_trigger_axis;
    uint8_t r2_trigger_axis;
    uint8_t directional_button;
    uint8_t square_button;
    uint8_t cross_button;
    uint8_t circle_button;
    uint8_t triangle_button;
    uint8_t l1_button;
    uint8_t r1_button;
    uint8_t l2_button;
    uint8_t r2_button;
    uint8_t create_button;
    uint8_t options_button;
    uint8_t l3_button;
    uint8_t r3_button;
    uint8_t ps_button;
    uint8_t touchpad_button;
    int gyro_x;
    int gyro_y;
    int gyro_z;
    int accel_x;
    int accel_y;
    int accel_z;
} DualSenseReport;
int DSSigReader_init(int idVendor, int idProduct);
int DSSigReader_read(int interfaceNum, int endpointAddr, DualSenseReport* report);
int DSSigReader_release(int interfaceNum);
int DSSigReader_deinit(void);
DualSenseReport defaultReportValue(void);

#endif /* dual_sense_signal_reader_h */

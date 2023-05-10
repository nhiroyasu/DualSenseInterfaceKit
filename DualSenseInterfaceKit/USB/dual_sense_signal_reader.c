#include "dual_sense_signal_reader.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "libusb.h"

libusb_context *ctx;
libusb_device_handle *dev_handle;

int DSSigReader_init(int idVendor, int idProduct) {
    int rc = libusb_init(&ctx);
    if (rc != 0) {
        fprintf(stderr, "libusb_init() failed: %s\n", libusb_error_name(rc));
        return -1;
    }

    dev_handle = libusb_open_device_with_vid_pid(ctx, idVendor, idProduct);
    if (dev_handle == NULL) {
        fprintf(stderr, "Not found a device\n");
        return -1;
    }


    int config;
    if (libusb_get_configuration(dev_handle, &config) != LIBUSB_SUCCESS) {
        fprintf(stderr, "Failed to get device configuration\n");
        return -1;
    }

    if (libusb_set_configuration(dev_handle, config) != LIBUSB_SUCCESS) {
        fprintf(stderr, "Failed to set device configuration\n");
        return -1;
    }

    // claimするときにkernelのdriverをdetachする
    // これしないとACCESS_DENIEDでエラーになる
    int result = libusb_set_auto_detach_kernel_driver(dev_handle, 1);

    if (result < 0) {
        printf("Failed detach\n");
        libusb_close(dev_handle);
        libusb_exit(ctx);
        return -1;
    }

    return 0;
}

int DSSigReader_read(int interfaceNum, int endpointAddr, DualSenseReport* report) {
    if (dev_handle == NULL) {
       return -1;
    }

    int result = libusb_claim_interface(dev_handle, interfaceNum);
    if (result < 0) {
        printf("Failed to claim interface\n");
        printf("%s", libusb_strerror(result));
        return -1;
    }

    int bufSize = 0x0040;
    unsigned char buffer[bufSize];
    int transferred = 0;
    int timeout = 1000; // 1秒

    result = libusb_interrupt_transfer(dev_handle, endpointAddr, buffer, bufSize, &transferred, timeout);
    if (result == LIBUSB_ERROR_TIMEOUT) {
        printf("Timeout\n");
        return -1;
    } else if (result < 0) {
        printf("Error: %s\n", libusb_strerror(result));
        return -1;
    } else {
        printf("Received %d bytes\n", transferred);
    }

    printf("Received data: ");

    unsigned char l_stick_x_axis = buffer[1];
    report->left_stick_x_axis = l_stick_x_axis;

    unsigned char l_stick_y_axis = buffer[2];
    report->left_stick_y_axis = l_stick_y_axis;

    unsigned char r_stick_x_axis = buffer[3];
    report->right_stick_x_axis = r_stick_x_axis;

    unsigned char r_stick_y_axis = buffer[4];
    report->right_stick_y_axis = r_stick_y_axis;

    unsigned char l2_trigger_axis = buffer[5];
    report->l2_trigger_axis = l2_trigger_axis;

    unsigned char r2_trigger_axis = buffer[6];
    report->r2_trigger_axis = r2_trigger_axis;

    unsigned char directional_button = buffer[8] & 0x0F;
    report->directional_button = directional_button;

    unsigned char square_button = (buffer[8] & 0x10) >> 4;
    unsigned char cross_button = (buffer[8] & 0x20) >> 5;
    unsigned char circle_button = (buffer[8] & 0x40) >> 6;
    unsigned char triangle_button = (buffer[8] & 0x80) >> 7;
    report->square_button = square_button;
    report->cross_button = cross_button;
    report->circle_button = circle_button;
    report->triangle_button = triangle_button;


    unsigned char l1_button = buffer[9] & 0x01;
    unsigned char r1_button = (buffer[9] & 0x02) >> 1;
    unsigned char l2_button = (buffer[9] & 0x04) >> 2;
    unsigned char r2_button = (buffer[9] & 0x08) >> 3;
    report->l1_button = l1_button;
    report->r1_button = r1_button;
    report->l2_button = l2_button;
    report->r2_button = r2_button;

    unsigned char create_button = (buffer[9] & 0x10) >> 4;
    unsigned char options_button = (buffer[9] & 0x20) >> 5;
    unsigned char l3_button = (buffer[9] & 0x40) >> 6;
    unsigned char r3_button = (buffer[9] & 0x80) >> 7;
    report->create_button = create_button;
    report->options_button = options_button;
    report->l3_button = l3_button;
    report->r3_button = r3_button;

    unsigned char ps_button = buffer[10] & 0x01;
    unsigned char touchpad_button = (buffer[10] & 0x02) >> 1;
    report->ps_button = ps_button;
    report->touchpad_button = touchpad_button;

    int16_t gyro_x = (int16_t)(buffer[16] + (buffer[17] << 8));
    int16_t gyro_y = (int16_t)(buffer[18] + (buffer[19] << 8));
    int16_t gyro_z = (int16_t)(buffer[20] + (buffer[21] << 8));
    report->gyro_x = gyro_x;
    report->gyro_y = gyro_y;
    report->gyro_z = gyro_z;

    printf("L Stick X Axis: %02x\t", l_stick_x_axis);
    printf("L Stick Y Axis: %02x\t", l_stick_y_axis);
    printf("R Stick X Axis: %02x\t", r_stick_x_axis);
    printf("R Stick Y Axis: %02x\t", r_stick_y_axis);
    printf("L2 Trigger axis: %02x\t", l2_trigger_axis);
    printf("R2 Trigger axis: %02x\t", r2_trigger_axis);
    printf("Directional Button: ");
    if (directional_button == 0x0) {
        printf("↑");
    }
    if (directional_button == 0x1) {
        printf("↑→");
    }
    if (directional_button == 0x2) {
        printf("→");
    }
    if (directional_button == 0x3) {
        printf("→↓");
    }
    if (directional_button == 0x4) {
        printf("↓");
    }
    if (directional_button == 0x5) {
        printf("↓←");
    }
    if (directional_button == 0x6) {
        printf("←");
    }
    if (directional_button == 0x7) {
        printf("←↑");
    }
    if (directional_button == 0x8) {
        printf("neutral");
    }
    printf("\t");
    printf("Square Button: %s\t", square_button ? "ON" : "OFF");
    printf("Cross Button: %s\t", cross_button ? "ON" : "OFF");
    printf("Circle Button: %s\t", circle_button ? "ON" : "OFF");
    printf("Triangle Button: %s\t", triangle_button ? "ON" : "OFF");
    printf("L1 Button: %s\t", l1_button ? "ON" : "OFF");
    printf("R1 Button: %s\t", r1_button ? "ON" : "OFF");
    printf("L2 Button: %s\t", l2_button ? "ON" : "OFF");
    printf("R2 Button: %s\t", r2_button ? "ON" : "OFF");
    printf("Create Button: %s\t", create_button ? "ON" : "OFF");
    printf("Options Button: %s\t", options_button ? "ON" : "OFF");
    printf("L3 Button: %s\t", l3_button ? "ON" : "OFF");
    printf("R3 Button: %s\t", r3_button ? "ON" : "OFF");
    printf("PS Button: %s\t", ps_button ? "ON" : "OFF");
    printf("Touchpad Button: %s\t", touchpad_button ? "ON" : "OFF");
    printf("Gyro X: %06d\t", gyro_x);
    printf("Gyro Y: %06d\t", gyro_y);
    printf("Gyro Z: %06d\t", gyro_z);

    return 0;
}

int DSSigReader_release(int interfaceNum) {
    if (dev_handle == NULL) {
        return -1;
    }

    libusb_release_interface(dev_handle, interfaceNum);
    return 0;
}

int DSSigReader_deinit(void) {
    if (dev_handle == NULL) {
        return -1;
    }
    if (ctx == NULL) {
        return -1;
    }
    libusb_close(dev_handle);
    libusb_exit(ctx);

    return 0;
}

DualSenseReport defaultReportValue(void) {
    DualSenseReport report = { 0 };
    return report;
}

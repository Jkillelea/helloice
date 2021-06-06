#include <errno.h>
#include <fcntl.h>
#include <math.h>
#include <stdbool.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <termios.h>
#include <unistd.h>

int set_interface_attribs(int fd, int speed, int parity)
{
    struct termios tty;

    if (tcgetattr(fd, &tty) != 0)
    {
        perror("error from tcgetattr");
        return -1;
    }

    cfsetospeed(&tty, speed);
    cfsetispeed(&tty, speed);

    tty.c_cflag = (tty.c_cflag & ~CSIZE) | CS8;     // 8-bit chars
    // disable IGNBRK for mismatched speed tests; otherwise receive break
    // as \000 chars
    tty.c_iflag &= ~IGNBRK;         // disable break processing
    tty.c_lflag = 0;                // no signaling chars, no echo,
    // no canonical processing
    tty.c_oflag = 0;                // no remapping, no delays
    tty.c_cc[VMIN]  = 0;            // read doesn't block
    tty.c_cc[VTIME] = 5;            // 0.5 seconds read timeout
    tty.c_iflag &= ~(IXON | IXOFF | IXANY); // shut off xon/xoff ctrl
    tty.c_cflag |= (CLOCAL | CREAD);        // ignore modem controls,
    // enable reading
    tty.c_cflag &= ~(PARENB | PARODD);      // shut off parity
    tty.c_cflag |= parity;
    tty.c_cflag &= ~CSTOPB;
    tty.c_cflag &= ~CRTSCTS;

    if (tcsetattr(fd, TCSANOW, &tty) != 0)
    {
        perror("error from tcsetattr");
        return -1;
    }

    return 0;
}

void set_blocking(int fd, bool should_block)
{
    struct termios tty;
    memset(&tty, 0, sizeof(tty));
    if (tcgetattr(fd, &tty) != 0)
    {
        perror("error from tggetattr");
        return;
    }

    tty.c_cc[VMIN]  = should_block ? 1 : 0;
    tty.c_cc[VTIME] = 5;            // 0.5 seconds read timeout

    if (tcsetattr(fd, TCSANOW, &tty) != 0)
    {
        perror("error setting term attributes");
    }
}


int main(int argc, char *argv[])
{
    char portname[256] = "/dev/ttyUSB1";
    if (argc > 1)
        strncpy(portname, argv[1], 256);

    int fd = open(portname, O_RDWR | O_NOCTTY | O_SYNC);

    if (fd < 0)
    {
        perror("open");
        return 0;
    }

    set_interface_attribs(fd, B115200, 0);  // set speed to 115,200 bps, 8n1 (no parity)
    set_blocking(fd, false);                // set no blocking

    for (int frequency = 1; frequency <= 1; frequency++)
    {
        uint8_t waveform[256] = {0};
        for (uint16_t i = 0; i < 256; i += 1)
        {
            uint8_t f = (uint8_t) 127 * sin(2 * M_PI * ((double) frequency*i) / 256) + 127;
            // uint8_t f = (uint8_t) frequency*i;
            waveform[i] = f;
        }

        write(fd, waveform, 256);
        sleep(1);
    }

    return 0;
}

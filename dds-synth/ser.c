#include <errno.h>
#include <fcntl.h>
#include <math.h>
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

    tty.c_cflag |= (CLOCAL | CREAD);// ignore modem controls,
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

void set_blocking(int fd, int should_block)
{
    struct termios tty;
    memset(&tty, 0, sizeof tty);
    if (tcgetattr(fd, &tty) != 0)
    {
        perror("error from tggetattr");
        return;
    }

    tty.c_cc[VMIN]  = should_block ? 1 : 0;
    tty.c_cc[VTIME] = 5;            // 0.5 seconds read timeout

    if (tcsetattr(fd, TCSANOW, &tty) != 0)
        perror("error setting term attributes");
}


int main(int argc, char *argv[])
{
    char *portname = "/dev/ttyUSB1";
    int fd = open(portname, O_RDWR | O_NOCTTY | O_SYNC);

    if (fd < 0)
    {
        perror("error opening");
        return 0;
    }

    set_interface_attribs(fd, B921600, 0);  // set speed to 115,200 bps, 8n1 (no parity)
    set_blocking(fd, 0);                // set no blocking

    while (1)
    {
        for (uint8_t i = 0; i < 0b01111111; i++)
        {
            // uint8_t f = (uint8_t) 127*sin(2 * M_PI * ((double) i) / 255) + 127;
            uint8_t f = i << 1;
            write(fd, &f, 1);
        }
    }

    return 0;
}

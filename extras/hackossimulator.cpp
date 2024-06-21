#include <cstdint>
#include <cstdlib>
#include <cstring>
#include <iostream>
#include <unistd.h>
#include <linux/can.h>
#include <linux/can/raw.h>
#include <net/if.h>
#include <signal.h>
#include <sys/ioctl.h>
#include <sys/socket.h>
#include <sys/stat.h>
#include <sys/time.h>
#include <unistd.h>



#include "../common/can.hpp"
#include "../common/car.hpp"
#include "../common/ConfigurationParser.hpp"



// The Console class and methods
class Console
{
private:
    int door_status[4];
    int turn_status[2];
    long current_speed;
    int maxdlen;
    int randomize;
    int seed;



    struct timeval tv;



    int can_socket;
    int enable_canfd;
    ifreq ifr;
    sockaddr_can addr;
    iovec iov;
    msghdr msg;
    cmsghdr *cmsg;
    canfd_frame can_frame;
    char ctrlmsg[CMSG_SPACE(sizeof(struct timeval)) + CMSG_SPACE(sizeof(__u32))];



public:
    Console()
    {
        current_speed = 0;
        maxdlen = 0;
        randomize = 0;
        seed = 0;



        for (int i = 0; i < 4; ++i)
        {
            door_status[i] = Car::Status::Door::Locked;
        }



        for (int i = 0; i < 2; ++i)
        {
            turn_status[i] = Car::Status::TurnSignal::Off;
        }
    }



    void initialize_can_frame(const uint8_t* data, size_t size)
    {
        if (size > sizeof(can_frame.data))
            size = sizeof(can_frame.data);
        std::memcpy(can_frame.data, data, size);
        can_frame.len = size;
    }



    void updateSpeedStatus()
    {
        int len = can_frame.len > maxdlen ? maxdlen : can_frame.len;
        if (len < CanMessage::Position::Speed + 1)
            return;



        int speed = can_frame.data[CanMessage::Position::Speed] << 8;
        speed += can_frame.data[CanMessage::Position::Speed + 1];
        speed = speed / 100; // speed in kilometers
        current_speed = speed;



        std::cout << "Current speed: " << current_speed << std::endl;
    }



    void updateSignalStatus()
    {
        int len = can_frame.len > maxdlen ? maxdlen : can_frame.len;
        if (len < CanMessage::Position::Signal)
            return;



        if (can_frame.data[CanMessage::Position::Signal] & 1)
            turn_status[0] = Car::Status::TurnSignal::On;
        else
            turn_status[0] = Car::Status::TurnSignal::Off;



        if (can_frame.data[CanMessage::Position::Signal] & 2)
            turn_status[1] = Car::Status::TurnSignal::On;
        else
            turn_status[1] = Car::Status::TurnSignal::Off;



        std::cout << "Turn signal status: " << turn_status[0] << ", " << turn_status[1] << std::endl;
    }



    void updateDoorStatus()
    {
        int len = can_frame.len > maxdlen ? maxdlen : can_frame.len;
        if (len < CanMessage::Position::Door)
            return;



        if (can_frame.data[CanMessage::Position::Door] & 1)
            door_status[0] = Car::Status::Door::Locked;
        else
            door_status[0] = Car::Status::Door::Unlocked;



        if (can_frame.data[CanMessage::Position::Door] & 2)
            door_status[1] = Car::Status::Door::Locked;
        else
            door_status[1] = Car::Status::Door::Unlocked;
        
        if (can_frame.data[CanMessage::Position::Door] & 4)
            door_status[2] = Car::Status::Door::Locked;
        else
            door_status[2] = Car::Status::Door::Unlocked;
        
        if (can_frame.data[CanMessage::Position::Door] & 8)
            door_status[3] = Car::Status::Door::Locked;
        else
            door_status[3] = Car::Status::Door::Unlocked;



        std::cout << "Door status: " << door_status[0] << ", " << door_status[1] << ", " << door_status[2] << ", " << door_status[3] << std::endl;
    }



    void processFrame()
    {
        if (can_frame.can_id == CanMessage::ID::Door)
            updateDoorStatus();
        if (can_frame.can_id == CanMessage::ID::Signal)
            updateSignalStatus();
        if (can_frame.can_id == CanMessage::ID::Speed)
            updateSpeedStatus();
    }
};



extern "C" int LLVMFuzzerTestOneInput(const uint8_t *data, size_t size)
{
    Console console;
    console.initialize_can_frame(data, size);
    console.processFrame();
    return 0;
}
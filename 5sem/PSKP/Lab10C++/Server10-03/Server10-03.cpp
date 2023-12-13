#define _WINSOCK_DEPRECATED_NO_WARNINGS

#include <Winsock2.h>
#include <iostream>

#pragma comment(lib, "ws2_32.lib")

int main() {
    WSADATA wsaData;
    WSAStartup(MAKEWORD(2, 2), &wsaData);

    SOCKET serverSocket = socket(AF_INET, SOCK_DGRAM, 0);

    sockaddr_in serverAddr;
    serverAddr.sin_family = AF_INET;
    serverAddr.sin_port = htons(40000);
    serverAddr.sin_addr.S_un.S_addr = htonl(INADDR_ANY);

    bind(serverSocket, (SOCKADDR*)&serverAddr, sizeof(serverAddr));

    char buffer[1024];
    sockaddr_in clientAddr;
    int clientAddrSize = sizeof(clientAddr);

    while (true) {
        int bytesReceived = recvfrom(serverSocket, buffer, sizeof(buffer), 0, (SOCKADDR*)&clientAddr, &clientAddrSize);
        if (bytesReceived > 0) {
            std::string message = "ECHO: " + std::string(buffer, bytesReceived);
            sendto(serverSocket, message.c_str(), message.size(), 0, (SOCKADDR*)&clientAddr, clientAddrSize);
            std::cout << std::string(buffer, bytesReceived) << std::endl;
        }
    }

    closesocket(serverSocket);
    WSACleanup();


    std::cin;

    return 0;
}
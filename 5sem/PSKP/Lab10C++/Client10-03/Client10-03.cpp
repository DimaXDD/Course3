#define _WINSOCK_DEPRECATED_NO_WARNINGS

#include <Winsock2.h>
#include <iostream>

#pragma comment(lib, "ws2_32.lib")

int main() {
    WSADATA wsaData;
    WSAStartup(MAKEWORD(2, 2), &wsaData);

    SOCKET clientSocket = socket(AF_INET, SOCK_DGRAM, 0);

    sockaddr_in serverAddr;
    serverAddr.sin_family = AF_INET;
    serverAddr.sin_port = htons(40000);
    serverAddr.sin_addr.S_un.S_addr = inet_addr("127.0.0.1");

    std::string message = "Hello, Server!";
    sendto(clientSocket, message.c_str(), message.size(), 0, (SOCKADDR*)&serverAddr, sizeof(serverAddr));

    char buffer[1024];
    int serverAddrSize = sizeof(serverAddr);
    int bytesReceived = recvfrom(clientSocket, buffer, sizeof(buffer), 0, (SOCKADDR*)&serverAddr, &serverAddrSize);
    if (bytesReceived > 0) {
        std::cout << "Client received: " << std::string(buffer, bytesReceived) << std::endl;
    }

    closesocket(clientSocket);
    WSACleanup();

    std::cin;

    return 0;
}

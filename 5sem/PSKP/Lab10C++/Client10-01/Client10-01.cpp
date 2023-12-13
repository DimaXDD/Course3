#define _WINSOCK_DEPRECATED_NO_WARNINGS

#include <iostream>
#include <Winsock2.h>
#include <string>
#include <Windows.h>

#pragma comment(lib, "ws2_32.lib")

int main() {
    WSADATA wsaData;
    WSAStartup(MAKEWORD(2, 2), &wsaData);

    SOCKET clientSocket = socket(AF_INET, SOCK_STREAM, IPPROTO_TCP);

    sockaddr_in serverAddr;
    serverAddr.sin_family = AF_INET;
    serverAddr.sin_port = htons(40000);
    serverAddr.sin_addr.S_un.S_addr = inet_addr("127.0.0.1");

    connect(clientSocket, (SOCKADDR*)&serverAddr, sizeof(serverAddr));

    std::string message = "Hello, Server!";
    send(clientSocket, message.c_str(), message.size(), 0);

    char buffer[100];
    int bytesReceived = recv(clientSocket, buffer, sizeof(buffer), 0);
    if (bytesReceived > 0) {
        std::cout << "Received: " << std::string(buffer, bytesReceived) << std::endl;
    }

    std::cin;

    closesocket(clientSocket);
    WSACleanup();

    return 0;
}
